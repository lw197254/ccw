//
//  ParamsCompareTool.m
//  chechengwang
//
//  Created by 严琪 on 2017/8/22.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ParamsCompareTool.h"
#import "CompareBodySize.h"
#import "CompareBodySizeChild.h"

@interface ParamsCompareTool()

@property(nonatomic,copy)NSMutableArray *newleftarray;
@property(nonatomic,copy)NSMutableArray *newrightarray;

@property(nonatomic,copy)NSMutableArray *newleftarrayStrings;
@property(nonatomic,copy)NSMutableArray *newrightarrayStrings;

@end

@implementation ParamsCompareTool


-(void)checkEachOther{
    
    if(self.rightParams.confs.count >0){
    
    [self.leftParams.confs enumerateObjectsUsingBlock:^(CompareBodySizeChild *objleft, NSUInteger idx, BOOL *  leftstop) {
        
        [self.rightParams.confs enumerateObjectsUsingBlock:^(CompareBodySizeChild *objright, NSUInteger idx, BOOL *  rightstop) {
            if ([objleft.name isEqualToString:objright.name]) {
                if ([objright.is_exit isEqualToString:objleft.is_exit]) {
                    *rightstop = YES;
                }else if([objleft.is_exit isEqualToString:@"1"]){
                    [self.newleftarray addObject:objleft];
                }else if([objright.is_exit isEqualToString:@"1"]){
                    [self.newrightarray addObject:objright];
                }else{
                    *rightstop = YES;
                }
            }
        }];

    }];
    
    
    if (self.newrightarray.count >self.newleftarray.count) {
        self.count = self.newrightarray.count;
    }else{
        self.count = self.newleftarray.count;
    }
    
    [self getLeftNewParams];
    [self getRightNewParams];
    }else{
        
        [self.leftParams.confs enumerateObjectsUsingBlock:^(CompareBodySizeChild *objleft, NSUInteger idx, BOOL *  leftstop) {
            
           [self.newleftarray addObject:objleft];    
            
        }];
        
        [self getRightNewParams];
        [self getLeftNewParams];
    }

}

-(void)getLeftNewParams{
    if (self.newleftarray.count == 0) {
        return ;
    }
    [self.newleftarray enumerateObjectsUsingBlock:^(CompareBodySizeChild *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.newleftarrayStrings addObject:obj.name];
    }];
}

-(void)getRightNewParams{
    if (self.newrightarray.count == 0) {
        return ;
    }
    
    [self.newrightarray enumerateObjectsUsingBlock:^(CompareBodySizeChild *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.newrightarrayStrings addObject:obj.name];
    }];

}

-(bool)isShowFooter{
    return self.newleftarray.count>3 ||self.newrightarray.count>3?YES:NO;
}

-(NSString *)getSmallLeftParams{
    if (self.newleftarrayStrings.count>3) {
        NSMutableArray *temp = [[NSMutableArray alloc] initWithObjects:self.newleftarrayStrings[0],
                                self.newleftarrayStrings[1],self.newleftarrayStrings[2],nil];
        return [temp componentsJoinedByString:@","];
    }
    return [self.newleftarrayStrings  componentsJoinedByString:@","];

}

-(NSString *)getSmallRighParams{
    if (self.newrightarrayStrings.count>3) {
        NSMutableArray *temp = [[NSMutableArray alloc] initWithObjects:self.newrightarrayStrings[0],
        self.newrightarrayStrings[1],self.newrightarrayStrings[2],nil];
        return [temp componentsJoinedByString:@","];
    }
    return [self.newrightarrayStrings  componentsJoinedByString:@","];
}

-(NSString *)getLeftParams{
    return [self.newleftarrayStrings componentsJoinedByString:@","];
}

-(NSString *)getRightParams{
    return [self.newrightarrayStrings componentsJoinedByString:@","];
}

-(void)removeAll{
    [self.newleftarray removeAllObjects];
    [self.newleftarrayStrings removeAllObjects];
    
    [self.newrightarray removeAllObjects];
    [self.newrightarrayStrings removeAllObjects];
}

-(NSMutableArray *)newleftarrayStrings{
    if (!_newleftarrayStrings) {
        _newleftarrayStrings = [[NSMutableArray alloc] init];
    }
    return _newleftarrayStrings;
}

-(NSMutableArray *)newrightarrayStrings{
    if (!_newrightarrayStrings) {
        _newrightarrayStrings = [[NSMutableArray alloc] init];
    }
    return _newrightarrayStrings;
}


-(NSMutableArray *)newleftarray{
    if (!_newleftarray) {
        _newleftarray = [[NSMutableArray alloc] init];
    }
    return _newleftarray;
}

-(NSMutableArray *)newrightarray{
    if (!_newrightarray) {
        _newrightarray = [[NSMutableArray alloc] init];
    }
    return _newrightarray;
    
}


@end
