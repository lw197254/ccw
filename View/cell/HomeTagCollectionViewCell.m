//
//  HomeTagCollectionViewCell.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/11.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "HomeTagCollectionViewCell.h"
#import "HomeTagDeleteCollectionViewCell.h"
#import "TagsViewController.h"
#import "TagsModel.h"

@interface HomeTagCollectionViewCell()

//@property(nonatomic , strong)NSArray *titlearray;

@property(nonatomic,strong)NSMutableArray<TagsModel> *dataArray;

@end

@implementation HomeTagCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UICollectionViewFlowLayout*layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 6;
    layout.minimumLineSpacing = 10;
    
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.collectionView setCollectionViewLayout:layout];
    
    [self.collectionView registerNib:nibFromClass(HomeTagDeleteCollectionViewCell) forCellWithReuseIdentifier:classNameFromClass(HomeTagDeleteCollectionViewCell)];
    
//    self.titlearray = @[@"全部",@"test",@"1",@"1",@"全部",@"test",@"1",@"1",@"test",@"1"];
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.dataArray.count>0) {
        return 1;
    }
    return 0;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    TagsModel *model = self.dataArray[indexPath.row];
    CGSize size = [self getSizeByString:model.name AndFontSize:14.0];
    return CGSizeMake(size.width+20, 60);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeTagDeleteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:classNameFromClass(HomeTagDeleteCollectionViewCell) forIndexPath:indexPath];
    
    TagsModel *model = self.dataArray[indexPath.row];
    
    [cell setTagsModel:model];
    if ([model.name isEqualToString:@"全部"]) {
        [cell.titlebutton setTitle:model.name forState:UIControlStateNormal];
        [cell.titlebutton setTitleColor:OrangeColorFF7B68 forState:UIControlStateNormal];
        
    }else{
        [cell.titlebutton setTitle:model.name forState:UIControlStateNormal];
        [cell.titlebutton setTitleColor:BlackColor666666 forState:UIControlStateNormal];
        
        
    }
    
    return cell;
}

//计算文字所占大小
- (CGSize)getSizeByString:(NSString*)string AndFontSize:(CGFloat)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(999, 25) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:FontOfSize(font)} context:nil].size;
    size.width += 20;
    return size;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}


-(NSMutableArray<TagsModel> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}

-(void)setXiHaoDataByForm:(TagsListModel *)data{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:data.userdata];
    
//    [data.hotdata enumerateObjectsUsingBlock:^(TagsModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj.showintab  isEqual: @"1"]) {
//            [self.dataArray addObject:obj];
//        }
//    }];
//
//    [data.cardata enumerateObjectsUsingBlock:^(TagsModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj.showintab  isEqual: @"1"]) {
//            [self.dataArray addObject:obj];
//        }
//    }];
//    if (self.dataArray.count>0) {
//         [self.dataArray addObject:[self buildModel]];
//    }
}

-(TagsModel *)buildModel{
    TagsModel *temp = [[TagsModel alloc] init];
    temp.name = @"全部";
    return temp;
}
- (IBAction)clickJump2Tags:(id)sender {
    TagsViewController *vc = [[TagsViewController alloc]init];
    [[Tool currentViewController].rt_navigationController pushViewController:vc animated:YES];
}

@end
