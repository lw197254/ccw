//
//  InfoArticleModel.h
//  chechengwang
//
//  Created by 严琪 on 16/12/30.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "FatherModel.h"

@protocol  InfoArticleModel
@end


@interface InfoArticleModel : FatherModel
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *title;

@property(nonatomic,strong)NSString *description;
@property(nonatomic,strong)NSString *click;
@property(nonatomic,strong)NSString *inputtime;
@property(nonatomic,strong)NSString *thumb;
///搜索结果没有该属性
@property(nonatomic,strong)NSString *shorttitle;
///"2017-03-01 16:10:16",,搜索结果含有的属性
@property(nonatomic,strong)NSString *realinputtime;

@property(nonatomic,strong)NSString *authorName;
@property(nonatomic,strong)NSString *authorId;
@property(nonatomic,strong)NSString *artType;

@property(nonatomic,strong)NSString *isRead;
@end
