//
//  FatherViewModel.m
//  PrivateOrdering
//
//  Created by 刘伟 on 16/3/21.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"

@implementation FatherViewModel
+(instancetype)viewModel{
    return [[self class] SceneModel];
}
-(void)loadSceneModel{
//    [super loadSceneModel];
    self.action = [MyAction Action];
    self.action.aDelegaete = self;
    
}
- (void)handleActionMsg:(FatherRequest*)msg{
    
//    NSString*str = [[NSMutableString alloc]initWithData:@"0a466174 616c2065 72726f72 3a205573 696e6720 24746869 73207768 656e206e 6f742069 6e206f62 6a656374 20636f6e 74657874 20696e20 2f647261 676f6e2f 77656261 70702f74 6d632f70 726f7465 63746564 2f6d6f64 656c732f 55736572 436f6e74 61637465 722e7068 70206f6e 206c696e 65203435 0a" encoding:NSUTF8StringEncoding];
      
    if(msg.sending){
       
    }else if(msg.succeed){
        if (msg.needLoadingView) {
             [LoadingView dismiss];
        }
       
        
       
    }else if(msg.failed){
        if (msg.needLoadingView) {
            [LoadingView dismiss];
        }

       
        
        NSString*errorMsg =[msg.output objectForKey:@"msg"];
//        NSLog(@"errorCode:%d",[[msg.output objectForKey:@"rc"] integerValue]);
        if (!errorMsg.isNotEmpty) {
            errorMsg = @"网络或服务器异常";
            errorMsg=[self codeToString: msg.error];
        }
        if (errorMsg!=nil&&![errorMsg isEqualToString:@"未完成操作"]) {
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            
            if (msg.withErrorAlert) {
                if (self.view) {
                    [[DialogView sharedInstance]showDlg:self.view textOnly:errorMsg];
                }else{
                    [[DialogView sharedInstance]showDlg:[UIApplication sharedApplication].keyWindow textOnly:errorMsg];
                }
            }
           
//           
        }
       
    }
   
}

-(void)upload:(FatherRequest*)request{
    [(MyAction*)self.action Upload:request];
}
-(NSString*)codeToString:(NSError*)error{
    NSDictionary*errordict = [NSDictionary dictionaryWithObjectsAndKeys:@"网络异常，请检查网络",@"-1009",@"请求参数异常，正在抢修",@"-3840",@"请求超时",@"-2102",@"请求超时",@"-1001",@"未完成操作",@"-999", nil];
    
    NSString*errorCode =  [NSString stringWithFormat:@"%ld",(long)error.code ];
    NSString*errorMassage =  errordict[errorCode];
    if (errorMassage==nil) {
        errorMassage=@"网络或服务器异常";
    }
    if (error==nil||[errorCode isEqualToString:@"未完成操作"]) {
        errorMassage=nil;
    }
    return errorMassage;
    
}
-(NSMutableArray *)success:(NSMutableArray *)originArray
                  newArray:(NSArray *)newArray currentPage:(NSInteger)currentPage initPage:(NSInteger)initPage{
    ///第一页
    if (currentPage == initPage) {
        [originArray removeAllObjects];
        originArray = [NSMutableArray array];
    }
    if([newArray count]>0){
        [originArray addObjectsFromArray:newArray];
    }
    return originArray;
}

@end
