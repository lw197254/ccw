//
//  ArtInfoViewController.h
//  chechengwang
//
//  Created by 严琪 on 2017/9/30.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ParentViewController.h"


//typedef NS_ENUM(NSInteger,ARTINFOTYPE)
//{
//    
//};

@interface ArtInfoViewController : ParentViewController

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *bookingButton;
@property (strong, nonatomic) UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UIButton *topTableView;

@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *shoucangButton;

@property (strong, nonatomic) NSString *aid;
// 必须由外部传入
@property (strong, nonatomic) NSString *artType;

@end
