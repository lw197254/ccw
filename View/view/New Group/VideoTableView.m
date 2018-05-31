//
//  VideoTableView.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/4.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "VideoTableView.h"

#import "PublicNormalTableViewCell.h"
#import "TableViewHeaderFooterView.h"
#import "VideoHearView.h"



@interface VideoTableView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) VideoHearView *videoTableHeadView;

@end

@implementation VideoTableView


-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        
        self.delegate = self;
        self.dataSource = self;
        self.estimatedSectionFooterHeight = 0;
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        self.separatorStyle =  UITableViewCellSeparatorStyleNone;
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self registerNib:[UINib nibWithNibName:@"PublicNormalTableViewCell" bundle:nil] forCellReuseIdentifier:@"PublicNormalTableViewCell"];
    }
    return self;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.daseModel.aboutList.count == 0) {
        return 0;
    }
    [self rebuildHeadView];
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.daseModel.aboutList.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PublicNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PublicNormalTableViewCell"];
    VideoModel *content = self.daseModel.aboutList[indexPath.row];
    
    
    [cell.img setImageWithURL:[NSURL URLWithString:content.big_img_url] placeholderImage:[UIImage imageNamed:@"默认图片80_60.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
 
    cell.title.text = content.title;
//    cell.views.text = content.click_count;
    cell.views.hidden = YES;
    cell.publicuser.text = content.click_count;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TableViewHeaderFooterView *headview = [[TableViewHeaderFooterView alloc]initWithFrame:CGRectMake(0, 0, kwidth, 25)];
    headview.noimage =YES;
    headview.image.hidden =NO;
    headview.label.text = @"相关视频";
    [headview.image setBackgroundColor:BlackColor333333];
    [headview.image mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headview.label);
        make.bottom.equalTo(headview);
    }];
    headview.label.textColor =BlackColor333333;
    headview.contentView.backgroundColor = [UIColor whiteColor];
    [headview.label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    return headview;;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 25;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
 
    return 0.0001;
}

#pragma 点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoModel *content = self.daseModel.aboutList[indexPath.row];
    
    if (self.block) {
        self.block(content);
    }
    
}

#pragma 功能

//计算文字所占大小
- (CGSize)getSizeByString:(NSString*)string AndFontSize:(CGFloat)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(9999, 25) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:FontOfSize(font)} context:nil].size;
    return size;
}


#pragma 其余界面
-(void)rebuildHeadView{
    float titleHeight;
    CGSize titleSize = [self getSizeByString:self.daseModel.info.title AndFontSize:17];
    if ( titleSize.width<kwidth-30) {
        titleHeight = titleSize.height;
    }else{
        titleHeight = (titleSize.width/kwidth+1)*titleSize.height;
    }
 
    
    float desHeight;
    CGSize desSize =  [self getSizeByString:self.daseModel.info.des AndFontSize:14];
    if (desSize.width<kwidth-30) {
        desHeight = desSize.height;
    }else{
        desHeight = (desSize.width/kwidth+1)*desSize.height;
    }
    
    self.videoTableHeadView = [[VideoHearView alloc] initWithFrame:CGRectMake(0, 0, kwidth, titleHeight+desHeight+30)];
    self.videoTableHeadView.title.text = self.daseModel.info.title;
    self.videoTableHeadView.des.text = self.daseModel.info.des;
    self.tableHeaderView = self.videoTableHeadView;
}






#pragma 懒加载



@end
