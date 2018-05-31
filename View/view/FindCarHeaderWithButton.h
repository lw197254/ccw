//
//  FindCarHeaderWithButton.h
//  chechengwang
//
//  Created by 严琪 on 2017/6/26.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FindCarHeaderWithButtonDelegate <NSObject>

-(void)handleButtonClick:(NSInteger) position;

@end


@interface FindCarHeaderWithButton : UIView

@property(nonatomic,strong)IBOutlet UIView *view;

@property(nonatomic,weak)id<FindCarHeaderWithButtonDelegate> delegate;

-(void)buildSingleView:(NSDictionary*)dict position:(NSInteger) i;
@end
