//
//  MyAppDatabase.m
//  Qumaipiao
//
//  Created by 刘伟 on 16/2/1.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "MyAppDatabase.h"
#import "BrowseKouBeiArtModel.h"



#import "KouBeiCarDeptModel.h"
#import "KouBeiCarTypeModel.h"
#import "KouBeiDBModel.h"
#import "KouBeiArtModel.h"

@implementation MyAppDatabase
-(void)runMigrations{
   
        [self beginTransaction];
        
        // Turn on Foreign Key support
        [self executeSql:@"PRAGMA foreign_keys = ON"];
        
        NSArray *tableNames = [self tableNames];
        
        if (![tableNames containsObject:@"ApplicationProperties"]) {
            [self createApplicationPropertiesTable];
        }
    
    NSLog(@"这个数据库的版本是 %lu",(unsigned long)[self databaseVersion]);
    
    
    if([self databaseVersion]<2){
        [self setDatabaseVersion:2];
        
        if ([self isTableExist:@"BrowseKouBeiArtModel"]) {
            [self insertTable:@"BrowseKouBeiArtModel" colums:@"arttype" defalutValue:@"1"];
            [self insertTable:@"BrowseKouBeiArtModel" colums:@"authorName" defalutValue:@"车城网"];
        }
        
        if ([self isTableExist:@"KouBeiArtModel"]) {
            [self insertTable:@"KouBeiArtModel" colums:@"arttype" defalutValue:@"1"];
            [self insertTable:@"KouBeiArtModel" colums:@"authorName" defalutValue:@"车城网"];
        }
        
        
    }
    if([self databaseVersion]<3){
        [self setDatabaseVersion:3];
    
        NSArray *tableArray = @[@"SubjectAuthorModel",@"KouBeiCarDeptModel",@"KouBeiCarTypeModel",@"KouBeiDBModel",@"KouBeiArtModel"];
        for (NSString *table in tableArray) {
            if ([self isTableExist:table]) {
               [self executeSql:[NSString stringWithFormat:@"drop table %@",table]];
            }
        }
    }
    ///因上一版本代码错误，使得一部分数据库为3版本的用户未更新数据库，故在更新一次数据库版本
    if([self databaseVersion]<4){
        [self setDatabaseVersion:4];
        
        NSArray *tableArray = @[@"KouBeiCarDeptModel",@"KouBeiCarTypeModel",@"KouBeiDBModel",@"KouBeiArtModel"];
        for (NSString *table in tableArray) {
            if ([self isTableExist:table]&& ![self isTableColumsExistsWithTableName:table colums:@"colId"]) {
                [self executeSql:[NSString stringWithFormat:@"drop table %@",table]];
            }
        }
        NSArray*dropArray = @[@"SubjectAuthorModel",@"ProvinceModel"];
        for (NSString *table in dropArray) {
            if ([self isTableExist:table]) {
                [self executeSql:[NSString stringWithFormat:@"drop table %@",table]];
            }
        }
        
    }

        
        
    

//        if ([self databaseVersion] <2) {
//            // Migrations for database version 1 will run here
//            
//            [self setDatabaseVersion:2];
//            [self dropTable];
//        }
//    NSLog(@"%ld",(unsigned long)self.databaseVersion);
//        /*
//         * To upgrade to version 3 of the DB do
//         
//         if ([self databaseVersion] < 3) {
//         // ...
//         [self setDatabaseVersion:3];
//         }
//         
//         *
//         */
        //[self dropTable:@"BrowseKouBeiArtModel" colums:@"arttype"];
//    bool hasArtType = false;
//        NSArray *colums = [self columnsForTableName:@"BrowseKouBeiArtModel"];
//    for (NSString *name in colums) {
//        if ([name isEqualToString:@"arttype"]) {
//            hasArtType = true;
//        }
//    }
//
//    if (!hasArtType) {
//        [self insertTable:@"BrowseKouBeiArtModel" colums:@"arttype"];
//    }
        [self commit];
    }
-(void)dropTable{
//    NSArray *tableArray = self.tableNames;
//    for (NSString *tablename in tableArray) {
//        if ([tablename isEqualToString:@"CityModel"]||[tablename isEqualToString:@"PositionModel"]||[tablename isEqualToString:@"AirplanePositionModel"]) {
//            
//
//        }
//    }
}




- (BOOL)isTableExist:(NSString *)tableName{
    NSArray *tableArray = self.tableNames;
    for (NSString *tablename in tableArray) {
        if ([tablename isEqualToString:tableName]) {
            return YES;
        }
    }
    return NO;
}
-(BOOL)isTableColumsExistsWithTableName:(NSString*)tableName colums:(NSString *)columnsName{
    NSString *sql1 = [NSString stringWithFormat:@"select sql from sqlite_master where type = '%@' and name = '%@'",tableName,columnsName];
    NSArray*array = [self executeSql:sql1];
    if (array.count > 0) {
        return YES;
    }else{
        return NO;
    }
}
-(void)dropTable:(NSString *)tableName colums:(NSString *)columnsName{
    NSString *sql =[NSString stringWithFormat: @"alter table %@ drop column %@",tableName,columnsName];
    [self executeSql:sql];
}

-(void)insertTable:(NSString *)tableName colums:(NSString *)columnsName defalutValue:(NSString *)value{
   
   
   
        NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ TEXT NOT NULL default %@",tableName,columnsName,value];
        [self executeSql:sql];
    
  
}

- (void) createApplicationPropertiesTable {
    [self executeSql:@"create table ApplicationProperties (primaryKey integer primary key autoincrement, name text, value integer)"];
    [self executeSql:@"insert into ApplicationProperties (name, value) values('databaseVersion', 1)"];
}

@end
