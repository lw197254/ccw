//
//  FavouriteTableView.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/13.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,FavouriteType){
    ///车系
    FavouriteTypeCarSeries = 0,
    ///车型
    FavouriteTypeCarType = 1,
    ///口碑
    FavouriteTypeKoubei = 2,
    ///文章
    FavouriteTypeArticle
};

typedef void(^FavouriteTableViewDeleteBlock)(NSMutableDictionary *list);
@interface FavouriteTableView : UITableView

@property(nonatomic,assign)BOOL edited;

@property(nonatomic,assign)BOOL selectedAll;

@property(nonatomic,assign)FavouriteType type;

@property(nonatomic,copy )FavouriteTableViewDeleteBlock  block;

//刷新
-(void)buildReload;
//刷新
-(void)selectStatus;
@end
