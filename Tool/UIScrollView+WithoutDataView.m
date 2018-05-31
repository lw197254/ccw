//
//  UITableView+WithoutDataView.m
//  TMC_convenientTravel
//
//  Created by 刘伟 on 16/6/1.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "UIScrollView+WithoutDataView.h"


 static char*const buttonClickedBlockKey = "buttonClickedBlockKey";
static char*const withoutViewKey = "withoutViewKeyKey";


@implementation UIScrollView (WithoutDataView)

-(void)showWithOutDataViewWithTitle:(NSString *)title{
    [self showWithOutDataViewWithTitle:title centerModel:WithDataViewCenterModeImageBottomEqualCenter];
}
-(void)showWithOutDataViewWithTitle:(NSString *)title centerYOffSet:(CGFloat)centerYOffSet{
    [self showWithOutDataViewWithTitle:title centerModel:WithDataViewCenterModeContentCenter];
    [self.withoutView.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.withoutView).with.offset(centerYOffSet);
    }];
}
-(void)showWithOutDataViewWithTitle:(NSString *)title centerModel:(WithDataViewCenterMode)centerModel{
    [self showWithOutDataViewWithTitle:title centerModel:centerModel image:nil];
}



-(void)showWithOutDataViewWithTitle:(NSString*)title image:(UIImage*)image{
    [self showWithOutDataViewWithTitle:title centerModel:WithDataViewCenterModeImageBottomEqualCenter image:image];
}
-(void)showWithOutDataViewWithTitle:(NSString *)title centerYOffSet:(CGFloat)centerYOffSet image:(UIImage*)image{
    [self showWithOutDataViewWithTitle:title centerModel:WithDataViewCenterModeContentCenter image:image];
    [self.withoutView.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.withoutView).with.offset(centerYOffSet);
    }];
}
-(void)showWithOutDataViewWithTitle:(NSString *)title centerModel:(WithDataViewCenterMode)centerModel image:(UIImage*)image{
    if (!self.withoutView) {
        WithDataView*view = [[WithDataView alloc]init];
        
        
        
        self.withoutView =view;
        view.imageView.image = [UIImage imageNamed:@"通用的玩意"];
        [self addSubview:self.withoutView];
        
        [self.withoutView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.equalTo(self);
            make.width.equalTo(self);
            make.height.equalTo(self);
            
        }];
    }
    if (title.length > 0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 10;// 字体的行间距
        
        paragraphStyle.headIndent = 0;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSDictionary *attributes = @{
                                     NSFontAttributeName:self.withoutView.titleLabel.font,
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        self.withoutView.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:title attributes:attributes];
    }else{
        self.withoutView.titleLabel.text = nil;
    }
   
    
    if (image) {
        self.withoutView.imageView.image =image;
    }else{
        self.withoutView.imageView.image = [UIImage imageNamed:@"通用的玩意"];
    }
    
    self.withoutView.centerModel = centerModel;

}

///断网
-(void)showNetLost{
    [self showNetLostWithCenterYOffSet:-50];
}
///断网  两种样式，一种图片底部居中，
-(void)showNetLostWithCenterModel:(WithDataViewCenterMode)centerModel{
    [self showWithOutDataViewWithTitle:@"好像断网了\n您可以连接网络后刷新重试" centerModel:WithDataViewCenterModeContentCenter image:[UIImage imageNamed:@"断网"]
                           buttonTitle:@"刷新" buttonClicked:self.buttonClickedBlock];
}
//一种自定义在内容居中的基础上修改偏移量
-(void)showNetLostWithCenterYOffSet:(CGFloat)centerYOffSet{
    [self showWithOutDataViewWithTitle:@"好像断网了\n您可以连接网络后刷新重试" centerModel:WithDataViewCenterModeContentCenter image:[UIImage imageNamed:@"断网"]
     buttonTitle:@"刷新" buttonClicked:self.buttonClickedBlock];
    
    [self.withoutView.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.withoutView).with.offset(centerYOffSet);
    }];
}

///有按钮的提示
-(void)showWithOutDataViewWithTitle:(NSString *)title centerModel:(WithDataViewCenterMode)centerModel image:(UIImage*)image buttonTitle:(NSString*)buttonTitle buttonClicked:(ButtonClickedBlock)block{
    [self showWithOutDataViewWithTitle:title centerModel:centerModel image:image];
       if (self.buttonClickedBlock!=block) {
         self.buttonClickedBlock = block;
    }
    [self setbuttonTitle:buttonTitle];
    [self.withoutView.button addTarget:self action:@selector(withoutViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)showWithOutDataViewWithTitle:(NSString *)title centerYOffSet:(CGFloat)centerYOffSet image:(UIImage*)image buttonTitle:(NSString*)buttonTitle buttonClicked:(ButtonClickedBlock)block{
    [self showWithOutDataViewWithTitle:title centerModel:WithDataViewCenterModeContentCenter image:image buttonTitle:buttonTitle buttonClicked:block];
    [self.withoutView.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.withoutView).with.offset(centerYOffSet);
    }];
}
-(void)showWithOutDataViewWithTitle:(NSString *)title image:(UIImage*)image buttonTitle:(NSString*)buttonTitle buttonClicked:(ButtonClickedBlock)block{
     [self showWithOutDataViewWithTitle:title centerModel:WithDataViewCenterModeImageBottomEqualCenter image:image buttonTitle:buttonTitle buttonClicked:block];
}
-(void)setbuttonTitle:(NSString*)title{
    if (title.length > 0) {
        self.withoutView.button.hidden = NO;
        [self.withoutView.button setTitle:title forState:UIControlStateNormal];
        CGSize titleSize = [title boundingRectWithSize:CGSizeMake(999999.0f, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.withoutView.button.titleLabel.font} context:nil].size;
        [self.withoutView.button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(titleSize.width+40);
        }];
    }else{
        self.withoutView.button.hidden = YES;
    }
   

}


//-(void)showWithOutDataViewWithTitle:(NSString *)title centerYOffSet:(CGFloat)centerYOffSet{
//     [self showWithOutDataViewWithTitle:title frame:self.frame image:[UIImage imageNamed:@"暂无经销商"]];
//    [self.withoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.width.height.top.equalTo(self);
//        
//        
//    }];
//    self.withoutView.centerModel = WithDataViewCenterModeContentCenter;
//    [self.withoutView.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.withoutView).with.offset(centerYOffSet);
//    }];
//}
//-(void)showWithOutDataViewWithTitle:(NSString *)title centerYOffSet:(CGFloat)centerYOffSet image:(UIImage*)image{
//    [self showWithOutDataViewWithTitle:title image:image];
//    [self.withoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.width.height.top.equalTo(self);
//        
//        
//    }];
//    [self.withoutView.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.withoutView).with.offset(centerYOffSet);
//    }];
//    
//}
//-(void)showWithOutDataViewWithTitle:(NSString*)title image:(UIImage*)image{
//    [self showWithOutDataViewWithTitle:title frame:self.frame image:image];
//}
//-(void)showWithOutDataViewWithTitle:(NSString*)title frame:(CGRect)frame laugh:(BOOL)laugh{
//   
//    if (laugh) {
//       [self showWithOutDataViewWithTitle:title frame:frame image:[UIImage imageNamed:@"暂无经销商"]];
//    }else{
//        [self showWithOutDataViewWithTitle:title frame:frame image:[UIImage imageNamed:@"暂无经销商"]];
//    }
// 
//}
//-(void)showNetLost{
//    [self showWithOutDataViewWithTitle:@"" frame:self.frame image:[UIImage imageNamed:@"断网了"]];
//    [self.withoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.width.height.top.equalTo(self);
//        
//        
//    }];
//    [self.withoutView.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.withoutView).with.offset(0);
//    }];
//}
//-(void)showNetLostWithCenterYOffSet:(CGFloat)centerYOffSet{
//    [self showWithOutDataViewWithTitle:@"" frame:self.frame image:[UIImage imageNamed:@"断网了"]];
//    [self.withoutView.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.withoutView).with.offset(centerYOffSet);
//    }];
//}
//-(void)showWithOutDataViewWithTitle:(NSString*)title frame:(CGRect)frame image:(UIImage*)image{
//    
//
//}
//-(void)showWithOutDataViewWithTitle:(NSString*)title buttonTitle:(NSString*)buttonTitle frame:(CGRect)frame buttonClicked:(ButtonClickedBlock)block laugh:(BOOL)laugh{
//    
//    [self showWithOutDataViewWithTitle:title frame:frame laugh:laugh];
//        if (block!=self.buttonClickedBlock) {
//            self.buttonClickedBlock = block;
//        }
//        
//        [self.withoutView.button setTitle:[NSString stringWithFormat:@"  %@  ",buttonTitle] forState:UIControlStateNormal];
//        [self.withoutView.button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        
//    [self.withoutView.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.withoutView).with.offset(0);
//    }];
//
//}
-(void)setButtonClickedBlock:(ButtonClickedBlock)buttonClickedBlock{
    objc_setAssociatedObject(self, buttonClickedBlockKey,buttonClickedBlock , OBJC_ASSOCIATION_COPY);
    //    if (self.isTouchDown) {
    //        self.selectedState = lowToHighState;
    //    }else{
    //        self.selectedState = highToLowState;
    //    }
}
-(ButtonClickedBlock)buttonClickedBlock{
    return objc_getAssociatedObject(self, buttonClickedBlockKey) ;
}
-(void)setWithoutView:(WithDataView *)withoutView{
    objc_setAssociatedObject(self, withoutViewKey,withoutView , OBJC_ASSOCIATION_RETAIN);
   
}
-(WithDataView*)withoutView{
    return objc_getAssociatedObject(self, withoutViewKey) ;
}
-(void)withoutViewButtonClicked:(UIButton*)button{
    if (self.buttonClickedBlock) {
        self.buttonClickedBlock();
    }else{
        [self.mj_header beginRefreshing];
    }
}
-(void)dismissWithOutDataView{
    
        if (self.withoutView&&self.withoutView.superview) {
            [self.withoutView removeFromSuperview];
            self.withoutView=nil;
            
        }
    
           
    

    
}
@end
