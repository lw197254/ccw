//
//  MediaArtInfoTableView.m
//  chechengwang
//
//  Created by 严琪 on 2017/9/30.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "MediaArtInfoTableView.h"


#import "SubscribeDetailViewController.h"
#import "ArtInfoViewController.h"
#import "ShadowLoginViewController.h"
#import "CarDeptViewController.h"


#import "PTableViewCell.h"
#import "ImgTableViewCell.h"
#import "RelateCarTableViewCell.h"
#import "PublicNormalTableViewCell.h"
#import "RecommendTableViewCell.h"
#import "RelateTypeCarTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ZiMeiTiRelateCarTableViewCell.h"


#import "CommiteModel.h"

#import "InfoViewModel.h"
#import "CommiteListViewModel.h"
#import "AddCommentViewModel.h"
#import "MediaDetailViewModel.h"

#import "InfoDetailFont.h"
#import "IQKeyboardManager.h"
#import "DeliverData.h"
#import "UIImage+GIF.h"
#import "SaveFlow.h"
#import "SharePlatform.h"
#import "UIImage+ZLPhotoLib.h"
#import "ZLPhoto.h"
#import "MyUMShare.h"
#import "UITableView+UITableViewTopView.h"

#import "TableTopViewHeaderFooterView.h"
#import "TableViewHeaderFooterView.h"
#import "TableViewFooterView.h"

#import "ShareTableViewHeaderFooterView.h"
#import "CommentView.h"
#import "InfoTableView.h"
#import "ArtPopView.h"
#import "Utils.h"

#import "KouBeiArtModel.h"
#import "BrowseKouBeiArtModel.h"
#import "SubjectAuthorModel.h"
#import "SubjectUserModel.H"
#import "DeliverModel.h"
#import "ReadRecordModel.h"
#import "MatchModel.h"
#import "CommiteModel.h"
#import "ShareModel.h"


#import "CommitListTableView.h"
@interface MediaArtInfoTableView()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSArray<InfoNewSonModel> *sonModel;
@property(nonatomic,strong)NSArray<InfoRelateTypesModel> *relatetypes;
@property(nonatomic,strong)NSMutableArray<InfoContentModel> *contentList;
///存放图片的数组
@property(nonatomic,strong)NSMutableArray *photos;
@property(nonatomic,strong)NSMutableArray<InfoArticleModel> *articleList;
@property(nonatomic,strong)NSMutableArray<MatchModel> *match;

@property(nonatomic,strong)DeliverModel *deliverModel;
@property(nonatomic,strong)DeliverData *deliverData;



@property(nonatomic,strong)UIView *titleView;
@property(nonatomic,strong)SubjectAndSaveObject *subjectTool;
//文字
@property(nonatomic,retain)NSString *p;
@property(nonatomic,retain)NSString *s;
//图片
@property(nonatomic,retain)NSString *i;


@property(nonatomic,strong)MediaDetailViewModel *mediaModel;

@property (nonatomic,strong)AddCommentViewModel *addCommentViewModel;

@end


@implementation MediaArtInfoTableView

#pragma tableview界面

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
        
        [self registerNib:nibFromClass(RecommendTableViewCell) forCellReuseIdentifier:classNameFromClass(RecommendTableViewCell)];
        
        [self registerNib:nibFromClass(PublicNormalTableViewCell)
             forCellReuseIdentifier:classNameFromClass(PublicNormalTableViewCell)];
        
        [self registerNib:[UINib nibWithNibName:@"ShareTableViewHeaderFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"ShareTableViewHeaderFooterView"];
        
        [self registerNib:nibFromClass(RelateTypeCarTableViewCell) forCellReuseIdentifier:@"RelateTypeCarTableViewCell"];
        
        [self registerNib:nibFromClass(ZiMeiTiRelateCarTableViewCell) forCellReuseIdentifier:classNameFromClass(ZiMeiTiRelateCarTableViewCell)];
        
        [self registerClass:[TableSubjectTopHeaderFooterView class]  forHeaderFooterViewReuseIdentifier:classNameFromClass(TableSubjectTopHeaderFooterView)];
        
//        //尾部
//        [self registerNib:nibFromClass(CommitListTableView) forHeaderFooterViewReuseIdentifier:classNameFromClass(CommitListTableView)];
    }
    return self;
}

-(void)tableviewHeadView{
    
 
    if (self.data.title.length>10) {
        self.headview = [[TableSubjectTopHeaderFooterView alloc]initWithFrame:CGRectMake(0, 0, kwidth, 150)];
        
    }else{
         self.headview = [[TableSubjectTopHeaderFooterView alloc]initWithFrame:CGRectMake(0, 0, kwidth, 120)];
    }
    
     self.headview.subjectObject = self.subjectTool;
    
    [ self.headview setInfoData:self.data];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    @weakify(self);
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        //这边是头部点击事件
        [self jumpToZMT];
    }];
    [ self.headview addGestureRecognizer:tap];
    
    self.tableHeaderView =  self.headview;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.commitList.count>0) {
        return 3;
    }
    if (self.data.isNotEmpty ) {
        return 3;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            if ([self.contentList isNotEmpty]) {
                return self.contentList.count;
            }else{
                return 0;
            }
        }
            break;
        case 1:
        {
            if ([self.relatetypes isNotEmpty]) {
                return self.relatetypes.count;
            }else{
                return 0;
            }
            
        }
            break;
        case 2:
        {
            if ([self.articleList isNotEmpty]) {
                return self.articleList.count;
            }else{
                return 0;
            }
        }
            break;
            //这边是评论条数
        case 3:{
            if (self.commitList.count>0) {
               
                return 0;
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
            NSString *imgURL = [content.value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            
            UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgURL];
            [imgcell.img sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"默认图片330_165.png"]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//                 [imgcell updateConstraintsIfNeeded];
            }];
//            if ( !cachedImage ) {
//                [self downloadImage:imgURL forIndexPath:indexPath];
//                // [imgcell.btn setBackgroundImage:[UIImage imageNamed:@"默认图片330_165.png"] forState:UIControlStateNormal];
//                [imgcell.img setImage:[UIImage imageNamed:@"默认图片330_165.png"] ];
//            } else {
//                if (cachedImage.images !=NULL) {
//                    //这边是gif
//                    NSData *data =UIImageJPEGRepresentation(cachedImage, 1.0);
//                    UIImage *gifImage = [UIImage sd_animatedGIFWithData:data];
//                    imgcell.img.image = gifImage;
//                }else{
//                    [imgcell.img setImage:cachedImage ];
//                }
//            }
            imgcell.selectionStyle = UITableViewCellSelectionStyleNone;
            return imgcell;
        }
    }else if(indexPath.section ==1){
        ZiMeiTiRelateCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZiMeiTiRelateCarTableViewCell"];
        InfoRelateTypesModel *content = self.relatetypes[indexPath.row];
        [cell setData:content];
        //        [cell setArtType:self.arttype];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row != self.relatetypes.count-1) {
            [cell setBottomLineWithEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        return cell;
    }else if(indexPath.section ==2){
        InfoArticleModel *content = self.articleList[indexPath.row];
        
        if ([content.artType isEqualToString:zimeiti]) {
            PublicNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PublicNormalTableViewCell" forIndexPath:indexPath];
            [cell setData:content];
            if (indexPath.row != self.articleList.count-1) {
                [cell setBottomLineWithEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            RecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendTableViewCell" forIndexPath:indexPath];
            [cell.img setImageWithURL:[NSURL URLWithString:content.thumb] placeholderImage:[UIImage imageNamed:@"默认图片80_60.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            cell.title.text = content.title;
            cell.title.numberOfLines = 0;
            cell.view.text = content.click;
            cell.time.text = content.inputtime;
            
            if (indexPath.row != self.articleList.count-1) {
                [cell setBottomLineWithEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else if(indexPath.section == 3){

    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        InfoContentModel *content = self.contentList[indexPath.row];
        if ([content.type isEqualToString:self.i]) {
            return UITableViewAutomaticDimension;
//            UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey: content.value];
//
//            // 没有找到已下载的图片就使用默认的占位图，当然高度也是默认的高度了，除了高度不固定的文字部分。
//            if (!image) {
//                image = [UIImage imageNamed:@"默认图片330_165.png"];
//            }
//
//            //手动计算cell
//            CGFloat imgHeight = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
//            return imgHeight;
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
        return 150;
    }else if(indexPath.section == 1){
        return 95;
    }else if(indexPath.section == 2){
        return 95;
    }else if(indexPath.section == 3){
        return 200;
    }
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        if (self.data.isNotEmpty) {
            
//                TableSubjectTopHeaderFooterView *headview =[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TableSubjectTopHeaderFooterView"];
//                headview.subjectObject = self.subjectTool;
//
//                [headview setInfoData:self.data];
//                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
//                @weakify(self)
//                [[tap rac_gestureSignal] subscribeNext:^(id x) {
//                    //这边是头部点击事件
//                    [self_weak_ jumpToZMT];
//                }];
//                [headview addGestureRecognizer:tap];
//
//                return headview;
            return nil;
            
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
            headview.contentView.backgroundColor = [UIColor whiteColor];
            [headview.label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
            return headview;
        }
    }else if(section ==2){
        if (self.articleList.count>0) {
            TableViewHeaderFooterView *headview = [[TableViewHeaderFooterView alloc]initWithFrame:CGRectMake(0, 0, kwidth, 25)];
            headview.noimage =YES;
            headview.image.hidden =NO;
            headview.label.text = @"相关文章";
            [headview.image setBackgroundColor:BlackColor333333];
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

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 0){
        ShareTableViewHeaderFooterView *footView = [[ShareTableViewHeaderFooterView alloc]initWithFrame:CGRectMake(0, 0, kwidth, 160)];
        footView.shareUrl = self.data.arcurl;
        footView.title = self.data.title;
        footView.model = self.data;
        footView.thumb = self.data.thumb;
        
        footView.contentView.backgroundColor = [UIColor whiteColor];
        return footView;
    }else if(section ==1){
        if (self.relatetypes.count>0) {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kwidth, 10)];
            view.backgroundColor =BlackColorF1F1F1;
            return view;
        }
    }else if(section ==2){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kwidth, 10)];
        view.backgroundColor =BlackColorF1F1F1;
        return view;
    }
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        
        return 0.000001;
    }else if(section ==1){
        if (self.relatetypes.count>0) {
            return 25;
        }return 0.000001;
    }else if(section ==2){
        return 25;
    }else if(section ==3){
        return kheight;
    }
    return 0.000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0){
        return 160;
    }else if(section ==1){
        if (self.relatetypes.count>0) {
            return 10;
        }return 0.0001;
    }else if(section ==2){
//        if (self.commitList.count>0) {
            return 10;
//        }return 0.0001;
    }
    return 0.0001;
}

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
      
        if ([art.artType isEqualToString:zimeiti]) {
            PublicNormalTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if ([art.isRead isEqualToString:isread]) {
                cell.title.textColor = BlackColor999999;
            }else{
                cell.title.textColor = BlackColor333333;
            }
        }else{
            RecommendTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if ([art.isRead isEqualToString:isread]) {
                cell.title.textColor = BlackColor999999;
            }else{
                cell.title.textColor = BlackColor333333;
            }
        }
        
        //        if ([art.isRead isEqualToString:notread]) {
//            art.isRead = isread;
//            [self reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//        }
        
        [[Tool currentNavigationController].rt_navigationController pushViewController:controller animated:YES];
        
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
//跳转去自媒体的方法
-(void)jumpToZMT{
   
    SubscribeDetailViewController *controller = [[SubscribeDetailViewController alloc] init];
    SubjectUserModel *model = [[SubjectUserModel alloc] init];

    NSArray*array =  [SubjectUserModel findByColumn:@"authorId" value: self.data.authorId]  ;

    if (array.count) {
        model = array[0];
    }else{
        model.authorName = self.data.authorName;
        model.imgurl = self.data.authorPic;
        model.authorId = self.data.authorId;
    }

    controller.model = model;

    [[Tool currentNavigationController].rt_navigationController pushViewController:controller animated:YES];
}


#pragma 功能
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (self.block) {
//        self.block(scrollView);
//    }
//
//    if (scrollView.contentOffset.y > scrollView.contentSize.height) {
//        NSLog(@"可以滑动");
//    }else{
//         NSLog(@"可以不可滑动");
//    }
    
}

#pragma 其余界面


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

-(SubjectAndSaveObject *)subjectTool{
    if(!_subjectTool){
        _subjectTool = [[SubjectAndSaveObject alloc] init];
    }
    return _subjectTool;
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

-(MediaDetailViewModel *)mediaModel{
    if (!_mediaModel) {
        _mediaModel = [MediaDetailViewModel SceneModel];
    }
    return _mediaModel;
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
 
    [self tableviewHeadView];
    [self reloadData];
}


@end
