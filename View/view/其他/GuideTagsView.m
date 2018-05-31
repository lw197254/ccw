//
//  GuideTagsView.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/13.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "GuideTagsView.h"
#import "TagsSelected.h"
@interface GuideTagsView()

@property (nonatomic,strong)TagsSelected *selectedView;

@end


@implementation GuideTagsView


-(instancetype)init{
    if (self = [super init]) {
        [[NSBundle mainBundle]loadNibNamed:@"GuideTagsView" owner:self options:nil];
        [self addSubview:self.view];
        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        //标签选择
        self.selectedView = [[TagsSelected alloc] init];
        [self.selectedView  callNet];
        
        [self.fatherView addSubview:self.selectedView];
        
        [self.selectedView  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(self.fatherView);
            make.bottom.equalTo(self.fatherView.mas_bottom).mas_equalTo(-20);
        }];
    }
    return  self;
}



@end
