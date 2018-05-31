//
//  SetUpViewController.m
//  chechengwang
//
//  Created by 严琪 on 2017/5/5.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "SetUpViewController.h"

#import "SetUpTableViewCell.h"
#import "SaveFlow.h"
#import "ReadRecordModel.h"
#import "InfoDetailFont.h"
@interface SetUpViewController ()

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSArray *array;

@property(nonatomic,strong)NSArray *arraySecond;

@property(nonatomic,assign)bool isSwitch;
//缓存大小
@property(nonatomic,strong)NSString *acaheSize;
//缓存的cell的位置
@property(nonatomic,strong)NSIndexPath *cellPath;
///上一次选中的字体颜色按钮
@property(nonatomic,strong)UIButton *laseSelectedFontButton;
@end

@implementation SetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"设置"];
    self.array = @[@"正文字号",@"省流量模式",@"清除缓存"];
    if([UserModel shareInstance].uid.isNotEmpty){
        self.arraySecond = @[@"退出登录"];
    }else{
        self.arraySecond=nil;
    }
   
    self.acaheSize = [self memory];
    [self.tableView reloadData];
   
}

#pragma tableview
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BlackColorF1F1F1;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:nibFromClass(SetUpTableViewCell)  forCellReuseIdentifier:classNameFromClass(SetUpTableViewCell)];
    }
    return _tableView;
}

#pragma  tableview data

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 ) {
        return  self.array.count;
    }else{
        return  self.arraySecond.count;
    }
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = classNameFromClass(SetUpTableViewCell);
    SetUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
   
    
    if (indexPath.section == 0) {
        [cell setTopLine];
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        cell.label.text = self.array[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(indexPath.row == 0){
            [cell.switchButton setHidden: YES];
            [cell.labelView setHidden:NO];
            cell.labelValue.hidden = NO;
            NSString*fontStr = @"中";
            switch ([InfoDetailFont shareInstance].fontStyle) {
                case ArticleFontStyleSmall:
                    fontStr = @"小";
                    break;
                case ArticleFontStyleMiddle:
                    fontStr = @"中";
                    break;
                case ArticleFontStyleLarge:
                    fontStr = @"大";
                    break;
                case ArticleFontStyleVeryLarge:
                    fontStr = @"超大";
                    break;
                    
                default:
                    break;
            }
            cell.labelValue.text = fontStr;
          
            ///tag即为字号
            }else if(indexPath.row == 1){
            [cell.switchButton setHidden: NO];
            [cell.labelView setHidden:YES];
           
            [cell.switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [RACObserve(self, isSwitch)subscribeNext:^(id x) {
                [cell.switchButton setOn:[SaveFlow getFlowSign]];
            }];

        }else if (indexPath.row == 2){
            self.cellPath = indexPath;
            //缓存大小
            [cell.switchButton setHidden:YES];
            cell.labelValue.text = self.acaheSize;
        }else {
            [cell.switchButton setHidden:YES];
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            cell.labelValue.text = [NSString stringWithFormat:@"V%@",version];
        }
    }else{
        [cell.switchButton setHidden:YES];
        cell.label.text = self.arraySecond[indexPath.row];
       
        cell.label.textAlignment = NSTextAlignmentCenter;
        cell.label.textColor = RedColorFF2525;
        [cell.labelValue setHidden:YES];
        [cell.img setHidden:YES];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 0.0001;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView*view = [[UIView alloc]init];
    view.backgroundColor = BlackColorF1F1F1;
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [UIAlertController showActionSheetInViewController:self withTitle:nil message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"小",@"中",@"大",@"超大"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
                
            } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                if (buttonIndex >0 && [InfoDetailFont shareInstance].fontStyle!=buttonIndex-2) {
                    [InfoDetailFont shareInstance].fontStyle = buttonIndex-2;
                    [self.tableView reloadData];
                    
                }
                
            }];
        }
        if (indexPath.row ==2) {
            [self showClearMemoryAlert];
        }
    }else{
        [UserModel loginOut];
        [MobClick event:exitApp];
        [self clearUpUserLocalInfo];
        self.arraySecond = nil;
        [self.tableView reloadData];
        [self.rt_navigationController popViewControllerAnimated:YES];
        NSLog(@"退出");
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        [self showAlert];
    }else {
        [SaveFlow setFlowSign:false];
        self.isSwitch = false;
    }
}

//缓存数据
-(NSString*)memory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths lastObject];
    float size = [self folderSizeAtPath:path];
    if (size >= MaxCacheSize) {
        size = 100;
    }
    NSString *str = [NSString stringWithFormat:@"%.1fM", size];
    return str;
}

//清除本地已经查看的数据
-(void)clearReadRecord{
    [ReadRecordModel deleteAll];
}

//清除缓存数据
-(void)CacheMemory{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths lastObject];
    path = [path stringByAppendingString:@"/Caches"];
    NSString *str = [NSString stringWithFormat:@"缓存已清除%.1fM", [self folderSizeAtPath:path]];
    NSLog(@"%@",str);
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:path];
    for (NSString *p in files) {
        NSError *error;
        NSString *Path = [path stringByAppendingPathComponent:p];
        if ([[NSFileManager defaultManager] fileExistsAtPath:Path]) {
            [[NSFileManager defaultManager] removeItemAtPath:Path error:&error];
        }
    }
}


//清除缓存的方法
- (void)showClearMemoryAlert {
    NSString *title = NSLocalizedString(@"提示", nil);
    NSString *message = NSLocalizedString(@"确定要清除缓存吗？", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"确定", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        MBProgressHUD*hud = [[MBProgressHUD alloc]initWithView:self.view];
        hud.removeFromSuperViewOnHide = YES;
        [self.view addSubview:hud];
        // [hud show:YES];
        
        //        MBProgressHUDModeIndeterminate,
        //        /** Progress is shown using a round, pie-chart like, progress view. */
        //        MBProgressHUDModeDeterminate,
        //        /** Progress is shown using a horizontal progress bar */
        //        MBProgressHUDModeDeterminateHorizontalBar,
        //        /** Progress is shown using a ring-shaped progress view. */
        //        MBProgressHUDModeAnnularDeterminate,
        //        /** Shows a custom view */
        //        MBProgressHUDModeCustomView,
        //        /** Shows only labels */
        //        MBProgressHUDModeText
        
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"清理中";
        //    hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud showAnimated:YES whileExecutingBlock:^{
            [self clearReadRecord];
            [self CacheMemory];
            hud.labelText = @"清理成功";
        } onQueue:[GCDQueue globalQueue].dispatchQueue completionBlock:^{
            
            SetUpTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.cellPath];
            self.acaheSize = @"";
            cell.labelValue.text = @"";
        }];
        
        //[[DialogView sharedInstance]showDlg:self.view textOnly:@"清理成功"];
        //这边清除后补不现实任何数字
        
        
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


//清除省流量的方法
- (void)showAlert {
    NSString *title = NSLocalizedString(@"提示", nil);
    NSString *message = NSLocalizedString(@"在省流量模式下,文章内容中的图片将被压缩,有可能影响阅读体验,是否确定开启省流量模式", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"确定", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [SaveFlow setFlowSign:false];
        self.isSwitch = false;
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [SaveFlow setFlowSign:true];
        self.isSwitch = true;
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//遍历文件夹获得文件夹大小，返回多少M
- (float)folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    
    return folderSize/(1024.0*1024.0);
}

- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//退出之后删除所有该用户的数据
-(void)clearUpUserLocalInfo{
    NSArray *tableArray = @[@"SubjectUserModel",@"KouBeiCarDeptModel",@"KouBeiCarTypeModel",@"KouBeiDBModel",@"KouBeiArtModel"];
    for (NSString *table in tableArray) {
        Class Ojb = NSClassFromString(table);
        FatherModel *myObj = [[NSClassFromString(table) alloc] init];
        if ([myObj isTableExist]) {
            SEL sel = NSSelectorFromString(@"deleteAll");
            if([Ojb respondsToSelector:sel]) {
                [Ojb performSelector:sel];
            }
        }
    }
}
-(void)textFontButtonClicked:(UIButton*)button{
    self.laseSelectedFontButton.selected = NO;
    self.laseSelectedFontButton = button;
    button.selected = YES;
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInteger:button.tag ] forKey:ArticleFont];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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
