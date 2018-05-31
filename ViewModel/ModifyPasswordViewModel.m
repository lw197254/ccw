//
//  ModifyPasswordViewModel.m
//  TMC_lutao
//
//  Created by 刘伟 on 16/4/11.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "ModifyPasswordViewModel.h"

@implementation ModifyPasswordViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [ModifyPasswordRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
}
@end
