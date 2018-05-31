//
//  FastLoginView.h
//  chechengwang
//
//  Created by 严琪 on 2017/8/1.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShadowLoginViewController.h"

@interface FastLoginView : UIView<ShadowLoginViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) id<ShadowLoginViewControllerDelegate> showDelagate;

@end
