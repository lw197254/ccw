//
//  WithDataView.h
//  TMC_convenientTravel
//
//  Created by 刘伟 on 16/6/1.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,WithDataViewCenterMode){
     WithDataViewCenterModeImageBottomEqualCenter=1,  ///default 图片底部等于整体中心
    WithDataViewCenterModeContentCenter ///内容整体居中
   
};
@interface WithDataView : UIView
@property(nonatomic,strong)UIImageView*imageView;
@property(nonatomic,strong)UILabel*titleLabel;
@property(nonatomic,strong)UIButton*button;
@property(nonatomic,strong)UIView*contentView;
@property(nonatomic,assign)WithDataViewCenterMode centerModel;

@end
