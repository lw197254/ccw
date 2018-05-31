//
//  ConditionSelectedCarPriceView.m
//  chechengwang
//
//  Created by 刘伟 on 2017/6/27.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ConditionSelectedCarPriceView.h"
#import "ConditionSelectCarPriceButtonCollectionViewCell.h"

#define itemCountInRow 4
@interface ConditionSelectedCarPriceView()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property(nonatomic,strong)UIButton*selectedButton;
@property(nonatomic,copy)NSString*selectedTitle;
@property(nonatomic,strong)UIView*collectionViewBackgroundView;
///点击退出的半透明view
@property(nonatomic,strong)UIView*otherView;
///自定义是否展示
@property(nonatomic,assign)BOOL customShow;
@property(nonatomic,assign)NSInteger minPrice;
@property(nonatomic,assign)NSInteger maxPrice;
@end
#define priceButtonBackgroudViewHeight 278/2
#define priceButtonBackgroudFooterHeight (120+96)/2
@implementation ConditionSelectedCarPriceView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [super awakeFromNib];
    [self configUI];
}
-(void)configUI{

    [self.collectionViewBackgroundView addSubview: self.collectionView];
    self.collectionView.scrollEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.collectionViewBackgroundView];
    [self.collectionViewBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(priceButtonBackgroudViewHeight);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.collectionViewBackgroundView);
    }];
    self.collectionView.delegate =self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:nibFromClass(ConditionSelectCarPriceButtonCollectionViewCell) forCellWithReuseIdentifier:classNameFromClass(ConditionSelectCarPriceButtonCollectionViewCell)];
    [self.collectionView registerNib:nibFromClass(ConditionSelectCarPriceFooterCollectionReusableView) forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:classNameFromClass(ConditionSelectCarPriceFooterCollectionReusableView)];
    [self addSubview: self.otherView];
    [self.otherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionViewBackgroundView.mas_bottom);
         make.left.right.equalTo(self);
        make.height.equalTo(self).multipliedBy(2);
    }];
    self.collectionViewBackgroundView.transform = CGAffineTransformMakeTranslation(0, -priceButtonBackgroudViewHeight);
    self.otherView.transform = CGAffineTransformMakeTranslation(0, -priceButtonBackgroudViewHeight);
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancel)];
    [self.otherView addGestureRecognizer:tap];
    @weakify(self);
    [RACObserve(self, customShow)subscribeNext:^(id x) {
        @strongify(self);
        if (self.customShow) {
            [self.collectionViewBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(priceButtonBackgroudViewHeight+priceButtonBackgroudFooterHeight);
                
            }];
            if (self.priceChangedBlock) {
                self.priceChangedBlock(0, MaxPrice);
            }
//            [UIView animateWithDuration:0.25 animations:^{
//               [self.collectionViewBackgroundView layoutIfNeeded];
//            }completion:^(BOOL finished) {
//                
//            }];
            
        }else{
            [self.collectionViewBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(priceButtonBackgroudViewHeight);
                
            }];
           
//            [UIView animateWithDuration:0.25 animations:^{
//                [self.collectionViewBackgroundView layoutIfNeeded];
//            }completion:^(BOOL finished) {
//                
//            }];
           

        }
    }];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
            NSInteger row =  [self conditionArray].count/itemCountInRow;
            NSInteger lastRowItemCount = [self conditionArray].count%itemCountInRow;
    return row+(lastRowItemCount>0?1:0);
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (itemCountInRow*(section+1) <= [self conditionArray].count) {
        return itemCountInRow;
    }
    return [self conditionArray].count-itemCountInRow*(section);
}
///列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 7.5;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section*itemCountInRow+indexPath.row==[self conditionArray].count-1) {
        return  CGSizeMake(2*(kwidth-(itemCountInRow-1)*7.5-15*2)/4+7.5,33);
    }else{
       return  CGSizeMake((kwidth-(itemCountInRow-1)*7.5-15*2)/4,33);
    }

}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section== [collectionView numberOfSections]-1) {
        return CGSizeMake(kwidth, priceButtonBackgroudFooterHeight);
    }else{
        return CGSizeZero;
    }
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section==0) {
        return UIEdgeInsetsMake(10, 15, 10, 15);
    }else{
        return UIEdgeInsetsMake(0, 15, 10, 15);
    }
    
    
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ConditionSelectCarPriceButtonCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:classNameFromClass(ConditionSelectCarPriceButtonCollectionViewCell) forIndexPath:indexPath];
    [cell.button setTitle:[self conditionArray][indexPath.section*itemCountInRow+indexPath.row] forState:UIControlStateNormal];
    cell.button.tag =indexPath.section*itemCountInRow+indexPath.row;
    if(([[cell.button titleForState:UIControlStateSelected] isEqual:[self.selectedButton titleForState:UIControlStateSelected]]&&cell.button !=self.selectedButton)||[[cell.button titleForState:UIControlStateSelected] isEqual:self.selectedTitle]){
        [self buttonClicked:cell.button];
    }
    [cell.button addTarget:self action:@selector(priceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    ConditionSelectCarPriceFooterCollectionReusableView*view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:classNameFromClass(ConditionSelectCarPriceFooterCollectionReusableView) forIndexPath:indexPath];
    @weakify(self);
    [view.slideView sliderChange:^void (NSInteger leftCountValue, NSInteger rightCountValue) {
        @strongify(self);
       
        self.minPrice = leftCountValue;
        self.maxPrice = rightCountValue;
        NSString*title;
        if (rightCountValue >100) {
          
            self.maxPrice = MaxPrice;
            if(self.minPrice==0){
                title =@"自定义";
            }else{
               title =[NSString stringWithFormat:@"%ld万以上",self.minPrice];
            }
            
        }else{
           title = [NSString stringWithFormat:@"%ld-%ld万",self.minPrice,self.maxPrice];
        }
        
        [self.selectedButton setTitle:title forState:UIControlStateSelected];
      
        
    } endBlock:^{
        if (self.priceChangedBlock) {
             self.priceChangedBlock(self.minPrice, self.maxPrice);
           
        }
    }];

    [view.confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    if (self.isReduce) {
        [view.confirmButton setTitle:@"确定" forState:UIControlStateNormal ];
    }
    self.footerView = view;
    return view;
}
-(void)buttonClicked:(UIButton*)button{
    button.selected = !button.selected;
    if (self.selectedButton&&self.selectedButton !=button) {
        self.selectedButton.layer.borderWidth = 0;
        self.selectedButton.selected = NO;
        self.selectedButton.backgroundColor = BlackColorF8F8F8;
        
    }
    if (button.selected==YES) {
        self.selectedButton = button;
       
        self.selectedButton.backgroundColor = BlueColorF5F8FE;
        self.selectedButton.layer.borderWidth = 0.5;
        self.selectedButton.layer.borderColor = BlueColor447FF5.CGColor;
        
    }else{
        if (button==self.selectedButton) {
            self.selectedButton.layer.borderWidth = 0;
            self.selectedButton.selected = NO;
            self.selectedButton.backgroundColor = BlackColorF8F8F8;
            self.selectedButton = nil;
        }else{
            
        }
        
    }

}
-(void)priceButtonClicked:(UIButton*)button{
    [self buttonClicked:button];
     ///自定义按钮
    if (button.tag == [self conditionArray].count-1) {
        if (button.selected == YES){
            self.customShow = YES;
             [self.selectedButton setTitle:@"自定义" forState:UIControlStateSelected];
            self.minPrice = 0;
            self.maxPrice = MaxPrice;
            [self.footerView resetSliderView];
            ///展开
        }else{
            self.customShow = NO;
//            关闭
        }
    }else{
        self.customShow = NO;
        [self dismiss];
        if(self.block){
        NSString*title = [button titleForState:UIControlStateNormal];
         NSRange range =   [title rangeOfString:@"万"];
            title = [title substringToIndex:range.location];
            NSArray*titleArray = [title componentsSeparatedByString:@"-"];
            self.minPrice = 0;
            self.maxPrice = MaxPrice;
            if (titleArray.count <=1) {
                //针对5万以下的设置
                if ([[titleArray firstObject] integerValue] == 5) {
                    self.maxPrice = 5;
                }else{
                    self.minPrice = [[titleArray firstObject] integerValue];
                }
              
            }else{
                self.minPrice = [[titleArray firstObject] integerValue];
                self.maxPrice = [[titleArray lastObject] integerValue];
            }
            
            self.block(self.minPrice, self.maxPrice);
        }
    }
   
}
-(void)confirmButtonClick:(UIButton*)button{
    [self dismiss];
    if (self.block) {
        self.block(self.minPrice, self.maxPrice);
    }
}
-(void)showWithPriceButtonTitleWithoutCount:(NSString *)title selctedBlock:(ConditionSelectCarPriceAndBrandCollectionViewCellBlock)block priceChangeBlock:(ConditionSelectCarPriceAndBrandCollectionViewCellBlock)priceChangedBlock cancelBlock:(ConditionSelectCarPriceCancelBlock)cancelBlock{
    
    self.selectedTitle = title;
    
    if (self.selectedButton) {
        if (!self.selectedTitle||![self.selectedTitle isEqual:[self.selectedButton titleForState:UIControlStateSelected]]) {
            [self buttonClicked:self.selectedButton];
        }
        if (!self.selectedTitle) {
            self.customShow = NO;
        }
        
        
    }else{
        [[self conditionArray]enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqual:self.selectedTitle]) {
                NSInteger section =  idx/itemCountInRow;
                NSInteger row = idx%itemCountInRow;
                ConditionSelectCarPriceButtonCollectionViewCell*cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
                [self buttonClicked:cell.button];
                *stop = YES;
            }
        }];
    }
    if (block!=self.block) {
        self.block = block;
    }
    if (self.cancelBlock!=cancelBlock) {
        self.cancelBlock  = cancelBlock;
    }
    if (priceChangedBlock!=self.priceChangedBlock) {
        self.priceChangedBlock = priceChangedBlock;
    }
    
    self.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.collectionViewBackgroundView.transform = CGAffineTransformIdentity;
        self.otherView.transform = CGAffineTransformIdentity;
        
   
    }];
    
  
}

-(void)showWithPriceButtonTitle:(NSString*)title selctedBlock:(ConditionSelectCarPriceAndBrandCollectionViewCellBlock)block priceChangeBlock:(ConditionSelectCarPriceAndBrandCollectionViewCellBlock) priceChangedBlock cancelBlock:(ConditionSelectCarPriceCancelBlock)cancelBlock carSeriesCount:(NSInteger)carSeriesCount
{
    if (carSeriesCount > 0) {
        [self.confirmButton setTitle:[NSString stringWithFormat:@"共%ld个车系",carSeriesCount] forState:UIControlStateNormal];
    }else{
        [self.confirmButton setTitle:[NSString stringWithFormat:@"未找到符合条件的车系"] forState:UIControlStateNormal];
    }

    self.selectedTitle = title;

        if (self.selectedButton) {
            if (!self.selectedTitle||![self.selectedTitle isEqual:[self.selectedButton titleForState:UIControlStateSelected]]) {
                [self buttonClicked:self.selectedButton];
            }
            if (!self.selectedTitle) {
                self.customShow = NO;
            }
            
            
        }else{
            [[self conditionArray]enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqual:self.selectedTitle]) {
                    NSInteger section =  idx/itemCountInRow;
                    NSInteger row = idx%itemCountInRow;
                    ConditionSelectCarPriceButtonCollectionViewCell*cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
                    [self buttonClicked:cell.button];
                    *stop = YES;
                }
            }];
        }
    if (block!=self.block) {
        self.block = block;
    }
    if (self.cancelBlock!=cancelBlock) {
        self.cancelBlock  = cancelBlock;
    }
    if (priceChangedBlock!=self.priceChangedBlock) {
        self.priceChangedBlock = priceChangedBlock;
    }
    
    self.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        
        self.collectionViewBackgroundView.transform = CGAffineTransformIdentity;
        self.otherView.transform = CGAffineTransformIdentity;
        
    }];

// Initialization code
}
-(void)cancel{
    
    [self dismiss];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}
///隐藏该界面
-(void)dismiss{
    
    if (self.hidden==YES) {
        return;
    }
        [UIView animateWithDuration:0.25 animations:^{
            if (self.customShow) {
                self.collectionViewBackgroundView.transform = CGAffineTransformMakeTranslation(0, -priceButtonBackgroudFooterHeight-priceButtonBackgroudViewHeight);
                self.otherView.transform = CGAffineTransformMakeTranslation(0, -priceButtonBackgroudFooterHeight-priceButtonBackgroudViewHeight);
            }else{
                self.collectionViewBackgroundView.transform = CGAffineTransformMakeTranslation(0, -priceButtonBackgroudViewHeight);
                 self.otherView.transform = CGAffineTransformMakeTranslation(0, -priceButtonBackgroudViewHeight);
            }
            
        

        
        
        
    }completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    
    
}

-(UICollectionView*)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout*layout = [[UICollectionViewFlowLayout alloc]init];
        
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
       
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_collectionView];
//        NSInteger row =  [self conditionArray].count/itemCountInRow;
//        NSInteger lastRowItemCount = [self conditionArray].count%itemCountInRow;
//        NSMutableArray*sectionArray = [NSMutableArray array];
////        for (NSInteger i = 0; i < row+(lastRowItemCount>0?1:0); i++) {
////            NSMutableArray*array = [NSMutableArray array];
////            [sectionArray addObject:array];
////        }
//        __block NSMutableArray*array;
//        __block NSInteger currentRow = 0;
//      [[self conditionArray] enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
//          UIButton*button = [Tool createButtonWithTitle:obj titleColor:BlackColor666666 target:self action:@selector(priceButtonClicked:)];
//          button.backgroundColor = infolineback;
//          button.tag = idx;
//          if (idx <itemCountInRow*(currentRow+1)) {
//              [array addObject:button];
//          }else{
//              currentRow++;
//              if (!array) {
//                  [sectionArray addObject:array];
//              }
//              array = [NSMutableArray array];
//              [array addObject:button];
//          }
//      }];
//        [sectionArray enumerateObjectsUsingBlock:^(NSArray* obj, NSUInteger section, BOOL * _Nonnull stop) {
//            [obj enumerateObjectsUsingBlock:^(UIButton* button, NSUInteger idx, BOOL * _Nonnull stop) {
//                    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//                       
//                        if (((section+1)*itemCountInRow+ idx)==[self conditionArray].count-1) {
//                             ///最后一个自定义
//                            make.size.mas_equalTo(CGSizeMake(2*(kwidth-itemCountInRow*7.5-15*2)/4, 33));
//                        }else{
//                            make.size.mas_equalTo(CGSizeMake((kwidth-itemCountInRow*7.5-15*2)/4, 33));
//                        }
//                        
//                        if (idx==0) {
//                            make.left.equalTo(self.priceView).with.offset(15);
//                        }else{
//                            UIButton*leftButton = obj[idx-1];
//                            make.left.equalTo(leftButton.mas_right).with.offset(7.5);
//                            make.centerY.equalTo(leftButton);
//                        }
//                        if (section==0) {
//                            make.top.equalTo(self.priceView).with.offset(10);
//                        }else{
//                            UIButton*topButton = sectionArray[section-1][0];
//                            make.top.equalTo(topButton.mas_bottom).with.offset(10);
//                        }
//                        ///最后一行
//                        if (section==row+(lastRowItemCount>0?1:0)) {
//                            make.bottom.equalTo(self.priceView).with.offset(-10);
//                        }
//                        
//                        
//                    }];
//            }];
//        }];
        
    }
    return _collectionView;
}
-(NSArray*)conditionArray{
  return  @[@"5万以下",@"5-8万",@"8-10万",@"10-15万",
      @"15-20万",@"20-25万",@"25-35万",@"35-50万",@"50-100万",
      @"100万以上",@"自定义"];
}

-(UIView*)otherView{
    if (!_otherView) {
        _otherView = [[UIView alloc]init];
        _otherView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
    }
    return _otherView;
}
-(UIView*)collectionViewBackgroundView{
    if (!_collectionViewBackgroundView) {
        _collectionViewBackgroundView = [[UIView alloc]init];
        _collectionViewBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionViewBackgroundView;
}
-(HLDoubleSlideView*)doubleSlideView{
    return self.footerView.slideView;
}
-(UIButton*)confirmButton{
    return self.footerView.confirmButton;
}
@end
