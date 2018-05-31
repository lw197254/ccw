//
//  searchVC.h
//  searchController
//
//  Created by 王涛 on 15/12/28.
//  Copyright © 2015年 王涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityModel.h"
//选择城市
typedef void(^CityClickedBlock)(CityModel *model);
@interface CitySearchVC : UITableViewController
-(void)finishedSelected:(CityClickedBlock)block;
@property(nonatomic,copy)NSString *selectedCityName;
@end
