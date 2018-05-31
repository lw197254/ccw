//
//  FindCarHeaderWithButton.m
//  chechengwang
//
//  Created by 严琪 on 2017/6/26.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "FindCarHeaderWithButton.h"
#import "VerticalImageTitleButton.h"

@interface FindCarHeaderWithButton()
@property (weak, nonatomic) IBOutlet VerticalImageTitleButton *buttoimage;

@end

@implementation FindCarHeaderWithButton

-(instancetype)init{
    if(self = [super init]){
        [[NSBundle mainBundle]loadNibNamed:@"FindCarHeaderWithButton" owner:self options:nil];
        [self addSubview:self.view];
        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.buttoimage.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return  self;
}

-(void)buildSingleView:(NSDictionary*)dict position:(NSInteger) i{
    
    [self.buttoimage setImage:[UIImage imageNamed:dict[@"image"]] forState:UIControlStateNormal];
    
    [self.buttoimage setImage:[UIImage imageNamed:dict[@"imageclick"]] forState:UIControlStateHighlighted];
    [self.buttoimage setImage:[UIImage imageNamed:dict[@"imageclick"]] forState:UIControlStateSelected];
    
    [self.buttoimage setTitle:dict[@"title"] forState:UIControlStateNormal];
    [self.buttoimage setTitle:dict[@"title"] forState:UIControlStateSelected];

    [self.buttoimage addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.buttoimage.tag = i ;
}


-(void)handleClick:(UIView *)view{
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleButtonClick:)]) {
        [self.delegate handleButtonClick:view.tag];
    }
}


@end
