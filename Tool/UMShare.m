//
//  UMShare.m
//  12123
//
//  Created by 刘伟 on 2016/10/12.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "UMShare.h"
#import "WXApi.h"
//#import "UMSocial.h"
//#import "UMSocialWechatHandler.h"

//#import "UMSocialQQHandler.h"
@implementation UMShare

+(void)shareShow{
  
    
    NSArray *myshareList = [ShareSDK getShareListWithType:
                            ShareTypeWeixiSession,
                            ShareTypeWeixiTimeline,
                            ShareTypeQQ,nil];
    
    id publishContent = [UMShare contentWithString:@"和我一起用“手机违章”查违章吧" content:[NSString stringWithFormat:@"和我一起用“手机违章”查违章吧!"] shareurl:[NSString stringWithFormat:@"%@/download",WebViewHead] image:nil];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:myshareList content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                             
                             
                             
                             
                             if (state == SSPublishContentStateSuccess)
                             {
                                 NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                             }
                             else if (state == SSPublishContentStateFail)
                             {
                                 NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                 [[DialogUtil sharedInstance]showDlg:[Tool currentViewController].view textOnly:error.errorDescription];
                             }
                         }
     ];


}
+(void)shareWithString:(NSString*)title content:(NSString*)content shareurl:(NSString*)url image:(id)image shareType:(ShareType)shareType{
   
    
     id publishContent = [UMShare contentWithString:title content:content shareurl:url image:image];
    [ShareSDK showShareViewWithType:shareType
                          container:nil
                            content:publishContent
                      statusBarTips:YES
                        authOptions:nil
                       shareOptions:nil
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                      [[DialogUtil sharedInstance]showDlg:[Tool currentViewController].view textOnly:error.errorDescription];
                                 }
                             }];
    
}
//    [ShareSDK showShareActionSheet:nil
//                         shareList:myshareList content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                             if (state == SSPublishContentStateSuccess)
//                             {
//                                 NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
//                             }
//                             else if (state == SSPublishContentStateFail)
//                             {
//                                 NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
//                             }
//                         }
//     ];



+(void)shareWithString:(NSString*)title content:(NSString*)content shareurl:(NSString*)url image:(id)image {
    id publishContent = [UMShare contentWithString:title content:content shareurl:url image:image];
      //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:[Tool currentViewController].view arrowDirect:UIPopoverArrowDirectionUp];
    //弹出分享菜单
    
//    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:title
//                                                              oneKeyShareList:shareList
//                                                               qqButtonHidden:YES
//                                                        wxSessionButtonHidden:NO
//                                                       wxTimelineButtonHidden:NO
//                                                         showKeyboardOnAppear:YES
//                                                            shareViewDelegate:nil
//                                                          friendsViewDelegate:nil
//                                                        picViewerViewDelegate:nil];
    
    [ShareSDK showShareActionSheet:container
                         shareList:[ShareSDK getShareListWithType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeQQ, nil]
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                      [[DialogUtil sharedInstance]showDlg:[Tool currentViewController].view textOnly:error.errorDescription];
                                }
                            }];
    

}

+(id)contentWithString:(NSString*)title content:(NSString*)content shareurl:(NSString*)url image:(id)image{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    id<ISSContent> publishContent;
    if (!image) {
        image = [UIImage imageNamed:icon];
        publishContent = [ShareSDK content:content
                            defaultContent:@"和我一起用“手机违章”查违章吧"
                                     image:[ShareSDK pngImageWithImage:image]
                                     title:title
                                       url:url
                               description:content
                                 mediaType:SSPublishContentMediaTypeNews];
    }
    if ([image isKindOfClass:[NSString class]]) {
        
        publishContent = [ShareSDK content:content
                            defaultContent:@"和我一起用“手机违章”查违章吧"
                                     image:[ShareSDK imageWithUrl:image]
                                     title:title
                                       url:url
                               description:content
                                 mediaType:SSPublishContentMediaTypeNews];
        
        
        
    }
    
    return publishContent;
    
    
   
    
}
-(UIImage *)getImageFromView:(UIView *)theView
{
    
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, YES, 2);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
