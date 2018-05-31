//
//  ListSelectView.m
//  chechengwang
//
//  Created by 刘伟 on 2017/7/4.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ListSelectView.h"
#import "InformationTypeTableViewCell.h"
#define  cellHeight 44
@interface ListSelectView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)IBOutlet UIView*view;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableviewHeightConstraint;
@property(nonatomic,strong)NSArray<NSString*>*listArray;
@property(nonatomic,strong) NSString*selectedString;
@property(nonatomic,copy) ListSelectViewItemSelectedBlock itemSlectedBlock;
@property(nonatomic,copy) ListSelectViewAnimationComplationBlock showAnimationCompletionBlock;
@property(nonatomic,copy) ListSelectViewAnimationComplationBlock disAnimationCompletionBlock;
@end
@implementation ListSelectView
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self configUI];
    }
    return self;
}


-(instancetype)init{
    if (self =[super init]) {
        [self configUI];
      
    }
    return self;
}

-(void)showWithlistArray:(NSArray<NSString *> *)listArray selectedString:(NSString *)selectedString animationComplation:(ListSelectViewAnimationComplationBlock)animationComplationFinishedBlock itemSelectedBlock:(ListSelectViewItemSelectedBlock)itemSelectBlock dismissAnimationCompletionBlock:(ListSelectViewAnimationComplationBlock)dismissAnimationCompletionBlock{
    if (self.itemSlectedBlock!=itemSelectBlock) {
        self.itemSlectedBlock = itemSelectBlock;
    }
    if (self.showAnimationCompletionBlock!=animationComplationFinishedBlock) {
        self.showAnimationCompletionBlock = animationComplationFinishedBlock;
    }
    
    if (self.hidden==NO) {
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.transform = CGAffineTransformMakeTranslation(0, -self.tableviewHeightConstraint.constant);
            
        } completion:^(BOOL finished) {
            
           
            if (self.disAnimationCompletionBlock) {
                self.disAnimationCompletionBlock(finished);
            }
            self.hidden = NO;
            self.view.hidden = NO;
            self.listArray = listArray;
            if (self.disAnimationCompletionBlock!=dismissAnimationCompletionBlock) {
                self.disAnimationCompletionBlock = dismissAnimationCompletionBlock;
            }

            self.tableviewHeightConstraint.constant = listArray.count*cellHeight;
            self.tableView.transform = CGAffineTransformMakeTranslation(0, -self.tableviewHeightConstraint.constant);
            self.selectedString = selectedString;
            [self.tableView reloadData];
            [UIView animateWithDuration:0.25 animations:^{
                self.tableView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                if (self.showAnimationCompletionBlock) {
                    self.showAnimationCompletionBlock(finished);
                }
                
            }];

        }];

    }else{
        self.hidden = NO;
        self.view.hidden = NO;
        self.listArray = listArray;
        if (self.disAnimationCompletionBlock!=dismissAnimationCompletionBlock) {
            self.disAnimationCompletionBlock = dismissAnimationCompletionBlock;
        }

        self.tableviewHeightConstraint.constant = listArray.count*cellHeight;
        self.tableView.transform = CGAffineTransformMakeTranslation(0, -self.tableviewHeightConstraint.constant);
        self.selectedString = selectedString;
        [self.tableView reloadData];
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (self.showAnimationCompletionBlock) {
                self.showAnimationCompletionBlock(finished);
            }
            
        }];

    }
   }
-(void)configUI{
   [[NSBundle mainBundle]loadNibNamed:classNameFromClass([self class]) owner:self options:nil] ;
    [self addSubview:self.view];
    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.hidden = YES;
    self.tableView.transform = CGAffineTransformMakeTranslation(0, -self.tableviewHeightConstraint.constant);
   self.view.layer.masksToBounds = YES;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:nibFromClass(InformationTypeTableViewCell) forCellReuseIdentifier:classNameFromClass(InformationTypeTableViewCell)];
}
-(void)dismissWithAnimationComplation:(ListSelectViewAnimationComplationBlock)animationComplationFinishedBlock{
    if (self.disAnimationCompletionBlock!=animationComplationFinishedBlock) {
        self.disAnimationCompletionBlock = animationComplationFinishedBlock;
    }
    [self dismiss:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)dismiss:(UITapGestureRecognizer *)sender {
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.transform = CGAffineTransformMakeTranslation(0, -self.tableviewHeightConstraint.constant);
        
    } completion:^(BOOL finished) {
        
        self.view.hidden = YES;
        self.hidden = YES;
        if (self.disAnimationCompletionBlock) {
            self.disAnimationCompletionBlock(finished);
        }
    }];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InformationTypeTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(InformationTypeTableViewCell) forIndexPath:indexPath];
    NSString*title =self.listArray[indexPath.row] ;
    
    [cell.titleButton setTitle:title forState:UIControlStateNormal];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([title isEqual:self.selectedString]) {
       
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
         cell.selected = YES;
        //        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString*title =self.listArray[indexPath.row] ;
    
    
    
    self.selectedString = title;
    if (self.itemSlectedBlock) {
        self.itemSlectedBlock(indexPath.row,self.selectedString);
    }
    [self dismiss:nil];
}


@end
