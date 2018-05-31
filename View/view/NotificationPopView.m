//
//  NotificationPopView.m
//  chechengwang
//
//  Created by 严琪 on 2017/7/13.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "NotificationPopView.h"
#import "NotificationModel.h"
#import "PopTimeModel.h"

@implementation NotificationPopView


-(instancetype)init{
    if (self = [super init]) {
        
        [[NSBundle mainBundle]loadNibNamed:@"NotificationPopView" owner:self options:nil];
        [self addSubview:self.view];

        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];

    }
    return self;
}

-(void)buildView:(NotificationModel *)data{
    self.title.text = data.title;
    __block NSString *message = @"";
    
    if (data.message.count==0) {
        return ;
    }
    [data.message enumerateObjectsUsingBlock:^(NSString  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (data.message.count-1 == idx) {
              message = [message stringByAppendingString:[NSString stringWithFormat:@"%@",obj]];
        }else{
              message = [message stringByAppendingString:[NSString stringWithFormat:@"%@\n",obj]];
        }
    }];
    
    self.message.text = message;
}


-(NSString *)transferTime:(NSDate *) time{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    return strDate;
}

- (IBAction)closeclick:(id)sender {
    //删除之前所有的时间对象
    [PopTimeModel deleteAll];
    PopTimeModel *model = [[PopTimeModel alloc]init];
    model.currentTime =  [self transferTime:[NSDate date]];
    //保存当前时间
    [model save];
    [self removeFromSuperview];
}

- (IBAction)startOpen:(id)sender {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
    
}

@end
