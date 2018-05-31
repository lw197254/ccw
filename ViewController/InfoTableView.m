//
//  InfoTableView.m
//  chechengwang
//
//  Created by 严琪 on 17/1/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "InfoTableView.h"

@implementation InfoTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if(self = [super initWithFrame:frame style:style]){
        
        self.delegate = self;
        self.dataSource =self;
        
        [self registerNib:[UINib nibWithNibName:@"RelateCarTableViewCell" bundle:nil] forCellReuseIdentifier:@"RelateCarTableViewCell"];
        
        
        [[RACObserve(self.sonModel, count)filter:^BOOL(id value) {
            return self.sonModel.count;
        }]subscribeNext:^(id x) {
            [self reloadData];
        }];

    }
    return self;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sonModel.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 175;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InfoNewSonModel *content = self.sonModel[indexPath.section];

    RelateCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RelateCarTableViewCell" forIndexPath:indexPath];
    [cell.img setImageWithURL:[NSURL URLWithString:content.pic.smallpic] placeholderImage:[UIImage imageNamed:@"默认图片80_60.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    cell.title.text = content.brand_son_name;
    cell.price.text = content.factory_price;
    cell.factory.text = @"厂商指导价";
 
    return cell;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
