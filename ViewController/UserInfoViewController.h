//
//  UserInfoViewController.h
//  12123
//
//  Created by 刘伟 on 2016/10/13.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"

@interface UserInfoViewController : ParentViewController<UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *headimage;

@property (weak, nonatomic) IBOutlet UIView *nickname;
@property (weak, nonatomic) IBOutlet UIView *phone;
@property (weak, nonatomic) IBOutlet UIView *sex;
@property (weak, nonatomic) IBOutlet UIView *area;


@property (weak, nonatomic) IBOutlet UILabel *nicknamelabel;

@property (weak, nonatomic) IBOutlet UILabel *phonelabel;

@property (weak, nonatomic) IBOutlet UILabel *arealabel;
@property (weak, nonatomic) IBOutlet UILabel *sexlabel;

//@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
