//
//  PhotoSelectCarTypeViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/9.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PhotoSelectCarTypeViewController.h"
#import "PhotoSelectCarTypeTableView.h"
#import "HTHorizontalSelectionList.h"
@interface PhotoSelectCarTypeViewController ()<HTHorizontalSelectionListDelegate,HTHorizontalSelectionListDataSource>
@property (strong, nonatomic)  UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet UIButton *allTypeButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet HTHorizontalSelectionList *selectionList;
@property (weak, nonatomic) IBOutlet UIView *seperateLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seperateLineHeightConstraint;

@end

@implementation PhotoSelectCarTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNavigationTitle:@"图片选择"];
    self.selectionList.delegate = self;
    self.selectionList.dataSource = self;
    
    self.seperateLine.backgroundColor = BlackColorE3E3E3;
    self.seperateLineHeightConstraint.constant = lineHeight;
    //设置颜色
    [self.selectionList setTitleColor:BlackColor999999 forState:UIControlStateNormal];
    self.selectionList.leftSpace = 10;
    self.selectionList.seperateSpace = 20;
    self.selectionList.bottomTrimColor = [UIColor clearColor];
    self.selectionList.selectionIndicatorColor = BlueColor447FF5;
   
    if (self.viewModel.model.isNotEmpty) {
        [self configUI];
    }else{
         self.viewModel.request.startRequest = YES;
        @weakify(self);
        [[RACObserve(self.viewModel, model)filter:^BOOL(id value) {
            @strongify(self);
            return self.viewModel.model.isNotEmpty;
        }]subscribeNext:^(id x) {
            @strongify(self);
            [self configUI];
        }];

    }
    self.allTypeButton.selected = YES;
    
    if ([self.selectedImageView.superview isKindOfClass:[UIButton class]]) {
        
    }else{
        UITableViewCell*cell = (UITableViewCell*)self.selectedImageView.superview;
        [cell setSelected:NO];
    }
    
    
    [self.allTypeButton addSubview: self.selectedImageView];
    [self.selectedImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.allTypeButton);
        make.right.equalTo(self.allTypeButton.mas_right).with.offset(-15);
    }];

       // Do any additional setup after loading the view from its nib.
}
-(void)configUI{
    
    [self.selectionList reloadData];
    
    [self.viewModel.model.cars enumerateObjectsUsingBlock:^(CarTypeSectionModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PhotoSelectCarTypeTableView*tableView = [[PhotoSelectCarTypeTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        
        [self.contentView addSubview:tableView];
        tableView.selectedImageView = self.selectedImageView;
        tableView.model = obj;
        tableView.selectedBlock = ^(CarTypeModel*model){
//            self.allTypeButton.selected = NO;
            if (self.selectedBlock) {
                 self.selectedBlock(model);
            }
//
        };
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).with.offset(kwidth*idx);
            make.width.equalTo(self.scrollView);
            if (idx == self.viewModel.model.cars.count-1) {
                make.right.equalTo(self.contentView);
            }
        }];
        [tableView reloadData];
    }];
    
}

-(NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList{
    return self.viewModel.model.cars.count;
}
-(NSString*)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index{
    CarTypeSectionModel*model = self.viewModel.model.cars[index];
    return model.name;
}
-(void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index{
   
    [self.scrollView setContentOffset:CGPointMake(kwidth*index, 0) animated:YES];
        //    NewCarForSaleTableView*tableView = [self.contentView viewWithTag:index+tableViewTagHeader];
    //
    //    self.carCountLabel.text = [NSString stringWithFormat:@"共%ld辆车", tableView.viewModel.model.list.count];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView==self.scrollView) {
        NSInteger current = (self.scrollView.contentOffset.x+kwidth/2)/kwidth;
//        if (current!=self.currentPage) {
//            self.currentPage = current;
            //            UIButton*button = [self.titleView viewWithTag:current+buttonTag];
            //            [self selectButton:button];
            [self.selectionList setSelectedButtonIndex:current];
            //            NewsTableView*tableView = [self.scrollView.contentView viewWithTag:self.currentPage +tableViewTag ];
            //            self.currentTableView = tableView;
            
            //            [tableView refreshWithCarIdType:self.carIdType];
//        }
        
        
    }
    
}

- (IBAction)allTypeClicked:(UIButton *)sender {
    sender.selected = YES;
    
    if ([self.selectedImageView.superview isKindOfClass:[UIButton class]]) {
       
    }else{
        UITableViewCell*cell = (UITableViewCell*)self.selectedImageView.superview;
        [cell setSelected:NO];
    }
   
   
         [self.allTypeButton addSubview: self.selectedImageView];
        [self.selectedImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.allTypeButton);
            make.right.equalTo(self.allTypeButton.mas_right).with.offset(-15);
        }];
    
    if (self.selectedBlock) {
        self.selectedBlock(nil);
    }
    [self.rt_navigationController popViewControllerAnimated:YES];
}
-(UIImageView*)selectedImageView{
    if (!_selectedImageView) {
        _selectedImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"对号"]];
    }
    return _selectedImageView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
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
