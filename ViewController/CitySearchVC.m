//
//  searchVC.m
//  searchController
//
//  Created by 王涛 on 15/12/28.
//  Copyright © 2015年 王涛. All rights reserved.
//

#import "CitySearchVC.h"
#import "SearchResultViewController.h"
#import "CityListViewModel.h"
#import "CityHeaderFooterView.h"
#import "CityListTableViewCell.h"
#import "Location.h"
#import "CityListArrayModel.h"
#define sectionM 10000
@interface CitySearchVC ()<UISearchResultsUpdating,UISearchBarDelegate>
@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) NSMutableArray *tempsArray;
@property(nonatomic,strong)NSMutableArray *searchResults;//接收搜索结果

@property(nonatomic,strong)NSArray*dataArray;
@property(nonatomic,strong)CityListArrayModel*listModel;
@property(nonatomic,copy)CityClickedBlock cityClickedBlock;
@property(nonatomic,strong)CityModel*currentCityModel;
@property(nonatomic,strong)Location*locationManager;

@end

@implementation CitySearchVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.definesPresentationContext = YES;
    self.listModel = [[CityListArrayModel alloc]init];
    self.dataArray = self.listModel.list;
    NSMutableArray*array = [[NSMutableArray alloc]initWithArray:self.listModel.list];
    CityListModel*currentListModel = [[CityListModel alloc]init];
    currentListModel.firstChar = @"定位";
    currentListModel.cities = [NSArray<CityModel> arrayWithObject:self.currentCityModel];
    [array insertObject:currentListModel atIndex:0];
    self.dataArray = array;
    [self.tableView registerNib:[UINib nibWithNibName:@"CityListTableViewCell" bundle:nil] forCellReuseIdentifier:@"headerCell"];
    //    字体颜色
    self.tableView.sectionIndexColor = BlackColor;
    //    背景颜色
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.tableView reloadData];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     NSLog(@"11");
        return _dataArray.count;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CityListModel*listModel;
    
         NSLog(@"22");
        listModel = _dataArray[section];
    
    
    CityHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    if (view==nil)
    {
        view = [[CityHeaderFooterView alloc]initWithReuseIdentifier:@"headerView"];
    }
    
    
    
    [view setSectionHeaderViewWithTitle:listModel.firstChar section:section];
    if([listModel.firstChar isEqualToString:@"热门"]||[listModel.firstChar isEqualToString:@"定位"])
    {
        view.topLine.hidden = YES;
        view.bottomLine.hidden = YES;
        view.middleLine.hidden = YES;
        view.contentView.backgroundColor = [UIColor whiteColor];
    }
    else if(section==3)
    {
        view.topLine.hidden = YES;
        view.middleLine.hidden = YES;
        view.bottomLine.hidden = NO;
        view.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    else
    {
        view.topLine.hidden = NO;
        view.middleLine.hidden = YES;
        view.bottomLine.hidden = NO;
        view.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
    return view;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CityListModel *listModel;
     NSLog(@"33");
        listModel = _dataArray[section];
        
    
    
    if ([listModel.firstChar isEqualToString:@"热门"] ||[listModel.firstChar isEqualToString:@"定位"])
    {
        NSInteger count = listModel.cities.count/3+(listModel.cities.count%3==0?0:1);
        return count;
    }
    return listModel.cities.count;
    
    
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CityListModel *listModel;
    NSLog(@"44");
        listModel= _dataArray[indexPath.section];
    
    if ([listModel.firstChar isEqualToString:@"热门"] ||[listModel.firstChar isEqualToString:@"定位"])
    {
        CityListTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CityModel *model1 = listModel.cities[indexPath.row*3];
        [cell.leftButton setTitle:model1.all_name forState:UIControlStateNormal];
        [cell.leftButton setTitle:model1.all_name forState:UIControlStateSelected];
        [cell.leftButton addTarget:self action:@selector(hotButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([model1.all_name isEqualToString:_selectedCityName])
            cell.leftButton.selected = YES;
        else
            cell.leftButton.selected = NO;
        
        
        
        
        cell.leftButton.tag = indexPath.row*3+sectionM*indexPath.section;
        if(indexPath.row*3+1<listModel.cities.count)
        {
            
            CityModel *model2 = listModel.cities[indexPath.row*3+1];
            
            if ([model2.all_name isEqualToString:_selectedCityName])
                cell.middleButton.selected = YES;
            else
                cell.middleButton.selected = NO;
            
            
            cell.middleButton.hidden =NO;
            [cell.middleButton setTitle:model2.all_name forState:UIControlStateNormal];
            [cell.middleButton setTitle:model2.all_name forState:UIControlStateSelected];
            [cell.middleButton addTarget:self action:@selector(hotButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.middleButton.tag = indexPath.row*3+1+sectionM*indexPath.section;
        }
        else
        {
            cell.middleButton.hidden =YES;
        }
        if(indexPath.row*3+2<listModel.cities.count)
        {
            cell.rightButton.hidden =NO;
            CityModel*model3 = listModel.cities[indexPath.row*3+2];
            [cell.rightButton setTitle:model3.all_name forState:UIControlStateNormal];
            [cell.rightButton setTitle:model3.all_name forState:UIControlStateSelected];
            [cell.rightButton addTarget:self action:@selector(hotButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.rightButton.tag = indexPath.row*3+2+sectionM*indexPath.section;
            
            if ([model3.all_name isEqualToString:_selectedCityName])
                cell.rightButton.selected = YES;
            else
                cell.rightButton.selected = NO;
            
        }
        else
        {
            cell.rightButton.hidden =YES;
        }
        
        if ([model1.all_name isEqualToString:@"未知位置"]) {
            cell.leftButton.userInteractionEnabled = NO;
        }else{
            cell.leftButton.userInteractionEnabled = YES;
        }
        
        return cell;
        
    }
    else
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell==nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = BlueColor;
        }
        
        
        CityModel*model = listModel.cities[indexPath.row];
        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        cell.textLabel.text =model.all_name;
        
        if ([model.all_name isEqualToString:_selectedCityName])
            cell.textLabel.textColor = BlueColor;
        else
            cell.textLabel.textColor = [UIColor blackColor];
        
        
        return cell;
    }
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CityListModel *model;
     NSLog(@"55");
    
        model = _dataArray[indexPath.section];
        if ([model.firstChar isEqualToString:@"热门"] ||[model.firstChar isEqualToString:@"定位"]){
            return;
        }
   
    
    CityModel *cityModel = model.cities[indexPath.row];
    if (_cityClickedBlock!=nil)
    {
        _cityClickedBlock(cityModel);
    }
    
    self.searchController.searchBar.text = @"";
    if(cityModel.cityCode){
        [cityModel save];
    }
    
   
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(NSArray<NSString*>*)sectionIndexTitlesForTableView:(UITableView *)tableView
{ NSLog(@"n66r");
    NSMutableArray*array = [[NSMutableArray alloc]init];
    
        [self.dataArray enumerateObjectsUsingBlock:^(CityListModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.firstChar!=nil)
            {
                [array addObject:obj.firstChar];            }
            
        }];
    

    return array;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
     NSLog(@"77r");
    return 30;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
     NSLog(@"88");
    return 0.00001;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     NSLog(@"99");
    self.navigationController.navigationBar.translucent = YES;
    [self.locationManager startLocationSuccess:^(CLLocationCoordinate2D coordinate, NSString *all_name) {
        self.currentCityModel.latitude = coordinate.latitude;
        self.currentCityModel.longitude = coordinate.longitude;
        self.currentCityModel.all_name = all_name;
        self.currentCityModel.cityCode = nil;
        [self.tableView reloadData];
    } failed:^(NSString *errorMessage) {
        //        [AlertView showAlertWithMessage:errorMessage];
        
    }];
     [self initSearchController];
}

- (NSMutableArray *)tempsArray{
    if (!_tempsArray) {
        _tempsArray = [NSMutableArray array];
    }
    return _tempsArray;
}



-(Location*)locationManager{
    if (_locationManager==nil) {
        _locationManager = [[Location alloc]init];
    }
    return _locationManager;
}
-(CityModel*)currentCityModel{
     NSLog(@"10");
    if (_currentCityModel==nil) {
        _currentCityModel = [[CityModel alloc]init];
        _currentCityModel.all_name = @"未知位置";
        _currentCityModel.initial = @"定";
    }
    return _currentCityModel;
}


- (void)initSearchController{
     NSLog(@"11");
    SearchResultViewController *resultTVC = [[SearchResultViewController alloc] initWithNibName:@"SearchResultViewController" bundle:nil];
    UINavigationController *resultVC = [[UINavigationController alloc] initWithRootViewController:resultTVC];
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:resultVC];
    self.searchController.searchResultsUpdater = self;
    
    //self.searchController.dimsBackgroundDuringPresentation = NO;
    //self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    self.searchController.searchBar.backgroundColor =[UIColor clearColor];
    self.searchController.searchBar.barTintColor = LineGrayColor;
    self.searchController.searchBar.placeholder = @"中文/拼音/首字母";

    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x+44,self.searchController.searchBar.frame.origin.y,self.searchController.searchBar.frame.size.width -200,44);
   
    [self.view addSubview:self.searchController.searchBar];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.searchController.searchBar.delegate = self;
    
    resultTVC.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
}


#pragma mark - Table view data source








#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
     NSLog(@"12");
    if (!self.searchResults) {
        self.searchResults = [[NSMutableArray alloc]init];
    }else{
        [self.searchResults removeAllObjects];
    }
    //NSPredicate 谓词
    if (!searchController.searchBar.text.isNotEmpty)
    {
        [self.searchResults addObjectsFromArray:self.dataArray];
        [self.tableView reloadData];
        return;
    }
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"all_name BEGINSWITH[cd] %@ OR initial BEGINSWITH[cd ]  %@ OR spell BEGINSWITH[cd ] %@",searchController.searchBar.text,searchController.searchBar.text,searchController.searchBar.text,searchController.searchBar.text];
    [self.dataArray enumerateObjectsUsingBlock:^(CityListModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSArray *array = [model.cities filteredArrayUsingPredicate:searchPredicate];
        
        if (array.isNotEmpty)
        {
            
            [self.searchResults addObjectsFromArray:array];
        }
        else
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstChar BEGINSWITH[cd] %@ ",searchController.searchBar.text];
            
            if ([predicate evaluateWithObject:model] )
            {
                [self.searchResults addObjectsFromArray:model.cities];
            }
        }
        
    }];
    
    //刷新表格
    
        UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
        SearchResultViewController *resultVC = (SearchResultViewController *)navController.topViewController;
    [resultVC finishedSelected:^(CityModel *model) {
        if (_cityClickedBlock!=nil)
        {
            _cityClickedBlock(model);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
        resultVC.dataArray = [[NSMutableArray alloc]initWithArray: self.searchResults];
        [resultVC.tableView reloadData];

    
}

//- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
//    UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
//    SearchResultViewController *resultVC = (SearchResultViewController *)navController.topViewController;
//    [self filterContentForSearchText:self.searchController.searchBar.text];
//    resultVC.dataArray = self.tempsArray;
//    [resultVC.tableView reloadData];
//}
//
//#pragma mark - Private Method
//- (void)filterContentForSearchText:(NSString *)searchText{
//    NSLog(@"%@",searchText);
//    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
//    [self.tempsArray removeAllObjects];
//    for (int i = 0; i < self.dataArray.count; i++) {
//        NSString *title = self.dataArray[i];
//        NSRange storeRange = NSMakeRange(0, title.length);
//        NSRange foundRange = [title rangeOfString:searchText options:searchOptions range:storeRange];
//        if (foundRange.length) {
//            [self.tempsArray addObject:self.dataArray[i]];
//        }
//    }
//}
-(void)hotButtonClicked:(UIButton*)button
{
    NSInteger section =button.tag/sectionM;
    CityListModel*model = _dataArray[section];
    if (_cityClickedBlock!=nil) {
        _cityClickedBlock(model.cities[button.tag-section*sectionM]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)finishedSelected:(CityClickedBlock)block
{
    if (_cityClickedBlock!=block) {
        _cityClickedBlock = block;
    }
}
/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
