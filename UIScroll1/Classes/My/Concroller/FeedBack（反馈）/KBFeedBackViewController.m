//
//  FeedBackTVC.m
//  UIScroll1
//
//  Created by eddie on 15-6-14.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBFeedBackViewController.h"
#import "AppDelegate.h"
#import "KBCommonSingleValueModel.h"
#import "KBLoginSingle.h"
#import "MBProgressHUD.h"
#import "KBBaseNavigationController.h"
#import "KBConstant.h"
#import "KBColor.h"
#import "UIView+ITTAdditions.h"
#import "KBPostParametersModel.h"
#import "KBProgressHUD.h"

//反馈问题cell的高度
#define PROBLEM_HEIGHT 250
//反馈问题 iPhone5 cell的高度
#define PROBLEM_HEIGHT5 200
//反馈图片的高度
#define IMAGES_HEIGHT 150
//反馈图片 iPhone5 的高度
#define IMAGES_HEIGHT5 120
//距离上边
#define MARGIN_WIDTH 20
//距离左边
#define MARGIN_USUAL 5

@interface KBFeedBackViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate>
{
    UITextView *textView;//反馈的输入
    
    UIButton *setImageBtn;
    
    int imageCount;//计数添加图片的数量
    
    UILabel *setImageLable; //反馈图片的提示文字
    
    NSMutableArray *BtnArray;//添加图片的button的数组
    
    UICollectionView *collectionView;//用collectionView添加图片
    
    NSMutableArray *imageArray;//图片的数组
    
    AppDelegate* appDelegate;
    
    CGRect textViewOriginRect;//原始textView的rect
    
    KBCommonSingleValueModel * commonSingleValueModel;//传值的单例
    
    MBProgressHUD *hud;//提示
}
@end
@implementation KBFeedBackViewController

float btnWidth;
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    commonSingleValueModel=[KBCommonSingleValueModel newinstance];
    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    imageCount=0;
    BtnArray=[[NSMutableArray alloc]init];
    imageArray=[[NSMutableArray alloc]init];
    btnWidth=(self.tableView.frame.size.width-MARGIN_WIDTH*2)/5.0;//添加图片的button之间的距离
    
    //导航栏的title
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLable.textColor=[UIColor whiteColor];
    titleLable.textAlignment=NSTextAlignmentCenter;
    titleLable.text=_proTypeStr;
    titleLable.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:19];
    self.navigationItem.titleView=titleLable;
    
    //导航栏左边的返回
    UIButton *leftBarBtn=[[UIButton alloc]init];
    leftBarBtn.contentMode=UIViewContentModeScaleAspectFit;
    [leftBarBtn setImage:[UIImage imageNamed: @"返回.png"] forState:UIControlStateNormal];
    [leftBarBtn setFrame:CGRectMake(14, 0, 11, 19)];
    [leftBarBtn addTarget:self action:@selector(popFeedVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    //tableView
    self.tableView.estimatedRowHeight=100;
    self.tableView.rowHeight=UITableViewAutomaticDimension;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.scrollsToTop=NO;
}
#pragma mark - 视图已经出现
-(void)viewDidAppear:(BOOL)animated
{
    KBBaseNavigationController *navVC  =(KBBaseNavigationController *)self.navigationController;
    navVC.canDragBack=YES;
}
#pragma mark - 视图将要消失
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_ENABLE" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height;
    switch (indexPath.section) {
        case 0:{
            if (kWindowSize.width==320) {
                height=PROBLEM_HEIGHT5;
            }
            else
                height=PROBLEM_HEIGHT;
            break;
        }
        case 1:
        {
            if (kWindowSize.width==320) {
                height=IMAGES_HEIGHT5;
            }
            else
                height=IMAGES_HEIGHT;
            break;
        }
        default:
            break;
    }
    return height;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return [super tableView:tableView heightForFooterInSection:section];
    }
    else  return 150;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==1) {
        UIButton *submitBtn;//提交反馈的button
        if(kWindowSize.width==320)
        {
            submitBtn=[[UIButton alloc]initWithFrame:CGRectMake(MARGIN_WIDTH, 50, kWindowSize.width-2*MARGIN_WIDTH, 40)];
        }
        else
            submitBtn=[[UIButton alloc]initWithFrame:CGRectMake(MARGIN_WIDTH, 50,kWindowSize.width-2*MARGIN_WIDTH, 50)];
        //提交反馈的button
        UIView *footerView; footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width-2*MARGIN_WIDTH, 150)];
        submitBtn.backgroundColor=KColor_15_86_192;
        [submitBtn setTitle:@"提交反馈" forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:submitBtn];
        return footerView;
    }
    else
        return [super tableView:tableView viewForFooterInSection:section];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section>=1)
        return 3;
    else
        return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section==0) {
        if (kWindowSize.width==320) {
            [cell setFrame:CGRectMake(0, 0, kWindowSize.width, PROBLEM_HEIGHT5)];
        }
        else
            [cell setFrame:CGRectMake(0, 0, kWindowSize.width, PROBLEM_HEIGHT)];
        [cell.contentView setFrame:cell.frame];
        
        //反馈问题的标题
        UILabel * feedlebel=[[UILabel alloc]initWithFrame:CGRectMake(cell.left+20, cell.top+20, 150, 30)];
        feedlebel.text=[NSString stringWithFormat:@"%@:",self.proTypeStr];
        feedlebel.textColor=KColor_51;
        feedlebel.textAlignment=NSTextAlignmentLeft;
        [cell.contentView addSubview:feedlebel];
        
        //反馈问题的输入
        textViewOriginRect=CGRectMake(feedlebel.left, feedlebel.bottom+20,kWindowSize.width-40, cell.height-100);
        textView=[[UITextView alloc]initWithFrame:textViewOriginRect];
        textView.backgroundColor=KColor_238;
        textView.bounces=NO;
        textView.layoutManager.allowsNonContiguousLayout = NO;
        textView.font=[UIFont systemFontOfSize:17];
        textView.delegate=self;
        
        //反馈问题的内容的提示
        self.placeHolderStr=@"说明(选填)";
        self.placeHolderLable=[[UILabel alloc]init];
        self.placeHolderLable.text=self.placeHolderStr;
        self.placeHolderLable.numberOfLines=1;
        [self.placeHolderLable setTextColor:KColor_102];
        CGSize placeHolderSize=[self.placeHolderLable sizeThatFits:CGSizeMake(textView.width, textView.height-10)];
        [self.placeHolderLable setFrame:CGRectMake(10, 7, textView.width, placeHolderSize.height)];
        [textView addSubview:self.placeHolderLable];
        [cell.contentView addSubview:textView];
    }
    else if (indexPath.section==1)
    {
        
        [cell setFrame:CGRectMake(0, 0, tableView.width, IMAGES_HEIGHT)];
        [cell.contentView setFrame:cell.frame];
        
        //反馈图片的标题
        setImageLable=[[UILabel alloc]initWithFrame:CGRectMake(cell.left+20, cell.top+20, tableView.width, 30)];
        setImageLable.text=@"反馈附图(可选):";
        setImageLable.textAlignment=NSTextAlignmentLeft;
        setImageLable.textColor=KColor_51;
        [cell.contentView addSubview:setImageLable];
        
        //用collectionView添加反馈图片
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc]init];;
        collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(setImageLable.left, setImageLable.bottom+MARGIN_USUAL, self.tableView.width-MARGIN_WIDTH*2, btnWidth) collectionViewLayout:flowLayout];
        collectionView.backgroundColor=[UIColor whiteColor];
        collectionView.scrollsToTop=NO;
        collectionView.delegate=self;
        collectionView.dataSource=self;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
        [cell.contentView addSubview:collectionView];
        
        //设置反馈图片的button
        setImageBtn=[[UIButton alloc]initWithFrame:CGRectMake(setImageLable.left,setImageLable.bottom+40,btnWidth-2*MARGIN_USUAL  ,btnWidth-2*MARGIN_USUAL )];
        [setImageBtn setBackgroundImage:[UIImage imageNamed:@"图片.png"] forState:UIControlStateNormal];
        [setImageBtn addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
        setImageBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
        [BtnArray addObject:setImageBtn];
    }
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
}
#pragma mark - textView输入的改变
-(void)textViewDidChange:(UITextView *)textView1{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (textView.text.length==0) {
       self.placeHolderLable.text=self.placeHolderStr;
    }
    else
    {
        self.placeHolderLable.text=@"";
        CGRect frame = cell.frame;
        frame.size.height = cell.height;
        if (frame.size.height>textView.frame.size.height) {
            [cell setFrame:CGRectMake(cell.left
                                      ,cell.top, cell.width, frame.size.height)];
        }
        else if(frame.size.height<textView.frame.size.height)
        {
            [cell setFrame:CGRectMake(cell.left
                                      ,cell.top, cell.width, frame.size.height)];
        }
    }
}
#pragma mark - 添加反馈图片
-(void)addImage:(UIButton *)btn{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [picker.navigationBar setBarTintColor:KColor_15_86_192];
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    imageCount++;
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        UIImage    *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        UIImage *img= [self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];
        // setImageBtn
        UIButton *newImageBtn=[[UIButton alloc]initWithFrame:CGRectMake(0,0,btnWidth-2*MARGIN_USUAL  ,btnWidth-2*MARGIN_USUAL )];
        [newImageBtn setBackgroundImage:img forState:UIControlStateNormal];
        [newImageBtn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
        [imageArray addObject:img];
        [BtnArray insertObject:newImageBtn atIndex:0];
        if (BtnArray.count==5)
        {
            [BtnArray removeLastObject];
            
        }
        [picker dismissViewControllerAnimated:YES completion:^{
            [collectionView reloadData];
        }];
        
    }
}
#pragma mark - 压缩图片
-(UIImage *) scaleFromImage: (UIImage *) image1 toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image1 drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark - 设置导航栏
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //状态栏的颜色改变
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //导航栏左右按钮变白
    [navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //导航栏标题变白
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
#pragma mark - collectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return BtnArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView1 cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell=(UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    UIButton *imageBtn=[BtnArray objectAtIndex:indexPath.row];
    [imageBtn setCenter:cell.contentView.center];
    [cell.contentView addSubview:imageBtn];
    cell.contentView.contentMode=UIViewContentModeScaleAspectFill;
    cell.contentView.layer.cornerRadius=8;
    imageBtn.layer.cornerRadius=8;
    cell.contentView.backgroundColor=KColor_204;
    return  cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(btnWidth , btnWidth);
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
#pragma mark - scrollview开始拖拽
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([textView isFirstResponder]) {
        [textView resignFirstResponder];
    }
    
}
#pragma mark - 删除反馈图片
-(void)deleteImage:(UIButton *)btn{
    NSInteger index=[BtnArray indexOfObject:btn];
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForItem:index inSection:0];
    [BtnArray removeObjectAtIndex:index];
    
    [imageArray removeObjectAtIndex:index];
    
    [collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    imageCount--;
    if (imageCount==3) {
        [BtnArray addObject:setImageBtn];
        [collectionView reloadData];
    }
    
}
#pragma mark - 返回
-(void)popFeedVC{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 提交反馈
-(void)submit
{
     //反馈post参数
    NSDictionary * feedBackDic=[KBPostParametersModel setFeedBackMenuParameters:[KBLoginSingle newinstance].userID withFeedBackType:self.feedbackType withFeedBackContent:textView.text withScreenShot:imageArray withImageCount:imageCount];
//    NSInteger i;
//   
//    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
//    [dic setObject:[NSNumber numberWithInteger: [KBLoginSingle newinstance].userID ] forKey:@"userId"];
//    [dic setObject:[NSNumber numberWithInt:self.feedbackType] forKey:@"feedbackType"];
//    
//    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"hh:mm  MM-dd"];
//    [dic setObject:  [formatter stringFromDate:[NSDate date]]forKey:@"feedbackDate"];
//    
//    [dic setObject:textView.text forKey:@"feedbackContent"];
//    for (i=0; i<imageCount; i++)
//    {
//        UIImage * sumbitimage=[imageArray objectAtIndex:i];
//        NSData *data = UIImageJPEGRepresentation(sumbitimage,1.0f);
//        NSString * photo=[data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//        photo=[photo stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//        photo = [photo stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//        photo=  [photo stringByReplacingOccurrencesOfString:@"\t" withString:@""];
//        photo = [photo stringByReplacingOccurrencesOfString:@"\v" withString:@""];
//        photo = [photo stringByReplacingOccurrencesOfString:@"\f" withString:@""];
//        photo = [photo stringByReplacingOccurrencesOfString:@"\b" withString:@""];
//        photo = [photo stringByReplacingOccurrencesOfString:@"\a" withString:@""];
//        photo = [photo stringByReplacingOccurrencesOfString:@"\e" withString:@""];
//        
//        [dic setObject:photo forKey:[NSString stringWithFormat:@"screenShot%ld",(long)(i+1)]];
//        
//    }
//    for (i=0; i<4-imageCount; i++){
//        [dic setObject:@"" forKey:[NSString stringWithFormat:@"screenShot%ld",imageCount+i+1]];
//    }
//    NSString *dicToSendStr;
//    
//    if ([NSJSONSerialization isValidJSONObject:dic]) {
//        NSError *error;
//        NSData *data=    [NSJSONSerialization dataWithJSONObject:dic options: NSJSONWritingPrettyPrinted error:&error];
//        dicToSendStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        
//    }
//    NSDictionary * sendDic= @{@"feedbackString":dicToSendStr};
    
//    NSString * url=[NSString stringWithFormat:@"%@/kuibuversion1/user/feedback",commonSingleValueModel.ip121];
    if (textView.text.length!=0||imageCount!=0) {
        [appDelegate.manager
         POST:KMenuFeedBackUrl(kBaseUrl)
         parameters:feedBackDic// 指定无需请求参数
         // 获取服务器响应成功时激发的代码块
         success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
             NSString* feedbackResult =[json objectForKey:@"feedbackResult"];
             int intfeedbackResult=[feedbackResult intValue];
             if (intfeedbackResult==1) {
                 [KBProgressHUD setHud:self.view withText:@"反馈成功" AndWith:-0.42];
                 [self performSelector:@selector(popFeedVC) withObject:nil afterDelay:1];
             }
             else{
                [KBProgressHUD setHud:self.view withText:@"反馈失败" AndWith:-0.42];
             }
             
             
         }
         // 获取服务器响应失败时激发的代码块
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
              [KBProgressHUD setHud:self.view withText:@"请检查网络设置" AndWith:-0.42];
         }];
    }
    else
    {
        [KBProgressHUD setHud:self.view withText:@"请填写反馈内容" AndWith:-0.42];
    }
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end


