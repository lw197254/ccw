//
//  ArtPopTextView.h
//  chechengwang
//
//  Created by 严琪 on 2017/6/12.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ArtPopTextViewDelegate

-(void)chooseValue:(NSInteger) type;

@end

@interface ArtPopTextView : UIView

@property(nonatomic,strong)IBOutlet UIView *view;

@property(nonatomic,assign)NSInteger selectedIndex;
@property(nonatomic,weak) id delegate;

@end
