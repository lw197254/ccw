//
//  MyOwnShareView.m
//  chechengwang
//
//  Created by 严琪 on 2017/6/13.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "MyOwnShareView.h"
#import "ArtPopView.h"
#import "SharePlatform.h"
#import "ShareModel.h"
#import "MyUMShare.h"

@interface MyOwnShareView()<ArtPopViewDelegate>

@property(nonatomic,strong)ArtPopView *artPopView;

@end

@implementation MyOwnShareView

-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

/// 初始化弹出的界面
-(ArtPopView *)artPopView{
    if (!_artPopView) {
        _artPopView = [[ArtPopView alloc] init];
        _artPopView.delegate = self;
        [_artPopView setArtPopViewType:ArtPopViewTypeShare];
        
        _artPopView.shareItems = [SharePlatform getSharePlatforms];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.artPopView];
        [self.artPopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo([UIApplication sharedApplication].keyWindow);
        }];
    }
    return _artPopView;
}


-(void) initPopView{
    [self.artPopView show];
}



-(void)Handleclick:(ShareModel *)model{
    
    
    if ([model.tag isEqualToString:@"1"]) {
    
        if ([model.name isEqualToString:@"微信"]) {
            if (self.myownshareType == ShareArt) {
                [MyUMShare shareWithSSDKPlatform:SSDKPlatformTypeWechat title:self.title conent:self.content artUrl:self.share_url picUrl:self.pic_url];
            }else{
                [MyUMShare showSharePictureWithSSDKPlatform:SSDKPlatformTypeWechat title:self.title conent:self.content artUrl:self.share_url picUrl:self.pic_url];
            }
            
        }
        
        if ([model.name isEqualToString:@"朋友圈"]) {
            if (self.myownshareType == ShareArt) {
                [MyUMShare shareWithSSDKPlatform:SSDKPlatformSubTypeWechatTimeline title:self.title conent:self.content artUrl:self.share_url picUrl:self.pic_url];
            }else{
                [MyUMShare showSharePictureWithSSDKPlatform:SSDKPlatformSubTypeWechatTimeline title:self.title conent:self.content artUrl:self.share_url picUrl:self.pic_url];
            }
        }
        
        if ([model.name isEqualToString:@"QQ好友"]) {
            if (self.myownshareType == ShareArt) {
                [MyUMShare shareWithSSDKPlatform:SSDKPlatformTypeQQ title:self.title conent:self.content artUrl:self.share_url picUrl:self.pic_url];
            }else{
                [MyUMShare showSharePictureWithSSDKPlatform:SSDKPlatformTypeQQ title:self.title conent:self.content artUrl:self.share_url picUrl:self.pic_url];
            }
        }
        
        if ([model.name isEqualToString:@"QQ空间"]) {
            if (self.myownshareType == ShareArt) {
                [MyUMShare shareWithSSDKPlatform:SSDKPlatformSubTypeQZone title:self.title conent:self.content artUrl:self.share_url picUrl:self.pic_url];
            }else{
                [MyUMShare showSharePictureWithSSDKPlatform:SSDKPlatformSubTypeQZone title:self.title conent:self.content artUrl:self.share_url picUrl:self.pic_url];
            }
        }
    }
   
    
}



@end
