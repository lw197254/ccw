//
//  PTableViewCell.h
//  chechengwang
//
//  Created by 严琪 on 17/1/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoContentModel.h"
#import "MatchModel.h"
#import "TTTAttributedLabel.h"


@interface PTableViewCell : UITableViewCell<TTTAttributedLabelDelegate>
//@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *textview;

-(void)setinfo:(InfoContentModel *)info;
-(void)setMatch:(NSMutableArray<MatchModel> *) matches;
@end
