//
//  ThirdLogin.h
//  chechengwang
//
//  Created by 刘伟 on 2017/7/13.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,ThirdLoginType){
   
    ThirdLoginTypeWeichat,
    ThirdLoginTypeQQ,
    ThirdLoginTypeSina
};

typedef void(^LoginSuccessBlock)(void);
typedef void(^LoginSuccessDataBlock)(void);
@interface ThirdLoginObject : NSObject
@property (copy, nonatomic) LoginSuccessBlock loginSuccessBlock;
@property (copy, nonatomic) LoginSuccessDataBlock loginSuccessDataBlock;

-(void)loginSuccess:(LoginSuccessBlock)successBlock;
-(void)loginWithLoginDetailType:(ThirdLoginType)type;
@end
