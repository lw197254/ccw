//
//  TagsViewController.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/11.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "TagsViewController.h"

#import "TagsSelected.h"
#import "TagsViewModel.h"
#import "TagsListModel.h"

//登录前提下的调用
#import "XiHaoUserViewModel.h"
#import "XiHaoUserModel.h"
#import "XiHaoClickViewModel.h"
#import "XiHaoUserCheckTagsViewModel.h"
@interface TagsViewController ()

@property (weak, nonatomic) IBOutlet UIView *fatherView;

@property(nonatomic,strong)TagsViewModel *viewModel;
@property(nonatomic,strong)TagsViewModel *getAllTagsViewModel;
@property(nonatomic,strong)TagsSelected *tagsView;

@property(nonatomic,strong)TagsListModel *baseModel;

//登录前提下的调用
@property(nonatomic,strong)XiHaoUserViewModel *userViewModel;
@property(nonatomic,strong)XiHaoUserModel *userBaseModel;
@property(nonatomic,strong)XiHaoClickViewModel *clickViewModel;
@property(nonatomic,strong)XiHaoUserCheckTagsViewModel *tagViewModel;

@end

@implementation TagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"我的喜好"];
    
    NSString *uid = [UserModel shareInstance].uid;
    if ([uid isNotEmpty]) {
        self.userViewModel.request.uid = uid;
        self.userViewModel.request.startRequest = YES;
        self.getAllTagsViewModel.request.startRequest = YES;
    }else{
        self.viewModel.request.startRequest = YES;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[UserModel shareInstance].uid isNotEmpty]) {
    }else{
        self.clickViewModel.request.name = [XiHaoClickObject getnames];
        self.clickViewModel.request.startRequest = YES;
    }

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self buildTagsBaseModel];
    
    if ([[UserModel shareInstance].uid isNotEmpty]) {
        self.tagViewModel.request.uid = [UserModel shareInstance].uid;
        
        NSArray *temparray = [TagsModel findAll];
        
        NSMutableArray *ids = [NSMutableArray arrayWithCapacity:1];
        
        [temparray enumerateObjectsUsingBlock:^(TagsModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [ids addObject:obj.id];
        }];
        
        self.tagViewModel.request.tags = [ids componentsJoinedByString:@","];
        self.tagViewModel.request.startRequest = YES;
    }
    
     [UserSelectedTool shareInstance].isChangeTags = YES;
}

#pragma 功能
//登录前提下重新组合数据
-(TagsListModel *)buildTagsListModel:(XiHaoUserModel *)model{
    
    TagsListModel *temp = [[TagsListModel alloc] init];
    
    [temp.userdata addObjectsFromArray:model.searchtags];
    [temp.userdata addObjectsFromArray:model.checkedtags];
    
    [temp.hotdata addObjectsFromArray:model.group2tags];
    [temp.cardata addObjectsFromArray:model.group1tags];
    
    //删除重新写入文件
    [XiHaoClickObject deletAll];
    
    
    [temp.userdata enumerateObjectsUsingBlock:^(TagsModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
         [XiHaoClickObject addname:obj.name];
    }];
    
    return temp;
}

-(NSMutableArray *)buildTagsBaseModel{
    NSArray *temp = [[XiHaoClickObject getnames]  componentsSeparatedByString:@","];
    
    NSMutableArray *pushArray = [NSMutableArray arrayWithCapacity:1];
    if ([TagsModel findAll].count) {
        [TagsModel deleteAll];
    }
    
    [self.baseModel.data enumerateObjectsUsingBlock:^(TagsModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [temp enumerateObjectsUsingBlock:^(NSString *nsobj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.name isEqualToString:nsobj]) {
                [pushArray addObject:obj];
                [obj save];
                *stop = YES;
            }
        }];
    }];
 
    
    return pushArray;
}


#pragma 懒加载

-(XiHaoUserViewModel *)userViewModel{
    if (!_userViewModel) {
        _userViewModel = [XiHaoUserViewModel SceneModel];
        
        [[RACObserve(_userViewModel, data)filter:^BOOL(id value) {
            return _userViewModel.data.isNotEmpty;
        }]subscribeNext:^(id x) {
            if (x) {
                self.userBaseModel = _userViewModel.data;
                self.tagsView.baseModel = [self buildTagsListModel:self.userBaseModel];
                [self.tagsView.tableView reloadData];
            }
        }];
        
    }
    return _userViewModel;
}

-(TagsSelected *)tagsView{
    if (!_tagsView) {
        _tagsView = [[TagsSelected alloc] init];
        [self.fatherView addSubview:_tagsView];
        
        [_tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.fatherView);
        }];
    }
    return _tagsView;
}

//用户登录后需要上传的标签
-(TagsViewModel *)getAllTagsViewModel{
    if (!_getAllTagsViewModel) {
        _getAllTagsViewModel = [TagsViewModel SceneModel];
        [[RACObserve(_getAllTagsViewModel, data)filter:^BOOL(id value) {
            return _getAllTagsViewModel.data.isNotEmpty;
        }]subscribeNext:^(id x) {
            if (x) {
                self.baseModel = _getAllTagsViewModel.data;
            }
        }];
    }
    return _getAllTagsViewModel;
}

//用户未登录需要上传标签
-(TagsViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [TagsViewModel SceneModel];
        [[RACObserve(_viewModel, data)filter:^BOOL(id value) {
            return _viewModel.data.isNotEmpty;
        }]subscribeNext:^(id x) {
            if (x) {
                self.baseModel = _viewModel.data;
                [self.baseModel sethotandcar];
                self.tagsView.baseModel = self.baseModel;
                
                [self.tagsView rebuildbaseData];
                [self.tagsView.tableView reloadData];
            }
        }];
    }
    return _viewModel;
}


-(XiHaoClickViewModel *)clickViewModel{
    if (!_clickViewModel) {
        _clickViewModel = [XiHaoClickViewModel SceneModel];
    }
    return _clickViewModel;
    
}

-(XiHaoUserCheckTagsViewModel *)tagViewModel{
    if (!_tagViewModel) {
        _tagViewModel = [XiHaoUserCheckTagsViewModel SceneModel];
        
        [[RACObserve(_tagViewModel.request,state) filter:^BOOL(id value) {
            return _tagViewModel.request.succeed;
        }]subscribeNext:^(id x) {
            if (x) {
                [TagsModel deleteAll];
            }
        }];
         
    }
    return _tagViewModel;
}

@end
