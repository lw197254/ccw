//
//  VideoHearView.h
//  chechengwang
//
//  Created by 严琪 on 2017/12/4.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoHearView : UITableViewHeaderFooterView
@property(nonatomic,strong)IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *des;

@end
