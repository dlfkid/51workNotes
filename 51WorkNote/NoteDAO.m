//
//  NoteDAO.m
//  51WorkNote
//
//  Created by Ivan_deng on 2017/9/22.
//  Copyright © 2017年 Ivan_deng. All rights reserved.
//

#pragma mark - Definitions
#define HOSTNAME @"http://www.51work6.com/service/mynotes/WebService.php"

#pragma mark - Importations
#import "NSNumber+Messager.h"
#import "Note.h"
#import "NoteDAO.h"
#import "MainViewController.h"
#import "NOTEDATA+CoreDataClass.h"
#import <UIKit/UIKit.h>

static NoteDAO * sharedSingleton;

@implementation NoteDAO

+ (NoteDAO *)sharedNoteDao {
    if(sharedSingleton == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedSingleton = [[NoteDAO alloc]init];
        });
        sharedSingleton.severNotes = [NSMutableArray array];
        sharedSingleton.localNotes = [NSMutableArray array];
    }
    return sharedSingleton;
}


#pragma mark - NSURLSessionRequst
- (void)downLoadNoteFromServer {
    NSString *hostUrlStr = HOSTNAME;
    NSURL *hostUrl = [NSURL URLWithString:hostUrlStr];
    NSString *requestBodyStr = [NSString stringWithFormat:@"email=%@&type=JSON&action=query",self.UserID];
    NSData *requestBody = [requestBodyStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:hostUrl];
    [request setHTTPBody:requestBody];
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error) {
            NSLog(@"Error : %@",error.localizedDescription);
        }else{
            NSDictionary *recieveDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            [self analyzeData:recieveDict];
        }
    }];
    [task resume];
}

- (void)analyzeData:(NSDictionary *)resdict {
    NSNumber *resultCode = resdict[@"ResultCode"];
    NSString *errMsg = [resultCode errMessage];
    if([resultCode integerValue] >= 0){
        NSArray *notesDict = resdict[@"Record"];
        for( NSDictionary *noteDict in notesDict ) {
            NSString *noteidStr = noteDict[@"ID"];
            int noteID = [noteidStr intValue];
            Note *newNote = [[Note alloc]initWithUserid:noteDict[@"UserID"] AndNoteid:noteID  AndContent:noteDict[@"Content"] AndDate:noteDict[@"CDate"]];
            [self.severNotes addObject:newNote];
        }
        NSLog(@"read note success");
    }else{
        NSLog(@"Error occur : %@",errMsg);
    }
}

- (void)uploadNotesToServer:(Note *)note {
    NSString *hostUrlStr = HOSTNAME;
    NSURL *hostUrl = [NSURL URLWithString:hostUrlStr];
    NSString *requestBodyStr = [NSString stringWithFormat:@"email=%@&type=JSON&action=add&date=%@&content=%@",self.UserID,note.timestamp,note.content];
    NSData *requestBody = [requestBodyStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:hostUrl];
    [request setHTTPBody:requestBody];
    [request setHTTPMethod:@"POST"];
    
    NSURLSession *shared = [NSURLSession sharedSession];
    [shared dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error : %@",error.localizedDescription);
        }else{
            NSDictionary *DataRecive = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSNumber *resultCode = DataRecive[@"ResultCode"];
            NSLog(@"ResultCode:%@",[resultCode errMessage]);
        }
    }];
}

- (void)deleteNotesFromServer:(Note *)note {
    NSString *hostUrlStr = HOSTNAME;
    NSURL *hostUrl = [NSURL URLWithString:hostUrlStr];
    NSString *requestBodyStr = [NSString stringWithFormat:@"email=%@&type=JSON&action=remove&id=%@",self.UserID,note.noteid];
    NSData *requestBody = [requestBodyStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:hostUrl];
    [request setHTTPBody:requestBody];
    [request setHTTPMethod:@"POST"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error : %@",error.localizedDescription);
        }else{
            NSDictionary *DataRecive = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSNumber *resultCode = DataRecive[@"ResultCode"];
            NSLog(@"ResultCode:%@",[resultCode errMessage]);
        }
    }];
}

- (void)modifyNotesFromServer:(Note *)note {
    NSString *hostURLStr = HOSTNAME;
    NSURL *hostURL = [NSURL URLWithString:hostURLStr];
    NSString *requestBodyStr = [NSString stringWithFormat:@"email=%@&type=JSON&action=modify&date=%@&content=%@&id=%@",self.UserID,note.timestamp,note.content,note.noteid];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:hostURL];
    [request setHTTPBody:[requestBodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error : %@",error.localizedDescription);
        }else{
            NSDictionary *DataRecive = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSNumber *resultCode = DataRecive[@"ResultCode"];
            NSLog(@"ResultCode:%@",[resultCode errMessage]);
        }
    }];
}

- (void)notesSynchrinuzation {
    NSPredicate *filterLocal = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",self.severNotes];
    NSArray *uploadNotes = [self.localNotes filteredArrayUsingPredicate:filterLocal];
    for(Note *upload in uploadNotes) {
        [self uploadNotesToServer:upload];
    }
    NSPredicate *filterServer = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",self.localNotes];
    NSArray *deleteNotes = [self.severNotes filteredArrayUsingPredicate:filterServer];
    for(Note *delete in deleteNotes) {
        [self deleteNotesFromServer:delete];
    }
}

- (NSMutableArray *)loadAllNote {
    
    return _localNotes;
}

#pragma mark - CoreDataFunction

- (void)loadNotesFromCoreData {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entityDesctiption = [NSEntityDescription entityForName:@"NOTEDATA" inManagedObjectContext:context];
    NSFetchRequest *fetchReq = [[NSFetchRequest alloc]init];
    fetchReq.entity = entityDesctiption;
    
    NSSortDescriptor *sortDes = [[NSSortDescriptor alloc]initWithKey:@"noteid" ascending:true];
    NSArray *sortResult = @[sortDes];
    fetchReq.sortDescriptors = sortResult;
    
    NSError *error = nil;
    NSArray *listData = [context executeFetchRequest:fetchReq error:&error];
    if(error){
        NSLog(@"Error : %@",error.localizedDescription);
    }else{
        for(NOTEDATA *noteData in listData) {
            Note *newNote = [[Note alloc]initWithUserid:noteData.userid AndNoteid:noteData.noteid AndContent:noteData.content AndDate:noteData.timestamp];
            [self.localNotes addObject:newNote];
        }
    }
}

- (void)addANote:(Note *)newNote {
    NSManagedObjectContext *context = [self managedObjectContext];
    NOTEDATA *noteData = [NSEntityDescription insertNewObjectForEntityForName:@"NOTEDATA" inManagedObjectContext:context];
    noteData.timestamp = newNote.timestamp;
    noteData.noteid = [newNote.noteid intValue];
    noteData.content = newNote.content;
    noteData.userid = newNote.userid;
    [self saveContext];
}

- (void)removeNote:(Note *)targetNote {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entityDes = [NSEntityDescription entityForName:@"NOTEDATA" inManagedObjectContext:context];
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    fetch.entity = entityDes;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"noteid = %@",targetNote.noteid];
    [fetch setPredicate:predicate];
    NSError *error = nil;
    NSArray *listData = [context executeFetchRequest:fetch error:&error];
    if(error) {
        NSLog(@"Error : %@",error.localizedDescription);
    }else if(listData.count != 0) {
        NOTEDATA *target = listData.lastObject;
        [context deleteObject:target];
    }else {
        NSLog(@"Do not find target Notes");
    }
}

- (void)modifyNote:(Note *)targetNote {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entityDes = [NSEntityDescription entityForName:@"NOTEDATA" inManagedObjectContext:context];
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    fetch.entity = entityDes;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"noteid = %@",targetNote.noteid];
    [fetch setPredicate:predicate];
    NSError *error = nil;
    NSArray *listData = [context executeFetchRequest:fetch error:&error];
    if(error) {
        NSLog(@"Error : %@",error.localizedDescription);
    }else if(listData.count != 0) {
        NOTEDATA *target = listData.lastObject;
        target.timestamp = targetNote.timestamp;
        target.content = targetNote.content;
        [self saveContext];
    }else {
        NSLog(@"Do not find target Notes");
    }
}

@end
