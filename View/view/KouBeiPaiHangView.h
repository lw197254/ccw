//
//  KouBeiPaiHangView.h
//  chechengwang
//
//  Created by 严琪 on 2017/10/19.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTHorizontalSelectionList.h"
#import "KouBeiSerieskBData.h"


@interface KouBeiPaiHangView : UIView<HTHorizontalSelectionListDelegate,HTHorizontalSelectionListDataSource>


@property(nonatomic,copy)KouBeiSerieskBData *seriseKB;
@property(nonatomic,copy)KouBeiSerieskBData *seriseModelKB;
@property (weak, nonatomic) IBOutlet HTHorizontalSelectionList *selectListView;

@property (weak, nonatomic) IBOutlet UILabel *labelleft;
@property (weak, nonatomic) IBOutlet UILabel *labelleftname;

@property (weak, nonatomic) IBOutlet UILabel *labelright;
@property (weak, nonatomic) IBOutlet UILabel *carName;

@end
