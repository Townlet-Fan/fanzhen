//
//  KBWebviewInfoModel.m
//  UIScroll1
//
//  Created by kuibu technology on 15/12/12.
//  Copyright © 2015年 Test. All rights reserved.
//



#import "KBWebviewInfoModel.h"
#import "KBColumnModel.h"
#import "KBConstant.h"
#import "KBLoginSingle.h"
#import "KBTwoSortModel.h"
#import "KBHomeArticleModel.h"
#import "KBMyCollectionDataModel.h"
@implementation KBWebviewInfoModel

-(instancetype)init{
    self=[super init];
    if (self) {
        
    }
    return self;
}
+(KBWebviewInfoModel *)newinstance{
    static KBWebviewInfoModel * webviewInfoModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        webviewInfoModel=[[KBWebviewInfoModel alloc]init];
    });
    
    return webviewInfoModel;
}
-(void)setWebviewInfoColumnModel:(KBColumnModel * )columnModel
{
    _pageId=[columnModel.pageId integerValue];
    
    _textString=columnModel.pageTitle;
    _imagestr=columnModel.imageSrc;
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        _imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:_imagestr]];
    });
    _secondType=columnModel.secondType;
    
    _classString=columnModel.thirdTypeName;
    
    _shareURL=KWebviewUrl(kBaseUrl, _pageId);
    _readWebViewInfoCount=0;
    _isHomeTypeClass = false;
    for (NSMutableArray *typeOne in [KBLoginSingle newinstance].userAllTypeArray) {
        
        for (KBTwoSortModel *typeTwo in typeOne) {
            if (typeTwo.TypeTowID==[columnModel.secondType integerValue]) {
                if ([[KBLoginSingle newinstance].userAllTypeArray indexOfObject:typeOne]==4) {
                    _isHomeTypeClass= true;
                    
                } else {
                    _isHomeTypeClass = false;
                    
                }
                break;
            }
        }
    }

}
-(void)setWebviewInfoArticleModel:(KBHomeArticleModel * )articleModel
{
   
    _pageId=[[NSString stringWithFormat:@"%@",articleModel.pageId]integerValue];
    _textString=articleModel.firstTitle;
    _imagestr=articleModel.imageSrc;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        _imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:_imagestr]];
    });
    
    _secondType=articleModel.secondType;
    
    _classString=articleModel.thirdTypeName;
    
    _shareURL=KWebviewUrl(kBaseUrl, _pageId);
    _readWebViewInfoCount=0;
    _isHomeTypeClass = false;
    for (NSMutableArray *typeOne in [KBLoginSingle newinstance].userAllTypeArray) {
        
        for (KBTwoSortModel *typeTwo in typeOne) {
            if (typeTwo.TypeTowID==[articleModel.secondType integerValue]) {
                if ([[KBLoginSingle newinstance].userAllTypeArray indexOfObject:typeOne]==4) {
                    _isHomeTypeClass= true;
                    
                } else {
                    _isHomeTypeClass = false;
                    
                }
                break;
            }
        }
    }
    
}

-(void)setWebviewInfoMyCollectionDataModel:(KBMyCollectionDataModel * )myCollectionDataModel
{
    _pageId=[myCollectionDataModel.pageID integerValue];
    
    _textString=myCollectionDataModel.articleTitle;
    _imagestr=myCollectionDataModel.imagestr;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        _imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:_imagestr]];
    });
    //NSString 转 NSNumber
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    _secondType=[numberFormatter numberFromString :myCollectionDataModel.secondType] ;
    
    _classString=myCollectionDataModel.TypeName;
    
    _shareURL=KWebviewUrl(kBaseUrl, _pageId);
    _readWebViewInfoCount=0;
    _isHomeTypeClass = false;
    for (NSMutableArray *typeOne in [KBLoginSingle newinstance].userAllTypeArray) {
        
        for (KBTwoSortModel *typeTwo in typeOne) {
            if (typeTwo.TypeTowID==[myCollectionDataModel.secondType integerValue]) {
                if ([[KBLoginSingle newinstance].userAllTypeArray indexOfObject:typeOne]==4) {
                    _isHomeTypeClass= true;
                    
                } else {
                    _isHomeTypeClass = false;
                    
                }
                break;
            }
        }
    }

}


@end
