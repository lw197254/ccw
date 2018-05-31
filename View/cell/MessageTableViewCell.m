//
//  MessageTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 2017/8/16.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "ActiveViewController.h"
#import "ArtInfoViewController.h"
#import "PicShowModel.h"

#import "HaveSeeViewModel.h"
#import "JPUSHService.h"


@interface MessageTableViewCell()

@property(nonatomic,strong)MyDynamicModel *model;

@property (strong,nonatomic) HaveSeeViewModel *haveSeeViewModel;

@end

@implementation MessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMessage:(MyDynamicModel *)model{

    self.model = model;
    self.name.text = @"车城网";
    
    self.time.text = model.addtime;
    self.content.text = model.content;
    self.title.text = model.title;
   
}

- (IBAction)goToDetail:(id)sender {
    
    
    self.haveSeeViewModel.request.msg_id = self.model.msg_id;
    self.haveSeeViewModel.request.uid = [UserModel shareInstance].uid;
    self.haveSeeViewModel.request.token = [JPUSHService registrationID];
    self.haveSeeViewModel.request.startRequest = YES;
    
    if ([self.model.btype isEqual: @"3"]){
        ActiveViewController*vc = [[ActiveViewController alloc]init];
        vc.urlString = self.model.url;
        vc.titleString = self.model.title;
        vc.cityShow = YES;
        [URLNavigation pushViewController:vc animated:YES];
    }else if ([self.model.btype isEqual: @"2"]){
        ArtInfoViewController *controller = [[ArtInfoViewController alloc] init];
        controller.aid = self.model.art_id;
        controller.artType = zimeiti;
        [URLNavigation pushViewController:controller animated:YES];
    }else{
        ArtInfoViewController *controller = [[ArtInfoViewController alloc] init];
        controller.aid = self.model.art_id;
        controller.artType = wenzhang;
        [URLNavigation pushViewController:controller animated:YES];
    }

}

-(HaveSeeViewModel *)haveSeeViewModel{
    if (!_haveSeeViewModel) {
        _haveSeeViewModel = [HaveSeeViewModel SceneModel];
    }
    return _haveSeeViewModel;
}

@end
