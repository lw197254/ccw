//
//  VideoCollectionReusableView.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/5.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "VideoCollectionReusableView.h"
#import "VideoHomeHeaderView.h"
#import "VideoViewListViewController.h"

@implementation VideoCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionlistView = [[HTHorizontalSelectionList alloc] init];
    self.selectionlistView.selectionIndicatorStyle = HTHorizontalSelectionIndicatorStyleNone;
    self.selectionlistView.delegate = self;
    self.selectionlistView.dataSource = self;
    self.selectionlistView.leftSpace = 10;
    self.selectionlistView.rightSpace = 10;
 
    [self addSubview:self.selectionlistView];
    
    [self.selectionlistView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


-(NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList{
    return self.datas.info.count;
}

-(UIView *)selectionList:(HTHorizontalSelectionList *)selectionList viewForItemWithIndex:(NSInteger)index{
    VideoHomeHeaderView *view = [[VideoHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, 200, 84)];
    VideoLabelModel *model = self.datas.info[index];
    
    [view.imageview setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:[UIImage imageNamed:@"默认图片330_165"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    view.title.text = model.label_name;
    view.des.text = model.describe;
    
    return view;
}

- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index {
    VideoViewListViewController *controller = [[VideoViewListViewController alloc] init];
    
    VideoLabelModel *model = self.datas.info[index];
    controller.catid = model.id;
    controller.titlename = model.label_name;
    [[Tool currentViewController].rt_navigationController pushViewController:controller animated:YES];
}


@end
