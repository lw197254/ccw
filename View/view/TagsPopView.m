//
//  TagsPopView.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/19.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "TagsPopView.h"

@interface TagsPopView()
@property(strong,nonatomic)UIImageView *background;

@property (weak, nonatomic) IBOutlet UILabel *dissmisslabel;

@end

@implementation TagsPopView

-(UIImageView *)background{
    if (!_background) {
        _background = [[UIImageView alloc]init];
    }
    return _background;
}

-(instancetype)init{
    if(self = [super init]){
        
        [[NSBundle mainBundle]loadNibNamed:@"TagsPopView" owner:self options:nil];
        [self addSubview:self.view];
        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
    }
    return self;
}

- (IBAction)closePopView:(id)sender {
    [self removeFromSuperview];
}

@end
