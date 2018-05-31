//
//  CustomNavigationBar.h
//  chechengwang
//
//  Created by 刘伟 on 2017/6/9.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CustomNavigationBarItemClickedBlock)(NSInteger index,__kindof UIView*item);
@interface CustomNavigationBar : UIView
@property(nonatomic,strong,readonly)UIButton*backButton;
@property(nonatomic,strong,readonly)UIView*titleContentView;
@property(nonatomic,strong,readonly)NSArray<__kindof UIView*>*leftBarItems;
@property(nonatomic,strong,readonly)NSArray<__kindof UIView*>*rightBarItems;
///最左边的item距离左边的距离
@property(nonatomic,assign)double leftSpace;
///最由边的item距离右边的距离
@property(nonatomic,assign)double rightSpace;
///两个item的间距
@property(nonatomic,assign)double separeteSpace;



-(void)showRightBarItems:(NSArray<__kindof UIView*>*)rightBarItems rightItemClickedBlock:(CustomNavigationBarItemClickedBlock)rightItemClickedBlock;
-(void)showLeftBarItems:(NSArray<__kindof UIView*>*)leftBarItems leftItemClickedBlock:(CustomNavigationBarItemClickedBlock)leftItemClickedBlock;
-(void)showNavigationTitle:(NSString*)title;

@end
