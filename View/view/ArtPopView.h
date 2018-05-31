//
//  ArtPopView.h
//  chechengwang
//
//  Created by 严琪 on 2017/6/12.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShareModel;


typedef NS_ENUM(NSUInteger, ArtPopViewType) {
    /**
     *  only share
     */
    ArtPopViewTypeShare,
    /**
     *  share and setting
     */
    ArtPopViewTypeShareAndSetting,
    /**
     *  setting
     */
    ArtPopViewTypeSetting
};

@protocol ArtPopViewDelegate

@required

///处理点击事件
-(void)Handleclick:(ShareModel*)model;
@optional
///文字切换
-(void)changeFont:(NSInteger) type;
@end


@interface ArtPopView : UIView

@property(nonatomic,copy)NSArray *shareItems;

@property(nonatomic,copy)NSArray *commonItems;


-(void)show;

@property(nonatomic,weak)id delegate;

@property(nonatomic,assign)ArtPopViewType artPopViewType;


//-(void)reloadData;

@end
