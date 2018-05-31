//
//  ConditionSelectCarLevelSubView.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/16.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ConditionSelectCarLevelSubViewSelectFinishBlock)(NSDictionary*selectedDict,NSString*sectionKey,NSString*rowKey,NSArray*deSelectedArray);
#define cellLineSpace 12  ///最小行间距
#define cellInteritemSpace 15 ///最小列间距
@interface ConditionSelectCarLevelSubView : UIView



-(void)showWithArray:(NSArray*)array SelectFinishBlock:(ConditionSelectCarLevelSubViewSelectFinishBlock)block selectedDict:(NSDictionary*)selectedDict sectionKey:(NSString*)sectionKey rowKey:(NSString*)rowkey;

@end
