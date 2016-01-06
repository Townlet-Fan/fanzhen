//
//  KBWebviewFootAndCollectModel.m
//  UIScroll1
//
//  Created by kuibu technology on 15/12/17.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBWebviewFootAndCollectModel.h"
#import "KBMyCollectionDataModel.h"
#import <sqlite3.h>
#import "KBWebviewInfoModel.h"

@interface KBWebviewFootAndCollectModel()
{
    KBMyCollectionDataModel *collection;//收藏对象
    
    sqlite3 *db;//db数据库
    
    KBWebviewInfoModel * webviewInfoModel; //webview的model
}
@end


@implementation KBWebviewFootAndCollectModel

-(instancetype)init{
    self=[super init];
    if (self) {
       
        
    }
    return self;
}

+(void)insertFootMaskSQL
{
    KBMyCollectionDataModel *collection=[[KBMyCollectionDataModel alloc]init];
    KBWebviewInfoModel * webviewInfoModel=[KBWebviewInfoModel newinstance];
    sqlite3 *db;//db数据库
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh:mm  MM-dd"];
    collection.time= [formatter stringFromDate:[NSDate date]];
    collection.articleTitle=webviewInfoModel.textString;
    collection.TypeName=webviewInfoModel.classString;
    collection.pageID=[NSNumber numberWithInteger:webviewInfoModel.pageId];
    collection.imagestr=webviewInfoModel.imagestr;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:@"Footer.sqlite"];
    
    
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS Footer(ID INTEGER PRIMARY KEY AUTOINCREMENT,pageid INTEGER  , title TEXT, type TEXT, time TEXT,imagestr TEXT,imagedata TEXT,secondType TEXT)";
    char *err;
    if (sqlite3_exec(db, [sqlCreateTable UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库操作数据失败!");
    }
    
    const char * sql="insert into Footer(pageid,title,type,time,imagestr,imagedata,secondType) values(?,?,?,?,?,?,?);";
    sqlite3_stmt *stmp;
    //在执行SQL语句之前检查SQL语句语法,-1代表字符串的长度
    int result= sqlite3_prepare_v2(db, sql, -1, &stmp, NULL);
    if(result==SQLITE_OK){
        NSLog(@"插入SQL语句语法没有问题");
        //绑定参数,插入的参数的下标是从1开始
        sqlite3_bind_int(stmp, 1,  [collection.pageID intValue]);
        sqlite3_bind_text(stmp, 2, [collection.articleTitle UTF8String], -1, nil);
        sqlite3_bind_text(stmp, 3, [collection.TypeName UTF8String], -1, nil);
        sqlite3_bind_text(stmp, 4, [collection.time UTF8String], -1, nil);
        sqlite3_bind_text(stmp, 5, [collection.imagestr UTF8String], -1, nil);
        
        sqlite3_bind_blob(stmp, 6, [webviewInfoModel.imageData bytes], (int)[webviewInfoModel.imageData length], NULL);
        sqlite3_bind_text(stmp, 7, [[NSString stringWithFormat:@"%@",webviewInfoModel.secondType]UTF8String],-1,nil);
        //执行参参数的SQL语句，不能有exec
        int result=sqlite3_step(stmp);
        //插入进行判断,要用sqLite_Done来判断
        if(result==SQLITE_DONE){
            NSLog(@"插入成功");
            
        }
        else{
            NSLog(@"插入失败") ;
        }
        
    }
    else{
        NSLog(@"插入SQL语句有问题");
    }
    sqlite3_close(db);
}

+(void)deleteFooter;
{

    KBWebviewInfoModel * webviewInfoModel=[KBWebviewInfoModel newinstance];
    sqlite3 *db;//db数据库
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:@"Footer.sqlite"];
    
    
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    NSString * sqldel=@"DELETE FROM Footer WHERE pageid =?";
    sqlite3_stmt *stmp;
    int result= sqlite3_prepare_v2(db, [sqldel UTF8String], -1, &stmp, nil);
    if(result!=SQLITE_OK){
        NSLog(@"Error: failed to delete:testTable");
        sqlite3_close(db);
        
    }
    else{
        
        sqlite3_bind_int(stmp, 1,[[NSString stringWithFormat:@"%ld",(long)webviewInfoModel.pageId] intValue]);
        //NSLog(@"pageId:%ld",(long)webviewInfoModel.pageId);
        int r = sqlite3_step(stmp);
        if (r==SQLITE_DONE) {
            NSLog(@"删除done!!!!");
        }
        else{
            NSLog(@"删除SQL语句有问题");
        }
    }
    

}

+(void)deleteHavecollect;
{
   
    KBWebviewInfoModel * webviewInfoModel=[KBWebviewInfoModel newinstance];
    sqlite3 *db;//db数据库
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:@"Footer.sqlite"];
    
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    //NSString *sqlQuery = @"SELECT * FROM Footer ";
    NSString * sqldel=@"DELETE FROM Collection WHERE pageid =?";
    sqlite3_stmt *stmp;
    int result= sqlite3_prepare_v2(db, [sqldel UTF8String], -1, &stmp, nil);
    if(result!=SQLITE_OK){
        NSLog(@"Error: failed to delete:testTable");
        sqlite3_close(db);
        
    }
    else{
        sqlite3_bind_int(stmp, 1, [[NSString stringWithFormat:@"%ld",(long)webviewInfoModel.pageId] intValue]);
        int r = sqlite3_step(stmp);
        if (r==SQLITE_DONE) {
            NSLog(@"done!!!!");
        }
        else{
            NSLog(@"删除SQL语句有问题");
        }
    }

}
+(BOOL )insertCollect
{
    KBMyCollectionDataModel *collection=[[KBMyCollectionDataModel alloc]init];
    KBWebviewInfoModel * webviewInfoModel=[KBWebviewInfoModel newinstance];
    sqlite3 *db;//db数据库
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh:mm  MM-dd"];
    collection=[[KBMyCollectionDataModel alloc]init];
    collection.time= [formatter stringFromDate:[NSDate date]];
    collection.articleTitle=webviewInfoModel.textString;
    collection.TypeName=webviewInfoModel.classString;
    collection.pageID=[NSNumber numberWithInteger:webviewInfoModel.pageId];
    collection.imagestr=webviewInfoModel.imagestr;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:@"Footer.sqlite"];
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS Collection(ID INTEGER PRIMARY KEY AUTOINCREMENT,pageid INTEGER , title TEXT, type TEXT, secondType TEXT,time TEXT,imagestr TEXT,imagedata TEXT)";
    char *err;
    if (sqlite3_exec(db, [sqlCreateTable UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库操作数据失败!");
    }
    const char * sql=
    "insert into Collection(pageid,title,type,secondType,time,imagestr,imagedata) values(?,?,?,?,?,?,?);";
    
    sqlite3_stmt *stmp;
    //在执行SQL语句之前检查SQL语句语法,-1代表字符串的长度
    int result= sqlite3_prepare_v2(db, sql, -1, &stmp, NULL);
    if(result==SQLITE_OK){
        
        
        
        
        sqlite3_bind_int(stmp, 1,  [collection.pageID intValue]);
        sqlite3_bind_text(stmp, 2, [collection.articleTitle UTF8String], -1, nil);
        sqlite3_bind_text(stmp, 3, [collection.TypeName UTF8String], -1, nil);
       sqlite3_bind_text(stmp, 4, [[NSString stringWithFormat:@"%@",webviewInfoModel.secondType]UTF8String],-1,nil);
        sqlite3_bind_text(stmp, 5, [collection.time UTF8String], -1, nil);
        sqlite3_bind_text(stmp, 6, [collection.imagestr UTF8String], -1, nil);
        sqlite3_bind_blob(stmp, 7, [webviewInfoModel.imageData bytes], (int)[webviewInfoModel.imageData length], nil);
        //绑定参数,插入的参数的下标是从1开始
        
        //执行参参数的SQL语句，不能有exec
        
        int result=sqlite3_step(stmp);
        //插入进行判断,要用sqLite_Done来判断
        if(result==SQLITE_DONE){
             sqlite3_close(db);
            return YES;
        }
        else{
            sqlite3_close(db);
            return NO;
        }
        
    }
    else{
        
    }
    sqlite3_close(db);
    return NO;

}
+(BOOL)deleteCollect
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:@"Footer.sqlite"];
    sqlite3 *db;//db数据库
   KBWebviewInfoModel * webviewInfoModel=[KBWebviewInfoModel newinstance];
    
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    
    const char * sql="delete from Collection   where pageid=?";
    sqlite3_stmt *stmp;
    //根据ID删除，根据PageID？
    
    int result= sqlite3_prepare_v2(db, sql, -1, &stmp, NULL);
    if(result==SQLITE_OK){
        int ID;
        ID=[[NSString stringWithFormat:@"%ld",(long)webviewInfoModel.pageId] intValue];
        
        sqlite3_bind_int(stmp, 1, ID );
        int r=  sqlite3_step(stmp);
        if(r==SQLITE_DONE){
            sqlite3_close(db);
            return YES;
        }
        else{
            sqlite3_close(db);
            return NO;
        }
        
    }
    else{
       
    }
    sqlite3_close(db);
    return NO;
}
@end
