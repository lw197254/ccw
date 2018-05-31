//
//  ArtPopView.m
//  chechengwang
//
//  Created by 严琪 on 2017/6/12.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ArtPopView.h"
#import "ArtPopViewCollectionViewCell.h"
#import "ArtPopTextView.h"
#import "ShareModel.h"
#import "InfoDetailFont.h"

@interface ArtPopView()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,ArtPopTextViewDelegate>
//分享的collection
@property(nonatomic,strong) UICollectionView *shareCollectionView;
//自定义的collection
@property(nonatomic,strong) UICollectionView *settingCollectionView;
//取消按钮
@property(nonatomic,strong) UIButton *cancelButton;

@property(nonatomic,strong) UIView *whiteView;
@property(nonatomic,strong) UIView *bottomBackgroundView;
@property(nonatomic,strong) UIView *topView;

@property(nonatomic,strong) ArtPopTextView *popTextView;

@property(nonatomic,strong) UIView *line;

@end


static const NSInteger collectonHeight = 105;

@implementation ArtPopView



-(instancetype)init{
    
    if (self = [super init]) {
        
        [self setBackgroundColor:[UIColor colorWithWhite:0.f alpha:0.3]];
       
        
        [self addSubview:self.bottomBackgroundView];
         [self.bottomBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.bottom.right.equalTo(self);
        }];
        [self addSubview:self.topView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.bottom.equalTo(self.bottomBackgroundView.mas_top);

        }];
        [self.bottomBackgroundView addSubview:self.cancelButton];
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(44);
            make.right.equalTo(self.mas_right);
            make.left.equalTo(self.mas_left);
            make.bottom.equalTo(self.bottomBackgroundView).with.offset(-SafeAreaBottom);
        }];

        [self.bottomBackgroundView addSubview:self.popTextView];
        [self.popTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.bottomBackgroundView);
            
            make.bottom.equalTo(self.cancelButton.mas_top);
            make.height.mas_equalTo(95);
        }];

        [self.bottomBackgroundView addSubview:self.settingCollectionView];
        [self.settingCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(collectonHeight);
            make.right.left.equalTo(self.bottomBackgroundView);
            make.bottom.equalTo(self.cancelButton.mas_top);

           
            
        }];
        [self.settingCollectionView setBackgroundColor:WhiteColorF6F6F6];
        
        [self.bottomBackgroundView addSubview:self.shareCollectionView];
        [self.shareCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(collectonHeight);
            make.right.top.left.equalTo(self.bottomBackgroundView);
          
            make.bottom.equalTo(self.settingCollectionView.mas_top);
            
        }];
        [self.shareCollectionView setBackgroundColor:WhiteColorF6F6F6];
       
        UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelClick:)];
        [self.topView addGestureRecognizer:tap];
        
        
        [self.settingCollectionView addSubview:self.line];
        
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(lineHeight);
            make.left.right.equalTo(self);
            make.top.equalTo(self.settingCollectionView.mas_top);
        }];
    }
    
    return self;
}
-(void)reloadData{
    
   
}

#pragma 设置界面风格


/////仅有分享的view界面
//-(void)buildShareView{
//    [self addSubview:self.shareCollectionView];
//    [self.shareCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_offset(collectonHeight);
//        make.right.equalTo(self.mas_right);
//        make.left.equalTo(self.mas_left);
//        make.bottom.equalTo(self.cancelButton.mas_top);
//    }];
//}
//
/////分享和设置的view界面
//-(void)buildShareAndSettingView{
//    
//    [self addSubview:self.settingCollectionView];
//    [self.settingCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_offset(collectonHeight);
//        make.right.equalTo(self.mas_right);
//        make.left.equalTo(self.mas_left);
//        make.bottom.equalTo(self.cancelButton.mas_top);
//        
//    }];
//    
//    [self addSubview:self.shareCollectionView];
//    [self.shareCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_offset(collectonHeight);
//        make.right.equalTo(self.mas_right);
//        make.left.equalTo(self.mas_left);
//        make.bottom.equalTo(self.settingCollectionView.mas_top);
//        
//    }];
//    
//
//}

#pragma mark click

-(void)cancelClick:(UIButton*)button{
   
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomBackgroundView.transform = CGAffineTransformMakeTranslation(0, collectonHeight*2);
    }completion:^(BOOL finished) {
        [self setHidden:YES];
    }];
}

-(void)chooseValue:(NSInteger)type{
    if (self.delegate) {
        [self.delegate changeFont:type];
    }
}


#pragma mark collection


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    if ([collectionView isEqual:self.shareCollectionView]) {
        if (self.shareItems.count>0) {
            return 1;
        }else{
            return 0;
        }
    }else{
        return 1;
    }
   
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([collectionView isEqual:self.shareCollectionView]) {
        if (self.shareItems.count>0) {
            return self.shareItems.count;
        }else{
            return 0;
        }
    }else{
        return self.commonItems.count;
    }
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([collectionView isEqual:self.shareCollectionView]) {
        ArtPopViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:classNameFromClass(ArtPopViewCollectionViewCell) forIndexPath:indexPath];
        [cell setData:self.shareItems[indexPath.row]];
        return cell;
    }else{
        ArtPopViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:classNameFromClass(ArtPopViewCollectionViewCell) forIndexPath:indexPath];
        [cell setData:self.commonItems[indexPath.row]];
        return cell;
    }
}

//每个section中不同的列之间的列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return  (kwidth-20*2-60*4)/3;
    
    
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
   return 0;
}
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, collectonHeight);
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
   return UIEdgeInsetsMake(0, 20, 0, -20);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([collectionView isEqual:self.shareCollectionView]) {
        [self cancelClick:nil];
        if(self.delegate){
            [self.delegate Handleclick:self.shareItems[indexPath.row]];
        }
    }else{
        
        ShareModel *model = self.commonItems[indexPath.row];

        if ([model.name isEqualToString:@"字号设置"]) {
            if(self.delegate){
                self.popTextView.hidden = NO;
                self.shareCollectionView.hidden = YES;
                self.settingCollectionView.hidden = YES;
            }
        }else{
            
           [self cancelClick:nil];
                if(self.delegate&&[self.delegate respondsToSelector:@selector(Handleclick:)]){
                    
                    [self.delegate Handleclick:self.commonItems[indexPath.row]];
                }
            
           
        }
        
        
    }
   
}


-(void)show{
    [self setHidden:NO];
    if (self.artPopViewType == ArtPopViewTypeShareAndSetting) {
        
        self.popTextView.hidden = YES;
            if (self.shareItems.count>0) {
            self.shareCollectionView.hidden = NO;
            [self.shareCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(collectonHeight);
            }];
                
                [self.settingCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(collectonHeight);
                }];
        }else{
             self.shareCollectionView.hidden = YES;
            [self.shareCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
           
        }
         [self.shareCollectionView reloadData];
        
        self.settingCollectionView.hidden = NO;
        self.popTextView.selectedIndex = [InfoDetailFont shareInstance].fontStyle;
        [self.settingCollectionView reloadData];
    }else if(self.artPopViewType == ArtPopViewTypeShare){
        
         self.settingCollectionView.hidden = YES;
        [self.settingCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
         self.popTextView.hidden = YES;
        if (self.shareItems.count>0) {
            self.shareCollectionView.hidden = NO;
            [self.shareCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(collectonHeight);
            }];
            [self.shareCollectionView reloadData];
        }else{
            //分享界面和取消按钮界面都不显示
            self.hidden = YES;
        }
    }else {
        self.settingCollectionView.hidden = NO;
        self.popTextView.selectedIndex = [InfoDetailFont shareInstance].fontStyle;
        [self.settingCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(collectonHeight);
        }];
        [self.settingCollectionView reloadData];
        
        self.shareCollectionView.hidden = YES;
        [self.shareCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.shareCollectionView reloadData];
    }

    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomBackgroundView.transform = CGAffineTransformIdentity;
    }];
}
-(ArtPopTextView *)popTextView{
    if (!_popTextView) {
        _popTextView = [[ArtPopTextView alloc] init];
        _popTextView.delegate = self;
        
    }
    return _popTextView;
}
-(UIView*)bottomBackgroundView{
    if (!_bottomBackgroundView) {
        _bottomBackgroundView = [[UIView alloc]init];
        _bottomBackgroundView.backgroundColor = [UIColor whiteColor];
        _bottomBackgroundView.transform = CGAffineTransformMakeTranslation(0, collectonHeight*2);
    }
    return _bottomBackgroundView;
}
-(UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [Tool createButtonWithTitle:@"取消" titleColor:BlackColor333333 target:self action:@selector(cancelClick:)];
        [_cancelButton setBackgroundColor:[UIColor whiteColor]];
        _cancelButton.titleLabel.font = FontOfSize(15);
    }
    return _cancelButton;
}


-(UICollectionView *)shareCollectionView{
    if (!_shareCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        
        _shareCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _shareCollectionView.dataSource = self;
        _shareCollectionView.delegate = self;
        _shareCollectionView.showsHorizontalScrollIndicator = NO;
        
        [_shareCollectionView registerNib:nibFromClass(ArtPopViewCollectionViewCell) forCellWithReuseIdentifier:classNameFromClass(ArtPopViewCollectionViewCell)];
        
        [_shareCollectionView setBackgroundColor:WhiteColorF6F6F6];
    }
    return _shareCollectionView;
}


-(UICollectionView *)settingCollectionView{
    if (!_settingCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        
        _settingCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _settingCollectionView.dataSource = self;
        _settingCollectionView.delegate = self;
        _settingCollectionView.showsHorizontalScrollIndicator = NO;
        
        [_settingCollectionView registerNib:nibFromClass(ArtPopViewCollectionViewCell) forCellWithReuseIdentifier:classNameFromClass(ArtPopViewCollectionViewCell)];
        
        [_settingCollectionView setBackgroundColor:WhiteColorF6F6F6];
        
    }
    return _settingCollectionView;
}
-(UIView*)topView{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = [UIColor clearColor];
    }
    return _topView;
}

-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = BlackColorE3E3E3;
    }
    return _line;
}

@end
