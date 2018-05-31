//
//  SubjectvViewController.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/13.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "SubjectViewController.h"
#import "CarDeptViewController.h"
#import "SubjectCollectionViewCell.h"

#import "SubjectViewModel.h"
#import "XiHaoSubjectModel.h"
#import "SubjectChexiModel.h"
#import "PicModel.h"

@interface SubjectViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIImageView *topImage;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) SubjectViewModel *viewModel;

@property (strong, nonatomic) XiHaoSubjectModel *baseData;

@end

@implementation SubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UICollectionViewFlowLayout*layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.collectionView setCollectionViewLayout:layout];
    
    [self.collectionView registerNib:nibFromClass(SubjectCollectionViewCell) forCellWithReuseIdentifier:classNameFromClass(SubjectCollectionViewCell)];
    
    self.viewModel.request.zhutiid = self.id;
    self.viewModel.request.startRequest = YES;

}

#pragma 代理方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.baseData.chexiitems.count>0) {
        return 1;
    }
    return 0;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.baseData.chexiitems.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SubjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:classNameFromClass(SubjectCollectionViewCell) forIndexPath:indexPath];
    
    SubjectChexiModel *model = self.baseData.chexiitems[indexPath.row];
    PicModel *pic = model.picture;
    
    [cell setSubjectModel:model];
    
    [cell.topImage setImageWithURL:[NSURL URLWithString:pic.bigpic] placeholderImage:[UIImage imageNamed:@"默认图片105_80"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    NSString *picname = [NSString stringWithFormat:@"top%ld",indexPath.row+1];
    
    [cell.rightAngleImage setImage:[UIImage imageNamed:picname]];
    
    cell.carname.text = model.car_brand_type_name;
    cell.price.text = model.dealer_series_price;
    cell.paiming.text = model.line3str;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CarDeptViewController *vc = [[CarDeptViewController alloc] init];
    SubjectChexiModel *model = self.baseData.chexiitems[indexPath.row];
    vc.chexiid = model.car_brand_type_id;
    [[Tool currentViewController].rt_navigationController pushViewController:vc animated:YES];
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kwidth-30-10)/2, 211);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(SubjectViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [SubjectViewModel SceneModel];
        
        [[RACObserve(_viewModel, data)filter:^BOOL(id value) {
            return _viewModel.data.isNotEmpty;
        }]subscribeNext:^(id x) {
            if (x) {
                self.baseData = _viewModel.data;
                [self.topImage setImageWithURL:[NSURL URLWithString:self.baseData.zhutiimg] placeholderImage:[UIImage imageNamed:@"默认图片105_80"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [self setTitle:self.baseData.name];
                [self.collectionView reloadData];
            }
        }];
    }
    return _viewModel;
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
