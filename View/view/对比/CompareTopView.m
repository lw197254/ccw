//
//  CompareTopView.m
//  chechengwang
//
//  Created by 严琪 on 2017/8/21.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "CompareTopView.h"
#import "ImageCollectionViewCell.h"
#import "AddCollectionViewCell.h"
#import "TitleCompareCollectionViewCell.h"
#import "NewCompareCarViewController.h"
#import "NewCompareCarListModel.h"
#import "NewCompareCarModel.h"

#import "CustomPageControl.h"
#import "CarTypeDetailViewController.h"
#import "AddTitleCollectionViewCell.h"

#define showImage @"showImage"

#define showTitle @"showTitle"

#define MaxConut 8
#define MinConut 2

@interface CompareTopView()

@property (copy,nonatomic) NSMutableArray *oldArray;

@property (copy,nonatomic) NSIndexPath *selectIndexPath;

@property (nonatomic,assign) bool open;

@property (nonatomic,strong) UIImageView *imagePK;

@property (nonatomic,strong) CustomPageControl *pageControl;

//是否是滑动手势
@property (nonatomic,assign) bool isHandMove;

//这部分的参数是用来处理collectionview加载不同界面
@property (nonatomic,assign) bool selectShowImage;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) NSString* selectShowImageType;

//这边是用来切换数据源 唯一标志位
@property (nonatomic,strong) NSString* firstCarId;
@property (nonatomic,strong) NSString* secondCarId;

@property (nonatomic,assign) bool isNoDelete;
@property (weak, nonatomic) IBOutlet UIView *topBackgroundView;
//删除的车辆下标 大于8 即是无效数据
@property (nonatomic,assign) NSInteger deleteCarNum;
@property (nonatomic,assign) bool isfristSetUp;

@end

@implementation CompareTopView

-(instancetype)init{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]firstObject];

        
//        UISwipeGestureRecognizer * recognizerUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
//        [recognizerUp setDirection:(UISwipeGestureRecognizerDirectionUp)];
//        [self addGestureRecognizer:recognizerUp];
//        
//        UISwipeGestureRecognizer * recognizerDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
//        [recognizerDown setDirection:(UISwipeGestureRecognizerDirectionDown)];
//        [self addGestureRecognizer:recognizerDown];
//        
//        UISwipeGestureRecognizer * recognizerLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
//        [recognizerLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
//        [self addGestureRecognizer:recognizerLeft];
//        
//  
//        UISwipeGestureRecognizer * recognizerRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
//        [recognizerRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
//        [self addGestureRecognizer:recognizerRight];
        
        self.selectShowImage = true;
        self.selectShowImageType = showImage;
        self.currentPage = 0;
        self.deleteCarNum = 9;
        self.isHandMove = NO;
        self.isfristSetUp =YES;
//        [self.topBackgroundView setBackgroundColor:[UIColor blackColor]];
        
    }
    
    return self ;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    
//    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(160);
//        make.top.left.right.equalTo(self.topBackgroundView);
//    }];
    
    [self.collectionView setCollectionViewLayout:self.flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.adelegate = self;
    self.collectionView.adataSource = self;
    self.collectionView.alwaysBounceVertical = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.collectionView initLongHand];
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
    
     [self.collectionView registerNib:[UINib nibWithNibName:@"AddCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"AddCollectionViewCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"TitleCompareCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TitleCompareCollectionViewCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"AddTitleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"AddTitleCollectionViewCell"];
    
    [self setBottomLine];
    [self setBottomLineShow:NO];
    [self addPKView];
    [self addPageControlView];
}


-(void)addPKView{
    self.imagePK = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PK"]];
    [self addSubview:self.imagePK];
    
    [self.imagePK mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(60);
    }];
}

-(void)addPageControlView{
    [self addSubview:self.pageControl];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
}

-(void)loadView{
  
    NSArray *array = [self.cars.data copy];
    
    //是否需要删除 当conut值为2的时候不得删除
    if (array.count == MinConut) {
        self.isNoDelete = YES;
       
    }else{
        self.isNoDelete = NO;
    }
    
    self.oldArray = [[NSMutableArray alloc] init];
    self.oldArray = [array copy];
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadData];
    }];
 
}

-(void)reloadCollectionWithType:(NSString *) type{
    if ([type isEqualToString:showImage]) {
        [self setBottomLineShow:NO];
        if (self.selectShowImage) {
            return ;
        }else{
            self.selectShowImage = YES;
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(180);
                make.top.left.right.equalTo(self.topBackgroundView);
            }];
            
            [UIView performWithoutAnimation:^{
                [self.collectionView reloadData];
            }];
        }
    }else{
        [self setBottomLineShow:YES];
        if (self.selectShowImage) {
            self.selectShowImage = NO;
            [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.pageControl.mas_top);
                make.height.mas_equalTo(80);
            }];
            [self.collectionView layoutIfNeeded];
            [UIView performWithoutAnimation:^{
                [self.collectionView reloadData];
            }];
        }else{
            return ;
        }
    }
}

-(void)reloadCollection{

    
    if (self.selectShowImage) {
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(180);
            make.top.left.right.equalTo(self.topBackgroundView);
        }];
    }else{
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.pageControl.mas_top);
            make.height.mas_equalTo(80);
        }];
    }
    
   
    
    self.collectionView.availNum = self.cars.data.count;
    self.oldArray = [[NSMutableArray alloc] init];
    self.oldArray = [self.cars.data copy];
    
    
    if (self.oldArray.count == MinConut) {
        self.isNoDelete = YES;
    }else{
        self.isNoDelete = NO;
    }
    
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadData];

    }];
   
    //刷新完成
    [self loadPageControlData];
}

-(void)loadPageControlData{
    //等于8的时候只设置8个
    if (self.collectionView.availNum==MaxConut) {
        [self.pageControl setPageNumber:self.collectionView.availNum];
    }else{
        [self.pageControl setPageNumber:self.collectionView.availNum+1];
    }
    
    if (self.pageControl.pageNumber>=2) {
        
        if (self.deleteCarNum<8) {
        
             NSLog(@"%ld求余数之后%ld",self.deleteCarNum,self.deleteCarNum%2);
            
            if (self.deleteCarNum == 0) {
                [self.pageControl setCurrentPageNumber:0 nextPage:1];
                NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        
            }else{
                [self.pageControl setCurrentPageNumber: self.deleteCarNum-1 nextPage: self.deleteCarNum];
                NSIndexPath *path = [NSIndexPath indexPathForRow:self.deleteCarNum-1 inSection:0];
                [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
               

            }
            // 偏移量
            [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x - 10, self.collectionView.contentOffset.y)];

        }else{
            
            if (self.isfristSetUp) {
                [self.pageControl setCurrentPageNumber:0 nextPage:1];
                return ;
            }
            
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        
            [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            
            // 偏移量
            [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x - 10, self.collectionView.contentOffset.y)];
        }

    }
}


-(void)setUpNewCarsArray{
    NewCompareCarModel *carLeft = self.oldArray[self.currentPage];
    NewCompareCarModel *carRight;
    if (self.currentPage + 1 >= self.oldArray.count) {
        [self.imagePK setHidden:YES];
    }else{
        [self.imagePK setHidden:NO];
       carRight = self.oldArray[self.currentPage+1];
    }
    
    NSLog(@"左边的car%@",carLeft.cars.cx_name);
    
    NSLog(@"右边边的car%@",carRight.cars.cx_name);
    
    if (self.swDelegate) {
        [self.swDelegate setUpNewCarsArrayWithLeftCar:carLeft RightCar:carRight];
    }
}



#pragma mark UIcollectonViewDelegate代理方法

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
         return UIEdgeInsetsMake(0, 10, 0, 10);//分别为上、左、下、右
    }
   
    return UIEdgeInsetsMake(0, 10, 0, 10);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    //添加的最大数字
    if (self.oldArray.count==8) {
        return 1;
    }
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.oldArray.count;
    }else{
        return  1;
    }
  
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            if (self.selectShowImage) {
                
          
                NSString *cellString = @"ImageCollectionViewCell";
                ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellString forIndexPath:indexPath];
                NewCompareCarModel *model = self.oldArray[indexPath.row];
                [cell setCarInfo:model.cars];
                
                cell.deleteButton.tag = indexPath.row;
                [cell.deleteButton addTarget:self action:@selector(deleteCar:) forControlEvents:UIControlEventTouchUpInside];
                
                if (self.isNoDelete) {
                    [cell.deleteButton setHidden:YES];
                    [cell.deleteimage setHidden:YES];
                }else{
                    [cell.deleteButton setHidden:NO];
                    [cell.deleteimage setHidden:NO];
                }
                
                
                if (self.open) {
                    [self addsharkAnimation: cell];
                }else{
                    [self removesharkAnimation:cell];
                }
                
                return cell;
            }else{
                NSString *cellString = @"TitleCompareCollectionViewCell";
                TitleCompareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellString forIndexPath:indexPath];
                
                cell.deleteButton.tag = indexPath.row;
                [cell.deleteButton addTarget:self action:@selector(deleteCar:) forControlEvents:UIControlEventTouchUpInside];
                
                NewCompareCarModel *model = self.oldArray[indexPath.row];
                [cell setCarInfo:model.cars];
                
                if (self.isNoDelete) {
                    [cell.deleteButton setHidden:YES];
                    [cell.deleteimage setHidden:YES];
                }else{
                    [cell.deleteButton setHidden:NO];
                    [cell.deleteimage setHidden:NO];
                }

                
//                if (self.isNoDelete) {
//                    [cell.deleteButton setHeight:YES];
//                }else{
//                    [cell.deleteButton setHeight:NO];
//                }
                return cell;
            }

        }
            break;
        case 1:
            
        {
              if (self.selectShowImage) {
            NSString *cellString = @"AddCollectionViewCell";
            AddCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellString forIndexPath:indexPath];
            return cell;
              }else{
                  NSString *cellString = @"AddTitleCollectionViewCell";
                  AddTitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellString forIndexPath:indexPath];
                  return cell;
              }

        }
            break;
        default:
            break;
    }
    return nil;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeZero;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectShowImage) {
          return CGSizeMake((kwidth-30)/2,160);
    }else{
         return CGSizeMake((kwidth-30)/2,80);
    }

    
}

#pragma mark 按钮点击事件
-(void)deleteCar:(UIButton *)button{
    if (self.swDelegate) {
        self.deleteCarNum = button.tag;
        [self.swDelegate rebuildArray:self.oldArray withDelateNumber:button.tag];
    }
    
}

#pragma mark - RTDragCellcollectionViewDataSource & Delegate 滑动代理

-(void)setOpenShark:(bool)open{
    self.open = open;
    //开始晃动当前的view
    if (open) {
        self.isHandMove = YES;
        [[self.collectionView visibleCells] enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[ImageCollectionViewCell class]]) {
                [self addsharkAnimation:obj];
            }
        }];
    }else{
        [[self.collectionView visibleCells] enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self removesharkAnimation:obj];
        }];
    }
}


-(void)cellIsMovingIncollectionView:(ModuleCollectionView *)collectionView{
}
-(void)collectionView:(ModuleCollectionView *)collectionView cellReadyToMoveAtIndexPath:(NSIndexPath *)indexPath{
}

- (void)collectionView:(ModuleCollectionView *)collectionView newArrayDataForDataSource:(NSArray *)newArray withIndexPath:(NSIndexPath *)indexPath{
    self.oldArray = [newArray copy];
    self.selectIndexPath = indexPath;
}

- (void)cellDidEndMovingIncollectionView:(ModuleCollectionView *)collectionView{
    
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadData];
    }];

    [self.collectionView performBatchUpdates:^{
        
    } completion:^(BOOL finished) {
        UICollectionViewCell *cell =  [self.collectionView cellForItemAtIndexPath:self.selectIndexPath];
        NSLog(@"cell : %f,%f",cell.frame.origin.x,cell.frame.origin.y);
        if (cell.frame.origin.x>(kwidth/2)) {
            [self.collectionView scrollToItemAtIndexPath:self.selectIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
            self.currentPage = self.selectIndexPath.row-1;
        }else{
            [self.collectionView scrollToItemAtIndexPath:self.selectIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
            self.currentPage = self.selectIndexPath.row;
        }
        
        
        self.isHandMove = false;
        if (self.currentPage+1 >= self.cars.data.count+1) {
            return ;
        }
        
        // 偏移量
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x - 10, self.collectionView.contentOffset.y)];
        
        [self.pageControl setCurrentPageNumber:self.currentPage nextPage:self.currentPage+1];
        [self setUpNewCarsArray];
        
    }];
}

- (NSArray *)originalArrayDataForcollectionView:(ModuleCollectionView *)collectionView{
    return self.oldArray;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        if (self.oldArray.count>=CompareMaxCount) {
            [[DialogView sharedInstance]showDlg:self.parentView textOnly:[NSString stringWithFormat:@"最多只能添加%d个车型",CompareMaxCount]];
            return ;
        }
          [[Tool currentViewController].rt_navigationController popViewControllerAnimated:YES];
    }else{
    NewCompareCarModel *car = self.oldArray[indexPath.row];
    CarTypeDetailViewController*vc = [[CarTypeDetailViewController alloc]init];
    vc.chexingId = car.cars.car_id;
    [[Tool currentViewController].rt_navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark 动画
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//     self.imagePK.alpha = 0.0f;
    self.isfristSetUp = NO;
    if (decelerate == NO && self.isHandMove) {
        UICollectionViewCell *cell =  [self.collectionView cellForItemAtIndexPath:self.selectIndexPath];
        NSLog(@"cell : %f,%f",cell.frame.origin.x,cell.frame.origin.y);
        
        if (cell.frame.origin.x>(kwidth/2)) {
            [self.collectionView scrollToItemAtIndexPath:self.selectIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
        }else{
            [self.collectionView scrollToItemAtIndexPath:self.selectIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        }
    }else if(decelerate == NO){
        NSLog(@"慢慢滑动停止了");
        NSArray<UICollectionViewCell *> *array = [self.collectionView visibleCells];
        
        if (array.count == 3) {
            UICollectionViewCell *cell = array[0];
            self.selectIndexPath =  [self.collectionView indexPathForCell:cell];
            NSLog(@"慢慢滑动停止了 %f",scrollView.contentOffset.x);
            if (scrollView.contentOffset.x>(kwidth/4)) {
                [self.collectionView scrollToItemAtIndexPath:self.selectIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
                if (self.selectIndexPath.row == self.currentPage) {
                    return ;
                }
              
            }else{
                [self.collectionView scrollToItemAtIndexPath:self.selectIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
               

            }
            
            
            if (self.selectIndexPath.row == self.currentPage) {
                return ;
            }
            
            if (self.cars.data.count == MaxConut) {
                if (self.currentPage+1 >= self.cars.data.count) {
                    return ;
                }
            }else{
                if (self.currentPage+1 >= self.cars.data.count+1) {
                    return ;
                }
            }

            
            [self.pageControl setCurrentPageNumber:self.currentPage nextPage:self.currentPage+1];
            [self setUpNewCarsArray];
        }
       
    }
   
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
        self.isfristSetUp = NO;
    self.imagePK.alpha = 0.0f;
    
    NSInteger current = (self.collectionView.contentOffset.x+kwidth/2)/(kwidth/2);
    
    if (self.isHandMove) {

        
    }else{
        //如果是按钮点击，则不需要再次变幻状态
        if(scrollView.decelerating && self.currentPage !=current){
           
            if (current+1 >= self.cars.data.count+1) {
                return ;
            }
            
            NSIndexPath *path = [NSIndexPath indexPathForRow:current inSection:0];
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:path];
            self.currentPage = current;
            [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
          
            [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x - 10, self.collectionView.contentOffset.y)];
            
            
            if (self.cars.data.count == MaxConut) {
                if (self.currentPage+1 >= self.cars.data.count) {
                    return ;
                }
            }else{
                if (self.currentPage+1 >= self.cars.data.count+1) {
                    return ;
                }
            }
            
 
            
            [self.pageControl setCurrentPageNumber:self.currentPage nextPage:self.currentPage+1];
            [self setUpNewCarsArray];
        }

        
        
        [UIView animateWithDuration:0.5 animations:^{
            self.imagePK.alpha = 1.0f;
        }];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView

{
        self.isfristSetUp = NO;
    //OK,真正停止了,do something
    if (self.isHandMove) {
        UICollectionViewCell *cell =  [self.collectionView cellForItemAtIndexPath:self.selectIndexPath];
        NSLog(@"cell : %f,%f",cell.frame.origin.x,cell.frame.origin.y);
        [self.collectionView setContentOffset:cell.frame.origin animated:NO];
    }else{
        NSLog(@"停止了");
    }
    self.imagePK.alpha = 1.0f;
}


-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
        self.isfristSetUp = NO;
    CGPoint originalTargetContentOffset = CGPointMake(targetContentOffset->x, targetContentOffset->y);
    NSLog(@"originalTargetContentOffset : %f,%f",originalTargetContentOffset.x,originalTargetContentOffset.y);
    CGPoint targetCenter = CGPointMake(originalTargetContentOffset.x + kwidth/4, CGRectGetHeight(self.collectionView.bounds) / 2);
    
    NSIndexPath *indexPath = nil;
    indexPath = [self.collectionView indexPathForItemAtPoint:targetCenter];
    NSLog(@"indexPath1 : %ld,%ld",indexPath.row,indexPath.section);
    self.selectIndexPath = indexPath;
    
    //滑动回弹
//    UICollectionViewCell *cell =  [self.collectionView cellForItemAtIndexPath:self.selectIndexPath];
//    NSLog(@"cell : %f,%f",cell.frame.origin.x,cell.frame.origin.y);
//    [self.collectionView setContentOffset:cell.frame.origin animated:NO];
}

/***
 * 添加 抖动动画
 */
-(void)addsharkAnimation:(UIView *)view{
    [view.layer removeAllAnimations];
    
    CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animation];
    keyAnimaion.keyPath = @"transform.rotation";
    keyAnimaion.values = @[@(-10 / 180.0 * M_PI),@(10 /180.0 * M_PI),@(-10/ 180.0 * M_PI)];//度数转弧度
    
    keyAnimaion.removedOnCompletion = NO;
    keyAnimaion.fillMode = kCAFillModeForwards;
    keyAnimaion.duration = 0.2;
    keyAnimaion.repeatCount = MAXFLOAT;
    [view.layer addAnimation:keyAnimaion forKey:@"cellShake"];
}

/***
 * 移除 抖动动画
 */
-(void)removesharkAnimation:(UIView *)view{
    [view.layer removeAnimationForKey:@"cellShake"];
}


#pragma mark 判断手势
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"swipe down");
        [self.swDelegate setSwipeWay:YES];
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"swipe up");
        [self.swDelegate setSwipeWay:YES];
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"swipe left");
        [self.swDelegate setSwipeWay:NO];
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"swipe right");
        [self.swDelegate setSwipeWay:NO];
    }
}

//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    return YES;
//}

#pragma mark pageControl
-(CustomPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[CustomPageControl alloc]initWithFrame:CGRectZero pageStyle:CustomPageControlBlueCircle withImageArray:nil];
    }
    return _pageControl;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    return [super hitTest:point withEvent:event];
}
@end
