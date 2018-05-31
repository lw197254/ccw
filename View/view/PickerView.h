//
//  PickerView.h
//  TMC_lutao
//
//  Created by 刘伟 on 16/4/19.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^PickerViewConfirmBlock)(void);
@interface PickerView : UIView
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
- (IBAction)cancelClicked:(UIButton *)sender;
- (IBAction)confirmClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *whiteBackgroundViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *whiteBackgroundView;
+(instancetype)pickerViewWithConfirmBlock:(PickerViewConfirmBlock)pickerBlock;
@property(nonatomic,copy)PickerViewConfirmBlock confirmBlock;
-(void)show;
-(void)dismiss;
@end
