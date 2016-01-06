//
//  KBComEditTableViewController.m
//  UIScroll1
//
//  Created by 樊振 on 15/12/27.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBComEditTableViewController.h"
#import "UMComUser+UMComManagedObject.h"
#import "UIViewController+UMComAddition.h"
#import "UMComImageView.h"
#import "KBConstant.h"
#import "UIView+ITTAdditions.h"
#import "UMComTopic.h"
#import "UMComPullRequest.h"
#import "UMComSession.h"
#import "KBComEditTableViewCell.h"
#import "UMComShowToast.h"
#import "UMComUser.h"
#import "UMImagePickerController.h"
#import "UMComPushRequest.h"
#import <MobileCoreServices/UTCoreTypes.h>




#import "UMComLocationListController.h"
#import "UMComFriendTableViewController.h"
#import "UMComEditTopicsViewController.h"
#import "UMComUser.h"
#import "UMComTopic.h"
#import "UMComShowToast.h"
#import "UMUtils.h"
#import "UMComSession.h"
#import "UIViewController+UMComAddition.h"
#import "UMComNavigationController.h"
#import "UMComImageView.h"
#import "UMComAddedImageView.h"
#import "UMComBarButtonItem.h"
#import "UMComFeedEntity.h"
#import <AVFoundation/AVFoundation.h>
@interface KBComEditTableViewController ()<KBComEditTableViewCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UMComUser *user;

//选择的照片
@property (nonatomic, strong) NSMutableArray *chosenImages;

@end

@implementation KBComEditTableViewController

-(id)initWithTopic:(UMComTopic*)topic
{
    if (self = [super init]) {
        self.topic = topic;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:49/255.0 green:110/255.0 blue:214/255.0 alpha:1.0]];
    [self setTitleViewWithTitle:@"话题"];
    
    UMComBarButtonItem *backButtonItem = [[UMComBarButtonItem alloc] initWithNormalImageName:@"Backx" target:self action:@selector(onEditClickClose)];
    backButtonItem.customView.frame = CGRectMake(0, 0, 40, 35);
    backButtonItem.customButtonView.frame = CGRectMake(0, 0, 20, 20);
    self.navigationItem.leftBarButtonItem = backButtonItem;
    //[self setLeftButtonWithImageName:@"Backx" action:@selector(onEditClickClose)];
    [self setRightButtonWithTitle:@"发布" action:@selector(publishFeed)];
    
    
    self.tableView.tableHeaderView = [self headView];
    [self.tableView registerClass:[KBComEditTableViewCell class] forCellReuseIdentifier:@"KBComEditTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    
    UMComUserProfileRequest *userProfileController = [[UMComUserProfileRequest alloc] initWithUid:[UMComSession sharedInstance].uid sourceUid:nil];
    __weak KBComEditTableViewController *weakself = self;
    [userProfileController fetchRequestFromCoreData:^(NSArray *data, NSError *error) {
        if (!error && data.count>0) {
            _user = data.firstObject;
            [weakself.tableView reloadData];
        }
        [userProfileController fetchRequestFromServer:^(NSArray *data, BOOL haveNextPage, NSError *error) {
            if (!error && data.count>0) {
                _user = data.firstObject;
                [weakself.tableView reloadData];
            }else{
                [UMComShowToast showFetchResultTipWithError:error];
            }
        }];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - table的头(feed名称)
- (UIView*)headView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    //话题名称（自适应高度）
    _topicName = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, kWindowSize.width-40, 0)];
    _topicName.numberOfLines = 0;
    _topicName.lineBreakMode = NSLineBreakByWordWrapping;
    _topicName.font = [UIFont systemFontOfSize:20];
    _topicName.text = [NSString stringWithFormat:@"        %@",_topic.name];//实现自适应高度，关键要先有text，即内容
    //自适应实现（bounding或者sizeToFit）
    //    CGRect rect = [_topicName.text boundingRectWithSize:CGSizeMake(_topicName.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_topicName.font} context:nil];
    CGSize size = [_topicName sizeThatFits:CGSizeMake(_topicName.width, MAXFLOAT)];
    _topicName.frame = CGRectMake(_topicName.left, _topicName.top, _topicName.width, size.height);
    [view setFrame:CGRectMake(view.left, view.top, kWindowSize.width, _topicName.height + 30)];
    [view addSubview:_topicName];
    return view;
}
#pragma mark - 返回
- (void)onEditClickClose
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}
#pragma mark - 发布帖子
- (void)publishFeed
{
    @try {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        KBComEditTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        UMComFeedEntity *feedEntity = [[UMComFeedEntity alloc] init];
        
        feedEntity.uid = _user.uid;
        if (cell.comment.text&&self.chosenImages) {
            feedEntity.images = self.chosenImages;
            feedEntity.text = cell.comment.text;
        }else if(!self.chosenImages){
            feedEntity.text = cell.comment.text;
        }
        else if (!cell.comment.text){
            feedEntity.images = self.chosenImages;
        }
        
        if ([cell.comment.text isEqualToString:@""]&&self.chosenImages==nil){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"文字和图片不能同时为空" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            }];
            [alertController addAction:otherAction];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
        
        feedEntity.topics = [NSArray arrayWithObjects:_topic, nil];
        [UMComPushRequest postWithFeed:feedEntity completion:^(id responseObject, NSError *error) {
            NSLog(@"error:%@",error);
            if ([error isEqual:@"null"]) {
                NSLog(@"发送成功");
            }
//            else{
//                NSString *message = [NSString stringWithFormat:@"%@",error];
//                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"发送失败，请检查网络" preferredStyle:UIAlertControllerStyleAlert];
//                
//                UIAlertAction *OKayAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    
//                }];
//                
//                [alertController addAction:OKayAction];
//                [self presentViewController:alertController animated:YES completion:^{
//                    
//                }];
//            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"exce:%@",exception);
    }
    @finally {
        
    }
    
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KBComEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KBComEditTableViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[KBComEditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KBComEditTableViewCell"] ;
    }
    cell.delegate = self;
    NSLog(@"_user:******%@",_user);
    if (_user) {
        [cell setEditViewCellWith:_user];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}
#pragma mark - cell代理方法(输入超出警告)
- (void)showTipMessage
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"字符个数不能超过6行" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - 选择照片
-(void)showImagePicker
{
    //if(self.chosenImages.count >= 6){
        //[[[UIAlertView alloc] initWithTitle:UMComLocalizedString(@"Sorry",@"抱歉") message:UMComLocalizedString(@"Too many images",@"图片最多只能选6张") delegate:nil cancelButtonTitle:UMComLocalizedString(@"OK",@"好") otherButtonTitles:nil] show];
        //return;
    //}
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = 6; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
    
    elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];

}

#pragma mark ELCImagePickerControllerDelegate Methods
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                [images addObject:image];
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypeVideo){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                
                [images addObject:image];
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else {
            NSLog(@"Uknown asset type");
        }
    }
    
    self.chosenImages = images;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    KBComEditTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell setCellImagesWith:_chosenImages];
}
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    [picker dismissViewControllerAnimated:YES completion:^{}];
//    
//    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    /* 此处info 有六个值
//     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
//     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
//     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
//     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
//     * UIImagePickerControllerMediaURL;       // an NSURL
//     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
//     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
//     */
//    NSLog(@"&^&^&^&^&^&-------->%@",image);
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
//    KBComEditTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    for (NSInteger i=0; i<5; i++) {
//        [_originImages addObject:image];
//    }
//    
//    [cell setCellImagesWith:_originImages];
//}
//

////压缩图片
//- (UIImage *)compressImage:(UIImage *)image
//{
//    UIImage *resultImage  = image;
//    if (resultImage.CGImage) {
//        NSData *tempImageData = UIImageJPEGRepresentation(resultImage,0.9);
//        if (tempImageData) {
//            resultImage = [UIImage imageWithData:tempImageData];
//        }
//    }
//    return image;
//}

@end
