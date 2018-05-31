//
//  BuyCarGuideViewController.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/13.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "BuyCarGuideViewController.h"
#import "ActiveViewController.h"
#import "ArtInfoViewController.h"

#import "TitleTableViewCell.h"

#import "BuyCarGuideViewModel.h"
#import "CarGuideByModel.h"
#import "BuyCarGuideModel.h"
#import "PicShowModel.h"

@interface BuyCarGuideViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

@property (strong, nonatomic) BuyCarGuideViewModel *viewModel;
@property (strong, nonatomic) CarGuideByModel *baseModel;

@property (assign, nonatomic) NSInteger leftClick;
@property (assign, nonatomic) NSInteger rightClick;
@end

@implementation BuyCarGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"购车百科"];
    
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.leftTableView registerNib:nibFromClass(TitleTableViewCell) forCellReuseIdentifier:classNameFromClass(TitleTableViewCell)];
    
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.rightTableView registerNib:nibFromClass(TitleTableViewCell) forCellReuseIdentifier:classNameFromClass(TitleTableViewCell)];
    
  
    self.viewModel.request.startRequest = YES;
   
}

#pragma 代理

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([tableView isEqual:self.leftTableView]) {
        if (self.baseModel.data.count>0) {
            return 1;
        }
        return 0;
    }else{
        if (self.baseModel.data.count>0) {
            return 1;
        }
        return 0;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.leftTableView]) {
        return self.baseModel.data.count;
    }else{
        BuyCarGuideModel *model = self.baseModel.data[self.leftClick];
        return model.article.list.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.leftTableView]) {
        return 50;
    }else{
        return 50;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.leftTableView]) {
        return 50;
    }else{
        return 50;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.leftTableView]) {
     TitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(TitleTableViewCell) forIndexPath:indexPath];
        BuyCarGuideModel *model = self.baseModel.data[indexPath.row];
        
        if (indexPath.row == self.leftClick) {
            cell.titleButton.selected = YES;
        }else{
            cell.titleButton.selected = NO;
        }
        
        cell.titleButton.tag = indexPath.row;
        [cell.titleButton setTitle:model.typeName forState:UIControlStateNormal];
        [cell.titleButton addTarget:self action:@selector(buttonLeftClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        TitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(TitleTableViewCell) forIndexPath:indexPath];
        cell.titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        cell.titleButton.selected = YES;
        [cell.titleButton.titleLabel setNumberOfLines:0];
        [cell setBottomLineWithEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        [cell.titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
        BuyCarGuideModel *model = self.baseModel.data[self
                                                      .leftClick];
        PicShowModel *data  = model.article.list[indexPath.row];
        cell.titleButton.tag = indexPath.row;
        [cell.titleButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:cell.titleButton.size] forState:UIControlStateNormal];
        [cell.titleButton setTitle:data.title forState:UIControlStateNormal];
        [cell.titleButton addTarget:self action:@selector(buttonRightClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.leftTableView]) {
        self.leftClick = indexPath.row;
        [self.rightTableView reloadData];
    }else{
        
 
    }
    
    
}

-(void)buttonRightClick:(UIButton *)button{
    BuyCarGuideModel *model = self.baseModel.data[self.leftClick];
    PicShowModel *pic  = model.article.list[button.tag];
    
    ArtInfoViewController *controller = [[ArtInfoViewController alloc] init];
    
    controller.artType = pic.artType;
    controller.aid = pic.id;
    
    [[Tool currentViewController].rt_navigationController pushViewController:controller animated:YES];
}

-(void)buttonLeftClick:(UIButton *)button{
    button.selected = !button.selected;
    self.leftClick = button.tag;
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma 懒加载

-(BuyCarGuideViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [BuyCarGuideViewModel SceneModel];
        @weakify(_viewModel);
        @weakify(self);
        [[RACObserve(_viewModel, data)filter:^BOOL(id value) {
            @strongify(_viewModel);
            return _viewModel.data.isNotEmpty;
        }]subscribeNext:^(id x) {
             @strongify(self);
             @strongify(_viewModel);
            if (x) {
                self.baseModel = _viewModel.data;
                self.leftClick = 0;
                [self.leftTableView reloadData];
                [self.rightTableView reloadData];
                
            }
        }];
      
    }
    return _viewModel;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
