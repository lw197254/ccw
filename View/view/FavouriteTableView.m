//
//  FavouriteTableView.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/13.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FavouriteTableView.h"
#import "FavouriteTableViewCell.h"

#import "KouBeiCarDeptModel.h"
#import "KouBeiCarTypeModel.h"
#import "KouBeiDBModel.h"
#import "KouBeiArtModel.h"

#import "CarDeptViewController.h"
#import "PublicPraiseDetailViewController.h"
#import "CarTypeDetailViewController.h"
#import "VideoViewController.h"

//车系
#import "RelateCarTableViewCell.h"
#import "CheXiSCTableViewCell.h"
//车型
#import "KouBeiCarTypeTableViewCell.h"
//口碑
#import "KouBeiTableViewCell.h"
//文章
#import "ArtTableViewCell.h"
#import "ArtZiMeiTiTableViewCell.h"
#import "ArtInfoViewController.h"
#import "PicShowModel.h"

#import "VideoModel.h"


@interface FavouriteTableView ()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong)NSMutableDictionary *deleteDict;

@property(nonatomic,strong)NSArray *dataArray;

@end


@implementation FavouriteTableView
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.backgroundColor = [UIColor whiteColor];
//        self.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [self registerNib:[UINib nibWithNibName:@"KouBeiCarTypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"KouBeiCarTypeTableViewCell"];
        
        [self registerNib:[UINib nibWithNibName:@"CheXiSCTableViewCell" bundle:nil] forCellReuseIdentifier:@"CheXiSCTableViewCell"];
        
        [self registerNib:[UINib nibWithNibName:@"ArtTableViewCell" bundle:nil] forCellReuseIdentifier:@"ArtTableViewCell"];
        
         [self registerNib:[UINib nibWithNibName:@"KouBeiTableViewCell" bundle:nil] forCellReuseIdentifier:@"KouBeiTableViewCell"];
        
        [self registerNib:nibFromClass(ArtZiMeiTiTableViewCell) forCellReuseIdentifier:classNameFromClass(ArtZiMeiTiTableViewCell)];
        
        self.edited =NO;
        self.allowsMultipleSelection =NO;
        
        //self.deleteDict = [NSMutableDictionary dictionaryWithCapacity:5];
        self.deleteDict = [[NSMutableDictionary alloc] init];
   
    }
    return self;
}
 

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([self getShouCanCout] > 0) {
        return 0.0001;
    }
    return 0.0001;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   
    if ([self getShouCanCout] ==0) {
        [self showWithOutDataViewWithTitle:@"暂无收藏" image:[UIImage imageNamed:@"暂无收藏"]];
    }else{
        [self dismissWithOutDataView];
        return [self getShouCanCout];
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
    
}
-(void)setType:(FavouriteType)type{
    if (_type!=type) {
        _type = type;
        
    }
    [self reloadSelfData];
}

///从本地读取数据
-(void)reloadSelfData{
    switch (self.type) {
        case FavouriteTypeCarSeries:
        {
            self.dataArray = [[KouBeiCarDeptModel findAll ] reverseObjectEnumerator].allObjects ;
        }
            break;
        case FavouriteTypeCarType:
        {
           
           self.dataArray = [[KouBeiCarTypeModel findAll]reverseObjectEnumerator].allObjects;
        }
            break;
        case FavouriteTypeKoubei:
        {
           
           self.dataArray =[[KouBeiDBModel findAll]reverseObjectEnumerator].allObjects;
        }
            break;
        case FavouriteTypeArticle:
        {
           
           self.dataArray = [[KouBeiArtModel findAll]reverseObjectEnumerator].allObjects;
        }
            break;
        default:
            break;
    }
    

}
-(NSInteger)getShouCanCout{
    
    return self.dataArray.count;
    
    }


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger count = indexPath.row;
    switch (self.type) {
        case FavouriteTypeCarSeries:
        {
            
            NSArray* reversedArray =  self.dataArray;
            
            KouBeiCarDeptModel *model =reversedArray[count];
            
            CheXiSCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheXiSCTableViewCell" forIndexPath:indexPath];
            [cell.img setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"默认图片80_60.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.title.text = model.name;
            cell.price.text = model.zhidaoPrice;
            cell.factory.text = @"厂商指导价";
            
            if (self.edited) {
                cell.showSelectButton  = YES;
            }else{
                cell.showSelectButton = NO;
            }

            return  cell;
            
        }
            break;
        case FavouriteTypeCarType:
        {
            
            
            NSArray* reversedArray =  self.dataArray;
            
            KouBeiCarTypeModel *model =reversedArray[count];
            
            KouBeiCarTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KouBeiCarTypeTableViewCell" forIndexPath:indexPath];
            //cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.image setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"默认图片80_60.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.cardept.text = model.typeName;
            cell.title.text = model.name;
            if ([model.zhidaoPrice isNotEmpty]) {
                if([model.zhidaoPrice isEqualToString:@"0.00"]){
                    cell.price.text = @"";
                    cell.factory.text = @"暂无报价";
                }else{
                cell.price.text = [model.zhidaoPrice stringByAppendingString:@"万"];
                cell.factory.text = @"厂商指导价:";
                }
            }else{
                 cell.price.text = @"";
                cell.factory.text = @"暂无报价";
            }
            
            
            
            if (self.edited) {
                cell.showSelectButton  = YES;
            }else{
                cell.showSelectButton = NO;
            }
            
            return  cell;

        }
            break;
        case FavouriteTypeKoubei:
        {
            
            
            NSArray* reversedArray =  self.dataArray;
            
            KouBeiDBModel *model =reversedArray[count];
            
            KouBeiTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:classNameFromClass(KouBeiTableViewCell) forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            cell.title.text = model.title;
            cell.views.text = model.click;
            cell.time.text =model.addtime;
    
            if (self.edited) {
                cell.showSelectButton  = YES;
            }else{
                cell.showSelectButton = NO;
            }
            
            return  cell;
        }
            break;
        case FavouriteTypeArticle:
        {

            NSArray* reversedArray =  self.dataArray;
            
            KouBeiArtModel *model =reversedArray[count];
            
            
//            if([model.arttype isEqualToString:zimeiti]){
                ArtZiMeiTiTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"ArtZiMeiTiTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [cell.image setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"默认图片105_80.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                if (self.edited) {
                    cell.showSelectButton  = YES;
                }else{
                    cell.showSelectButton = NO;
                }
                
                
                cell.title.text = model.title;
                cell.views.text = model.authorName;
            
                cell.time.text =[NSString stringWithFormat:@"%@人阅读",model.click];
                
                return cell;
//            }else{
//                
//                ArtTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"ArtTableViewCell" forIndexPath:indexPath];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                
//                [cell.image setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"默认图片105_80.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                
//                cell.title.text = model.name;
//                cell.views.text = model.views;
//                cell.time.text =model.time;
//                
//                if (self.edited) {
//                    cell.showSelectButton  = YES;
//                }else{
//                    cell.showSelectButton = NO;
//                }
//                
//                return cell;
//            }

            
        }
            break;
        default:
              return nil;
            break;
    }
  
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger count = indexPath.row;
    if (self.block) {
        [self.deleteDict removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)count]];
         self.block(self.deleteDict);
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger count = indexPath.row;
    
    if(!self.edited){
    switch (self.type) {
        case FavouriteTypeCarSeries:
        {
            KouBeiCarDeptModel *model =  [[KouBeiCarDeptModel findAll ]reverseObjectEnumerator].allObjects[count];
         
            CarDeptViewController *vc = [[CarDeptViewController alloc]init];
            vc.picture  = model.imgurl;
            vc.chexiid = model.colId;
            [URLNavigation pushViewController:vc animated:YES];
        }
            break;
        case FavouriteTypeCarType:
        {
            KouBeiCarTypeModel *model =  [[KouBeiCarTypeModel findAll ] reverseObjectEnumerator].allObjects[count];
            CarTypeDetailViewController *controller =[[CarTypeDetailViewController alloc] init];
            controller.chexingId = model.colId;
            [URLNavigation pushViewController:controller animated:YES];
        }
            break;
        case FavouriteTypeKoubei:
        {
            KouBeiDBModel *model = [[KouBeiDBModel findAll ] reverseObjectEnumerator].allObjects[count];
            PublicPraiseDetailViewController *controller = [[PublicPraiseDetailViewController alloc] init];
            controller.koubeiId = model.colId;
            controller.views = model.click ;
            [URLNavigation pushViewController:controller animated:YES];
        }
            break;
        case FavouriteTypeArticle:
        {
            KouBeiArtModel *model =  [[KouBeiArtModel findAll ] reverseObjectEnumerator].allObjects[count];
            //文章详情
            if ([model.artType isEqualToString:@"2"]) {
                ArtInfoViewController *controller = [[ArtInfoViewController alloc] init];
                controller.aid = model.colId;
                controller.artType= zimeiti;
                [[Tool currentViewController].rt_navigationController pushViewController:controller animated:YES];
            }else if ([model.artType isEqualToString:@"1"]){
                ArtInfoViewController *controller = [[ArtInfoViewController alloc] init];
                controller.aid = model.colId;
                controller.artType= wenzhang;
                [[Tool currentViewController].rt_navigationController pushViewController:controller animated:YES];
            }else{
                VideoViewController *controller = [[VideoViewController alloc] init];
                VideoModel *basemodel = [[VideoModel alloc] init];
                basemodel.id = model.colId;
                controller.baseModel = basemodel;
                 [[Tool currentViewController].rt_navigationController pushViewController:controller animated:YES];
            }

        }
            break;
        default:
            break;
        }
    }else{
       //删除传入对像的id
        NSString *deleteid;
        switch (self.type) {
            case FavouriteTypeCarSeries:
            {
                KouBeiCarDeptModel *model =  self.dataArray[count];
                deleteid= model.id;
            }
                break;
            case FavouriteTypeCarType:
            {
                KouBeiCarTypeModel *model = self.dataArray[count];
                deleteid= model.id;
            }
                break;
            case FavouriteTypeKoubei:
            {
                KouBeiDBModel *model =  self.dataArray[count];
                deleteid= model.id;
            }
                break;
            case FavouriteTypeArticle:
            {
                KouBeiArtModel *model =  self.dataArray[count];
                deleteid= model.id;
            }
                break;
            default:
                break;
        }
        
        if (self.block) {
            [self.deleteDict setValue:deleteid forKey:[NSString stringWithFormat:@"%ld",(long)count]];
            self.block(self.deleteDict);
        }
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kwidth, 1)];
   
   
    view.backgroundColor =  BlackColorE3E3E3;
    return view;
    
}

-(void)selectStatus{
    if(self.selectedAll){
    for (int row=0; row<[self getShouCanCout]; row++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [self selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        //删除传入对像的id
        NSString *deleteid;
        switch (self.type) {
            case 0:
            {
                KouBeiCarDeptModel *model = self.dataArray[row];
                deleteid= model.id;
            }
                break;
            case 1:
            {
                KouBeiCarTypeModel *model =  self.dataArray[row];
                deleteid= model.id;
            }
                break;
            case 2:
            {
                KouBeiDBModel *model =  self.dataArray[row];
                deleteid= model.id;
            }
                break;
            case 3:
            {
                KouBeiArtModel *model =   self.dataArray[row];
                deleteid= model.id;
            }
                break;
            default:
                break;
        }
        
        if (self.block) {
            [self.deleteDict setValue:deleteid forKey:[NSString stringWithFormat:@"%ld",(long)row]];
        }

    }
    }else{
        [self.deleteDict removeAllObjects];
        for (int row=0; row<[self getShouCanCout]; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
            [cell setSelected:NO];
        }
    }
    
    if (self.block) {
        self.block(self.deleteDict);
    }
    
}

-(void)buildReload{
    [self reloadSelfData];
    [self reloadData];
}

@end
