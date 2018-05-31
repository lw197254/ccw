//
//  DelearTypeSwitchView.m
//  chechengwang
//
//  Created by 刘伟 on 2017/3/2.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "DelearTypeSwitchView.h"

@implementation DelearTypeSwitchView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    NSString*title =self.storeListArray[indexPath.row] ;
//    self.selectedStoreName = title;
//    InformationTypeTableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
//    [cell setSelected:YES animated:YES];
//    [self.storeTitleView.storeButton setTitle:title forState:UIControlStateNormal];
//    
//    [self.storeTitleView.storeButton exchangeImageAndTitle];
//    [self storeButtonClicked:self.storeTitleView.storeButton];
//    [self.collectionView reloadData];
//}

@end
