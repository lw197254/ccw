//
//  VideoViewController.h
//  chechengwang
//
//  Created by 严琪 on 2017/12/1.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ParentViewController.h"
#import "VideoModel.h"
@interface VideoViewController : ParentViewController

//这个对象只用了id
@property(nonatomic,copy) VideoModel *baseModel;

@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *shoucangButton;

@end
