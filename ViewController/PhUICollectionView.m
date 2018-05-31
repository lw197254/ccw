//
//  PhUICollectionView.m
//  chechengwang
//
//  Created by 严琪 on 17/1/9.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PhUICollectionView.h"

#import "PhotoCollectionViewCell.h"
#import "PicModel.h"

@interface PhUICollectionView()

@property(nonatomic,strong)NSString *typeId;
@property(nonatomic,strong)NSString *carId;
@property(nonatomic,strong)NSString *color;
@property(nonatomic,assign)NSInteger page;

//判断是否是刷新
@property(nonatomic,assign)bool isheadfresh;

@property(nonatomic,assign)NSUInteger pageid;


//@property(nonatomic,strong)NSMutableArray *pic;

@end

@implementation PhUICollectionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self =[super initWithFrame:frame collectionViewLayout:layout]) {
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
