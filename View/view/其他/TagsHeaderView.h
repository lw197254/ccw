//
//  TagsHeaderView.h
//  chechengwang
//
//  Created by 严琪 on 2017/12/11.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagsHeaderView : UITableViewHeaderFooterView

@property(nonatomic,strong) UILabel *label;



-(void)setLabelText:(NSString *)text Color:(UIColor *) color;
@end
