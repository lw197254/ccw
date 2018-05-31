//
//  CarVikiViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2017/5/15.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "CarVikiViewController.h"
 
#import "HomeViewController.h"

#import "InfoViewModel.h"
#import "InfoContentModel.h"
#import "PTableViewCell.h"
#import "ImgTableViewCell.h"
#import "RelateCarTableViewCell.h"
#import "RecommendTableViewCell.h"
#import "CarDeptViewController.h"

#import "TableViewHeaderFooterView.h"
#import "TableViewFooterView.h"
#import "TableTopViewHeaderFooterView.h"
#import "ShareTableViewHeaderFooterView.h"
#import "CarDeptViewController.h"

#import "InfoRelateTypesModel.h"
#import "RelateTypeCarTableViewCell.h"
#import "ZiMeiTiRelateCarTableViewCell.h"

#import "InfoTableView.h"
#import "KouBeiArtModel.h"
#import "BrowseKouBeiArtModel.h"

#import "Utils.h"
//图片
#import "UIImage+ZLPhotoLib.h"
#import "ZLPhoto.h"



#import "SaveFlow.h"


#import "DeliverModel.h"
#import "ReadRecordModel.h"
#import "MatchModel.h"

#import "DeliverData.h"
#import "SubjectAndSaveObject.h"

#import "CarViKiViewModel.h"
@interface CarVikiViewController ()<UITableViewDelegate,UITableViewDataSource>



@property(nonatomic,strong)CarViKiViewModel *viewModel;



@property(nonatomic,strong)UITableView *tableView;

//文字
@property(nonatomic,retain)NSString *p;
@property(nonatomic,retain)NSString *s;
//图片
@property(nonatomic,retain)NSString *i;



///存放图片的数组
@property(nonatomic,strong)NSMutableArray *photos;


@property(nonatomic,strong)DeliverModel *deliverModel;
@property(nonatomic,strong)DeliverData *deliverData;

//头部标题是否要两行
@property(nonatomic,assign)bool needmax;

@property(nonatomic,strong)SubjectAndSaveObject *subjectTool;

@end


@implementation CarVikiViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
   
    
   
   
    
    self.p =@"p";
    self.s =@"strong";
    self.i =@"img";
    
   
    
    [self initTableView];
   
    [self initdata];
    
    
    
    
  
    
}

-(SubjectAndSaveObject *)subjectTool{
    if(!_subjectTool){
        _subjectTool = [[SubjectAndSaveObject alloc] init];
    }
    return _subjectTool;
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




-(void)initdata{
    self.viewModel = [CarViKiViewModel SceneModel];
    [self showNavigationTitle:self.key];
    self.viewModel.request.key = self.key;
    
    self.viewModel.request.startRequest = YES;
     @weakify(self);
    [[RACObserve(self.viewModel, model)filter:^BOOL(id value) {
        @strongify(self);
        return self.viewModel.model.isNotEmpty;
    }]subscribeNext:^(id x) {
        @strongify(self);
         [self.tableView reloadData];
        if (self.viewModel.model.data.count > 0) {
            [self.tableView dismissWithOutDataView];
            [self initPhotos];
        }else{
            [self.tableView showWithOutDataViewWithTitle:@"暂无数据"];
        }
      
        
        
        
       
        
        
       
        //[self.tableView layoutIfNeeded];
    }];
    [[RACObserve(self.viewModel, request)filter:^BOOL(id value) {
        @strongify(self);
        return self.viewModel.request.failed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView showNetLost];
       
        //[self.tableView layoutIfNeeded];
    }];
    
    
}

-(void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
   
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PTableViewCell" bundle:nil] forCellReuseIdentifier:@"PTableViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ImgTableViewCell" bundle:nil] forCellReuseIdentifier:@"ImgTableViewCell"];
    
  
    
   
    
   
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.viewModel.model.isNotEmpty) {
        return 1;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.viewModel.model.data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
        InfoContentModel *content = self.viewModel.model.data[indexPath.row];
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
    
        return UITableViewAutomaticDimension;

}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
     return 44;
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
        InfoContentModel *content = self.viewModel.model.data[indexPath.row];
        if ([content.type isEqualToString:self.p]||[content.type isEqualToString:self.s]) {
            PTableViewCell *titlecell = [tableView dequeueReusableCellWithIdentifier:@"PTableViewCell" forIndexPath:indexPath];
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
                [imgcell.img setImage:cachedImage ];
                //[imgcell.btn setBackgroundImage:cachedImage forState:UIControlStateNormal];
            }
            
            imgcell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return imgcell;
        }
   }
///点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
        InfoContentModel *content = self.viewModel.model.data[indexPath.row];
        int count = 0;
        for (ZLPhotoPickerBrowserPhoto *photo in self.photos) {
            if([photo.photoURL.absoluteString isEqual:content.value]){
                break;
            }
            count++;
        }
        [self jump2photo:count];
    
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
        for (InfoContentModel *model in self.viewModel.model.data) {
            if([model.type isEqualToString:@"img"]){
                ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
                photo.photoURL = [NSURL URLWithString:model.value];
                [self.photos addObject:photo];
            }
        }
    }
}







-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
      return 0.000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
       return 0.000001;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}










- (void)downloadImage:(NSString *)imageURL forIndexPath:(NSIndexPath *)indexPath {
    // 利用 SDWebImage 框架提供的功能下载图片
    [[GCDQueue globalQueue]queueBlock:^{
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageURL] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            // do nothing
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            
            
            
            if (!error) {
                [[SDImageCache sharedImageCache] storeImage:image forKey:imageURL toDisk:YES];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    [self.tableView reloadData];
                });
                
            }
        }];
        
    }];
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
