//
//  CobubTongJi.m
//  chechengwang
//
//  Created by 严琪 on 2017/7/10.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "CobubTongJi.h"
#import "CoBuBViewModel.h"
#import "UICKeyChainStore.h"


#import <AdSupport/AdSupport.h>
#import <cobub/UMSAgentInfo.h>

#define kActivityLog @"activityLog"
#define kClientDataArray @"clientDataArray"

static NSString *clientData = @"1";
static NSString *historyData = @"2";

@interface CobubTongJi(){
      NSDate *postTimerFireDate;
}

@property(nonatomic,strong)CoBuBViewModel *clientModel;
@property(nonatomic,strong)CoBuBViewModel *activityModel;
///定时发送
@property(nonatomic,strong)NSTimer *postTimer;
///发送频率 单位分
@property (nonatomic) int sendInterval;
///串行队列 用来顺序发送数据
@property(nonatomic,strong)dispatch_queue_t queue;

@end

@implementation CobubTongJi

-(instancetype)init{
    if (self = [super init]) {
        self.clientModel = [CoBuBViewModel SceneModel];
        self.activityModel = [CoBuBViewModel SceneModel];
        [self setCobub];
        postTimerFireDate = [[NSDate date] copy];
        self.sendInterval = 1;
        [self sendPostInterval];
        self.queue = dispatch_queue_create("chechengwang_ios", NULL);
    }
    return self;
}


-(void)setCobub{
    [UMSAgent setOnLineConfig:YES];
    [UMSAgent setUpdateOnlyWifi:YES];
    [UMSAgent setIsLogEnabled:YES];
    [UMSAgent startWithAppKey:UMSAgentKey
               MyReportPolicy:COBUBBATCH serverURL:UMSAgentUrl];
    [UMSAgent setDeviceID:[self getDeviceId]];
    
    [UMSAgent getArchivedLogs:UMSAgentKey];
}

-(NSString *)getDeviceId
{
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"chechengwang_ios"];
    
    NSString *token = keychain[@"key"];
    if (token==nil) {
        NSString *uuid = [[NSUUID UUID] UUIDString];
        keychain[@"key"] = uuid;
        token = uuid;
    }
    NSLog(@"~~~~~~~~~~%@",token);
    return token;
}


-(void)postClientData{
    NSMutableArray *clientInfo = [UMSAgentInfo getArchiveClientData:UMSAgentKey];
    
    //idfa
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [clientInfo setValue:idfa forKey:@"idfa"];
    
    NSLog(@"用户信息%@",[clientInfo componentsJoinedByString:@""]);
    self.clientModel.request.type = clientData;
    
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//    [dictionary setObject:clientInfo forKey:@"data"];
    if (clientInfo.count == 0) {
         NSLog(@"无用户信息");
        return ;
    }
    self.clientModel.request.data = [self array2Json:clientInfo];
    
    [[RACObserve(self.clientModel.request,state)
      filter:^BOOL(id value) {
          return self.clientModel.request.succeed;
      }]subscribeNext:^(id x) {
          if (x) {
               [UMSAgent removeArchivedFile:kClientDataArray];
          }
      }];
    
    self.clientModel.request.startRequest = YES;
    
    
}

-(void)postActivityData{
    NSMutableArray *activityInfo = [UMSAgentInfo getArchiveActivityLog];
    if (activityInfo.count==0) {
        NSLog(@"定时发送activity的信息为空");
        return ;
    }
    self.activityModel.request.type = historyData;
 
    self.activityModel.request.data = [UMSAgentInfo getArchiveActivityLogString:UMSAgentKey];
    
    [[RACObserve(self.activityModel.request,state)
    filter:^BOOL(id value) {
        return self.activityModel.request.succeed;
    }]subscribeNext:^(id x) {
        if (x) {
            [UMSAgent removeArchivedFile:kActivityLog];
        }
    }];
    
    self.activityModel.request.startRequest = YES;
}


-(void)sendPostInterval{
    self.postTimer = [NSTimer scheduledTimerWithTimeInterval:self.sendInterval target:self selector:@selector(postActivityCurrentData) userInfo:nil repeats:YES];
}

-(void)cancelPostInterval{
    NSLog(@"关闭发送");
    [self.postTimer invalidate];
    self.postTimer = nil;
}

//连续发送
-(void)postActivityCurrentData{
 
    NSTimeInterval intervalSinceLastFire = -[postTimerFireDate timeIntervalSinceNow];

    if(intervalSinceLastFire + 0.00000001 > self.sendInterval*60)
    {
        NSLog(@"定时发送activity信息");
        postTimerFireDate = [[NSDate date] copy];
        dispatch_async(self.queue, ^{
            [self postActivityData];
        });
    }
}


-(NSString *)array2Json:(NSArray *)array{
    
    NSString *jsonString = nil;
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
    
}


-(NSString *)dic2Json:(NSDictionary *)dic{
    
    NSString *jsonString = nil;
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;

}


@end
