//
//  ProvinceViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/5.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "CityViewController.h"
#import "CityNewViewModel.h"
#import "CitySearchResultViewController.h"
#import "UITableView+CustomTableViewIndexView.h"
#import "Location.h"
#import "ProvinceLocationTableViewCell.h"
#import "DialogView.h"
#define GPS @"GPS定位中"
#define GPSError @"定位失败"

@interface CityViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) CityNewViewModel *viewModel;
@property (strong, nonatomic)ProvinceLocationTableViewCell*locationCell;
@property (strong, nonatomic) AreaNewModel *model;
@property (assign, nonatomic) BOOL imageAnimating;
@property (assign, nonatomic) BOOL stopAnimating;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopToViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarRightConstraintToSuperView;
@property (weak, nonatomic) IBOutlet UIButton *cancelSearchButton;

@property (weak, nonatomic) IBOutlet UIView *searchBarSuperView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *returnButton;
@property (weak, nonatomic) IBOutlet UIView *searchBarBottomLineView;

//@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong)CitySearchResultViewController*searchResultViewController;
@property (nonatomic, strong) NSMutableArray *tempsArray;
@property(nonatomic,strong)NSMutableArray *searchResults;//接收搜索结果

//@property(nonatomic,strong)NSArray*dataArray;
//@property(nonatomic,strong)CityListArrayModel*listModel;
//@property(nonatomic,copy)CityClickedBlock cityClickedBlock;
//@property(nonatomic,strong)CityModel*currentCityModel;
@property(nonatomic,strong)Location*locationManager;
@end

@implementation CityViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.searchBarSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(StatusHeight);
    }];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.translucent = YES;
     self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.estimatedSectionHeaderHeight=0;
    self.tableView.estimatedSectionFooterHeight=0;
    [self.tableView registerNib:nibFromClass(ProvinceLocationTableViewCell) forCellReuseIdentifier:classNameFromClass(ProvinceLocationTableViewCell)];
    
    self.viewModel = [CityNewViewModel SceneModel];
    [self addRAC];
    if (self.viewModel.model&&self.viewModel.model.info.count >0) {
        self.viewModel.request.areav = self.viewModel.model.areav+1;
        self.viewModel.request.needLoadingView = NO;
        self.viewModel.request.startRequest = YES;
    }else{
        self.viewModel.request.areav = 0;
        self.viewModel.request.needLoadingView = YES;
        self.viewModel.request.startRequest = YES;
    }

   
    [self startLocation];
    [self initSearchController];
    
    self.definesPresentationContext = YES;

   
    // Do any additional setup after loading the view from its nib.
}
-(void)addRAC{
    
    @weakify(self);
    [[RACObserve(self.viewModel, model)filter:^BOOL(id value) {
        @strongify(self);
        return self.viewModel.model.isNotEmpty;
    }]subscribeNext:^(id x) {
        @strongify(self);
        
        NSMutableArray<NSString*>*array = [NSMutableArray<NSString*> array];
        [self.viewModel.model.showList enumerateObjectsUsingBlock:^(CityNewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array addObject:obj.firstletter];
        }];
        CityNewModel*model = [[CityNewModel alloc]init];
        model.firstletter = @"";
        
        if ([Location shareInstance].city) {
            self.model.name = [Location shareInstance].city;
            
        }
        
        self.model.firstletter = @"定";
        
        model.array =@[self.model];
        NSMutableArray*array1 = [NSMutableArray arrayWithObject:model];
        [array1 addObjectsFromArray:self.viewModel.model.showList ];
        self.viewModel.model.showList =  array1;
        
        //        [array insertObject:model.firstletter atIndex:0];
        self.tableView.customIndexViewEdgeInsets = UIEdgeInsetsMake(44, 0, 0, 0);
        [self.tableView reloadViewWithArray:array select:^(NSString *title, NSInteger index) {
            @strongify(self);
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index+1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            
        }];
        [self.tableView reloadData];
    }];
    [[RACObserve([Location shareInstance], cityId)filter:^BOOL(id value) {
        
        return [Location shareInstance].cityId;
    }]subscribeNext:^(id x) {
        @strongify(self);
        self.model.name = [Location shareInstance].city;
        self.model.id = [Location shareInstance].cityId;
        [self stopAnimating];
        if (self.viewModel.model.showList.count > 0) {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            
        }
        
    }];
    

}
-(void)startLocation{
    if ([self.model.name isEqualToString:GPS]) {
        return;
    }
    self.model.name = GPS;
   
    [self startAnimation];
    if (self.viewModel.model.showList.count > 0) {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];

    }
    @weakify(self);
        [[Location shareInstance] startLocationNeedCityIDSuccess:^(CLLocationCoordinate2D coordinate, NSString *cityName, NSString *address) {
            @strongify(self);
            self.model.name = cityName;
            self.model.id = [Location shareInstance].cityId;
            
            if (self.viewModel.model.showList.count > 0) {
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                
            }
            [self stopAnimation];
        } failed:^(NSString *errorMessage) {
            @strongify(self);
            self.model.name = GPSError;
           [self stopAnimation];
            if (errorMessage) {
                [[DialogView sharedInstance]showDlg:self.view textOnly:errorMessage];
            }
           
            if (self.viewModel.model.showList.count > 0) {
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                
            }

        }];
    

}
- (void)initSearchController{
    self.searchBar.tintColor = [UIColor blackColor];
    self.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchBar.backgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
    UITextField *searchField=[self.searchBar valueForKey:@"searchField"];
   
        ///searchbar，搜索框里面的背景色
        searchField.backgroundColor = BlackColorF1F1F1;
   
        searchField.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"搜索"]];
        ///改变searcher的textcolor
        searchField.font = FontOfSize(13);
        searchField.textColor=BlackColor333333;
        //改变placeholder的颜色
        [searchField setValue:BlackColorBBBBBB forKeyPath:@"placeholderLabel.textColor"];
//        self.searchBar.placeholder = @"搜索城市";

//    NSLog(@"11");
//    CitySearchResultViewController *resultTVC = [[CitySearchResultViewController alloc] initWithNibName:classNameFromClass(CitySearchResultViewController) bundle:nil];
//    UIrt_navigationController *resultVC = [[UIrt_navigationController alloc] initWithRootViewController:resultTVC];
//    self.searchController = [[UISearchController alloc]initWithSearchResultsController:resultVC];
//    self.searchController.searchResultsUpdater = self;
//    
//    //self.searchController.dimsBackgroundDuringPresentation = NO;
//    //self.searchController.hidesNavigationBarDuringPresentation = NO;
//    
//   
//    ///searchbar的背景色
//     self.searchController.searchBar.backgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
//    
//    
//    UITextField *searchField=[self.searchController.searchBar valueForKey:@"searchField"];
//   
//    ///searchbar，搜索框里面的背景色
//    searchField.backgroundColor = cutlineback;
//   
//    searchField.leftViewMode=UITextFieldViewModeNever;
//    ///改变searcher的textcolor
//    searchField.font = FontOfSize(13);
//    searchField.textColor=[UIColor colorWithString:@"0x333333"];
//    //改变placeholder的颜色
//    [searchField setValue:[UIColor colorWithString:@"0xBBBBBB"]forKeyPath:@"placeholderLabel.textColor"];
//    self.searchController.searchBar.placeholder = @"搜索城市";
//   
//    
//    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x+44,self.searchController.searchBar.frame.origin.y,self.searchController.searchBar.frame.size.width -200,44);
//    
//    [self.view addSubview:self.searchController.searchBar];
//    self.tableView.tableHeaderView = self.searchController.searchBar;
//    
//    self.searchController.searchBar.delegate = self;
//    
//    resultTVC.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
}


#pragma mark - Table view data source








#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchText:(NSString*)searchText
{
    [self.tableView reloadData];
    
    NSLog(@"12");
    if (!self.searchResults) {
        self.searchResults = [[NSMutableArray alloc]init];
    }else{
        [self.searchResults removeAllObjects];
    }
    //NSPredicate 谓词
    if (!searchText.isNotEmpty)
    {
        [self.searchResults removeAllObjects];
        [self.tableView reloadData];
       
    }else{
        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH[cd] %@ OR firstletter BEGINSWITH[cd ]  %@ OR pinyin BEGINSWITH[cd ] %@",searchText,searchText,searchText];
        NSMutableArray*cityArray = [NSMutableArray arrayWithArray:self.viewModel.model.showList];
        if (cityArray.count > 0) {
            [cityArray removeObjectAtIndex:0];
        }
        
        
        [cityArray enumerateObjectsUsingBlock:^(CityNewModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        
            NSArray *array = [model.array filteredArrayUsingPredicate:searchPredicate];
        
            if (array.isNotEmpty)
            {
            
                [self.searchResults addObjectsFromArray:array];
            }
            else
            {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstletter BEGINSWITH[cd] %@ ",searchText];
            
                if ([predicate evaluateWithObject:model] )
                {
                    [self.searchResults addObjectsFromArray:model.array];
                }
            }
        
        }];
    
    }
    //刷新表格
    

    
    self.searchResultViewController.dataArray = self.searchResults;
     [self.searchResultViewController reloadData];
    @weakify(self);
    [self.searchResultViewController finishedSelected:^(AreaNewModel *model) {
        @strongify(self);
        [self.searchResultViewController.view removeFromSuperview];
        [self.searchResultViewController removeFromParentViewController];
        if (self.citySelectedBlock!=nil){
            self.citySelectedBlock(model);
        }
        [[AreaNewModel shareInstanceSelectedInstance] mergeFromModel:model];
        [[AreaNewModel shareInstanceSelectedInstance] saveToFile];
        [self.rt_navigationController popViewControllerAnimated:YES];
    }];
   
   
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.model.showList.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CityNewModel*model =self.viewModel.model.showList[section];
    return model.array.count;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    CityNewModel*model =self.viewModel.model.showList[section];
    if (section == 0) {
        return @"GPS定位";
    }
    return [NSString stringWithFormat:@"%@", model.firstletter];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row == 0) {
        if (!self.locationCell) {
           self.locationCell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(ProvinceLocationTableViewCell) forIndexPath:indexPath];
           
        }
        
        CityNewModel*sectionModel =self.viewModel.model.showList[indexPath.section];
        AreaNewModel*model = sectionModel.array[indexPath.row];
        self.locationCell.titleLabel.text = model.name;
        if ([model.name isEqualToString:GPS]) {
            [self startAnimation];
        }else{
            [self stopAnimation];
        }
        if ([model.name isEqualToString:[AreaNewModel shareInstanceSelectedInstance].name]) {
            self.locationCell.titleLabel.textColor = BlueColor447FF5;
        }else{
             self.locationCell.titleLabel.textColor = BlackColor333333;
        }
        [self.locationCell.locationRefreshButton addTarget:self action:@selector(startLocation) forControlEvents:UIControlEventTouchUpInside];
        
        return self.locationCell;
    }
    
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.font = FontOfSize(16);
        cell.textLabel.textColor = BlackColor333333;
        
    }
    CityNewModel*sectionModel =self.viewModel.model.showList[indexPath.section];
    AreaNewModel*model = sectionModel.array[indexPath.row];
    if ([model.name isEqualToString:[AreaNewModel shareInstanceSelectedInstance].name]) {
       cell.textLabel.textColor = BlueColor447FF5;
    }else{
        cell.textLabel.textColor = BlackColor333333;
    }
    cell.textLabel.text = model.name;
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = FontOfSize(14);
    header.textLabel.textAlignment = NSTextAlignmentLeft;
    
    header.textLabel.textColor = BlackColor666666;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0&&indexPath.row == 0) {
        if(self.model.id.isNotEmpty){
              [[AreaNewModel shareInstanceSelectedInstance] mergeFromModel:self.model];
            [[AreaNewModel shareInstanceSelectedInstance] saveToFile];
            if (self.citySelectedBlock) {
                self.citySelectedBlock(self.model);
            }
            [self.rt_navigationController popViewControllerAnimated:YES];
        }else{
            [[DialogView sharedInstance]showDlg:self.view textOnly:@"定位失败请重试"];
        }
        
        return;
    }else{
        CityNewModel*section = self.viewModel.model.showList[indexPath.section];
        AreaNewModel*model = section.array[indexPath.row];
   
       
        
         [[AreaNewModel shareInstanceSelectedInstance] mergeFromModel:model];
        [[AreaNewModel shareInstanceSelectedInstance] saveToFile];
        if (self.citySelectedBlock) {
            self.citySelectedBlock(model);
        }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.rt_navigationController popViewControllerAnimated:YES];

    }
   
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startAnimation
{
    if (self.imageAnimating) {
        return;
    }
    self.imageAnimating = YES;
    self.stopAnimating = NO;
    [self animating];
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.searchResultViewController.searchKey = searchText;
    [self updateSearchResultsForSearchText:searchText];
}
//-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
//    self.tableViewTopToViewConstraint.constant = 64-44;
//    return YES;
//}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    @weakify(self);
    self.searchResultViewController.searchResignFirstResponceBlock = ^(){
        @strongify(self);
        [self.searchBar resignFirstResponder];
    };
    [UIView animateWithDuration:0.25 animations:^{
        
        if (IOS_11_OR_LATER) {
         self.searchBarSuperView.transform = CGAffineTransformMakeTranslation(0,-44);
//              self.tableViewTopToViewConstraint.constant = -44;
        }else{
           self.searchBarSuperView.transform = CGAffineTransformMakeTranslation(0, -44);
//          self.tableViewTopToViewConstraint.constant = -44;
        }
       
        self.returnButton.alpha = 0;
        self.titleLabel.alpha = 0;
        self.searchBarBottomLineView.alpha = 1;
       self.searchBarRightConstraintToSuperView.priority = 250;
       
        [self.tableView layoutIfNeeded];
       
        
    }completion:^(BOOL finished) {
         ///显示取消按钮
        
        [self.view addSubview:self.searchResultViewController.view];
        [self addChildViewController:self.searchResultViewController];
    }];
    
}
- (IBAction)cancelSearchClicked:(UIButton *)sender {
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    self.searchResultViewController.searchKey = self.searchBar.text;
    [self.searchResultViewController.dataArray removeAllObjects];
    [self.searchResultViewController reloadData];
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.searchResultViewController.view removeFromSuperview];
        [self.searchResultViewController removeFromParentViewController];
        self.searchBarSuperView.transform = CGAffineTransformIdentity;
        self.returnButton.alpha = 1;
        self.titleLabel.alpha = 1;
        self.searchBarBottomLineView.alpha = 0;
        self.searchBarRightConstraintToSuperView.priority = 800;
        self.tableViewTopToViewConstraint.constant = 0;
        [self.tableView layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        ///隐藏取消按钮
        
        
        
    }];

}

-(void)animating{
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        if (self.locationCell.locationRefreshButton) {
             self.locationCell.locationRefreshButton.transform = CGAffineTransformRotate(self.locationCell.locationRefreshButton.transform, M_PI/2);
        }else{
            self.imageAnimating = NO;
            self.stopAnimating = YES;
        }
            //       ／／ NSLog(@"start");
        
        
    } completion:^(BOOL finished) {
        //        NSLog(@"complate");
        
        if (self.stopAnimating==YES) {
            self.imageAnimating = NO;
            return ;
        }
        if (finished) {
            [self animating];
        }
        
        
        
    }];

}
-(void)stopAnimation{
    self.stopAnimating = YES;
     self.imageAnimating = NO;
}

- (IBAction)backClicked{
    [super leftButtonTouch];
}

-(AreaNewModel*)model{
    if (!_model) {
        _model = [[AreaNewModel alloc]init];
        
        _model.name = nil;
    }
    return _model;
}
-(CitySearchResultViewController*)searchResultViewController{
    if (!_searchResultViewController) {
        _searchResultViewController = [[CitySearchResultViewController alloc]init];
       
        _searchResultViewController.view.frame = CGRectMake(0, self.searchBar.bounds.size.height+StatusHeight, kwidth, kheight-self.searchBar.bounds.size.height-StatusHeight);
    }
    return _searchResultViewController;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    
    if (!self.viewModel.model.isNotEmpty) {
        self.viewModel.request.startRequest = YES;
    }
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
