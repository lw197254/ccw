//
//  MessageCenterViewController.m
//  chechengwang
//
//  Created by 严琪 on 2017/8/17.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "ActiveViewController.h"


#import "MessageTableViewCell.h"
#import "DoubleCommentTableViewCell.h"
#import "DoubleSingleCommentTableViewCell.h"

#import "ReBackViewModel.h"
#import "MyDynamicViewModel.h"
#import "HaveSeeViewModel.h"
// 引 JPush功能所需头 件
#import "JPUSHService.h"
#import "CommentView.h"
#import "AddCommentViewModel.h"
#import "MyDynamicModel.h"
#import "PicShowModel.h"

#import "ArtInfoViewController.h"
#import "VideoViewController.h"
#import "VideoModel.h"

#import "IQKeyboardManager.h"
 


@interface MessageCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;


@property (weak, nonatomic) IBOutlet UILabel *leftline;
@property (weak, nonatomic) IBOutlet UILabel *rightline;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;

@property (weak, nonatomic) IBOutlet UIView *redType;
@property (strong,nonatomic) UITableView *leftTableView;
@property (strong,nonatomic) UITableView *rightTableView;
@property (assign,nonatomic) NSInteger currentpage;

@property (strong,nonatomic) ReBackViewModel *rebackViewModel;
@property (strong,nonatomic) MyDynamicViewModel *myDynamicViewModel;
@property (strong,nonatomic) HaveSeeViewModel *haveSeeViewModel;

@property (strong, nonatomic) CommentView *sendCommentView;
@property (nonatomic,strong) AddCommentViewModel *addCommentViewModel;
///上一个被评论的id
@property (nonatomic,copy) NSString *pid;
@property (nonatomic,assign) NSInteger rebackPage;
@property (nonatomic,assign) NSInteger mydynamicPage;

//消息列表
@property (nonatomic,strong) NSMutableArray *mydynamicList;

@end

@implementation MessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.navigationController.navigationBar.translucent = NO;
  
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"消息"];
    self.navigationBarBottomLineHidden = YES;
    
    self.rebackPage = 1;
    self.mydynamicPage = 1;
    self.currentpage = 0;
    self.scrollView.bounces = NO;
    
    self.leftButton.highlighted = NO;
    self.rightButton.highlighted = NO;
    
    [self.redType setHidden:YES];
    [self configUI];
    [self initData];
}

#pragma mark 界面方法

-(void)configUI{
    self.currentpage = 0;
    self.scrollView.showsVerticalScrollIndicator = FALSE;
    self.scrollView.showsHorizontalScrollIndicator = FALSE;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    self.leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.leftTableView.estimatedRowHeight= 0;
    self.leftTableView.estimatedSectionFooterHeight = 0;
    self.leftTableView.estimatedSectionHeaderHeight = 0;
    if (@available(iOS 11.0, *)) {
        self.leftTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.leftTableView setBackgroundColor:BlackColorF1F1F1];
    [self.scrollContentView addSubview:self.leftTableView];
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(self.scrollContentView);
        make.width.equalTo(self.view);
    }];
    [self.leftTableView registerNib:nibFromClass(DoubleCommentTableViewCell) forCellReuseIdentifier:classNameFromClass(DoubleCommentTableViewCell)];
    
     [self.leftTableView registerNib:nibFromClass(DoubleSingleCommentTableViewCell) forCellReuseIdentifier:classNameFromClass(DoubleSingleCommentTableViewCell)];
    
    self.rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.rightTableView.estimatedRowHeight= 0;
    self.rightTableView.estimatedSectionFooterHeight = 0;
    self.rightTableView.estimatedSectionHeaderHeight = 0;
    if (@available(iOS 11.0, *)) {
        self.rightTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    [self.rightTableView setBackgroundColor:BlackColorF1F1F1];
    self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.scrollContentView addSubview:self.rightTableView];
    [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.scrollContentView);
        make.left.equalTo(self.leftTableView.mas_right);
        make.width.equalTo(self.view);
    }];
    
    [self.rightTableView registerNib:nibFromClass(MessageTableViewCell) forCellReuseIdentifier:classNameFromClass(MessageTableViewCell)];
    
//    [self.scrollView addSubview: self.scrollContentView];
//
//    [self.scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.scrollView);
//    }];
}

-(void)hideRight{
    self.rightButton.selected = NO;
     [self.rightline setHidden:YES];
}

-(void)hideLeft{
    self.leftButton.selected = NO;
    [self.leftline setHidden:YES];
}


#pragma  mark 数据加载
-(void)initData{
    self.rebackViewModel.request.uid = [UserModel shareInstance].uid;
    self.rebackViewModel.request.page = self.rebackPage;
    
    @weakify(self)
    [[RACObserve(self.rebackViewModel,data)
    filter:^BOOL(id value) {
        return self.rebackViewModel.data.isNotEmpty;
    }]subscribeNext:^(id x) {
        @strongify(self)
        if (x) {
            
            self.leftTableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
                self.rebackViewModel.request.page = self.rebackPage++;
                [self.leftTableView.mj_footer beginRefreshing];
                self.rebackViewModel.request.startRequest = YES;
            }];
            
            if (self.rebackViewModel.data.totalpage <= self.rebackPage+1) {
               [self.leftTableView.mj_footer endRefreshing];
               [self.leftTableView.mj_footer setState:MJRefreshStateNoMoreData];
                ((MJRefreshAutoNormalFooter*)self.leftTableView.mj_footer).stateLabel.text = @"";
            }else{
              [self.leftTableView.mj_footer endRefreshing];
            }
            
            [self.leftTableView reloadData];
            
        }
    }];
    
    self.rebackViewModel.request.startRequest =YES;
    
    
    self.myDynamicViewModel.request.uid = [UserModel shareInstance].uid;
    self.myDynamicViewModel.request.page = 1;
    self.myDynamicViewModel.request.token = [JPUSHService registrationID];
    
    
    [[RACObserve(self.myDynamicViewModel,data)
      filter:^BOOL(id value) {
          return self.myDynamicViewModel.data.list.isNotEmpty;
      }]subscribeNext:^(id x) {
          @strongify(self)
          if (x) {
              [self.mydynamicList addObjectsFromArray:self.myDynamicViewModel.data.list];
             
              
              self.rightTableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
                  self.mydynamicPage++;
                  self.myDynamicViewModel.request.page++;
                  [self.rightTableView.mj_footer beginRefreshing];
                  self.myDynamicViewModel.request.startRequest = YES;
              }];
              
              
              
              
              if (self.myDynamicViewModel.data.totalpage <= self.mydynamicPage+1) {
 
                  [self.rightTableView.mj_footer endRefreshing];
                  [self.rightTableView.mj_footer setState:MJRefreshStateNoMoreData];
                  ((MJRefreshAutoNormalFooter*)self.rightTableView.mj_footer).stateLabel.text = @"";
              }else{
                  [self.mydynamicList addObjectsFromArray:self.myDynamicViewModel.data.list];
                  [self.rightTableView.mj_footer endRefreshing];
              }
              [self.rightTableView reloadData];
              if ([MyDynamicModel findAll].count>0 && self.myDynamicViewModel.request.page == 1) {
                  MyDynamicModel *temp = [MyDynamicModel findAll][0];
                  MyDynamicModel *first_temp = [self.myDynamicViewModel.data.list objectAtIndex:0];
                  
                  if ([temp.msg_id isEqualToString:first_temp.msg_id]) {
                      //nothing 不变化
                      [self.redType setHidden:YES];
                  }else{
                      [self.redType setHidden:NO];
                     
                  }
              }else if([MyDynamicModel findAll].count == 0){
                  [self.redType setHidden:NO];
              }else{
                  [self.redType setHidden:YES];
              }
          }
      }];
    
    self.myDynamicViewModel.request.startRequest = YES;
    
    
    [[RACObserve(self.addCommentViewModel.request,state)
      filter:^BOOL(id value) {
          return self.addCommentViewModel.request.succeed||self.addCommentViewModel.request.failed;
      }]subscribeNext:^(id x) {
          if (x) {
              [self_weak_.sendCommentView dismiss];
              self_weak_.rebackViewModel.request.startRequest = YES;
          }else{
              
          }
      }];
}

#pragma mark tableviewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.leftTableView) {
        return 1;
    }
    
    if (tableView == self.rightTableView) {
        return 1;
    }
    
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.leftTableView) {
        if (self.rebackViewModel.data.list.count!=0) {
            [tableView dismissWithOutDataView];
            return self.rebackViewModel.data.list.count;

        }else{
            [tableView showWithOutDataViewWithTitle:@"没有收到任何消息" image:[UIImage imageNamed:@"没有消息"]];
            return 0;

        }
    }
    
    if (tableView == self.rightTableView) {
        
        if (self.myDynamicViewModel.data.list.count!=0) {
            [tableView dismissWithOutDataView];
            return self.myDynamicViewModel.data.list.count;
            
        }else{
            [tableView showWithOutDataViewWithTitle:@"没有收到任何消息" image:[UIImage imageNamed:@"没有消息"]];
            return 0;
            
        }
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        
        CommiteModel *model = self.rebackViewModel.data.list[indexPath.row];
        if (model.maxnum >2) {
            DoubleCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(DoubleCommentTableViewCell) forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setMessageModelMessageCenter:model];
            [cell setMessageModelIndex:indexPath.row];
            [cell.commite addTarget:self action:@selector(cellCommentMessage:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }else{
            DoubleSingleCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(DoubleSingleCommentTableViewCell) forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setMessageModelMessageCenter:model];
            [cell setMessageModelIndex:indexPath.row];
            [cell.commite addTarget:self action:@selector(cellCommentMessage:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
       
    }
    
    if (tableView == self.rightTableView) {
        MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(MessageTableViewCell) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setMessage:self.myDynamicViewModel.data.list[indexPath.row]];
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if ([tableView isEqual:self.rightTableView]) {
        MyDynamicModel *model = self.mydynamicList[indexPath.row];
        
        self.haveSeeViewModel.request.msg_id = model.msg_id;
        self.haveSeeViewModel.request.uid = [UserModel shareInstance].uid;
        self.haveSeeViewModel.request.token = [JPUSHService registrationID];
        self.haveSeeViewModel.request.startRequest = YES;
        
        if ([model.btype  isEqual: zimeiti]) {
        
            //文章详情
            ArtInfoViewController *controller = [[ArtInfoViewController alloc] init];
            controller.aid = model.art_id;
            controller.artType = zimeiti;
            [self.rt_navigationController pushViewController:controller animated:YES];
            
        }else  if ([model.btype isEqual: @"3"]){
            ActiveViewController*vc = [[ActiveViewController alloc]init];
            vc.urlString = @"";
            vc.titleString = model.title;
            vc.cityShow = YES;
            [self.rt_navigationController pushViewController:vc animated:YES];
        }
        else{
            //文章详情
            ArtInfoViewController *controller = [[ArtInfoViewController alloc] init];
            controller.aid = model.art_id;
            controller.artType = wenzhang;
            [self.rt_navigationController pushViewController:controller animated:YES];
        }
    }else{
         CommiteModel *model = self.rebackViewModel.data.list[indexPath.row];
        
        if ([model.type  isEqual: zimeiti]) {
            
            //文章详情
            ArtInfoViewController *controller = [[ArtInfoViewController alloc] init];
            controller.aid = model.aid;
            controller.artType = zimeiti;
            [self.rt_navigationController pushViewController:controller animated:YES];
            
        }
        else  if ([model.type isEqual: @"3"]){
            VideoViewController *controller = [[VideoViewController alloc] init];
            VideoModel *basemodel = [[VideoModel alloc] init];
            basemodel.id = model.aid;
            controller.baseModel = basemodel;
            [[Tool currentViewController].rt_navigationController pushViewController:controller animated:YES];
        }
        else{
            //文章详情
            ArtInfoViewController *controller = [[ArtInfoViewController alloc] init];
            controller.aid = model.aid;
            controller.artType = wenzhang;
            [self.rt_navigationController pushViewController:controller animated:YES];
        }
    }
}

#pragma mark 点击事件

-(void)commentSend{
    
    
    [self.rebackViewModel.data.list enumerateObjectsUsingBlock:^(CommiteModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.pid isEqualToString:self.pid]) {
            self.addCommentViewModel.request.type = obj.type;
            self.addCommentViewModel.request.aid = obj.aid;
            *stop = YES;
        }
        
    }];
    
    self.addCommentViewModel.request.pid = self.pid;
    self.addCommentViewModel.request.uid = [UserModel shareInstance].uid;
    self.addCommentViewModel.request.content = self.sendCommentView.messageTextView.text;
    

    
    self.addCommentViewModel.request.startRequest = YES;
    [self.sendCommentView dismiss];
}


///commentSend的方法是发送信息
-(void)cellCommentMessage:(UIButton *)sender{
    
    CommiteModel *model = self.rebackViewModel.data.list[sender.tag];
    
    self.sendCommentView.messageField.hidden = NO;
    self.sendCommentView.messageField.placeholder = [NSString stringWithFormat:@"回复%@的评论",model.username];
    self.pid =  model.pid;
    self.sendCommentView.hidden = NO;
    [self.sendCommentView.messageTextView becomeFirstResponder];
}

- (IBAction)leftButtonClick:(UIButton *)sender {
    self.currentpage = 0;
    if (!self.leftline.hidden) {
        return ;
    }
    
    sender.selected = !sender.selected;
    if (!sender.selected) {
        [self.leftline setHidden:YES];
    }else{
        [self.leftline setHidden:NO];
        [self hideRight];
        [self.scrollView scrollRectToVisible:self.leftTableView.frame animated:YES];
    }
}

- (IBAction)rightButtonClick:(UIButton *)sender {
     self.currentpage = 1;
    [self checkIfShowRed];
    
    if (!self.rightline.hidden) {
        return ;
    }
    
    sender.selected = !sender.selected;
    [self.redType setHidden:YES];
    if (!sender.selected) {
        [self.rightline setHidden:YES];
    }else{
        [self.rightline setHidden:NO];
        [self hideLeft];
        [self.scrollView scrollRectToVisible:self.rightTableView.frame animated:YES];
    }

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==self.scrollView) {
        NSInteger current = (self.scrollView.contentOffset.x+kwidth/2)/kwidth;
        //如果是按钮点击，则不需要再次变幻状态
        if(scrollView.decelerating && self.currentpage !=current){
            self.currentpage = current;
            if (current ==0) {
                [self leftButtonClick:self.leftButton];
            }else{
                [self rightButtonClick:self.rightButton];
            }
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 关于红色标签的设置

-(void)checkIfShowRed{
    
    if ([MyDynamicModel findAll].count>0) {
        MyDynamicModel *temp = [MyDynamicModel findAll][0];
        MyDynamicModel *first_temp = [self.myDynamicViewModel.data.list objectAtIndex:0];
        
        if ([temp.msg_id isEqualToString:first_temp.msg_id]) {
            //nothing 不变化
            [self.redType setHidden:YES];
        }else{
            [self.redType setHidden:NO];
            [MyDynamicModel deleteAll];
            [first_temp save];
        }
    }else{
        [self.redType setHidden:NO];
        MyDynamicModel *first_temp  = [self.myDynamicViewModel.data.list objectAtIndex:0];
        [first_temp save];
    }
}

#pragma mark 懒加载
-(NSMutableArray *)mydynamicList{
    if (!_mydynamicList) {
        _mydynamicList = [NSMutableArray arrayWithCapacity:1];
    }
    return _mydynamicList;
}

-(HaveSeeViewModel *)haveSeeViewModel{
    if (!_haveSeeViewModel) {
        _haveSeeViewModel = [HaveSeeViewModel SceneModel];
    }
    return _haveSeeViewModel;
}

-(ReBackViewModel *)rebackViewModel{
    if (!_rebackViewModel) {
        _rebackViewModel = [ReBackViewModel SceneModel];
    }
    return _rebackViewModel;
}

-(MyDynamicViewModel *)myDynamicViewModel{
    if (!_myDynamicViewModel) {
        _myDynamicViewModel = [MyDynamicViewModel SceneModel];
    }
    return _myDynamicViewModel;
}

-(AddCommentViewModel *)addCommentViewModel{
    if (!_addCommentViewModel) {
        _addCommentViewModel = [AddCommentViewModel SceneModel];
    }
    return _addCommentViewModel;
}

-(CommentView *)sendCommentView{
    if (!_sendCommentView) {
        _sendCommentView = [[CommentView alloc]init];

        [[UIApplication sharedApplication].keyWindow addSubview:_sendCommentView];
        [_sendCommentView.sendButton addTarget:self action:@selector(commentSend) forControlEvents:UIControlEventTouchUpInside];
        [_sendCommentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo([UIApplication sharedApplication].keyWindow);
        }];
        @weakify(self);
        [_sendCommentView dismiss:^{
            @strongify(self);
            NSString*str  = [self.sendCommentView.messageTextView.text stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
            _sendCommentView.messageField.hidden = NO;
            _sendCommentView.messageTextView.text =@"";
            [_sendCommentView.messageField becomeFirstResponder];
            //            if (str.length > 0) {
            //                self.commentField.text = [NSString stringWithFormat:@"[草稿]%@",str];
            //            }else{
            //                self.commentField.text =@"";
            //            }
            
        }];
        
        [_sendCommentView setHidden:YES];
        
    }
    return _sendCommentView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable =NO;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable =YES;
    
    self.sendCommentView = NULL;
    
    
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
