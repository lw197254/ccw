//
//  UIView+DistributeSpace.m
//  CarAssistantsTest
//
//  Created by 刘伟 on 15/5/19.
//  Copyright (c) 2015年 江苏十分便民. All rights reserved.
//

#import "UIView+DistributeSpace.h"

@implementation UIView (DistributeSpace)

-(void)distributeSpacingHorizontallySpaceEqualWith:(NSArray *)views{
    [self distributeSpacingHorizontallySpaceEqualWith:views withLeftSpaceBaifenbi:1];
}
- (void) distributeVerticallyWith:(NSArray*)views withTopSpaceBaifenbi:(CGFloat)baofenbi{
    if (views.count==0) {
        return;
    }else{
        NSMutableArray *spaces = [NSMutableArray arrayWithCapacity:views.count+1];
        for ( int i = 0 ; i < views.count+1 ; ++i )
        {
            UIView *v = [UIView new];
            [spaces addObject:v];
            [self addSubview:v];
            
            if (i==0||i==views.count) {
                
                [v mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.equalTo(v.mas_height);
                }];
            }else{
                [v mas_makeConstraints:^(MASConstraintMaker *make) {
                    // UIView*v0 = spaces[0];
                    make.width.equalTo(v.mas_height);
                    
                    
                }];
                
            }
            
        }
        UIView *v0 = spaces[0];
        __weak __typeof(&*self)ws = self;
        [v0 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws);
            
            make.centerX.equalTo(((UIView*)views[0]));
        }];
        UIView *lastSpace = v0;
        for ( int i = 0 ; i < views.count; ++i )
        {
            UIView *obj = views[i];
            UIView *space = spaces[i+1];
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastSpace.mas_bottom);
            }];
            
            if (i==views.count-1) {
                [space mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(obj.mas_bottom);
                    make.centerX.equalTo(obj);
                    make.height.equalTo(v0);
                }];
            }else{
                [space mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(obj.mas_bottom);
                    make.centerX.equalTo(obj);
                    if (baofenbi<1.0) {
                        make.height.equalTo(v0).dividedBy(baofenbi);
                    }else{
                        make.height.equalTo(v0).multipliedBy(baofenbi);
                    }
                    
                }];
            }
            lastSpace = space;
        }
        [lastSpace mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ws);
        }];
    }
}
-(void)distributeHorizontallyWith:(NSArray *)views{
    for (NSInteger i = 0; i <views.count; i++) {
        UIView *v = views[i];
       
        if (i==0) {
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                
            }];
            
        }else{
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                UIView*v0 = views[i-1];
                make.left.equalTo(v0.mas_right);
            }];
        }
//        if (i==views.count-1) {
//            [v mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(self);
//            }];
//        }
        
    }
}

//左边右边的百分比
-(void)distributeSpacingHorizontallySpaceEqualWith:(NSArray *)views withLeftSpaceBaifenbi:(CGFloat)baofenbi{
   
    if (views.count==0) {
        return;
    }else{
        NSMutableArray *spaces = [NSMutableArray arrayWithCapacity:views.count+1];
        for ( int i = 0 ; i < views.count+1 ; ++i )
        {
            UIView *v = [UIView new];
            [spaces addObject:v];
            [self addSubview:v];
            
            if (i==0||i==views.count) {
                
                [v mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.equalTo(v.mas_height);
                }];
            }else{
                [v mas_makeConstraints:^(MASConstraintMaker *make) {
                    // UIView*v0 = spaces[0];
                    make.width.equalTo(v.mas_height);
                    
                    
                }];
                
            }
            
        }
        UIView *v0 = spaces[0];
        __weak __typeof(&*self)ws = self;
        [v0 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws);
            
            make.centerY.equalTo(((UIView*)views[0]));
        }];
        UIView *lastSpace = v0;
        for ( int i = 0 ; i < views.count; ++i )
        {
            UIView *obj = views[i];
            UIView *space = spaces[i+1];
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastSpace.mas_right);
            }];
            
            if (i==views.count-1) {
                [space mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(obj.mas_right);
                    make.centerY.equalTo(obj);
                    make.width.equalTo(v0);
                }];
            }else{
                [space mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(obj.mas_right);
                    make.centerY.equalTo(obj);
                    if (baofenbi<1.0) {
                        make.width.equalTo(v0).dividedBy(baofenbi);
                    }else{
                        make.width.equalTo(v0).multipliedBy(baofenbi);
                    }
                   
                }];
            }
            lastSpace = space;
        }
        [lastSpace mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(ws.mas_right);
        }];
    }
}
- (void) distributeSpacingHorizontallyWith:(NSArray*)views
{
    [self distributeSpacingHorizontallySpaceEqualWith:views withLeftSpaceBaifenbi:0.5];
}

- (void) distributeSpacingVerticallyWith:(NSArray*)views
{
    NSMutableArray *spaces = [NSMutableArray arrayWithCapacity:views.count+1];
    for ( int i = 0 ; i < views.count+1 ; ++i )
    {
        
        
        
        UIView *v = [UIView new];
        [spaces addObject:v];
        [self addSubview:v];
        UIView*view = views[0];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(view);
        }];
    }
    UIView *v0 = spaces[0];
    UIView *lastSpace = spaces[views.count];
    __weak __typeof(&*self)ws = self;
    [v0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws);
        make.centerX.equalTo(((UIView*)views[0]));
        make.height.equalTo(lastSpace);
    }];
    
    for ( int i = 0 ; i < views.count; ++i )
    {
        UIView *obj = views[i];
        UIView *space = spaces[i+1];
        UIView*space0 = spaces[i];
        
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(space0.mas_bottom);
           // make.bottom.equalTo(space.mas_top);
        }];
        [space mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(obj.mas_bottom);
            make.height.equalTo(v0);
            make.centerX.equalTo(obj.mas_centerX);
            
        }];
                //lastSpace = spaces[views.count-1];
    }
    [lastSpace mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.height.equalTo(v0);
        make.bottom.equalTo(ws.mas_bottom);
    }];
}

@end
