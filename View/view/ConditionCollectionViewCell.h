//
//  ConditionCollectionViewCell.h
//  chechengwang
//
//  Created by 严琪 on 2017/10/23.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PEIZHIBLOCK)(NSString *title,bool isSelected,NSInteger tag);

@interface ConditionCollectionViewCell : UICollectionViewCell

@property(nonatomic,assign)float cellheight;

@property(nonatomic,copy)PEIZHIBLOCK block;

@property(nonatomic,copy)NSMutableArray *selectedArray;

-(void)rebuildArray:(NSArray *)titleArr title:(NSString *)title tag:(NSInteger) tag;

-(void)rebuildArray:(NSArray *)titleArr title:(NSString *)title;



@end
