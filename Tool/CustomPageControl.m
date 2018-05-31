//
//  MyPageControl.m
//  chechengwang
//
//  Created by 严琪 on 17/2/23.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "CustomPageControl.h"
@interface CustomPageControl()
#define tranferScale 1.4
@end
@implementation CustomPageControl

-(instancetype)initWithFrame:(CGRect)frame pageStyle:(CustomPageControlStyle)pageStyle withImageArray:(NSMutableArray *)imageArray
{
    self = [super initWithFrame:frame];
    if (self) {
        _pageBackgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
        _selectedColor = [UIColor whiteColor];
        _pageSpace = 7;//默认的点的空隙
        _pageStyle = pageStyle;
        _currentPageNumber = 0;
        _imageArray = [NSMutableArray arrayWithArray:imageArray];
        
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
}

#pragma mark 重写pageNumber的setter方法
-(void)setPageNumber:(NSInteger)pageNumber
{
    if (_pageNumber != pageNumber) {
        _pageNumber = pageNumber;
        for (UIImageView *imageView in self.subviews) {
            [imageView removeFromSuperview];
        }
        //创建page小点

        //2.循环创建图片,添加到self上
        
        
        for (NSInteger i = 0; i < _pageNumber; i++) {
            //每个小点
            UIImageView *imageView = [[UIImageView alloc]init];
              [self addSubview:imageView];
            
            switch (_pageStyle) {
                case CustomPageControlBlueCircle:
                {
                    imageView.layer.masksToBounds = YES;
                    imageView.layer.cornerRadius = 3;
                    
                    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(6, 6));
                        make.centerY.equalTo(self);
                        if (i==0) {
                            ///转为大的
                            [imageView setBackgroundColor:BlueColor447FF5];
                            
                            make.left.equalTo(self);
                        }else{
                            UIImageView*view  = self.subviews[i-1];
                            make.left.equalTo(view.mas_right).with.offset(self.pageSpace);
                        }
                        if (i==_pageNumber-1) {
                            make.right.equalTo(self);
                        }
                        [imageView setBackgroundColor:GRAYColorEEEEEE];
                        make.top.bottom.equalTo(self).priorityHigh();
                    }];
           
                }
                    break;
                case CustomPageControlStyleDefaoult:{
                    imageView.layer.cornerRadius = 5 / 2.0;
                    imageView.layer.masksToBounds = YES;
//                    imageView.image = _imageArray[i];
                    
                    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(5, 5));
                        make.centerY.equalTo(self);
                        if (i==0) {
                            make.left.equalTo(self);
                        }else{
                            UIImageView*view  = self.subviews[i-1];
                            make.left.equalTo(view.mas_right).with.offset(self.pageSpace);
                        }
                        if (i==_pageNumber-1) {
                            make.right.equalTo(self);
                        }
                        
                        make.top.bottom.equalTo(self).priorityHigh();
                        
                    }];
                }
                    break;
                case CustomPageControlStyleSquare:{
                    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(5, 5));
                        make.centerY.equalTo(self);
                        if (i==0) {
                            ///转为大的
                             imageView.transform = CGAffineTransformMakeScale(tranferScale, tranferScale);
                            
                            make.left.equalTo(self);
                        }else{
                            UIImageView*view  = self.subviews[i-1];
                            make.left.equalTo(view.mas_right).with.offset(self.pageSpace);
                        }
                        if (i==_pageNumber-1) {
                            make.right.equalTo(self);
                        }
                        
                        make.top.bottom.equalTo(self).priorityHigh();
                    }];
                }
                    break;
                case CustomPageControlStyleImages:{
                    imageView.image = _imageArray[i];
                    
                    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                       
                        make.centerY.equalTo(self);
                        if (i==0) {
                            make.left.equalTo(self);
                        }else{
                            UIImageView*view  = self.subviews[i-1];
                            make.left.equalTo(view.mas_right).with.offset(self.pageSpace);
                        }
                        if (i==_pageNumber-1) {
                            make.right.equalTo(self);
                        }
                        
                        make.top.bottom.equalTo(self).priorityHigh();
                        
                    }];

                }
                    break;
                default:
                    break;
                    
            }
            //为每张图添加tag值
            [  imageView setTag:1000 + i ];
            
           
            imageView.backgroundColor = _pageBackgroundColor;
          
        }
        //设置被选中的颜色和被选中的点
        if (self.subviews.count>0) {
            UIImageView *imageView = [self.subviews objectAtIndex:_currentPageNumber];
            imageView.backgroundColor = _selectedColor;
        }
  
    }
}
#pragma mark 设置背景颜色方法
-(void)setPageBackgroundColor:(UIColor *)pageBackgroundColor
{
    _pageBackgroundColor = pageBackgroundColor;
    //子视图不空的情况下遍历修改每张图的颜色
    if (self.subviews.count != 0) {
        for (UIImageView *imageView in self.subviews) {
            imageView.backgroundColor = _pageBackgroundColor;
        }
        //被选中的颜色,防止被覆盖
        UIImageView *imageView = [self.subviews objectAtIndex:_currentPageNumber];
        imageView.backgroundColor = _selectedColor;
    }
}

#pragma mark 被选中的颜色
-(void)setSelectedColor:(UIColor *)selectedColor
{
    if (_selectedColor != selectedColor) {
        _selectedColor = selectedColor;
        //有图的情况下
        if (self.subviews.count) {
            //修改被选中的那张图片的颜色
            UIImageView *imageView = [self.subviews objectAtIndex:_currentPageNumber];
            imageView.backgroundColor = _selectedColor;
        }
    }
}
#pragma mark 设置当前被选中的下标(currentPageNumber)
-(void)setCurrentPageNumber:(NSInteger)currentPageNumber
{
  
    
    if (_currentPageNumber != currentPageNumber) {
        ///将原来的动画取消
        if (self.subviews.count > _currentPageNumber) {
            UIImageView *originImageView = [self.subviews objectAtIndex:_currentPageNumber];
            originImageView.transform = CGAffineTransformIdentity;
        }else{
            //2yanqi 直接退出防止出错 2017/5/10
          
            return ;
        }
        
        if (self.subviews.count>currentPageNumber) {
            _currentPageNumber = currentPageNumber;
        }else{
   
            return ;
        }
                //判断当前图片是否已经存在(即pageNumber是否为0)
        if (self.subviews.count) {
            //改变没有被选中的颜色
            for (UIImageView *imageView in self.subviews) {
                imageView.backgroundColor = _pageBackgroundColor;
            }
            UIImageView *imageView = [self.subviews objectAtIndex:_currentPageNumber];
            imageView.backgroundColor = _selectedColor;
            
            [UIView animateWithDuration:.3 animations:^{
                imageView.transform = CGAffineTransformMakeScale(tranferScale, tranferScale);
            } completion:^(BOOL finished) {
//                imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                //当翻页的时候pageControl会有个放大缩小的动动画
            }];
        }
    }
}

#pragma mark 设置当前被选中的下标(currentPageNumber,nextPageNumber)
-(void)setCurrentPageNumber:(NSInteger)currentPageNumber nextPage:(NSInteger)nextPageNumber
{
    
//    
//    if (self.subviews.count) {
//        //改变没有被选中的颜色
//        for (UIImageView *imageView in self.subviews) {
//              [imageView setBackgroundColor:[UIColor whiteColor]];
//        }
//    }

    
    if (self.subviews.count) {
        //改变没有被选中的颜色
        for (UIImageView *imageView in self.subviews) {
            [imageView setBackgroundColor:GRAYColorEEEEEE];
        }
        UIImageView *imageView = [self.subviews objectAtIndex:currentPageNumber];
        imageView.backgroundColor = _selectedColor;
        
        UIImageView *imageView2 = [self.subviews objectAtIndex:nextPageNumber];
        imageView2.backgroundColor = _selectedColor;
        
        [UIView animateWithDuration:.3 animations:^{
            [imageView setBackgroundColor:BlueColor447FF5];
            [imageView2 setBackgroundColor:BlueColor447FF5];
        } completion:^(BOOL finished) {
            //                imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            //当翻页的时候pageControl会有个放大缩小的动动画
        }];
    }

    
    
//    if (_currentPageNumber != currentPageNumber) {
//        ///将原来的动画取消
//        if (self.subviews.count > _currentPageNumber) {
//            UIImageView *originImageView = [self.subviews objectAtIndex:_currentPageNumber];
//            originImageView.transform = CGAffineTransformIdentity;
//        }else{
//            //2yanqi 直接退出防止出错 2017/5/10
//            
//            return ;
//        }
//        
//        NSLog(@"pagecontrol %ld  %ld  %ld", _currentPageNumber,currentPageNumber,self.subviews.count);
//        
//        if (self.subviews.count>currentPageNumber) {
//            _currentPageNumber = currentPageNumber;
//        }else{
//            NSLog(@"pagecontrol 退出");
//            return ;
//        }
//        //判断当前图片是否已经存在(即pageNumber是否为0)
//        
//    }
}


@end
