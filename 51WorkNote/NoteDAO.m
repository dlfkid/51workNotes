//
//  NoteDAO.m
//  51WorkNote
//
//  Created by Ivan_deng on 2017/9/22.
//  Copyright © 2017年 Ivan_deng. All rights reserved.
//

#pragma mark - Definitions
#define HOSTNAME @"http://www.51work6.com/service/mynotes/WebService.php"
#define VALIDTIME 10

#pragma mark - Importations
#import "NSNumber+Messager.h"
#import "Note.h"
#import "UserID.h"
#import "NoteDAO.h"
#import "MainViewController.h"
#import "NOTEDATA+CoreDataClass.h"
#import "USERFILE+CoreDataClass.h"
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
        sharedSingleton.IDStorage = [NSMutableArray array];
    }
    return sharedSingleton;
}


#pragma mark - NSURLSessionRequst
- (void)downLoadNoteFromServer {
    NSLog(@"Downloading server note data");
    NSString *getURlString = [[NSString alloc]initWithFormat:@"http://www.51work6.com/service/mynotes/WebService.php?email=%@&type=JSON&action=query",_currentID.username];
    getURlString = [getURlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *getURL = [NSURL URLWithString:getURlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:getURL];
    
    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfig delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error : %@",error.localizedDescription);
        }else if(data != nil) {
            NSLog(@"analizing recived server data");
            NSError *error = nil;
            NSDictionary *recieveDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if(error) {
                NSLog(@"Error occur: %@",error.localizedDescription);
            }
            [self analyzeData:recieveDict];
        }else {
            NSLog(@"Empty Data recived");
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
            Note *newNote = [[Note alloc]initWithUserid:nil AndNoteid:noteID  AndContent:noteDict[@"Content"] AndDate:noteDict[@"CDate"]];
            newNote.userid = [self currentID].username;
            [self.severNotes addObject:newNote];
            NSLog(@"read note %@ success",newNote.content);
        }
    }else{
        NSLog(@"ResultCode : %@",errMsg);
    }
}

- (void)uploadNotesToServer:(Note *)note {
    NSString *hostUrlStr = HOSTNAME;
    NSURL *hostUrl = [NSURL URLWithString:hostUrlStr];
    NSString *requestBodyStr = [NSString stringWithFormat:@"email=%@&type=JSON&action=add&date=%@&content=%@",_currentID.username,note.timestamp,note.content];
    NSData *requestBody = [requestBodyStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:hostUrl];
    [request setHTTPBody:requestBody];
    [request setHTTPMethod:@"POST"];
    
    NSURLSession *shared = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [shared dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error : %@",error.localizedDescription);
        }else{
            NSDictionary *DataRecive = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSNumber *resultCode = DataRecive[@"ResultCode"];
            NSLog(@"ResultCode:%@",[resultCode errMessage]);
        }
    }];
    [task resume];
}

- (void)deleteNotesFromServer:(Note *)note {
    NSString *hostUrlStr = HOSTNAME;
    NSURL *hostUrl = [NSURL URLWithString:hostUrlStr];
    NSString *requestBodyStr = [NSString stringWithFormat:@"email=%@&type=JSON&action=remove&id=%@",_currentID.username,note.noteid];
    NSData *requestBody = [requestBodyStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:hostUrl];
    [request setHTTPBody:requestBody];
    [request setHTTPMethod:@"POST"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error : %@",error.localizedDescription);
        }else{
            NSDictionary *DataRecive = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSNumber *resultCode = DataRecive[@"ResultCode"];
            NSLog(@"ResultCode:%@",[resultCode errMessage]);
        }
    }];
    [task resume];
}

- (void)modifyNotesFromServer:(Note *)note {
    NSString *hostURLStr = HOSTNAME;
    NSURL *hostURL = [NSURL URLWithString:hostURLStr];
    NSString *requestBodyStr = [NSString stringWithFormat:@"email=%@&type=JSON&action=modify&date=%@&content=%@&id=%@",_currentID.username,note.timestamp,note.content,note.noteid];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:hostURL];
    [request setHTTPBody:[requestBodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error : %@",error.localizedDescription);
        }else{
            NSDictionary *DataRecive = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSNumber *resultCode = DataRecive[@"ResultCode"];
            NSLog(@"ResultCode:%@",[resultCode errMessage]);
        }
    }];
    [task resume];
}

#pragma mark - Synchrinuzation method

- (void)notesSynchrinuzation {
    //下载服务器上的笔记内容
    if(self.severNotes.count != 0) {
        //比较本地notes和服务器notes，将服务器上有而本地没有的notes下载到本地
        NSPredicate *filterServer = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",self.localNotes];
        NSArray *downloadNotes = [self.severNotes filteredArrayUsingPredicate:filterServer];
        NSLog(@"%lu notes prepared to be download",downloadNotes.count);
        for(Note *download in downloadNotes) {
            [self.localNotes addObject:download];
            [self addANote:download];
        }
    }
    if(self.localNotes.count != 0) {
        //再次比较本地notes和服务器notes，将本地已有而服务器上没有的note上传
        NSPredicate *filterLocal = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",self.severNotes];
        NSArray *uploadNotes = [self.localNotes filteredArrayUsingPredicate:filterLocal];
        NSLog(@"%lu notes prepared to be upload",uploadNotes.count);
        for(Note *upload in uploadNotes) {
            [self uploadNotesToServer:upload];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"netWorkFinished" object:nil];
}

- (NSMutableArray *)loadAllNote {
    if(_localNotes.count == 0) {
        [self loadNotesFromCoreData];
    }
    return _localNotes;
}

- (void)unloadAllNotes {
    [self.localNotes removeAllObjects];
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
            if([newNote.userid isEqualToString:_currentID.username])
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
    NSLog(@"New note added to data core");
    [self saveContext];
}

- (void)removeNote:(Note *)targetNote {
    [self deleteNotesFromServer:targetNote];
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
    [self modifyNotesFromServer:targetNote];
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
        NSLog(@"Note ID: %d modified content:%@",target.noteid,target.content);
        [self saveContext];
    }else {
        NSLog(@"Do not find target Notes");
    }
}

#pragma mark - IDmanagement
- (void)getAllIDs {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entityDesctiption = [NSEntityDescription entityForName:@"USERFILE" inManagedObjectContext:context];
    NSFetchRequest *fetchReq = [[NSFetchRequest alloc]init];
    fetchReq.entity = entityDesctiption;
    
    NSSortDescriptor *sortDes = [[NSSortDescriptor alloc]initWithKey:@"username" ascending:true];
    NSArray *sortResult = @[sortDes];
    fetchReq.sortDescriptors = sortResult;
    
    NSError *error = nil;
    NSArray *listData = [context executeFetchRequest:fetchReq error:&error];
    if(error){
        NSLog(@"Error : %@",error.localizedDescription);
    }else{
        for(USERFILE *userData in listData) {
            [self.IDStorage addObject:userData];
            }
        }
}

- (BOOL)fliterQualifiedIDs {
    if(self.IDStorage.count > 0) {
        for(USERFILE *sample in self.IDStorage) {
            if(sample.valid <= VALIDTIME){
                if(sample.issigned == true) {
                    sample.valid += 1;
                    _currentID = [[UserID alloc]initWithName:sample.username AndPassword:sample.password AndValid:sample.valid AndIssigned:sample.issigned];
                    [self modifyUserFile:sample];
                    NSLog(@"Recent signed in ID found.");
                    return true;
                }
            }else {
                sample.valid = 0;
                sample.issigned = false;
                [self modifyUserFile:sample];
            }
        }
    }
    return false;
}

- (void)registUserIDwithName:(NSString *)userName
                 AndPassword:(NSString *)passWord
                    AndValid:(int)valid
                 AndIssigned:(BOOL)issigned {
    NSManagedObjectContext *context = [self managedObjectContext];
    USERFILE *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"USERFILE" inManagedObjectContext:context];
    newUser.username = userName;
    newUser.password = passWord;
    newUser.valid = valid;
    newUser.issigned = issigned;
    _currentID = [[UserID alloc]initWithName:newUser.username AndPassword:newUser.password AndValid:newUser.valid AndIssigned:newUser.issigned];
    [self saveContext];
}

- (void)modifyUserFile:(USERFILE *)userFile {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entityDes = [NSEntityDescription entityForName:@"USERFILE" inManagedObjectContext:context];
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    fetch.entity = entityDes;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username = %@",userFile.username];
    [fetch setPredicate:predicate];
    NSError *error = nil;
    NSArray *listData = [context executeFetchRequest:fetch error:&error];
    if(error) {
        NSLog(@"Error : %@",error.localizedDescription);
    }else if(listData.count != 0) {
        USERFILE *target = listData.lastObject;
        target.username = userFile.username;
        target.password = userFile.password;
        target.valid = userFile.valid;
        target.issigned = userFile.issigned;
        [self saveContext];
    }else {
        NSLog(@"Do not find target ID");
    }
}


@end
