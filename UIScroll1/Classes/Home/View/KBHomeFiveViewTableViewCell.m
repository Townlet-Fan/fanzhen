//
//  recommendTableViewCell1.m
//  UIScroll1
//
//  Created by kuibu technology on 15/10/30.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBHomeFiveViewTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "KBHomeFiveView.h"
#import "UIView+ITTAdditions.h"
#import "KBConstant.h"
#import "KBHomeArticleModel.h"
#import "UIImageView+KBAddView.h"
//控件间距
#define kSpace 2

//下面四个Image和Label之间的间距
#define KImage_Label 5


//下面四个Label的高度

#define KLabelHeight 40

@interface KBHomeFiveViewTableViewCell()
{
    NSArray *_FiveArray; //文章的数组
}
/**
 *  顶部
 */
@property(nonatomic,strong) KBHomeFiveView *topView;
/**
 *  左上方
 */
@property(nonatomic,strong) KBHomeFiveView *leftUpView;
/**
 *  左下方
 */
@property(nonatomic,strong) KBHomeFiveView *leftDownView;
/**
 *  右上方
 */
@property(nonatomic,strong)KBHomeFiveView * rightUpView;
/**
 *  右下方
 */
@property(nonatomic,strong)KBHomeFiveView * rightDownView;

@end

@implementation KBHomeFiveViewTableViewCell
float rowBighight;
float DEVICE_WIDTH,DEVICE_HEIGHT;
float smallIamgewidth,smallIamgehight;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        DEVICE_WIDTH=[UIScreen mainScreen].bounds.size.width;
        DEVICE_HEIGHT=[UIScreen mainScreen].bounds.size.height;
        //下面四个小图的宽度
        smallIamgewidth=(DEVICE_WIDTH-2)/2.0;
        //下面四个小图的高度
        smallIamgehight=(DEVICE_WIDTH-2)/2.0/1.5;
        //大图的高度
        rowBighight=DEVICE_WIDTH/2.35;
        //up大图
        self.topView=[[KBHomeFiveView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, rowBighight)];
        [self setDimViewWithView:self.topView andImageName:@"马斯克235"];
        [self.contentView addSubview:self.topView];
        
        //leftUp
        self.leftUpView=[[KBHomeFiveView alloc]initWithFrame:CGRectMake(0, self.topView.bottom+kSpace, smallIamgewidth, smallIamgehight)];
        [self.contentView addSubview:self.leftUpView];
        [self setDimViewWithView:self.leftUpView andImageName:@"胡歌"];
        
        //rightUp
        self.rightUpView=[[KBHomeFiveView alloc]initWithFrame:CGRectMake(self.leftUpView.right+kSpace, self.leftUpView.top, smallIamgewidth, smallIamgehight)];
        [self setDimViewWithView:self.rightUpView andImageName:@"胡歌"];
        [self.contentView addSubview:self.rightUpView];
        
        //leftDown
        self.leftDownView=[[KBHomeFiveView alloc]initWithFrame:CGRectMake(0, self.leftUpView.bottom+KImage_Label*2+KLabelHeight, smallIamgewidth, smallIamgehight)];
        [self setDimViewWithView:self.leftDownView andImageName:@"胡歌"];
        [self.contentView addSubview:self.leftDownView];
        
        //rightDown
        
        self.rightDownView=[[KBHomeFiveView alloc]initWithFrame:CGRectMake(self.leftDownView.right+kSpace, self.leftDownView.top, smallIamgewidth, smallIamgehight)];
        [self setDimViewWithView:self.rightDownView andImageName:@"胡歌"];
        [self.contentView addSubview:self.rightDownView];
        
        [self setFrame:CGRectMake(0, 0, DEVICE_WIDTH, rowBighight+smallIamgehight*2+80+4+10)];
        [self.contentView setFrame:self.frame];
        
        
    }
    return  self;
}
- (void)setDimViewWithView:(KBHomeFiveView *)view andImageName:(NSString *)imageName
{
    [UIImageView addDimImageViewWithImageName:imageName toView:view];
    [view addSubview:view.FiveImageLabel];
}

- (void)setFiveViewWithArray:(NSArray *)Fivearray
{
    _FiveArray =Fivearray;
    //设置每个view
    [_FiveArray enumerateObjectsUsingBlock:^(KBHomeArticleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (idx) {
            case 0:{
                [self setFiveModelWithTag:idx andView:self.topView];
            }
                break;
            case 1:{
                [self setFiveModelWithTag:idx andView:self.leftUpView];
            }
                break;
            case 2:{
                [self setFiveModelWithTag:idx andView:self.rightUpView];
            }
                break;
            case 3:{
                [self setFiveModelWithTag:idx andView:self.leftDownView];
            }
            case 4:{
                [self setFiveModelWithTag:idx andView:self.rightDownView];
            }
            default:
                break;
        }
    }];
}
#pragma mark - 设置文章的view
- (void)setFiveModelWithTag:(NSInteger)tag andView:(KBHomeFiveView *)fiveView
{
    //取出model
    KBHomeArticleModel* fiveModel =_FiveArray[tag];
    //有数据的时候再 加上手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arctViewTapDo:)];
    [fiveView addGestureRecognizer:tap];
    //设置tag
    fiveView.tag = tag;
    fiveView.userInteractionEnabled = YES;
    //设置view
    if (tag==0) {
        [fiveView setViewWithTopViewModel:fiveModel];
    }
    else
        [fiveView setViewWithFourViewModel:fiveModel];
}

#pragma mark - 文章view的点击事件

- (void)arctViewTapDo:(UITapGestureRecognizer *)tap
{
    KBHomeArticleModel *fiveModel =_FiveArray[tap.view.tag];
   
   
    //代理
    if ([_delegate respondsToSelector:@selector(fiveViewTapActionWithartModel:)]) {
        
        [_delegate fiveViewTapActionWithartModel:fiveModel];
    }
    
}

@end
