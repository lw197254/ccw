//
//  ShareTableViewHeaderFooterView.m
//  chechengwang
//
//  Created by 严琪 on 17/1/13.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ShareTableViewHeaderFooterView.h"
#import "ShareCellCollectionViewCell.h"
#import "MyUMShare.h"

static NSString *cell = @"ShareCellCollectionViewCell";
@interface ShareTableViewHeaderFooterView()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)NSArray *arrayList;

@end

@implementation ShareTableViewHeaderFooterView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        UICollectionViewFlowLayout*layout = [[UICollectionViewFlowLayout alloc]init];
        
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0,kwidth,100)                                                                      collectionViewLayout:layout];
        
        [self addSubview:self.collectionView];
        [self initData];
        
        self.collectionView.backgroundColor = [UIColor whiteColor];
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        [self.collectionView registerNib:[UINib nibWithNibName:cell bundle:nil] forCellWithReuseIdentifier:cell];
        
        // 初始化分享至
        // 将分享至改成线
        UIView *label = [[UIView alloc]init];
        //label.text = @"分享至";
//        label.font = FontOfSize(14);
//        label.textColor = BlackColor333333;
        label.backgroundColor = BlackColorE3E3E3;

        
        [self addSubview:label];
 
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.mas_equalTo(lineHeight);
            make.top.equalTo(self.mas_top).offset(35);
        }];
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.mas_equalTo(95);
            make.top.equalTo(label.mas_bottom).offset(10);
        }];
        
        UILabel *backgroundline = [[UILabel alloc]init];
        backgroundline.backgroundColor = BlackColorF1F1F1;
        
        [self addSubview:backgroundline];
        
        [backgroundline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(10);
            make.bottom.equalTo(self.mas_bottom);
        }];


    }
    return self;
}

-(void)initData{
    self.arrayList =@[@{@"name":@"微信",@"pic":@"icon_wechat"},@{@"name":@"朋友圈",@"pic":@"icon_wechatq"},@{@"name":@"QQ好友",@"pic":@"icon_QQ"}
                      ,@{@"name":@"QQ空间",@"pic":@"icon_QQ空间"}];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrayList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ShareCellCollectionViewCell *collectioncell = [collectionView dequeueReusableCellWithReuseIdentifier:cell forIndexPath:indexPath];
    collectioncell.shareImage.image = [UIImage imageNamed:self.arrayList[indexPath.row][@"pic"]];

    collectioncell.name.text = self.arrayList[indexPath.row][@"name"];

    return collectioncell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kwidth-50)/self.arrayList.count, 95);
}

//点击分享
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
            //微信
        case 0:
            [MyUMShare shareWithSSDKPlatform:SSDKPlatformTypeWechat title:self.title conent:self.title artUrl:self.shareUrl picUrl:self.thumb];
            break;
            //朋友圈
        case 1:
            [MyUMShare shareWithSSDKPlatform:SSDKPlatformSubTypeWechatTimeline title:self.title conent:self.title artUrl:self.shareUrl picUrl:self.thumb];
            break;
//            //新浪微博
//        case 2:
//            
//            break;
            //QQ好友
        case 2:
            [MyUMShare shareWithSSDKPlatform:SSDKPlatformTypeQQ title:self.title conent:self.title artUrl:self.shareUrl picUrl:self.thumb];
            break;
            //QQ空间
        case 3:
            [MyUMShare shareWithSSDKPlatform:SSDKPlatformSubTypeQZone title:self.title conent:self.title artUrl:self.shareUrl picUrl:self.thumb];
            break;
            
        default:
            break;
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
