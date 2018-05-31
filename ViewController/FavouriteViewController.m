//
//  FavouriteViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2016/12/27.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "FavouriteViewController.h"
#import "FavouriteTableViewCell.h"
@interface FavouriteViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong,nonatomic)UIButton*rightButton;
@end

@implementation FavouriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_rightButton) {
        _rightButton = [Tool createButtonWithTitle:@"编辑" titleColor:[UIColor whiteColor] target:self        action:@selector(rightButtonClicked:)];
        _rightButton.frame = CGRectMake(0, 0, 60, 30);
        [_rightButton setTitle:@"全选" forState:UIControlStateSelected];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_rightButton setTintColor:[UIColor clearColor]];
        
    }
    [self showBarButton:NAV_RIGHT button:_rightButton];
    [self.tableView registerNib:nibFromClass(FavouriteTableViewCell) forCellReuseIdentifier:classNameFromClass(FavouriteTableViewCell)];
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FavouriteTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(FavouriteTableViewCell) forIndexPath:indexPath];
    if (self.rightButton.selected) {
        cell.showSelectButton  = YES;
    }else{
        cell.showSelectButton = NO;
    }
    return cell;
}

-(void)rightButtonClicked:(UIButton*)button{
    button.selected = !button.selected;
    [self.tableView reloadData];
    if (button.selected==YES) {
        
        self.tableView.allowsMultipleSelection = YES;
    }else{
        
        self.tableView.allowsMultipleSelection = NO;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
