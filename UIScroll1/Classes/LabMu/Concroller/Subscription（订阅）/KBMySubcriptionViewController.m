//
//  InterestedCollectionViewController.m
//  UIScroll1
//
//  Created by 樊振 on 15/10/13.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBMySubcriptionViewController.h"
#import "KBSortDetailViewControl.h"
#import "KBCommonSingleValueModel.h"
#import "AppDelegate.h"
#import "KBTwoSortModel.h"
#import "KBThreeSortModel.h"
#import "KBMySubscriptionViewCell.h"
#import "KBColumnSortButton.h"
#import "KKNavigationController.h"
#import "KBLoginSingle.h"
#import "KBSubcriptionMainViewController.h"
#import "KBMySubscriptionViewCell.h"
#import "KBConstant.h"
#import "KBMyCollectionReusableView.h"
#import "KBBaseNavigationController.h"
#import "KBWhetherReachableModel.h"
#define DEVICE_WIDTH [UIScreen mainScreen].bounds.size.width
#define DEVICE_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface KBMySubcriptionViewController ()<UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate,KBMySubscriptionViewDelegate>
{
    KBLoginSingle *loginSingle;//用户的单例
    
    NSMutableArray *typeOneInterestStructArray;//一级分类关注有结构的数组 有二级和三级的结构
    
    UIAlertView *alterview;//提示
    
    KBCommonSingleValueModel *commonSingleValueModel;//传值的单例
    
    AppDelegate* appDelegate;
    
    UIImageView * imageView;//没有订阅的图
    
    bool isEditing;//是否处于编辑状态
    
    NSMutableArray *allDeleteButton;//所有删除button
    
}

@end

@implementation KBMySubcriptionViewController

static NSString * reuseIdentifier = @"Cell";
static NSString * kheaderIdentifier = @"Header";
static NSString * kfooterIdentifier = @"Footer";
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    commonSingleValueModel=[KBCommonSingleValueModel newinstance];
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    isEditing=false;
    loginSingle=[KBLoginSingle newinstance];
    typeOneInterestStructArray = [NSMutableArray arrayWithCapacity:5];
    allDeleteButton = [NSMutableArray arrayWithCapacity:5];
    alterview =[[UIAlertView alloc]initWithTitle:@"提示" message:@"无法连接到网络,请检查网络设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    // Register cell classes
    [self.collectionView registerClass:[KBMySubscriptionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    //注册headerView的view需要继承UICollectionReusableView
    [self.collectionView registerClass:[KBMyCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifier];
    
    //注册footerView 的view需要继承UICollectionReusableView
    [self.collectionView registerClass:[KBMyCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kfooterIdentifier];
    
    // Do any additional setup after loading the view.
    self.collectionView.backgroundColor=[UIColor whiteColor];
    self.collectionView.scrollsToTop=NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //没有订阅的图
    imageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.0-120, DEVICE_HEIGHT/2.0-200, 240,200)];
    imageView.image=[UIImage imageNamed:@"无 我的订阅"];
    
    //完成编辑
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editComplete) name:@"editComplete" object:nil];
}
#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
    KBBaseNavigationController *navVC =(KBBaseNavigationController *)self.navigationController;
    navVC.canDragBack=YES;
    
    [typeOneInterestStructArray removeAllObjects];
    for (KBTwoSortModel *find2 in self.typeOneInterestStruct) {
        if (find2.subArray.count!=0) {
            [typeOneInterestStructArray addObject:find2];
        }
    }

    if (typeOneInterestStructArray.count==0) {
        [self.view addSubview:imageView];
    }
}
#pragma mark - 视图将要消失
-(void)viewWillDisappear:(BOOL)animated{
    
    [imageView removeFromSuperview];
    if (isEditing) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IntersetedEditNotComplete" object:nil];
    }
}
#pragma mark - 视图已经出现
-(void)viewDidDisappear:(BOOL)animated
{
    [alterview removeFromSuperview];
    [self setDeleteButtonHidden:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 长按cell触发事件
- (void)mySubscriptionViewLongPressActionWithIndexPath:(NSIndexPath *)indexPath{
    isEditing=true;
    NSLog(@"开始触发长按手势");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addRightButton" object:nil userInfo:nil];
    
    [self setDeleteButtonHidden:NO];
}
#pragma mark - 点击删除图标
- (void)mySubscriptionCellDelete:(NSIndexPath*)indexPath
{
    if (![KBWhetherReachableModel whetherReachable]) {
        [alterview show];
    }
    else
    {
        KBTwoSortModel *find2=[typeOneInterestStructArray objectAtIndex:indexPath.section];
        KBThreeSortModel *find3;
        for (int i=0; i<find2.subArray.count; i++) {
            if (i==indexPath.row) {
                find3 = [find2.subArray objectAtIndex:i];
                find3.isIntrest=false;
            }
        }
        [self.typeThreeInterestedStruct removeObject:find3];
        [find2.subArray removeObjectAtIndex:indexPath.row];
        self.isChanged=YES;
        
        if (find2.subArray.count == 0) {
            [typeOneInterestStructArray removeObject:find2];
        }
        [self.collectionView reloadData];
    }
    
    if (self.typeThreeInterestedStruct.count == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IntersetedEditNotComplete" object:nil userInfo:nil];
        [self.view addSubview:imageView];
    }
}
#pragma mark - 隐藏删除图标
- (void)setDeleteButtonHidden:(BOOL)hidden
{
    [allDeleteButton enumerateObjectsUsingBlock:^(KBMySubscriptionViewCell*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setDeleteButtonHidden:hidden];
    }];
    
}
#pragma mark - 点击右上角完成按钮
-(void)editComplete{
    
    isEditing=false;
    
    [self setDeleteButtonHidden:YES];
    
    KBBaseNavigationController *navVC =(KBBaseNavigationController *)self.navigationController;
    navVC.canDragBack=YES;
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return typeOneInterestStructArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    KBTwoSortModel *find2=[typeOneInterestStructArray objectAtIndex:section];
    return find2.subArray.count;
    
}

- (KBMySubscriptionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    KBMySubscriptionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    
    KBTwoSortModel *find2=[typeOneInterestStructArray objectAtIndex:indexPath.section];
    KBThreeSortModel *find3=[find2.subArray objectAtIndex:indexPath.row];
    [cell setMySubscriptionViewWithModel:find3 andIndexPath:indexPath];
    
    //添加所有cell，以备控制删除图标
    [allDeleteButton addObject:cell];
    if (isEditing) {
        [self setDeleteButtonHidden:NO];
    }
    return cell;
}

- (KBMyCollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    NSString *reuseIdentifier;
    if ([kind isEqualToString: UICollectionElementKindSectionFooter ]){
        reuseIdentifier = kfooterIdentifier;
    }else{
        reuseIdentifier = kheaderIdentifier;
    }
    
    KBMyCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    KBTwoSortModel *find2=[typeOneInterestStructArray objectAtIndex:indexPath.section];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        if (find2.subArray.count!=0) {
            [view setReusableViewWithModel:find2 andIsSectionHeader:YES];
        }
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        
        if (find2.subArray.count!=0) {
            [view setReusableViewWithModel:find2 andIsSectionHeader:NO];
            
            if (indexPath.section < typeOneInterestStructArray.count-1)
            {
                [view setBorderView];
            }
        }
        
    }
    return view;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return NO;
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath{
    
    if (sourceIndexPath.section==destinationIndexPath.section) {
        
        //[self.collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];//本来手势就已经算move了，这样会再move一遍
        KBTwoSortModel *find2=[typeOneInterestStructArray objectAtIndex:sourceIndexPath.section];
        //        [find2.subArray exchangeObjectAtIndex:destinationIndexPath.row withObjectAtIndex:sourceIndexPath.row];//这个只是把起始和终点的两个cell变了，没有达到流的效果
        
        if (sourceIndexPath.row<destinationIndexPath.row) {
            //find2.isHaveSorted=YES;
            for (long i=sourceIndexPath.row+1; i<=destinationIndexPath.row; i++) {
                [find2.subArray exchangeObjectAtIndex:i-1 withObjectAtIndex:i];
            }
        }
        else {
            //find2.isHaveSorted=YES;
            for (long i=sourceIndexPath.row; i>destinationIndexPath.row; i--) {
                [find2.subArray exchangeObjectAtIndex:i withObjectAtIndex:i-1];
            }
        }
        
    }
    [self.collectionView reloadData];
}
#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    KBTwoSortModel *find2 = [typeOneInterestStructArray objectAtIndex:indexPath.section];
    KBThreeSortModel *find_3=[find2.subArray objectAtIndex:indexPath.row];
    KBSortDetailViewControl *nttVC=[[KBSortDetailViewControl alloc]init];
    nttVC.thirdTypeName=find_3.name;
    nttVC.secondTypeID=find_3.TypeTowID;
    [self.navigationController pushViewController:nttVC animated:YES];
}


#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(0.35*DEVICE_WIDTH, 40);
}
//定义每个Section 的 margin(范围)
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //return UIEdgeInsetsMake(10, 0.1*DEVICE_WIDTH, 10, 0.1*DEVICE_WIDTH);//分别为上、左、下、右
    return UIEdgeInsetsMake(15, 30, 15, 30);
}
//一个section内行距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
//一个section内列距（item之间距离）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={self.collectionView.frame.size.width,25};
    return size;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    CGSize size={self.collectionView.frame.size.width,30};
    return size;
}

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

@end
