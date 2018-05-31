//
//  VideoHomeHeaderView.h
//  chechengwang
//
//  Created by 严琪 on 2017/12/5.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoHomeHeaderView : UIView

@property(nonatomic,strong)IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *des;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;

@end
