//
//  ConditctionCollectionReusableView.h
//  chechengwang
//
//  Created by 严琪 on 2017/10/18.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CHILDHEIGHT)(NSInteger height);

@interface ConditctionCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) CHILDHEIGHT block;

@property (copy, nonatomic) NSDictionary*dict;

-(void)updateView;
@end
