//
//  DealerDetailTableViewHeaderFooterView.m
//  chechengwang
//
//  Created by 严琪 on 17/3/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "DealerDetailTableViewHeaderFooterView.h"
#import "DealerCollectionViewCell.h"

@interface DealerDetailTableViewHeaderFooterView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *collectionView;
@end


@implementation DealerDetailTableViewHeaderFooterView

-(instancetype)init{
    if (self = [super init]) {
        
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.left.equalTo(self.mas_left).offset(15);
        }];
        
        label.textColor = BlackColor333333;
        label.font = FontOfSize(14);
        
        self.collectionView = [[UICollectionView alloc] init];
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).offset(15);
        }];
        
        self.collectionView.delegate =self;
        self.collectionView.dataSource = self;
        
        [self initCollectionView];
    }
    return self;
}

-(void)setData{
    
}

-(void)initCollectionView{
    [self.collectionView registerClass:[DealerCollectionViewCell class] forCellWithReuseIdentifier:@"DealerCollectionViewCell"];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DealerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DealerCollectionViewCell" forIndexPath:indexPath];
    
    [cell setData:@""];
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
