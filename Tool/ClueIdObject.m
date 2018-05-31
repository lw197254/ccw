//
//  ClueIdObject.m
//  chechengwang
//
//  Created by 严琪 on 2017/6/7.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ClueIdObject.h"
#import "ClickXunjiaViewModel.h"

@interface ClueIdObject()

@property(nonatomic,strong)ClickXunjiaViewModel *viewModel;

@end

@implementation ClueIdObject

-(ClickXunjiaViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [ClickXunjiaViewModel SceneModel];
    }
    return _viewModel;
}

+(void)setClueId:(NSString *) clueid{
    NSUserDefaults *results = [NSUserDefaults standardUserDefaults];
    [results setValue:clueid forKey:@"clueid"];

    
    //类方法不可以调用对象属性 需要新建对象
    ClueIdObject *temp_obj = [[ClueIdObject alloc] init];
    temp_obj.viewModel.request.clue_id = clueid;
    temp_obj.viewModel.request.startRequest = YES;
    // 3.立刻同步
    [results synchronize];
   
}

+(NSString *)getClueId{
    NSUserDefaults *results = [NSUserDefaults standardUserDefaults];
    return [results valueForKey:@"clueid"];
}


@end
