//
//  UITableView+UITableViewTopView.m
//  chechengwang
//
//  Created by 严琪 on 2017/4/19.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "UITableView+UITableViewTopView.h"

static char*const tableToTopViewKey = "tableToTopViewKey";
static char*const tableToTopViewShowKey = "tableToTopViewShowKey";

@implementation UITableView(UITableViewTopView)

-(void)showTableTopView{
    if (!self.tableToTopView) {
        self.tableToTopView = [Tool createButtonWithImage:[UIImage imageNamed:@"btn_top"] target:self action:@selector(scrollsToTop) tag:0];
        //self.tableToTopView.transform = CGAffineTransformMakeRotation(M_PI_2);
        [self.superview addSubview:self.tableToTopView];
        [self.tableToTopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-20);
            make.bottom.equalTo(self).with.offset(-60);
            //            make.centerX.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(60, 60));
            //            make.height.equalTo(self.scrollToTopView.mas_width);
        }];
    }else{
        self.tableToTopView.hidden = NO;
    }
    [self.superview bringSubviewToFront:self.tableToTopView];
}
-(void)hideTableToTopView{
    self.tableToTopView.hidden = YES;
}
-(void)setTableToTopViewShow:(BOOL)scrollToTopViewShow{
    objc_setAssociatedObject(self, tableToTopViewShowKey, [NSNumber numberWithBool: scrollToTopViewShow ], OBJC_ASSOCIATION_ASSIGN);
    __block RACDisposable *handler;
    if (scrollToTopViewShow==YES) {
        @weakify(self);
        handler =  [[RACObserve(self, contentOffset)filter:^BOOL(id value) {
            @strongify(self);
            return (self.contentSize.height>0);
            
        }]subscribeNext:^(id x) {
            @strongify(self);
            if( self.contentOffset.y > 0){
                [self showTableTopView];
            }else{
                [self hideTableToTopView];
            }
            
        }];
        
    }else{
        //        [handler dispose];
        [self hideTableToTopView];
    }
}
-(BOOL)tableToTopViewShow{
    return [objc_getAssociatedObject(self, tableToTopViewShowKey) boolValue] ;
}
-(void)setTableToTopView:(UIButton*)scrollToTopView{
    objc_setAssociatedObject(self, tableToTopViewKey, scrollToTopView, OBJC_ASSOCIATION_RETAIN);
}
-(UIButton*)tableToTopView{
    return objc_getAssociatedObject(self, tableToTopViewKey) ;
}
-(void)scrollsToTop{
   
   
    if (self.numberOfSections > 0&&[self numberOfRowsInSection:0]>0) {
         [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
//    [self setContentOffset:offect animated:YES];
//    [self setContentOffset:CGPointMake(self.contentOffset.x, 0) animated:NO];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
