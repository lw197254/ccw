//
//  PopUpView.h
//  chechengwang
//
//  Created by 严琪 on 2017/6/21.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^backClick)();
@protocol PopUpViewDeleagte
@required
-(void)buildTargetView:(UIView *)targetView;
@end

@interface PopUpView : UIView

@property(nonatomic,weak) id deleagate;

@property(nonatomic,strong) UIView *targetView;

@property(nonatomic,strong) UIView *backView;

@property(nonatomic,assign) NSInteger targetViewHeight;

@property(nonatomic,copy) backClick block;


-(void)builderView;

-(void)showPopUpView;

-(void)dismissPopUpView;
 

@end
