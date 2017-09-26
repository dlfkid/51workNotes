//
//  NoteDAO.h
//  51WorkNote
//
//  Created by Ivan_deng on 2017/9/22.
//  Copyright © 2017年 Ivan_deng. All rights reserved.
//

#import "CoreDataManager.h"


@class Note;
@class USERFILE;
@interface NoteDAO : CoreDataManager<NSURLSessionDelegate>

@property(atomic,strong) NSMutableArray *severNotes;
@property(atomic,strong) NSMutableArray *localNotes;
@property(atomic,strong) NSMutableArray *IDStorage;
@property(nonatomic,copy) USERFILE *UserID;


+ (NoteDAO *)sharedNoteDao;

- (NSMutableArray *)loadAllNote;

- (void)downLoadNoteFromServer;

- (void)notesSynchrinuzation;

- (void)addANote:(Note *)newNote;

- (void)removeNote:(Note *)targetNote;

- (void)modifyNote:(Note *)targetNote;

- (void)getAllIDs;

- (void)registUserIDwithName:(NSString *)userName
                 AndPassword:(NSString *)passWord
                    AndValid:(int)valid
                 AndIssigned:(BOOL)issigned;

- (BOOL)fliterQualifiedIDs;

- (void)modifyUserFile:(USERFILE *)userFile;


@end
