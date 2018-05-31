//
//  WithDataView.m
//  TMC_convenientTravel
//
//  Created by 刘伟 on 16/6/1.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "WithDataView.h"
@interface WithDataView()

@end
@implementation WithDataView
-(instancetype)init{
    if (self = [super init]) {
       
        [self configUI];
         self.centerModel = WithDataViewCenterModeImageBottomEqualCenter;
    }
    return self;
}
-(void)setCenterModel:(WithDataViewCenterMode)centerModel{
    if (_centerModel!=centerModel) {
        _centerModel = centerModel;
        switch (centerModel) {
            case WithDataViewCenterModeImageBottomEqualCenter:{
                [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self);
                }];
                [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    
                    make.centerX.equalTo(self.contentView);
                    make.bottom.equalTo(self.contentView.mas_centerY);
                }];
                [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.imageView.mas_bottom).with.offset(15);
                    make.left.right.equalTo(self.contentView);
                    
                }];
            }
                
                break;
            case WithDataViewCenterModeContentCenter:{
                [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.left.right.equalTo(self);
                }];
                [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    
                    make.centerX.top.equalTo(self.contentView);
                }];
                [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.imageView.mas_bottom).with.offset(15);
                    make.left.bottom.right.equalTo(self.contentView);
                    
                }];

            }
                
                break;
                
            default:
                break;
        }

    }
   }
-(void)configUI{
    self.contentView = [[UIView alloc]init];
    self.backgroundColor = BlackColorF1F1F1;
    
   
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.left.right.equalTo(self);
    }];
    _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"没有数据cry.png"]];
    [self.contentView addSubview:_imageView];
    
    
    _titleLabel = [Tool createLabelWithTitle:@"" textColor:BlackColorC9C8C8 tag:0];
    _titleLabel.font =FontOfSize(14);
    _titleLabel.textColor = BlackColor333333;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).with.offset(15);
        make.left.bottom.right.equalTo(self.contentView);
        
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.top.equalTo(self.contentView);
    }];

}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self configUI];
}
-(UIButton*)button{
    if (!_button) {
        _button = [Tool createButtonWithTitle:@"" titleColor:[UIColor whiteColor] target:nil action:nil];
        _button.backgroundColor = BlueColor447FF5;
        _button.titleLabel.font = [UIFont systemFontOfSize:16];
        _button.layer.cornerRadius = 3;
        _button.layer.masksToBounds = YES;
        [self addSubview:_button];
        if (self.titleLabel.text.length > 0) {
            [_button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_titleLabel.mas_bottom).with.offset(20);
                make.centerX.equalTo(self);
                make.height.mas_equalTo(35);
                make.width.mas_equalTo(108);
            }];
        }else{
            [_button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.imageView.mas_bottom).with.offset(20);
                make.centerX.equalTo(self);
                make.height.mas_equalTo(35);
                make.width.mas_equalTo(108);
            }];
        }
       
    }
    return _button;
}
@end
