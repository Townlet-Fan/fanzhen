//
//  KBSubjectViewCell.m
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/29.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBSubjectViewCell.h"
#import "KBConstant.h"
#import "UIView+ITTAdditions.h"
#import "UITopLable.h"
#import "KBColumnModel.h"
#import "YYWebImage.h"
#import "KBColor.h"
#import "UIButtonWithIndexPath.h"

//控件距离左边的距离
#define MARGIN_WIDTH 7
//控件距离上边的距离
#define MARGIN_HEIGHT 5
//readImage
#define ReadImage [UIImage imageNamed:@"浏览量.png"]
//cell的大小
#define USUAL_CELL_HEIGHT 95

@interface KBSubjectViewCell()
{
    NSArray *viewArray; //文章的数组
}

/**
 *  三级分类的Icon的背景View
 */
@property(nonatomic,strong) UIImageView *thirdImageBackView;

/**
 *  三级分类的Icon
 */
@property(nonatomic,strong) UIImageView *thirdImageView;

/**
 *  三级分类的名字
 */
@property(nonatomic,strong) UILabel * thirdNameLabel;

/**
 *  三级分类和二级分类之间的间隔
 */
@property(nonatomic,strong) UIView *betweenSecondAndThirdView;

/**
 *  二级分类的名字
 */
@property(nonatomic,strong) UILabel * secondNameLabel;


/**
 *  置顶功能的ImageView
 */
@property(nonatomic,strong) UIImageView * TopButtonImageView;


/**
 *  第一张图片
 */
@property(nonatomic,strong) UIImageView *headImageView;

/**
 * section的head的Label
 */
@property(nonatomic,strong) UILabel * HeadImageLabel;

/**
 *  第一张图片的阅读量的ImageView
 */
@property (nonatomic,strong) UIImageView * readNumHeadImageView;
/**
 * 第一个的整个一个View
 */
@property(nonatomic,strong) UIView *FirstView;
/**
 *  第二张图片
 */
@property (nonatomic,strong)UIImageView * artSecondImageView;

/**
 *  第二张图片的标题
 */
@property (nonatomic,strong) UITopLable * artSecondTitleLabel;

/**
 *  第二张图片的阅读量的ImageView
 */
@property (nonatomic,strong) UIImageView * readNumSecondImageView;

/**
 *  第二个整个一个View
 */
@property (nonatomic,strong) UIView * secondView;

/**
 *  第三张图片
 */
@property (nonatomic,strong)UIImageView * artThirdImageView;

/**
 * 第三张图片的标题
 */
@property (nonatomic,strong) UITopLable * artThirdTitleLabel;

/**
 *  第三张图片的阅读量的ImageView
 */
@property (nonatomic,strong) UIImageView * readNumThirdImageView;

/**
 *  第三个整个一个View
 */
@property (nonatomic,strong) UIView * thirdView;

/**
 *  自定义图片之间的分割线
 */
@property (nonatomic,strong) UIView *separatorView;

@end

@implementation KBSubjectViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIndexpathArray:(NSArray *)indexpathArray
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=KColor_230;
        self.colorView = [[UIView alloc] init];
        [self calculateIndexPathArray:indexpathArray];
        self.colorView.backgroundColor=[UIColor whiteColor];
        self.colorView.layer.cornerRadius=5;
        self.colorView.layer.borderWidth=1;
        self.colorView.layer.borderColor=[UIColor whiteColor].CGColor;
        
        for (int i = 0;i <indexpathArray.count;i++) {
            if (i==0) {
                KBColumnModel * colunmnModel = indexpathArray[0];
                //三级分类Icon的背景View
               self.thirdImageBackView = [[UIImageView alloc]initWithFrame:CGRectMake(self.colorView.left+MARGIN_WIDTH, self.colorView.top+MARGIN_WIDTH, 30, 30)];
                self.thirdImageBackView.backgroundColor = KColor_255_209_44;
                self.thirdImageBackView.layer.cornerRadius=15;
                [self.colorView addSubview:self.thirdImageBackView];
                //三级分类的Icon
                self.thirdImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5 ,5, 20, 20)];
                self.thirdImageView.contentMode=UIViewContentModeScaleAspectFill;
                [self.thirdImageBackView addSubview:self.thirdImageView];
                
                //三级分类的名称
                self.thirdNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.thirdImageBackView.right+MARGIN_WIDTH, self.thirdImageBackView.top+5,65, 20)];
                self.thirdNameLabel.font=[UIFont systemFontOfSize:15];
                self.thirdNameLabel.textColor=KColor_102;
                self.thirdNameLabel.textAlignment=NSTextAlignmentLeft;
                [self.colorView addSubview:self.thirdNameLabel];
                
                //三级分类和二级分类直接的间隔
                self.betweenSecondAndThirdView = [[UIView alloc]initWithFrame:CGRectMake(self.thirdNameLabel.right+3, self.thirdNameLabel.top, 1,self.thirdNameLabel.height)];
                [self.colorView addSubview:self.betweenSecondAndThirdView];
                
                //二级分类的名字
                self.secondNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.betweenSecondAndThirdView.right + 7, self.thirdNameLabel.top, 80, 20)];
                self.secondNameLabel.font=[UIFont systemFontOfSize:13];
                self.secondNameLabel.textColor = KColor_153_Alpha_1;
                self.secondNameLabel.textAlignment=NSTextAlignmentLeft;
                [self.colorView addSubview:self.secondNameLabel];
                //置顶button
                self.TopButtonWithIndexpath  = [[UIButtonWithIndexPath alloc]initWithFrame:CGRectMake(self.colorView.right - 80, self.thirdImageBackView.top + 5, 60, 20)];
                //self.TopButtonWithIndexpath.whetherTotTop=YES;
                self.TopButtonWithIndexpath.titleLabel.font=[UIFont systemFontOfSize:13];
                [self.TopButtonWithIndexpath setTitleColor:KColor_102 forState:UIControlStateNormal];
                self.TopButtonWithIndexpath.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
                [self.colorView addSubview:self.TopButtonWithIndexpath];
                
                //置顶button的ImageView
                self.TopButtonImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.TopButtonWithIndexpath.right+5, self.TopButtonWithIndexpath.top, 20, 20)];
                //self.TopButtonImageView.image=KReplyImage;
                [self.colorView addSubview:self.TopButtonImageView];
                if (colunmnModel.infoImgType) {
                    
                    //第一个cell的 头视图
                    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.thirdImageBackView.left,self.thirdImageBackView.bottom+MARGIN_WIDTH,self.colorView.width-2*self.thirdImageBackView.left,(self.colorView.width-2*self.thirdImageBackView.left)*5/12)];
                    self.headImageView.backgroundColor=KColor_153_Alpha_05;
                    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
                    self.headImageView.clipsToBounds = YES;
                    [self.colorView addSubview:self.headImageView];
                    
                    
                    //标题
                    self.HeadImageLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, self.headImageView.height-80, self.headImageView.width-20, 50)];
                    self.HeadImageLabel.font=kFont_18;
                    self.HeadImageLabel.textColor=[UIColor whiteColor];
                    self.HeadImageLabel.numberOfLines=2;
                    [self.headImageView addSubview:self.HeadImageLabel];
                    
                    //cell的阅读量的ImageView
                    self.readNumHeadImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.headImageView.width-80, self.headImageView.height-20, 20, 10)];
                    self.readNumHeadImageView.image=ReadImage;
                    [self.headImageView addSubview:self.readNumHeadImageView];
                    
                    //cell的阅读量的Label
                    self.readNumFirstLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.readNumHeadImageView.left+23, self.readNumHeadImageView.top-2, 100, 13)];
                    self.readNumFirstLabel.textColor=KColor_240;
                    self.readNumFirstLabel.font=[UIFont systemFontOfSize:11];
                    self.readNumFirstLabel.textAlignment=NSTextAlignmentLeft;
                    [self.headImageView addSubview:self.readNumFirstLabel];
                }
                else
                {
                    //整个view
                    self.FirstView  = [[UIView alloc]initWithFrame:CGRectMake(self.colorView.left+MARGIN_WIDTH, self.thirdImageBackView.bottom+MARGIN_WIDTH, self.colorView.width-2*(self.colorView.left+MARGIN_WIDTH), USUAL_CELL_HEIGHT-2*MARGIN_HEIGHT)];
                    [self.colorView addSubview:self.FirstView];
                    //第一个cell的 头视图
                    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,(USUAL_CELL_HEIGHT-2*MARGIN_HEIGHT)*4/3.0 ,USUAL_CELL_HEIGHT-2*MARGIN_HEIGHT)];
                    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
                    self.headImageView.clipsToBounds = YES;
                    [self.FirstView addSubview:self.headImageView];
                    
                    //标题
                    self.HeadImageLabel=[[UITopLable alloc]initWithFrame:CGRectMake(self.headImageView.right+7, self.headImageView.top,self.FirstView.width-7-self.headImageView.width, 82)];
                    self.HeadImageLabel.numberOfLines = 2;
                    self.HeadImageLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
                    [self.HeadImageLabel setTextColor:KColor_51];
                    [self.FirstView addSubview:self.HeadImageLabel];
                    
                    //cell的阅读量的ImageView
                    self.readNumHeadImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.FirstView.width-80, self.headImageView.height-20, 20, 10)];
                    self.readNumHeadImageView.image=ReadImage;
                    [self.FirstView addSubview:self.readNumHeadImageView];
                    
                    //cell的阅读量的Label
                    self.readNumFirstLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.readNumHeadImageView.left+23, self.readNumHeadImageView.top-2, 100, 13)];
                    self.readNumFirstLabel.textColor=[UIColor grayColor];
                    self.readNumFirstLabel.font=[UIFont systemFontOfSize:11];
                    self.readNumFirstLabel.textAlignment=NSTextAlignmentLeft;
                    [self.FirstView addSubview:self.readNumFirstLabel];
                }
            }
            if (i==1) {
                KBColumnModel * colunmnModel = indexpathArray[0];
                //分割线
                self.separatorView = [[UIView alloc]initWithFrame:CGRectMake(MARGIN_WIDTH*2,colunmnModel.infoImgType?self.headImageView.bottom+MARGIN_HEIGHT:self.FirstView.bottom+MARGIN_HEIGHT, self.colorView.width -4*MARGIN_WIDTH, 1)];
                self.separatorView.backgroundColor = KColor_220;
                [self.colorView addSubview: self.separatorView];
                //整个view
                self.secondView  = [[UIView alloc]initWithFrame:CGRectMake(self.colorView.left+MARGIN_WIDTH, colunmnModel.infoImgType?self.headImageView.bottom+2*MARGIN_HEIGHT:self.FirstView.bottom+2*MARGIN_HEIGHT, self.colorView.width-2*(self.colorView.left+MARGIN_WIDTH), USUAL_CELL_HEIGHT-2*MARGIN_HEIGHT)];
                [self.colorView addSubview:self.secondView];
                
                //文章的图
                self.artSecondImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,(USUAL_CELL_HEIGHT-2*MARGIN_HEIGHT)*4/3.0 ,USUAL_CELL_HEIGHT-2*MARGIN_HEIGHT)];
                self.artSecondImageView.contentMode = UIViewContentModeScaleAspectFill;
                self.artSecondImageView.clipsToBounds = YES;
                [self.secondView addSubview:self.artSecondImageView];
                //文章的标题
                self.artSecondTitleLabel = [[UITopLable alloc] initWithFrame:CGRectMake(self.artSecondImageView.right+7, self.artSecondImageView.top,self.secondView.width-7-self.artSecondImageView.width, 82)];
                self.artSecondTitleLabel.numberOfLines = 2;
                self.artSecondTitleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
                [self.artSecondTitleLabel setTextColor:KColor_51];
                self.artSecondTitleLabel.numberOfLines=2;
                [self.secondView addSubview:self.artSecondTitleLabel];
                
                //cell的阅读量的ImageView
                self.readNumSecondImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.secondView.width-80, self.artSecondImageView.bottom-20, 20, 10)];
                self.readNumSecondImageView.image=ReadImage;
                [self.secondView addSubview:self.readNumSecondImageView];
                
                //cell的阅读量的Label
                self.readNumSecondLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.readNumSecondImageView.left+23, self.readNumSecondImageView.top-2,100,13)];
                self.readNumSecondLabel.textColor=[UIColor grayColor];
                self.readNumSecondLabel.font=[UIFont systemFontOfSize:11];
                self.readNumSecondLabel.textAlignment=NSTextAlignmentLeft;
                [self.secondView addSubview:self.readNumSecondLabel];
            }
            if (i==2)
            {
                //分割线
                self.separatorView = [[UIView alloc]initWithFrame:CGRectMake(MARGIN_WIDTH*2, self.secondView.bottom+MARGIN_HEIGHT,self.colorView.width -MARGIN_WIDTH*4 , 1)];
                self.separatorView.backgroundColor = KColor_220;
                [self.colorView addSubview: self.separatorView];
                
                //整个View
                self.thirdView = [[UIView alloc]initWithFrame:CGRectMake(self.secondView.left,self.secondView.bottom+2*MARGIN_HEIGHT,self.secondView.width, self.secondView.height)];
                [self.colorView addSubview:self.thirdView];
                
                //文章的图
                self.artThirdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,(USUAL_CELL_HEIGHT-2*MARGIN_HEIGHT)*4/3.0 ,USUAL_CELL_HEIGHT-2*MARGIN_HEIGHT)];
                self.artThirdImageView.contentMode = UIViewContentModeScaleAspectFill;
                self.artThirdImageView.clipsToBounds = YES;
                [self.thirdView addSubview:self.artThirdImageView];
                
                //文章的标题
                self.artThirdTitleLabel = [[UITopLable alloc] initWithFrame:CGRectMake(self.artThirdImageView.right+7, self.artThirdImageView.top,self.thirdView.width-7-self.artThirdImageView.width, 82)];
                self.artThirdTitleLabel.numberOfLines = 2;
                self.artThirdTitleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
                [self.artThirdTitleLabel setTextColor:KColor_51];
                self.artThirdTitleLabel.numberOfLines=2;
                [self.thirdView addSubview:self.artThirdTitleLabel];
                
                //cell的阅读量的ImageView
                self.readNumThirdImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.secondView.width-80, self.artThirdImageView.bottom-20, 20, 10)];
                self.readNumThirdImageView.image=ReadImage;
                [self.thirdView addSubview:self.readNumThirdImageView];
                
                //cell的阅读量的Label
                self.readNumThirdLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.readNumThirdImageView.left+23, self.readNumThirdImageView.top-2, 100, 13)];
                self.readNumThirdLabel.textColor=[UIColor grayColor];
                self.readNumThirdLabel.font=[UIFont systemFontOfSize:11];
                self.readNumThirdLabel.textAlignment=NSTextAlignmentLeft;
                [self.thirdView addSubview:self.readNumThirdLabel];
                
            }
        }
    }
    if (indexpathArray.count==0) {
        [self setFrame:CGRectMake(0, 0, 0,0)];
    }
    else
       [self setFrame:CGRectMake(0, 0, kWindowSize.width, self.colorView.bottom+2*MARGIN_HEIGHT)];
    [self.contentView setFrame:self.frame];
    [self.contentView addSubview:self.colorView];
    return  self;
}
//设置cell模型的数据
- (void)setSubjectCellWithModel:(NSMutableArray *)indexpathArray withIndexPath:(NSIndexPath *)indexPath //(KBColumnModel *)model
{
    viewArray = indexpathArray;
    for (int i = 0 ; i<indexpathArray.count; i++) {
        KBColumnModel * model = indexpathArray[i];
        if (i==0) {
            
            self.thirdImageView.image = [UIImage imageNamed:model.thirdTypeName];
            CGRect thirdNameRect = [self thirdNameRect:model.thirdTypeName];
            [self.thirdNameLabel setFrame:CGRectMake(self.thirdImageBackView.right+MARGIN_WIDTH, self.thirdImageBackView.top+5,thirdNameRect.size.width, 20)];
            [self.betweenSecondAndThirdView setFrame:CGRectMake(self.thirdNameLabel.right+3, self.thirdNameLabel.top, 1,self.thirdNameLabel.height)];
            [self.secondNameLabel setFrame:CGRectMake(self.betweenSecondAndThirdView.right + 7, self.thirdNameLabel.top, 80, 20)];
            
            self.thirdNameLabel.text=model.thirdTypeName;
            self.betweenSecondAndThirdView.backgroundColor = KColor_191;
            self.secondNameLabel.text=@"跬步";
            self.HeadImageLabel.text=model.pageTitle;
            
            [self.headImageView yy_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                
            }];
            self.readNumHeadImageView.image=ReadImage;
            self.readNumFirstLabel.text=[model.readNumber stringValue];
            self.TopButtonWithIndexpath.indexPath=indexPath;
            if (self.TopButtonWithIndexpath.whetherTotTop) {
                [self.TopButtonWithIndexpath setTitle:@"取消置顶" forState:UIControlStateNormal];
                [self.TopButtonWithIndexpath addTarget:self action:@selector(cancelToTop:) forControlEvents:UIControlEventTouchUpInside];
                self.colorView.backgroundColor=KColor_253_253_241;
            }
            else
            {
                [self.TopButtonWithIndexpath setTitle:@"置顶" forState:UIControlStateNormal];
                [self.TopButtonWithIndexpath addTarget:self action:@selector(toTop:) forControlEvents:UIControlEventTouchUpInside];
                self.colorView.backgroundColor=[UIColor whiteColor];
            }
            UITapGestureRecognizer *headImageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapDo:)];
            if (model.infoImgType) {
                //添加手势
                [self.headImageView addGestureRecognizer:headImageViewTap];
                //设置tag
                self.headImageView.tag = 0;
                self.headImageView.userInteractionEnabled = YES;
            }
            else
            {
                //添加手势
                [self.FirstView addGestureRecognizer:headImageViewTap];
                //设置tag
                self.FirstView.tag = 0;
                self.FirstView.userInteractionEnabled = YES;

            }
            
        }
        if (i==1)
        {
            [self.artSecondImageView yy_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholder:[UIImage imageNamed:@"载入中小图"] options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
            }];
            self.artSecondTitleLabel.text = model.pageTitle;
            self.readNumSecondLabel.text=[model.readNumber stringValue];
            //添加手势
            UITapGestureRecognizer *secondViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapDo:)];
            [self.secondView addGestureRecognizer:secondViewTap];
            //设置tag
            self.secondView.tag = 1;
            self.secondView.userInteractionEnabled = YES;
            
        }
        if (i==2)
        {
            [self.artThirdImageView yy_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholder:[UIImage imageNamed:@"载入中小图"] options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
            }];
            self.artThirdTitleLabel.text = model.pageTitle;
            self.readNumThirdLabel.text=[model.readNumber stringValue];
            //添加手势
            UITapGestureRecognizer *thirdViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapDo:)];
            [self.thirdView addGestureRecognizer:thirdViewTap];
            //设置tag
            self.thirdView.tag = 2;
            self.thirdView.userInteractionEnabled = YES;
        }
    }
}
// 根据数组设置colorview的大小
-(void)calculateIndexPathArray:(NSArray *)indexPathArray
{
    switch (indexPathArray.count) {
        case 0:
            [self.colorView setFrame:CGRectMake(0, 0, 0, 0)];
            break;
        case 1:
        {
            KBColumnModel * columnModel = indexPathArray[0];
            [self.colorView setFrame:CGRectMake(MARGIN_HEIGHT, MARGIN_HEIGHT, kWindowSize.width-2*MARGIN_HEIGHT,columnModel.infoImgType?(kWindowSize.width-24)*5/12+44:USUAL_CELL_HEIGHT+41)];
        }
            break;
        case 2:
        {
            KBColumnModel * columnModel = indexPathArray[0];
            [self.colorView setFrame:CGRectMake(MARGIN_HEIGHT, MARGIN_HEIGHT, kWindowSize.width-2*MARGIN_HEIGHT,columnModel.infoImgType?(kWindowSize.width-24)*5/12+44+USUAL_CELL_HEIGHT+5:USUAL_CELL_HEIGHT+41+(USUAL_CELL_HEIGHT+5))];
        }
            break;
        case 3:
        {
            KBColumnModel * columnModel = indexPathArray[0];
            [self.colorView setFrame:CGRectMake(MARGIN_HEIGHT, MARGIN_HEIGHT, kWindowSize.width-2*MARGIN_HEIGHT,columnModel.infoImgType?(kWindowSize.width-24)*5/12+44+2*(USUAL_CELL_HEIGHT+5):USUAL_CELL_HEIGHT+41+2*(USUAL_CELL_HEIGHT+5))];
        }
            break;
        default:
            break;
    }
    
}
#pragma mark - 计算三级分类名字的宽度
-(CGRect)thirdNameRect:(NSString *)thirdName
{
    CGRect  rect = [thirdName boundingRectWithSize:CGSizeMake(65, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    return  rect;
}
#pragma mark - 置顶
-(void)toTop:(UIButtonWithIndexPath *)buttonWithIndexPath
{
   
    if ([_delegate respondsToSelector:@selector(touchToTopButton:)]) {
        [_delegate touchToTopButton:buttonWithIndexPath.indexPath];
    }
}
#pragma mark -  取消置顶
-(void)cancelToTop:(UIButtonWithIndexPath * )buttonWithIndexPah
{
    if ([_delegate respondsToSelector:@selector(touchCancelToTopButton:)]) {
        [_delegate touchCancelToTopButton:buttonWithIndexPah.indexPath];
    }
}
#pragma mark - view的点击事件
- (void)viewTapDo:(UITapGestureRecognizer *)tap
{
    KBColumnModel *viewModel =viewArray[tap.view.tag];
    //代理
    if ([_delegate respondsToSelector:@selector(viewTapActionWithColumnModel:)]) {
        
        [_delegate viewTapActionWithColumnModel:viewModel];
    }
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
