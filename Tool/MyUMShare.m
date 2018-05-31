//
//  MyUMShare.m
//  chechengwang
//
//  Created by 严琪 on 17/1/16.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "MyUMShare.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>

#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <MOBFoundation/MOBFoundation.h>


@implementation MyUMShare


+(void)showShareInView:(UIView*)view title:(NSString*)title conent:(NSString*)content artUrl:(NSString*)artUrl  picUrl:(NSString*)picUrl{
    
    //更换分享菜单栏风格
    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray;
    if ([picUrl isNotEmpty]) {
         imageArray = @[picUrl];
    }else{
         NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
        NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
       
        
          UIImage*  image = [UIImage imageNamed:icon];
         imageArray = @[image];
    }
   
    [shareParams SSDKSetupShareParamsByText:content
                                     images:imageArray
                                     url:[NSURL URLWithString:artUrl]
                                     title:title
                                     type:SSDKContentTypeWebPage];
    
//    //1.2、自定义分享平台（非必要）
//    NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:[ShareSDK activePlatforms]];
    [self shareFunction:view shareParams:shareParams];
}

//单一分享图片的方法
+(void)showSharePictureInView:(UIView*)view title:(NSString*)title conent:(NSString*)content artUrl:(NSString*)artUrl  picUrl:(NSString*)picUrl{
    
    //更换分享菜单栏风格
    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray;
    if ([picUrl isNotEmpty]) {
        imageArray = @[picUrl];
    }else{
        NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
        NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
        
        
        UIImage*  image = [UIImage imageNamed:icon];
        imageArray = @[image];
    }
       [shareParams SSDKSetupShareParamsByText:content
                                     images:imageArray
                                        url:[NSURL URLWithString:artUrl]
                                      title:title
                                       type:SSDKContentTypeImage];
    
    //    //1.2、自定义分享平台（非必要）
    //    NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:[ShareSDK activePlatforms]];
    [self shareFunction:view shareParams:shareParams];
}


+(void)shareFunction:(UIView *)view shareParams:(NSMutableDictionary *)shareParams{
  SSUIShareActionSheetController*vc =  [ShareSDK showShareActionSheet:view
                             items:@[@(SSDKPlatformSubTypeWechatSession),
                                     @(SSDKPlatformSubTypeWechatTimeline),
                                     @(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeQZone)]
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                           
                       case SSDKResponseStateBegin:
                       {
                           
                           break;
                       }
                       case SSDKResponseStateSuccess:
                       {
                           //Facebook Messenger、WhatsApp等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
                           if (platformType == SSDKPlatformTypeFacebookMessenger)
                           {
                               break;
                           }
                           
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           if (platformType == SSDKPlatformTypeSMS && [error code] == 201)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"失败原因可能是：1、短信应用没有设置帐号；2、设备不支持短信应用；3、短信应用在iOS 7以上才能发送带附件的短信。"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           else if(platformType == SSDKPlatformTypeMail && [error code] == 201)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"失败原因可能是：1、邮件应用没有设置帐号；2、设备不支持邮件应用；"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           else
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
                           //                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                           //                                                                               message:nil
                           //                                                                              delegate:nil
                           //                                                                     cancelButtonTitle:@"确定"
                           //                                                                     otherButtonTitles:nil];
                           //                           [alertView show];
                           break;
                       }
                       default:
                           break;
                   }
                   
                   if (state != SSDKResponseStateBegin)
                   {
                       //                       [theController showLoadingView:NO];
                       //                       [theController.tableView reloadData];
                   }
                   
               }];
    
    //另附：设置跳过分享编辑页面，直接分享的平台。
    //        SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:view
    //                                                                         items:nil
    //                                                                   shareParams:shareParams
    //                                                           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
    //                                                           }];
    //
    //        //删除和添加平台示例
    //        [sheet.directSharePlatforms removeObject:@(SSDKPlatformTypeWechat)];
    //        [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
}

//无UI分享
+(void)shareWithSSDKPlatform:(SSDKPlatformType)platformType title:(NSString*)title conent:(NSString*)content artUrl:(NSString*)artUrl  picUrl:(NSString*)picUrl{
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray;
    if ([picUrl isNotEmpty]) {
        imageArray = @[picUrl];
    }else{
        NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
        NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
        
        
        UIImage*  image = [UIImage imageNamed:icon];
        imageArray = @[image];
    }
    
    [shareParams SSDKSetupShareParamsByText:content
                                     images:imageArray
                                        url:[NSURL URLWithString:artUrl]
                                      title:title
                                       type:SSDKContentTypeWebPage];
    [ShareSDK share:platformType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateFail:
            {
                // 无效的分享不可以弹出第三方内容
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                message:[NSString stringWithFormat:@"%@",error]
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil, nil];
//                [alert show];
                break;
            }
            case SSDKResponseStateSuccess:
            {
                //Facebook Messenger、WhatsApp等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
                if (platformType == SSDKPlatformTypeFacebookMessenger)
                {
                    break;
                }
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                break;
            }
            default:
            break;
        }

    }];

}


//无UI分享图片
+(void)showSharePictureWithSSDKPlatform:(SSDKPlatformType)platformType title:(NSString*)title conent:(NSString*)content artUrl:(NSString*)artUrl  picUrl:(NSString*)picUrl{
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray;
    if ([picUrl isNotEmpty]) {
        imageArray = @[picUrl];
    }else{
        NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
        NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
        
        
        UIImage*  image = [UIImage imageNamed:icon];
        imageArray = @[image];
    }
    [shareParams SSDKSetupShareParamsByText:content
                                     images:imageArray
                                        url:[NSURL URLWithString:artUrl]
                                      title:title
                                       type:SSDKContentTypeImage];
    
    //    //1.2、自定义分享平台（非必要）
    //    NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:[ShareSDK activePlatforms]];
    [ShareSDK share:platformType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
                
            case SSDKResponseStateFail:
            {
                // 无效的分享不可以弹出第三方内容
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                message:[NSString stringWithFormat:@"%@",error]
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil, nil];
//                [alert show];
                break;
            }
            case SSDKResponseStateSuccess:
            {
                //Facebook Messenger、WhatsApp等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
                if (platformType == SSDKPlatformTypeFacebookMessenger)
                {
                    break;
                }
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                break;
            }
            default:
                break;
        }
        
    }];

}



@end
