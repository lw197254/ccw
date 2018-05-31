//
//  paragramSelectView.m
//  chechengwang
//
//  Created by 刘伟 on 2017/4/19.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ParagramSelectView.h"
#import "ParameterClassifyCollectionViewCell.h"
@interface ParagramSelectView()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property(nonatomic,strong)NSArray*dataArray;
//@property(nonatomic,assign)NSInteger selectedButtonTag;
@property(nonatomic,copy)ParagramItemSelectedBlock block;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;
@end
@implementation ParagramSelectView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [super awakeFromNib];
    
 
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tap];
    self.collectionView.dataSource = self;
    self.collectionView.delegate =self;
    [self.collectionView registerNib:nibFromClass(ParameterClassifyCollectionViewCell) forCellWithReuseIdentifier:classNameFromClass(ParameterClassifyCollectionViewCell)];
   
}
-(void)imageLayer{
    
   
    [self.backgroundImageView addShadow];

}
-(void)showWithTitleArray:(NSArray<NSString*>*)titleArray titleClicked:(ParagramItemSelectedBlock)block{
    if (!self.superview) {
        self.viewBottomConstraint.constant +=64;
        UIWindow*window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(window);
        }];
    }
     self.alpha = 1;
    self.dataArray = titleArray;
    self.viewHeightConstraint.constant = (titleArray.count/2 +(titleArray.count%2==0?0:1))*(11+31)+11+1;
       self.backgroundImageView.image = [[UIImage imageNamed:@"配置分类背景.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
     [self imageLayer];
    [self.collectionView reloadData];
    if (self.block!=block) {
        self.block = block;
    }
}
-(void)dismiss{
   
    self.alpha = 0;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(192/2, 62/2);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(11, 11, 11, 11);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 11;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 11;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ParameterClassifyCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:classNameFromClass(ParameterClassifyCollectionViewCell) forIndexPath:indexPath];
    [cell.button setTitle:self.dataArray[indexPath.row] forState:UIControlStateNormal];
    cell.button.tag = indexPath.row;
//    if (cell.button.tag==self.selectedButtonTag) {
//        cell.button.selected = YES;
//       
//        
//        
//        
//    
//    }else{
//        cell.button.selected = NO;
//        
//    }
    [cell.button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return  cell;
}
-(void)buttonClicked:(UIButton*)button{
//    if (self.selectedButtonTag!=button.tag) {
//         ParameterClassifyCollectionViewCell*cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedButtonTag inSection:0]];
//        cell.button.selected = NO;
//    }
//    
//    
//        button.selected = YES;
//    self.selectedButtonTag= button.tag;
  
        
    
    

    if (self.block) {
        self.block(button.tag);
    }
    
    [self dismiss];
}

@end
