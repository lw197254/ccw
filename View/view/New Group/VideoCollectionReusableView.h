//
//  VideoCollectionReusableView.h
//  chechengwang
//
//  Created by 严琪 on 2017/12/5.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTHorizontalSelectionList.h"
#import "VideoLabelListModel.h"
#import "VideoLabelModel.h"

@interface VideoCollectionReusableView : UICollectionReusableView<HTHorizontalSelectionListDelegate,HTHorizontalSelectionListDataSource>
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic,strong) HTHorizontalSelectionList *selectionlistView;

@property (nonatomic,copy) VideoLabelListModel *datas;

@end
