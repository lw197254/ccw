//
//  ComparePriceTableViewCell.h
//  chechengwang
//
//  Created by 刘伟 on 2017/8/17.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ComparePriceView;
@interface ComparePriceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet ComparePriceView *leftPriceView;
@property (weak, nonatomic) IBOutlet ComparePriceView *righPricetView;

@end
