//
//  MyAppDatabase.h
//  Qumaipiao
//
//  Created by 刘伟 on 16/2/1.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "AppDatabase.h"

@interface MyAppDatabase : AppDatabase
-(void)insertTable:(NSString *)tableName colums:(NSString *)columnsName defalutValue:(NSString *)value;
@end
