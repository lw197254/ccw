//
//  KouBeiPaiHangView.m
//  chechengwang
//
//  Created by 严琪 on 2017/10/19.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "KouBeiPaiHangView.h"
#import "KouBeiPaiHangButtonView.h"

@interface KouBeiPaiHangView()
@property(nonatomic,strong)NSArray *listArray;

@property(nonatomic,strong)NSArray *kbArray;


@property (weak, nonatomic) IBOutlet UIView *view;
@end

@implementation KouBeiPaiHangView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    
        [[NSBundle mainBundle]loadNibNamed:classNameFromClass([self class]) owner:self options:nil];
        [self addSubview:self.view];
        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.selectListView.delegate =self;
        self.selectListView.dataSource = self;
        self.selectListView.selectionIndicatorStyle = HTHorizontalSelectionIndicatorStyleNone;
        self.selectListView.maxShowCount = 6;
        self.selectListView.minShowCount = 6;
        
        [self initSelectionList];
        [self.selectListView reloadData];
        [self setTopLine];
    }
    return self;
}



////初始化首页按钮数据
-(void)initSelectionList{
    self.listArray = @[
                       @{@"name":@"油耗",@"value":@"4"},@{@"name":@"空间",@"value":@"1"}
                        ,@{@"name":@"动力",@"value":@"2"}
                       ,@{@"name":@"外观",@"value":@"5"}
                       ,@{@"name":@"舒适性",@"value":@"7"}
                       ,@{@"name":@"性价比",@"value":@"8"}];
    
    self.kbArray = @[@"kb_ck",@"kb_kj",@"kb_dl",@"kb_wg",@"kb_ssx",@"kb_xjb"];
}

-(NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList{
    return self.listArray.count;
}

-(UIView *)selectionList:(HTHorizontalSelectionList *)selectionList viewForItemWithIndex:(NSInteger)index{
    KouBeiPaiHangButtonView *view = [[KouBeiPaiHangButtonView alloc] initWithFrame:CGRectMake(0, 0, kwidth/6, 150)];
    view.score.text = self.listArray[index][@"name"];
    
    switch (index) {
        case 0:
        {
            KouBeiSerieskBBaseData *data = self.seriseKB.kb_ck;
            KouBeiSerieskBBaseData *dataleft = self.seriseModelKB.kb_ck;
            view.name.text = [NSString stringWithFormat:@"%@分",data.score];
            
            [view.leftview mas_updateConstraints:^(MASConstraintMaker *make) {
                
                int height = [dataleft.score floatValue]*20;
                
                make.height.mas_offset(height);
                if (height == 0) {
                    [view.leftspareView setHidden:YES];
                }
              
            }];
            
            
            [view.rightview mas_updateConstraints:^(MASConstraintMaker *make) {
                int height = [data.score floatValue]*20;
                
                make.height.mas_offset(height);
                
                if (height == 0) {
                    [view.rightspareView setHidden:YES];
                }
            }];
 
            
        }
            break;
        case 1:
        {
            KouBeiSerieskBBaseData *data = self.seriseKB.kb_kj;
            KouBeiSerieskBBaseData *dataleft = self.seriseModelKB.kb_kj;
               view.name.text = [NSString stringWithFormat:@"%@分",data.score];
            [view.leftview mas_updateConstraints:^(MASConstraintMaker *make) {
                int height = [dataleft.score floatValue]*20;
                
                make.height.mas_offset(height);
                if (height == 0) {
                    [view.leftspareView setHidden:YES];
                }
            }];
            
            
            [view.rightview mas_updateConstraints:^(MASConstraintMaker *make) {
                int height = [data.score floatValue]*20;
                
                make.height.mas_offset(height);
                
                if (height == 0) {
                    [view.rightspareView setHidden:YES];
                }
            }];
        }
            break;
        case 2:
        {
            KouBeiSerieskBBaseData *data = self.seriseKB.kb_dl;
            KouBeiSerieskBBaseData *dataleft = self.seriseModelKB.kb_dl;
                view.name.text = [NSString stringWithFormat:@"%@分",data.score];
            [view.leftview mas_updateConstraints:^(MASConstraintMaker *make) {
                int height = [dataleft.score floatValue]*20;
                
                make.height.mas_offset(height);
                if (height == 0) {
                    [view.leftspareView setHidden:YES];
                }
            }];
            
            
            [view.rightview mas_updateConstraints:^(MASConstraintMaker *make) {
                int height = [data.score floatValue]*20;
                
                make.height.mas_offset(height);
                
                if (height == 0) {
                    [view.rightspareView setHidden:YES];
                }
            }];
        }
            break;
        case 3:
        {
            KouBeiSerieskBBaseData *data = self.seriseKB.kb_wg;
            KouBeiSerieskBBaseData *dataleft = self.seriseModelKB.kb_wg;
               view.name.text = [NSString stringWithFormat:@"%@分",data.score];
            [view.leftview mas_updateConstraints:^(MASConstraintMaker *make) {
                int height = [dataleft.score floatValue]*20;
                
                make.height.mas_offset(height);
                if (height == 0) {
                    [view.leftspareView setHidden:YES];
                }
            }];
            
            
            [view.rightview mas_updateConstraints:^(MASConstraintMaker *make) {
                int height = [data.score floatValue]*20;
                
                make.height.mas_offset(height);
                
                if (height == 0) {
                    [view.rightspareView setHidden:YES];
                }
            }];
        }
            break;
        case 4:
        {
            KouBeiSerieskBBaseData *data = self.seriseKB.kb_ssx;
            KouBeiSerieskBBaseData *dataleft = self.seriseModelKB.kb_ssx;
                view.name.text = [NSString stringWithFormat:@"%@分",data.score];
            [view.leftview mas_updateConstraints:^(MASConstraintMaker *make) {
                int height = [dataleft.score floatValue]*20;
                
                make.height.mas_offset(height);
                if (height == 0) {
                    [view.leftspareView setHidden:YES];
                }
            }];
            
            
            [view.rightview mas_updateConstraints:^(MASConstraintMaker *make) {
                int height = [data.score floatValue] *20;
                make.height.mas_offset(height);
                
                if (height == 0) {
                    [view.rightspareView setHidden:YES];
                }
            }];
        }
            break;
        case 5:
        {
            KouBeiSerieskBBaseData *data = self.seriseKB.kb_xjb;
            KouBeiSerieskBBaseData *dataleft = self.seriseModelKB.kb_xjb;
                view.name.text = [NSString stringWithFormat:@"%@分",data.score];
            [view.leftview mas_updateConstraints:^(MASConstraintMaker *make) {
                int height = [dataleft.score floatValue]*20;
                make.height.mas_offset(height);
                if (height == 0) {
                    [view.leftspareView setHidden:YES];
                }
            }];
            
            
            [view.rightview mas_updateConstraints:^(MASConstraintMaker *make) {
                int height = [data.score floatValue]*20;
                make.height.mas_offset(height);
                
                if (height == 0) {
                    [view.rightspareView setHidden:YES];
                }
            }];
        }
            break;
        default:
            break;
    }
    return view;
}

 
@end
