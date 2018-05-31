//
//  SearchResultViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2017/3/27.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "SearchResultViewController.h"
#import "HotBrandTableViewCell.h"
#import "CarSeriesTableViewCell.h"
//#import "ArtTableViewCell.h"
#import "PublicNormalTableViewCell.h"
#import "CustomTableViewHeaderSectionView.h"
#import "CarSeriesViewController.h"
#import "CarDeptViewController.h"
#import "ArtInfoViewController.h"


#import "DeliverModel.h"

#define  maxSeriesCount 3
@interface SearchResultViewController ()
@property(nonatomic,strong)NSMutableArray*dataArray;
@property(nonatomic,strong)UIButton*articleLoadMoreButton;
//@property(nonatomic,assign)BOOL noMoreData;


@property(nonatomic,strong)DeliverModel *deliverModel;
@property(nonatomic,strong)NSMutableArray<InfoArticleModel> *infolist;
@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
   
    self.deliverModel = [[DeliverModel alloc]init];
    self.infolist = [[NSMutableArray<InfoArticleModel> alloc] init];
    
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.bounces = YES;
    
    self.tableView.tableFooterView = [[UITableView alloc]initWithFrame:CGRectZero];
    [self.tableView registerClass:[CustomTableViewHeaderSectionView class] forHeaderFooterViewReuseIdentifier:classNameFromClass (CustomTableViewHeaderSectionView)];
    self.tableView.backgroundColor =BlackColorF1F1F1;
    [self.tableView registerClass:[HotBrandTableViewCell class] forCellReuseIdentifier:classNameFromClass(HotBrandTableViewCell)];
    [self.tableView registerNib:nibFromClass(CarSeriesTableViewCell) forCellReuseIdentifier:classNameFromClass(CarSeriesTableViewCell)];
//    [self.tableView registerNib:nibFromClass(ArtTableViewCell) forCellReuseIdentifier:classNameFromClass(ArtTableViewCell)];
    [self.tableView registerNib:nibFromClass(PublicNormalTableViewCell) forCellReuseIdentifier:classNameFromClass(PublicNormalTableViewCell)];
    
    @weakify(self);
    [[RACObserve(self.viewModel.searchArtmoreRequest, state)filter:^BOOL(id value) {
        @strongify(self);
        return self.viewModel.searchArtmoreRequest.succeed||self.viewModel.searchArtmoreRequest.failed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_footer endRefreshing];
       
        if (self.viewModel.searchArtmoreRequest.succeed) {
            
            SearchResultArticleListModel*article = [[SearchResultArticleListModel alloc]initWithDictionary:self.viewModel.searchArtmoreRequest.output[@"data"] error:nil];
            
            [self.viewModel.searchResultModel.article.showList addObjectsFromArray:article.list];
            
            if (self.viewModel.searchResultModel.article.showList.count == self.viewModel.searchResultModel.article.total) {
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }else{
                self.viewModel.searchArtmoreRequest.page++;

            }
            
            [self resetDataArray];
            [self.tableView reloadData];
            
        }else{
            
            [self.tableView showNetLost];
           
        }
        
       
    }];
    
    [[RACObserve(self.viewModel, searchResultModel)filter:^BOOL(id value) {
        @strongify(self);
        return self.viewModel.searchResultModel.isNotEmpty;
    }]subscribeNext:^(id x) {
        @strongify(self);
        
       [self.tableView setContentOffset:CGPointMake(0, 0)];
               [self.viewModel.searchResultModel.article.showList addObjectsFromArray:self.viewModel.searchResultModel.article.list];
        if (self.viewModel.searchResultModel.article.showList.count != self.viewModel.searchResultModel.article.total) {
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                @strongify(self);
                [self articleLoadMore:nil];
            }];
        }
        [self resetDataArray];
        if (self.dataArray.count > 0) {
            [self.tableView dismissWithOutDataView];
        }else{
            [self.tableView showWithOutDataViewWithTitle:@"暂无搜索内容"];
        }
        [self.tableView reloadData];
    }];


    // Do any additional setup after loading the view.
}
-(NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(void)resetDataArray{
    [self.dataArray removeAllObjects];
    if (self.viewModel.searchResultModel.brand.count > 0) {
        [self.dataArray addObject:self.viewModel.searchResultModel.brand];
    }
    if (self.viewModel.searchResultModel.series.count > 0) {
         [self.dataArray addObject:self.viewModel.searchResultModel.series];
    }
    if (self.viewModel.searchResultModel.article.showList.count > 0) {
        self.infolist = [self.deliverModel deliverInfoArticleModel:self.viewModel.searchResultModel.article.showList];
        [self.dataArray addObject: self.infolist];
    }
   

}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 190/2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray[indexPath.section] == self.viewModel.searchResultModel.brand) {
        return 80;
    }else if (self.dataArray[indexPath.section] == self.viewModel.searchResultModel.series){
                   return UITableViewAutomaticDimension;
    
        
    }else{
        return UITableViewAutomaticDimension;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (self.dataArray[section] == self.viewModel.searchResultModel.brand) {
//        return 0.000001;
//    }else if (self.dataArray[section] == self.viewModel.searchResultModel.series){
//        if (self.showAllSeries==NO&&self.viewModel.searchResultModel.series.count >maxSeriesCount) {
//             return 35;
//        }else{
//            return 0.000001;
//        }
//       
//    }else{
//        return 35;
//    }
//
//}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.dataArray[section] == self.viewModel.searchResultModel.brand) {
        return nil;
    }else if (self.dataArray[section] == self.viewModel.searchResultModel.series&&self.showAllSeries==NO&&self.viewModel.searchResultModel.series.count >maxSeriesCount){
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kwidth, 35)];
        view.backgroundColor = [UIColor whiteColor];
        UIButton*loadMore = [Tool createButtonWithImage:[UIImage imageNamed:@"箭头向下"] target:self action:@selector(carSeriesLoadMore:) tag:0];
        [view addSubview:loadMore];
         [loadMore setTitleColor:BlackColor333333 forState:UIControlStateNormal];
        loadMore.titleLabel.font =  FontOfSize(13);
        [loadMore setTitle:@"加载更多" forState:UIControlStateNormal];
        [loadMore exchangeImageAndTitle];
        [loadMore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        return view ;
    }else if(self.dataArray[section] == self.viewModel.searchResultModel.article.showList){
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kwidth, 35)];
        view.backgroundColor = [UIColor whiteColor];
        if (!self.articleLoadMoreButton) {
            self.articleLoadMoreButton = [Tool createButtonWithImage:[UIImage imageNamed:@"箭头向下"] target:self action:@selector(articleLoadMore:) tag:0];
            self.articleLoadMoreButton.titleLabel.font =  FontOfSize(13);
            [self.articleLoadMoreButton setTitleColor:BlackColor333333 forState:UIControlStateNormal];
            [self.articleLoadMoreButton setTitle:@"加载更多" forState:UIControlStateNormal];
            [self.articleLoadMoreButton exchangeImageAndTitle];
        }
        [view addSubview:self.articleLoadMoreButton];
        [self.articleLoadMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        return view ;

    }else{
        return nil;
    }

}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CustomTableViewHeaderSectionView*view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:classNameFromClass(CustomTableViewHeaderSectionView)];
    view.topLine.hidden = YES;
    view.middleLine.hidden = YES;
    view.bottomLine.hidden = YES;
    view.titleLabel.font = FontOfSize(13);
    view.titleLabel.textColor = BlackColor333333;
    view.contentView.backgroundColor = BlackColorF1F1F1;
    NSString*title;
    if (self.dataArray[section] == self.viewModel.searchResultModel.brand) {
        title= @"相关品牌";
    }else if (self.dataArray[section] == self.viewModel.searchResultModel.series){
        title= @"相关车系";
    }else{
        title= @"相关文章";
    }

            view.titleLabel.text = title;
    
    
    return view;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray*array = self.dataArray[section];
    if (array==self.viewModel.searchResultModel.brand) {
        
        return array.count/5 + array.count%5==0?0:1;
    }else if (self.dataArray[section] == self.viewModel.searchResultModel.series){
        if (self.showAllSeries==NO&&self.viewModel.searchResultModel.series.count >maxSeriesCount) {
            return maxSeriesCount+1;
        }
    }
    return  array.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray[indexPath.section] == self.viewModel.searchResultModel.brand) {
        HotBrandTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(HotBrandTableViewCell) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSMutableArray*array = [NSMutableArray array];
        for (NSInteger i = 5*indexPath.row; i <self.viewModel.searchResultModel.brand.count&&i <5*(indexPath.row+1)  ; i++) {
           SearchSugestionModel*model = self.viewModel.searchResultModel.brand[i];
            BrandModel*brand = [[BrandModel alloc]init];
            brand.name = model.name;
            brand.url = model.picurl;
            brand.id =model.id;
            [array addObject:brand];
        }
        [cell.view setCellWithArray:array itemClickBlock:^(HotBrandItem *item, NSInteger index) {
            CarSeriesViewController*vc = [[CarSeriesViewController alloc]init];
            
            
            
            BrandModel*model = array[index];
            vc.brandModel = model;
            [self.rt_navigationController pushViewController:vc animated:YES];
        }];
        return cell;
    }else if (self.dataArray[indexPath.section] == self.viewModel.searchResultModel.series){
        if (self.showAllSeries==NO&&self.viewModel.searchResultModel.series.count >maxSeriesCount&&indexPath.row==maxSeriesCount) {
            UITableViewCell*cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            UIButton*loadMore = [Tool createButtonWithImage:[UIImage imageNamed:@"箭头向下"] target:self action:@selector(carSeriesLoadMore:) tag:0];
            [cell.contentView addSubview:loadMore];
            [loadMore setTitleColor:BlackColor999999 forState:UIControlStateNormal];
            loadMore.titleLabel.font =  FontOfSize(13);
            [loadMore setTitle:@"加载更多" forState:UIControlStateNormal];
            [loadMore exchangeImageAndTitle];
            [loadMore mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cell.contentView);
                make.height.mas_equalTo(33);
            }];
            return cell;
        }

        CarSeriesTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(CarSeriesTableViewCell) forIndexPath:indexPath];
         SearchSugestionModel*model = self.viewModel.searchResultModel.series[indexPath.row];
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.picurl] placeholderImage:[UIImage imageNamed:@"默认图片80_60"]];
        cell.titleLabel.text = model.name;
        cell.subTitleLabel.text = model.price;
        return cell;
    }else{
//        ArtTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(ArtTableViewCell) forIndexPath:indexPath];
//          InfoArticleModel*model = self.infolist[indexPath.row];
//         [cell.image sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"默认图片80_60"]];
//        if ([model.isRead isEqualToString:isread]) {
//            cell.title.textColor = BlackColor999999;
//        }else{
//            cell.title.textColor = BlackColor333333;
//        }
//        
//        
//        cell.title.text = model.title;
//        cell.views.text = model.click;
//        cell.time.text = model.inputtime;
        InfoArticleModel *content = self.infolist[indexPath.row];
        PublicNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PublicNormalTableViewCell" forIndexPath:indexPath];
        [cell setData:content];
        
        
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray[indexPath.section] == self.viewModel.searchResultModel.brand) {
        //title= @"相关品牌";
        
        
    }else if (self.dataArray[indexPath.section] == self.viewModel.searchResultModel.series){
        
        CarDeptViewController*vc = [[CarDeptViewController alloc]init];
          SearchSugestionModel*model = self.viewModel.searchResultModel.series[indexPath.row];
        vc.chexiid = model.id;
        vc.picture = model.picurl;
        [self.rt_navigationController pushViewController:vc animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
//        title= @"相关车系";
    }else{
       
        InfoArticleModel*model = self.viewModel.searchResultModel.article.showList[indexPath.row];
        
        PicShowModel*listModel = [[PicShowModel alloc]init];
        //@property(nonatomic,strong)NSString *id;
        //@property(nonatomic,strong)NSString *title;
        
        //@property(nonatomic,strong)NSString *description;
       // @property(nonatomic,strong)NSString *click;
       // @property(nonatomic,strong)NSString *inputtime;
       // @property(nonatomic,strong)NSString *thumb;
        ///搜索结果没有该属性
       // @property(nonatomic,strong)NSString *shorttitle;
        ///"2017-03-01 16:10:16",,搜索结果含有的属性
       // @property(nonatomic,strong)NSString *realinputtime;
        listModel.id = model.id;
        listModel.title = model.title;
        listModel.thumb = model.thumb;
        listModel.inputtime = model.inputtime;
        listModel.click = model.click;
        listModel.authorName = model.authorName;
        listModel.artType = wenzhang;
        
        //@property(nonatomic,copy) NSString *showType;
        //@property(nonatomic,copy) NSString *id;
       // @property(nonatomic,copy) NSString *title;
       // @property(nonatomic,copy) NSString *thumb;
       // @property(nonatomic,copy) NSString *inputtime;
       // @property(nonatomic,copy) NSString *click;
        
       // @property(nonatomic,copy) NSArray<NSString *> *imglist;
        if ([model.artType isEqualToString:zimeiti]) {
            ArtInfoViewController*vc = [[ArtInfoViewController alloc]init];
            vc.aid = model.id;
            vc.artType = model.artType;
            [self.rt_navigationController pushViewController:vc animated:YES];
        }else{
            ArtInfoViewController*vc = [[ArtInfoViewController alloc]init];
            vc.aid = model.id;
            vc.artType = model.artType;
            [self.rt_navigationController pushViewController:vc animated:YES];
        }
       
        
      
         [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if ([model.isRead isEqualToString:notread]) {
            model.isRead = isread;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
//        title= @"相关文章";
    }

}
-(void)carSeriesLoadMore:(UIButton*)button{
    self.showAllSeries = YES;
    [self.tableView reloadData];
}
-(void)articleLoadMore:(UIButton*)button{
    self.viewModel.searchArtmoreRequest.keywords = self.viewModel.searchResultModel.keywords;
    self.viewModel.searchArtmoreRequest.startRequest = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.articleLoadMoreButton.userInteractionEnabled = YES;
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    
    return NO;
}
//-(void)setNoMoreData:(BOOL)noMoreData{
//    if (_noMoreData!=noMoreData) {
//        _noMoreData = noMoreData;
//    }
//    if (noMoreData) {
//        [self.articleLoadMoreButton setTitle:@"没有更多文章" forState:UIControlStateNormal];
//        [self.articleLoadMoreButton setImage:nil forState:UIControlStateNormal];
//        self.articleLoadMoreButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//        self.articleLoadMoreButton.userInteractionEnabled = NO;
//    }else{
//        [self.articleLoadMoreButton setImage:[UIImage imageNamed:@"箭头向下"] forState:UIControlStateNormal];
//        [self.articleLoadMoreButton setTitle:@"加载更多" forState:UIControlStateNormal];
//        [self.articleLoadMoreButton exchangeImageAndTitle];
//
//    }
//}

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
