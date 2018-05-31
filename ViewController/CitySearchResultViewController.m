//
//  SearchResultViewController.m
//  searchController
//
//  Created by 王涛 on 16/3/7.
//  Copyright © 2016年 王涛. All rights reserved.
//

#import "CitySearchResultViewController.h"
#import "ProvinceListNewModel.h"


#import "Location.h"
#define sectionM 10000
@interface CitySearchResultViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,copy)CityClickedBlock cityClickedBlock;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation CitySearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.searchResignFirstResponceBlock) {
        self.searchResignFirstResponceBlock();
    }
    [self.tableView endEditing:YES];
}

-(void)reloadData{
    if (self.dataArray.count==0&&self.searchKey.isNotEmpty) {
        [self.tableView showWithOutDataViewWithTitle:@"暂无搜索城市"];
    }else{
        [self.tableView dismissWithOutDataView];
    }
    [self.tableView reloadData];
}
#pragma mark - Table view data source






#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.6;
    }else{
        return 0.000001;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSLog(@"number");
//    if (self.dataArray&&[self.dataArray[0] isKindOfClass:[CityListModel class]]) {
//        return 0;
//    }

    return  _dataArray.count;
    
    
    
    
    
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cell");
    
           UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell==nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = BlackColor333333;
        }
        
        
        AreaNewModel*model = self.dataArray[indexPath.row];
           cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        cell.textLabel.text =model.name;
        
    if ([model.name isEqualToString:[AreaNewModel shareInstanceSelectedInstance].name]) {
        cell.textLabel.textColor = BlueColor447FF5;
    }else{
        cell.textLabel.textColor = BlackColor333333;
    }
        return cell;
    
   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  
    
    AreaNewModel *cityModel = self.dataArray[indexPath.row];
  
    
    
   
     
    if (_cityClickedBlock!=nil)
    {
        _cityClickedBlock(cityModel);
    }
}


-(void)finishedSelected:(CityClickedBlock)block
{
    if (_cityClickedBlock!=block) {
        _cityClickedBlock = block;
    }
}










#pragma mark - Table view data source










/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
