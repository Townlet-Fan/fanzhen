
//
//  UICopyLable.m
//  UIScroll1
//
//  Created by eddie on 15-4-17.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "UICopyLable.h"
#import "KBInfoTableViewController.h"
@implementation UICopyLable
@synthesize isLongPressing;
@synthesize cellDelegate;
@synthesize tableDelegate;
@synthesize isHaveHot;
@synthesize respondNameStr;
@synthesize commentid;
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addLongPressgesture];
        
        isLongPressing=NO;
    }
    return self;
}
-(void)addLongPressgesture{
    self.userInteractionEnabled = YES;  //用户交互的总开关
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.numberOfTapsRequired=2;
    [self addGestureRecognizer:longPress];
}
-(void)handleLongPress:(UIGestureRecognizer*) recognizer{
    
    //[self setBackgroundColor:[UIColor grayColor]];
//    [self becomeFirstResponder];
//    UIMenuController *menu = [UIMenuController sharedMenuController];
//    
//    
//    
//    UIMenuItem *copyItem=[[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyStrOnLable)];
//    menu.menuItems=nil;
//    menu.menuItems=[NSArray arrayWithObjects:copyItem, nil];
//    [menu setTargetRect:self.frame inView:self.superview];
//    
//    [menu setMenuVisible:YES animated:YES];
    [self becomeFirstResponder];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:self.frame inView:self.superview];
    [menu setMenuVisible:YES animated:YES];
    //[self setBackgroundColor:[UIColor whiteColor]];
}
-(BOOL)canBecomeFirstResponder{
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
//    if(action==@selector(copyStrOnLable))
//        return YES;
//    else
//        return NO;
     return (action == @selector(copy:));
}
-(void)copy:(id)sender

{
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    
    pboard.string = self.text;
    
} 


//-(void)copyStrOnLable{
//    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
//    pboard.string = self.text;
//}
//
//
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [self setBackgroundColor:[UIColor grayColor]];
//    NSLog(@"begin");
//}
//-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"cancle");
//    [self setBackgroundColor:[UIColor whiteColor]];
//    
//}
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    [self setBackgroundColor:[UIColor whiteColor]];
//    //    if (isHaveHot)
//    // {
//    //        UITableViewCell *cell=cellDelegate;
//    //        HaveHotTableVC *HotVC=tableDelegate;
//    //        [HotVC.haveHotTableView setContentOffset:CGPointMake(0, cell.frame.origin.y-cell.frame.size.height) animated:YES];        [HotVC.textView becomeFirstResponder];
//    //        HotVC.placeHolderLable.text=[[NSString alloc]initWithFormat: @"回复:%@",self.respondNameStr ];
//    //        HotVC.placeHolderStr=HotVC.placeHolderLable.text;
//    //        HotVC.commentId=self.commentid;
//    //    }
//    //    else{
//    
//    //    }
//    //
//    
//}
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    
//}
@end
