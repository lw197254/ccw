//
//  NormalArtTableView.m
//  chechengwang
//
//  Created by 严琪 on 2017/9/30.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "NormalArtTableView.h"

#import "CarDeptViewController.h"
#import "ArtInfoViewController.h"
#import "ZLPhotoPickerBrowserViewController.h"

#import "PTableViewCell.h"
#import "ImgTableViewCell.h"
#import "RelateCarTableViewCell.h"
#import "RecommendTableViewCell.h"
#import "RelateTypeCarTableViewCell.h"
#import "ZiMeiTiRelateCarTableViewCell.h"
#import "MyCommentTableViewCell.h"
#import "DoubleCommentTableViewCell.h"
#import "DoubleSingleCommentTableViewCell.h"

#import "TableViewHeaderFooterView.h"
#import "TableViewFooterView.h"
#import "TableTopViewHeaderFooterView.h"
#import "ShareTableViewHeaderFooterView.h"

#import "CommiteModel.h"

#import "InfoViewModel.h"
#import "CommiteListViewModel.h"
#import "AddCommentViewModel.h"
#import "MediaDetailViewModel.h"


#import "DeliverData.h"

#import "KouBeiArtModel.h"
#import "BrowseKouBeiArtModel.h"
#import "SubjectAuthorModel.h"
#import "SubjectUserModel.H"
#import "DeliverModel.h"
#import "ReadRecordModel.h"
#import "MatchModel.h"
#import "CommiteModel.h"
#import "ShareModel.h"

#import "ZLPhotoPickerBrowserPhoto.h"

@interface NormalArtTableView()
@property(nonatomic,strong)NSArray<InfoNewSonModel> *sonModel;
@property(nonatomic,strong)NSArray<InfoRelateTypesModel> *relatetypes;
@property(nonatomic,strong)NSMutableArray<InfoContentModel> *contentList;
///存放图片的数组
@property(nonatomic,strong)NSMutableArray *photos;
@property(nonatomic,strong)NSMutableArray<InfoArticleModel> *articleList;
@property(nonatomic,strong)NSMutableArray<MatchModel> *match;

@property(nonatomic,strong)DeliverModel *deliverModel;
@property(nonatomic,strong)DeliverData *deliverData;

//文字
@property(nonatomic,retain)NSString *p;
@property(nonatomic,retain)NSString *s;
//图片
@property(nonatomic,retain)NSString *i;


@property (nonatomic,strong) CommiteListViewModel *commiteViewModel;
@property (nonatomic,strong) AddCommentViewModel *addCommentViewModel;
@property (nonatomic,copy)NSMutableArray *commitList;
@end

@implementation NormalArtTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        
     
        self.delegate = self;
        self.dataSource = self;
        self.estimatedSectionFooterHeight = 0;
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        self.separatorStyle =  UITableViewCellSeparatorStyleNone;
        [self setBackgroundColor:[UIColor whiteColor]];
        
        self.p =@"p";
        self.s =@"strong";
        self.i =@"img";
        
        [self registerNib:[UINib nibWithNibName:@"PTableViewCell" bundle:nil] forCellReuseIdentifier:@"PTableViewCell"];
        
        [self registerNib:[UINib nibWithNibName:@"ImgTableViewCell" bundle:nil] forCellReuseIdentifier:@"ImgTableViewCell"];
        
        [self registerNib:[UINib nibWithNibName:@"RelateCarTableViewCell" bundle:nil] forCellReuseIdentifier:@"RelateCarTableViewCell"];
        
        [self registerNib:[UINib nibWithNibName:@"RecommendTableViewCell" bundle:nil]
             forCellReuseIdentifier:@"RecommendTableViewCell"];
        
        [self registerNib:[UINib nibWithNibName:@"ShareTableViewHeaderFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"ShareTableViewHeaderFooterView"];
        
        [self registerNib:nibFromClass(RelateTypeCarTableViewCell) forCellReuseIdentifier:@"RelateTypeCarTableViewCell"];
        
        [self registerNib:nibFromClass(ZiMeiTiRelateCarTableViewCell) forCellReuseIdentifier:classNameFromClass(ZiMeiTiRelateCarTableViewCell)];
        
        //评论
        [self registerNib:nibFromClass(MyCommentTableViewCell) forCellReuseIdentifier:classNameFromClass(MyCommentTableViewCell)];
        
        [self registerNib:nibFromClass(DoubleCommentTableViewCell) forCellReuseIdentifier:classNameFromClass(DoubleCommentTableViewCell)];
        
        [self registerNib:nibFromClass(DoubleSingleCommentTableViewCell) forCellReuseIdentifier:classNameFromClass(DoubleSingleCommentTableViewCell)];
    }
    return self;
}

#pragma 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.commiteViewModel.data.isNotEmpty) {
        return 4;
    }
    
    if (self.data.isNotEmpty ) {
        return 3;
    }
    
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return self.contentList.count;
            break;
        case 1:
            return self.relatetypes.count;
            break;
        case 2:
            return self.articleList.count;
            break;
            //这边是评论条数
        case 3:{
            if ([self.commitList isNotEmpty]) {
                return self.commitList.count;
            }else{
                return 0;
            }
            
        }
            break;
        default:
            return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 ) {
        InfoContentModel *content = self.contentList[indexPath.row];
        if ([content.type isEqualToString:self.i]) {

            
            UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey: content.value];
            
            // 没有找到已下载的图片就使用默认的占位图，当然高度也是默认的高度了，除了高度不固定的文字部分。
            if (!image) {
                image = [UIImage imageNamed:@"默认图片330_165.png"];
            }
            
            //手动计算cell
            CGFloat imgHeight = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
            return imgHeight;
            
        }
    }else if(indexPath.section == 1){
        return 95;
    }else if(indexPath.section == 2){
        return 95;
    }else if(indexPath.section == 3){
        return UITableViewAutomaticDimension;
    }
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
    
    }else if(indexPath.section == 1){
        return 95;
    }else if(indexPath.section == 2){
        return 95;
    }else if(indexPath.section == 3){
        return 200;
    }
    return 44;
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        InfoContentModel *content = self.contentList[indexPath.row];
        if ([content.type isEqualToString:self.p]||[content.type isEqualToString:self.s]) {
            PTableViewCell *titlecell = [tableView dequeueReusableCellWithIdentifier:@"PTableViewCell" forIndexPath:indexPath];
            [titlecell setMatch:self.match];
            [titlecell setinfo:content];
            titlecell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return titlecell;
        }else{
            ImgTableViewCell *imgcell = [tableView dequeueReusableCellWithIdentifier:@"ImgTableViewCell" forIndexPath:indexPath];
            
            
            NSString *imgURL = content.value;
            UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgURL];
            
            
            
            
            if ( !cachedImage ) {
                [self downloadImage:imgURL forIndexPath:indexPath];
                // [imgcell.btn setBackgroundImage:[UIImage imageNamed:@"默认图片330_165.png"] forState:UIControlStateNormal];
                [imgcell.img setImage:[UIImage imageNamed:@"默认图片330_165.png"] ];
            } else {
                
                
                if (cachedImage.images !=NULL) {
                    //这边是gif
                    Duration duration = (1.0f / 10.0f) * cachedImage.images.count;
                    UIImage *animatedImage = [UIImage animatedImageWithImages:cachedImage duration:duration];
                    imgcell.img.image = animatedImage;
                }else{
                    [imgcell.img setImage:cachedImage ];
                }
                
                //[imgcell.btn setBackgroundImage:cachedImage forState:UIControlStateNormal];
            }
            
            imgcell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return imgcell;
        }
    }else if(indexPath.section ==1){
        
        ZiMeiTiRelateCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZiMeiTiRelateCarTableViewCell"];
        InfoRelateTypesModel *content = self.relatetypes[indexPath.row];
        [cell setData:content];
        [cell setArtType:zimeiti];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row != self.relatetypes.count-1) {
            [cell setBottomLineWithEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        return cell;
    }else if(indexPath.section ==2){
        InfoArticleModel *content = self.articleList[indexPath.row];
        RecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendTableViewCell" forIndexPath:indexPath];
        [cell.img setImageWithURL:[NSURL URLWithString:content.thumb] placeholderImage:[UIImage imageNamed:@"默认图片80_60.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        if ([content.isRead isEqualToString:isread]) {
            cell.title.textColor = BlackColor999999;
        }else{
            cell.title.textColor = BlackColor333333;
        }
        
        cell.title.text = content.title;
        
        if ([content.authorName isNotEmpty]) {
            cell.view.text = content.authorName;
        }else{
            cell.view.text = @"车城网";
        }
        
        cell.time.text = [NSString stringWithFormat:@"%@人阅读",content.click];
        
        if (indexPath.row != self.articleList.count-1) {
            [cell setBottomLineWithEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if(indexPath.section == 3){
        CommiteModel *model = self.commitList[indexPath.row];
        if (![model.recontent isNotEmpty]) {
            MyCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(MyCommentTableViewCell) forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setMessageModel:model];
            [cell setMessageModelIndex:indexPath.row];
            [cell.commite addTarget:self action:@selector(cellCommentMessage:) forControlEvents:UIControlEventTouchUpInside];
            
            
            return cell;
        }else{
            if (model.maxnum>2) {
                DoubleCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(DoubleCommentTableViewCell) forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [cell setMessageModel:model];
                [cell setMessageModelIndex:indexPath.row];
                [cell.commite addTarget:self action:@selector(cellCommentMessage:) forControlEvents:UIControlEventTouchUpInside];
                
                
                return cell;
            }else{
                
                DoubleSingleCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(DoubleSingleCommentTableViewCell) forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [cell setMessageModel:model];
                [cell setMessageModelIndex:indexPath.row];
                [cell.commite addTarget:self action:@selector(cellCommentMessage:) forControlEvents:UIControlEventTouchUpInside];
                
                
                return cell;
            }
        }
    }
    
    
    return nil;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 0){
        ShareTableViewHeaderFooterView *footView = [[ShareTableViewHeaderFooterView alloc]initWithFrame:CGRectMake(0, 0, kwidth, 160)];
        footView.shareUrl = self.data.arcurl;
        footView.title = self.data.title;
        footView.model = self.data;
        footView.thumb = self.data.thumb;
        
        [footView.contentView setBackgroundColor:[UIColor whiteColor]];
        return footView;
    }else if(section ==1){
        if (self.relatetypes.count>0) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kwidth, 10)];
            view.backgroundColor =BlackColorF1F1F1;
            return view;
            //        TableViewFooterView *footView = [[TableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, kwidth, 10)];
            //            footView.image.hidden =YES;
            ////        footView.label.text = @"查看相关车型对比";
            ////        footView.label.textColor =LabelTextblueColor;
            ////        footView.label.font = [UIFont italicSystemFontOfSize:14];
            ////
            ////        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlTap)];
            ////            [tapRecognizer setNumberOfTapsRequired:1];
            ////        [footView addGestureRecognizer:tapRecognizer];
            ////        footView.userInteractionEnabled =YES;
            //        footView.label.backgroundColor = cutlineback;
            //        return footView;
        }
    }else if(section ==2){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kwidth, 10)];
        view.backgroundColor =BlackColorF1F1F1;
        return view;
    }
    
    return nil;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        if (self.data.isNotEmpty) {
            TableTopViewHeaderFooterView *headview =[[TableTopViewHeaderFooterView alloc]initWithFrame:CGRectMake(0, 0, kwidth, 45)];
            
            headview.labelTitle.text = self.data.title;
            headview.labelTitle.textColor = BlackColor333333;
            
            UIFont *font = [UIFont fontWithName:@"PingFangSC-Semibold" size:23];
            
            if (font) {
                [headview.labelTitle setFont:font];
            }else{
                [headview.labelTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:23]];
            }
            
            headview.labelTitle.numberOfLines =2;
            
            headview.views.text= self.data.click;
            headview.views.textColor = BlackColorBBBBBB;
            headview.views.font =  FontOfSize(11);
            
            headview.soure.text = self.data.source;
            headview.soure.textColor = BlackColorBBBBBB;
            headview.soure.font =  FontOfSize(11);
            
            headview.author.text = self.data.auther;
            headview.author.textColor = BlackColorBBBBBB;
            headview.author.font =  FontOfSize(11);
            
            headview.time.text = self.data.inputtime;
            headview.time.textColor = BlackColorBBBBBB;
            headview.time.font =  FontOfSize(11);
            
            headview.image.image = [UIImage imageNamed:@"icon_sea"];
            [headview.contentView setBackgroundColor:[UIColor whiteColor]];
            return headview;
        }
    }else if(section ==1){
        if (self.relatetypes.count>0) {
            
            TableViewHeaderFooterView *headview = [[TableViewHeaderFooterView alloc]initWithFrame:CGRectMake(0, 0, kwidth, 25)];
            headview.label.text = @"相关车系";
            [headview.image mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(headview.label);
                make.bottom.equalTo(headview);
            }];
            
            headview.noimage =YES;
            headview.image.hidden =NO;
            [headview.image setBackgroundColor:BlackColor333333];
            headview.label.textColor =BlackColor333333;
            [headview.contentView setBackgroundColor:[UIColor whiteColor]];
            [headview.label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
            return headview;
        }
    }else if(section ==2){
        if (self.articleList.count>0) {
            TableViewHeaderFooterView *headview = [[TableViewHeaderFooterView alloc]initWithFrame:CGRectMake(0, 0, kwidth, 25)];
            headview.noimage =YES;
            [headview.image mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(headview.label);
                make.bottom.equalTo(headview);
            }];
            
            headview.image.hidden =NO;
            [headview.image setBackgroundColor:BlackColor333333];
            headview.label.text = @"相关文章";
            headview.label.textColor =BlackColor333333;
            [headview.contentView setBackgroundColor:[UIColor whiteColor]];
            [headview.label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
            return headview;
        }
    }else if(section == 3){
        if (self.commitList.count>0) {
            TableViewHeaderFooterView *headview = [[TableViewHeaderFooterView alloc]initWithFrame:CGRectMake(0, 0, kwidth, 25)];
            headview.noimage =YES;
            headview.image.hidden =NO;
            [headview.image setBackgroundColor:BlackColor333333];
            headview.label.text = @"评论";
            [headview.image mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(headview.label);
                make.bottom.equalTo(headview);
            }];
            headview.label.textColor =BlackColor333333;
            headview.contentView.backgroundColor = [UIColor whiteColor];
            [headview.label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
            return headview;
        }
    }
    
    
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        if (self.data.title.length>10) {
            return 140;
        }else{
            return 120;
        }
    }else if(section ==1){
        if (self.relatetypes.count>0) {
            return 25;
        }return 0.000001;
    }else if(section ==2){
        return 25;
    }else if(section ==3){
        if (self.commitList.count>0){
            return 25;
        }
    }
    return 0.000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0){
        return 160;
    }else if(section ==1){
        if (self.relatetypes.count>0) {
            return 10;
        }return 0.000001;
    }else if(section ==2){
        if (self.commitList.count>0) {
            return 10;
        }return 0.0001;
    }
    return 0.000001;
}

#pragma 功能

#pragma 点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        InfoContentModel *content = self.contentList[indexPath.row];
        
        if ([content.type isEqualToString:self.i]) {
            int count = 0;
            for (ZLPhotoPickerBrowserPhoto *photo in self.photos) {
                if([photo.photoURL.absoluteString isEqual:content.value]){
                    break;
                }
                count++;
            }
            [self jump2photo:count];
        }
        
    }else if(indexPath.section == 1){
        //车系详情
        InfoRelateTypesModel *model = self.relatetypes[indexPath.row];
        CarDeptViewController *controller =[[CarDeptViewController alloc] init];
        //UIViewController *controller = [[UIViewController alloc] init];
        controller.chexiid = model.typeid;
        controller.picture = model.picurl;
        [[Tool currentNavigationController].rt_navigationController pushViewController:controller animated:YES];
        
    }else if(indexPath.section == 2){
        
        //UIViewController *controller = [[UIViewController alloc] init];
        InfoArticleModel *art = self.articleList[indexPath.row];
        ArtInfoViewController *controller = [[ArtInfoViewController alloc] init];
        controller.aid = art.id;
        controller.artType = art.artType;
        
        art.isRead = isread;
        
        
        RecommendTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([art.isRead isEqualToString:isread]) {
            cell.title.textColor = BlackColor999999;
        }else{
            cell.title.textColor = BlackColor333333;
        }
      
        
        [[Tool currentNavigationController].rt_navigationController pushViewController:controller animated:YES];
        
//        if ([art.isRead isEqualToString:notread]) {
//            art.isRead = isread;
//            [self reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//        }
        
    }
}

//跳转图片
-(void)jump2photo:(NSInteger) count{
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 淡入淡出效果
    // pickerBrowser.status = UIViewAnimationAnimationStatusFade;
    // 数据源/delegate
    //    pickerBrowser.editing = YES;
    pickerBrowser.photos = self.photos;
    // 当前选中的值
    pickerBrowser.currentIndex = count;
    // 展示控制器
    // 加入这个方法，可以使得条转方法变快
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       //跳转界面
                       [pickerBrowser showPickerVc:[Tool currentViewController]];
                   });
}


//初始化列表
-(void)initPhotos{
    if(!self.photos){
        self.photos = [[NSMutableArray alloc]init];
        for (InfoContentModel *model in self.contentList) {
            if([model.type isEqualToString:@"img"]){
                ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
                photo.photoURL = [NSURL URLWithString:model.value];
                [self.photos addObject:photo];
            }
        }
    }
}

- (void)downloadImage:(NSString *)imageURL forIndexPath:(NSIndexPath *)indexPath {
    @weakify(self)
    [[GCDQueue globalQueue]queueBlock:^{
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageURL] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            // do nothing
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            if (!error) {
                
                [[SDImageCache sharedImageCache] storeImage:image forKey:imageURL toDisk:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self_weak_ reloadData];
                });
                
            }
        }];
        
    }];
}



#pragma 懒加载

-(NSMutableArray *)commitList{
    if (!_commitList) {
        _commitList = [NSMutableArray arrayWithCapacity:5];
    }
    return _commitList;
    
}

-(CommiteListViewModel *)commiteViewModel{
    if (!_commiteViewModel) {
        _commiteViewModel = [CommiteListViewModel SceneModel];
    }
    return _commiteViewModel;
}

-(AddCommentViewModel *)addCommentViewModel{
    if (!_addCommentViewModel) {
        _addCommentViewModel = [AddCommentViewModel SceneModel];
    }
    return _addCommentViewModel;
}

-(DeliverModel *)deliverModel{
    if (!_deliverModel) {
        _deliverModel = [[DeliverModel alloc] init];
    }
    return _deliverModel;
}

-(DeliverData *)deliverData{
    if (!_deliverData) {
        _deliverData = [[DeliverData alloc] init];
    }
    return _deliverData;
}

 
-(NSMutableArray<InfoContentModel> *)contentList{
    if (!_contentList) {
        _contentList = [[NSMutableArray<InfoContentModel> alloc]init];
    }
    return _contentList;
}

-(NSMutableArray<InfoArticleModel> *)articleList{
    if (!_articleList) {
        _articleList = [[NSMutableArray<InfoArticleModel> alloc] init];
    }
    return _articleList;
}

-(NSMutableArray<MatchModel> *)match{
    if (!_match) {
        _match = [[NSMutableArray<MatchModel> alloc]init];
    }
    return _match;
}

-(void)setMediaData:(InfoBaseModel *)data{
    
    self.data = data;
    self.contentList = [self.data.content copy];
    
    self.sonModel = self.data.carRecommedList;
    self.match = self.data.match;
    
    [self.deliverData setinfo:self.contentList matches:self.match];
    
    self.articleList = [self.data.articleList copy];
    self.articleList = [self.deliverModel deliverInfoArticleModel:self.articleList];
    self.relatetypes = self.data.relatetypes;
    
    [self initPhotos];
    
    
    [self reloadData];
}
@end
