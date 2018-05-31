//
//  LoginAlertView.h
//  chechengwang
//
//  Created by 刘伟 on 2017/7/13.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThirdLoginObject.h"
typedef NS_ENUM(NSInteger,LoginDetailType){
    LoginDetailTypeMobile = 0,
    LoginDetailTypeWeichat,
    LoginDetailTypeQQ,
    LoginDetailTypeSina
};
@interface LoginAlertView : UIView

@end
