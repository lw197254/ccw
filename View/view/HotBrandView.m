//
//  HotBrandView.m
//  chechengwang
//
//  Created by 刘伟 on 2017/3/21.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "HotBrandView.h"



@interface HotBrandView()
@property(nonatomic,strong)NSMutableArray*itemArray;
@property(nonatomic,copy)HotBrandTableViewCellItemClickedBlock block;
@end
@implementation HotBrandView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)init{
    if (self  = [super init]) {
         [self configUI];
    }
    return self;
}
-(void)configUI{
    if (!self.itemArray) {
        self.itemArray = [NSMutableArray array];
    }
    for (NSInteger i = 0; i < itemCountInRow; i++) {
        HotBrandItem*item = [[HotBrandItem alloc]init];
        item.button.tag = i;
        [item.button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
        if (i==0) {
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(10);
                
            }];
        }
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
        }];
        if (i!=0) {
            HotBrandItem*itemLeft = self.itemArray[i-1];
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(itemLeft);
                make.left.equalTo(itemLeft.mas_right);
            }];
        }
        if (i==itemCountInRow-1) {
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.right.equalTo(self).with.offset(-10);
            }];
        }
        [self.itemArray addObject:item];
    }
}
-(void)buttonClicked:(UIButton*)button{
    HotBrandItem*item = self.itemArray[button.tag];
    if (_block) {
        _block(item,button.tag);
    }
    
}
-(void)setCellWithArray:(NSArray<BrandModel*>*)array itemClickBlock:(HotBrandTableViewCellItemClickedBlock)block{
    if (_block!=block) {
        _block = block;
    }
    for (NSInteger i = 0; i <self.itemArray.count; i++) {
        HotBrandItem*item = self.itemArray[i];
        if (i < array.count){
            
            item.hidden = NO;
            BrandModel*model = array[i];
            item.label.text = model.name;
            if ([model.url isEqualToString:@"iconlocal"]) {
                item.imageView.image = [UIImage imageNamed:@"ic_more"];
            }else{
                [item.imageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"默认汽车品牌"]];
            }
 
        }else{
            item.hidden = YES;
        }
        
    }
}


@end
@implementation HotBrandItem
-(instancetype)init{
    if (self = [super init]) {
        [self configUI];
    }
    return self;
}
-(void)configUI{
    
    _button = [Tool createButtonWithTitle:nil titleColor:nil target:nil action:nil];
    [self addSubview:_button];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"默认汽车品牌"]];
    [self addSubview:_imageView];
    _label= [Tool createLabelWithTitle:@"车牌" textColor:BlackColor333333 tag:0];
    _label.textColor = BlackColor333333;
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = FontOfSize(14);
    [self addSubview:_label];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self);
        //        make.width.lessThanOrEqualTo(self);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageView.mas_bottom);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    
}

@end

