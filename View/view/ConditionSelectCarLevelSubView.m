//
//  ConditionSelectCarLevelSubView.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/16.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ConditionSelectCarLevelSubView.h"
#import "ConditionSelectCarNormalCollectionViewCell.h"
@interface ConditionSelectCarLevelSubView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property (copy, nonatomic) ConditionSelectCarLevelSubViewSelectFinishBlock block;
@property (copy, nonatomic) NSString* sectionKey;
@property (copy, nonatomic) NSString* rowKey;
@property (strong, nonatomic) NSArray*dataArray;
@property (strong, nonatomic) NSMutableDictionary*selectedDict;
@property (strong, nonatomic) NSDictionary*originalSelectedDict;
@end
@implementation ConditionSelectCarLevelSubView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init{
    self = [[[NSBundle mainBundle]loadNibNamed:classNameFromClass([self class]) owner:nil options:nil]firstObject];
    self.collectionView.allowsMultipleSelection = YES;
         [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ConditionSelectCarNormalCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ConditionSelectCarNormalCollectionViewCell class])];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
   
    return self;
}
-(void)showWithArray:(NSArray*)array SelectFinishBlock:(ConditionSelectCarLevelSubViewSelectFinishBlock)block selectedDict:(NSDictionary*)selectedDict sectionKey:(NSString*)sectionkey rowKey:(NSString*)rowkey{
    self.hidden = NO;
    self.sectionKey = sectionkey;
    self.rowKey = rowkey;
    self.originalSelectedDict = selectedDict;
//    if (self.selectedDict==nil) {
        self.selectedDict = [[NSMutableDictionary alloc]initWithDictionary:selectedDict];
//    }else{
//        [self.selectedDict removeAllObjects];
//        [self.selectedDict addEntriesFromDictionary:selectedDict];
//    }
   
    if (block!=_block) {
        _block = block;
    }
    self.dataArray = array;
    CGFloat height =(array.count/3 +(array.count%3==0?0:1))*(34+cellLineSpace)+cellLineSpace ;
    self.collectionViewHeightConstraint.constant =height;
    [self.collectionView reloadData];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   return self.dataArray.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
           return CGSizeMake((kwidth-4*cellInteritemSpace)/3, 34);
   
    
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
     return cellLineSpace;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
      return cellInteritemSpace;
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
              return UIEdgeInsetsMake(cellLineSpace, cellInteritemSpace, -cellLineSpace, cellInteritemSpace);
    
}



- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
               ConditionSelectCarNormalCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ConditionSelectCarNormalCollectionViewCell class]) forIndexPath:indexPath];
    
            NSDictionary*dict = self.dataArray[indexPath.row];
//    index = 9;
//    key = 9;
//    value = "不限";
    NSString*value =dict[@"value" ] ;
    id index =dict[@"index" ] ;
    id currentIndex=[self.selectedDict.allValues find:^BOOL(id obj) {
        if ([index integerValue] == [obj integerValue]) {
            return YES;
        }else{
            return NO;
        }
    }];
    if (currentIndex!=nil) {
          [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [cell setSelected:YES];
    }else{
         [collectionView deselectItemAtIndexPath:indexPath animated:NO ];
        [cell setSelected:NO];
    }
//
            //            "index": 1,
            //            "key": 1,
            //            "value": "微型车"
    
            
            [ cell.titleButton setTitle:value forState:UIControlStateNormal];
            return cell;
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary*dict = self.dataArray[indexPath.row];
    [self.selectedDict setObject:dict[@"index"] forKey:dict[@"value"]];
    
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary*dict = self.dataArray[indexPath.row];
    [self.selectedDict removeObjectForKey:dict[@"value"]];
   
}
//-(void)deselectAll{
//    
//    [self.viewModel.data enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger section, BOOL * _Nonnull stop) {
//        NSArray*list = obj[@"list"];
//        [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger row, BOOL * _Nonnull stop) {
//            NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
//            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:path];
//            cell.selected = NO;
//            //            [self.selectorPatnArray addObject:self.array[i]];//添加到选中列表
//        }];
//    }];
//}

- (IBAction)hide:(UITapGestureRecognizer *)sender {
    self.hidden = YES;
    if (self.block) {
        
        self.block(self.originalSelectedDict,self.sectionKey,self.rowKey,nil);
    }

}
- (IBAction)confirmClicked:(UIButton *)sender {
    if (self.block) {
       __block NSMutableArray*deSelectedArray = [NSMutableArray array];
        [self.originalSelectedDict.allKeys enumerateObjectsUsingBlock:^(NSString* key, NSUInteger idx, BOOL * _Nonnull stop) {
            if (self.selectedDict[key] ==nil) {
                [deSelectedArray addObject:[NSDictionary dictionaryWithObject:self.originalSelectedDict[key] forKey:key]];
            }
        }];
        
        self.block(self.selectedDict,self.sectionKey,self.rowKey,deSelectedArray);
    }
     self.hidden = YES;
}

@end
