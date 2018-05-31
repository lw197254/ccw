//
//  BrowseUITableView.m
//  chechengwang
//
//  Created by 严琪 on 17/1/18.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "BrowseUITableView.h"


#import "BrowseKouBeiCarDeptModel.h"
#import "BrowseKouBeiCarTypeModel.h"
#import "BrowseKouBeiDBModel.h"
#import "BrowseKouBeiArtModel.h"


#import "CarDeptViewController.h"
#import "ArtInfoViewController.h"
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

#import "PicShowModel.h"

#import "VideoModel.h"

@interface BrowseUITableView ()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong)NSMutableDictionary *deleteArray;

@end

@implementation BrowseUITableView
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        
        self.delegate = self;
        self.dataSource = self;
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self registerNib:[UINib nibWithNibName:@"KouBeiCarTypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"KouBeiCarTypeTableViewCell"];
        
        [self registerNib:[UINib nibWithNibName:@"CheXiSCTableViewCell" bundle:nil] forCellReuseIdentifier:@"CheXiSCTableViewCell"];
        
        [self registerNib:[UINib nibWithNibName:@"ArtTableViewCell" bundle:nil] forCellReuseIdentifier:@"ArtTableViewCell"];
        
        [self registerNib:[UINib nibWithNibName:@"KouBeiTableViewCell" bundle:nil] forCellReuseIdentifier:@"KouBeiTableViewCell"];
        
        [self registerNib:nibFromClass(ArtZiMeiTiTableViewCell) forCellReuseIdentifier:classNameFromClass(ArtZiMeiTiTableViewCell)];
        
        self.edited =NO;
        self.allowsMultipleSelection =NO;
        
        //self.deleteArray = [NSMutableDictionary dictionaryWithCapacity:5];
        self.deleteArray = [[NSMutableDictionary alloc] init];
    }
    return self;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([self getShouCanCout] > 0) {
        return 1;
    }
    return 0.000001;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    if ([self getShouCanCout] ==0) {
        [self showWithOutDataViewWithTitle:@"暂无浏览记录"];
    }else{
        [self dismissWithOutDataView];
        return [self getShouCanCout];
    }

    return [self getShouCanCout];
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}


-(NSInteger)getShouCanCout{
    switch (self.type) {
        case 0:
        {
            NSArray *re = [BrowseKouBeiCarDeptModel findAll];
            return re.count;
        }
            break;
        case 1:
        {
            return [BrowseKouBeiCarTypeModel findAll].count;
        }
            break;
        case 2:
        {
            return [BrowseKouBeiDBModel findAll].count;
        }
            break;
        case 3:
        {
            return [BrowseKouBeiArtModel findAll].count;
        }
            break;
        default:
            break;
    }
    return 0;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger count = indexPath.row;
    switch (self.type) {
        case 0:
        {
            NSArray* reversedArray = [[ [BrowseKouBeiCarDeptModel findAll] reverseObjectEnumerator] allObjects];
            
            BrowseKouBeiCarDeptModel *model =reversedArray[count];
            
            CheXiSCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheXiSCTableViewCell" forIndexPath:indexPath];
            [cell.img setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"默认图片80_60.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.title.text = model.name;
        
            cell.price.text = model.price;
            self.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
            cell.factory.text = @"厂商指导价";
            
            if (self.edited) {
                cell.showSelectButton  = YES;
            }else{
                cell.showSelectButton = NO;
            }
            
            return  cell;
            
        }
            break;
        case 1:
        {
            
            
            NSArray* reversedArray = [[ [BrowseKouBeiCarTypeModel findAll] reverseObjectEnumerator] allObjects];
            
            BrowseKouBeiCarTypeModel *model =reversedArray[count];
            
            KouBeiCarTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KouBeiCarTypeTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.image setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"默认图片80_60.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            cell.cardept.text = model.typeName;
            cell.title.text = model.name;
            if ([model.price isNotEmpty]) {
                if ([model.price isEqualToString:@"0.00"]) {
                    cell.price.text = @"";
                    cell.factory.text = @"暂无报价";
                }else{
                cell.price.text = [model.price stringByAppendingString:@"万"];
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
        case 2:
        {
            
            NSArray* reversedArray = [[ [BrowseKouBeiDBModel findAll] reverseObjectEnumerator] allObjects];
            
            BrowseKouBeiDBModel *model =reversedArray[count];
            
            KouBeiTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:classNameFromClass(KouBeiTableViewCell) forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.title.text = model.name;
            cell.views.text = model.views;
            cell.time.text =model.time;
            
            if (self.edited) {
                cell.showSelectButton  = YES;
            }else{
                cell.showSelectButton = NO;
            }
            
            return  cell;
        }
            break;
        case 3:
        {
            
            NSArray* reversedArray = [[ [BrowseKouBeiArtModel findAll] reverseObjectEnumerator] allObjects];
            
            BrowseKouBeiArtModel *model =reversedArray[count];
            
//            if([model.arttype isEqualToString:zimeiti]){
                ArtZiMeiTiTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"ArtZiMeiTiTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [cell.image setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"默认图片105_80.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                if (self.edited) {
                    cell.showSelectButton  = YES;
                }else{
                    cell.showSelectButton = NO;
                }
                
                
                cell.title.text = model.name;
               if ([model.authorName isNotEmpty]) {
                cell.views.text = model.authorName;
              }else{
                cell.views.text = @"车城网";
            }
            
                cell.time.text =[NSString stringWithFormat:@"%@人阅读",model.views];
                
                return cell;
//            }else{
//                
//                ArtTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"ArtTableViewCell" forIndexPath:indexPath];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                
//                [cell.image setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"默认图片105_80.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//                
//                if (self.edited) {
//                    cell.showSelectButton  = YES;
//                }else{
//                    cell.showSelectButton = NO;
//                }
//                
//               
//                cell.title.text = model.name;
//                cell.views.text = model.views;
//                cell.time.text =model.time;
//                
//                 return cell;
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
        [self.deleteArray removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)count]];
        self.block(self.deleteArray);
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger count = indexPath.row;
    
    if(!self.edited){
        switch (self.type) {
            case 0:
            {
                BrowseKouBeiCarDeptModel *model =  [[BrowseKouBeiCarDeptModel findAll ] reverseObjectEnumerator].allObjects[count];
                
                CarDeptViewController *vc = [[CarDeptViewController alloc]init];
                vc.picture  = model.pic;
                vc.chexiid = model.id;
                [URLNavigation pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {
                BrowseKouBeiCarTypeModel *model =  [[BrowseKouBeiCarTypeModel findAll ] reverseObjectEnumerator].allObjects[count];
                CarTypeDetailViewController *controller =[[CarTypeDetailViewController alloc] init];
                controller.chexingId = model.id;
                
                [URLNavigation pushViewController:controller animated:YES];
            }
                break;
            case 2:
            {
                BrowseKouBeiDBModel *model = [[BrowseKouBeiDBModel findAll ] reverseObjectEnumerator].allObjects[count];
                PublicPraiseDetailViewController *controller = [[PublicPraiseDetailViewController alloc] init];
                controller.koubeiId = model.id;
                controller.views = model.views;
                [URLNavigation pushViewController:controller animated:YES];
            }
                break;
            case 3:
            {
                BrowseKouBeiArtModel *model =  [[BrowseKouBeiArtModel findAll ] reverseObjectEnumerator].allObjects[count];
                //文章详情
                if ([model.arttype isEqualToString:@"2"]) {
                    ArtInfoViewController *controller = [[ArtInfoViewController alloc] init];
                    controller.aid = model.id;
                    controller.artType = zimeiti;
                    [URLNavigation pushViewController:controller animated:YES];
                }else if ([model.arttype isEqualToString:@"1"]){
                    ArtInfoViewController *controller = [[ArtInfoViewController alloc] init];
                    controller.aid = model.id;
                    controller.artType= wenzhang;
                    [[Tool currentViewController].rt_navigationController pushViewController:controller animated:YES];
                }else{
                    VideoViewController *controller = [[VideoViewController alloc] init];
                    VideoModel *basemodel = [[VideoModel alloc] init];
                    basemodel.id = model.id;
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
            case 0:
            {
                BrowseKouBeiCarDeptModel *model =   [[BrowseKouBeiCarDeptModel findAll ] reverseObjectEnumerator].allObjects[count];
                deleteid= model.id;
            }
                break;
            case 1:
            {
                BrowseKouBeiCarTypeModel *model =   [[BrowseKouBeiCarTypeModel findAll ] reverseObjectEnumerator].allObjects[count];
                deleteid= model.id;
            }
                break;
            case 2:
            {
                BrowseKouBeiDBModel *model =   [[BrowseKouBeiDBModel findAll ] reverseObjectEnumerator].allObjects[count];
                deleteid= model.id;
            }
                break;
            case 3:
            {
                BrowseKouBeiArtModel *model =   [[BrowseKouBeiArtModel findAll ] reverseObjectEnumerator].allObjects[count];
                deleteid= model.id;
            }
                break;
            default:
                break;
        }
        
        if (self.block) {
            [self.deleteArray setValue:deleteid forKey:[NSString stringWithFormat:@"%ld",(long)count]];
            self.block(self.deleteArray);
        }
    }
}
-(void)setType:(NSInteger)type{
    if (_type != type) {
        _type = type;
        if ([self getShouCanCout]==0) {
            [self showWithOutDataViewWithTitle:@"暂无浏览记录"];
            
        }else{
            [self dismissWithOutDataView];
        }

    }
    
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
                    BrowseKouBeiCarDeptModel *model =  [[BrowseKouBeiCarDeptModel findAll]reverseObjectEnumerator].allObjects[row];
                    deleteid= model.id;
                }
                    break;
                case 1:
                {
                    BrowseKouBeiCarTypeModel *model =   [[BrowseKouBeiCarTypeModel findAll]reverseObjectEnumerator].allObjects[row];
                    deleteid= model.id;
                }
                    break;
                case 2:
                {
                    BrowseKouBeiDBModel *model =   [[BrowseKouBeiDBModel findAll]reverseObjectEnumerator].allObjects[row];
                    deleteid= model.id;
                }
                    break;
                case 3:
                {
                    BrowseKouBeiArtModel *model =   [[BrowseKouBeiArtModel findAll]reverseObjectEnumerator].allObjects[row];
                    deleteid= model.id;
                }
                    break;
                default:
                    break;
            }
            
            if (self.block) {
                [self.deleteArray setValue:deleteid forKey:[NSString stringWithFormat:@"%ld",(long)row]];
           }

        }
    }else{
        [self.deleteArray removeAllObjects];
        for (int row=0; row<[self getShouCanCout]; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            UITableViewCell *cell  = [self cellForRowAtIndexPath:indexPath];
            [cell setSelected:NO];
        }
    }
    
    if (self.block) {
        self.block(self.deleteArray);
    }

    
}


@end
