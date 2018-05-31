//
//  NotificationPopView.h
//  chechengwang
//
//  Created by 严琪 on 2017/7/13.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NotificationModel;

@interface NotificationPopView : UIView
@property (weak, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *message;


-(void)buildView:(NotificationModel *)data;
@end
