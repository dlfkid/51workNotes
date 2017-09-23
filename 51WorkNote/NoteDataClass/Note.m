//
//  Note.m
//  51WorkNote
//
//  Created by Ivan_deng on 2017/9/22.
//  Copyright © 2017年 Ivan_deng. All rights reserved.
//

#import "Note.h"

@implementation Note

- (instancetype)initWithUserid:(NSString *)userid AndNoteid:(int)noteid AndContent:(NSString *)content AndDate:(NSString *)timeStamp {
    self = [super init];
    self.userid = userid;
    self.noteid = [NSNumber numberWithInteger:noteid];
    self.content = content;
    self.timestamp = timeStamp;
    return self;
}

+ (Note *)noteWithCurrentTimeStamp:(int)noteid userid:(NSString *)userID content:(NSString *)content {
    NSDate *currentDate = [[NSDate alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    NSString *timeStamp = [formatter stringFromDate:currentDate];
    Note *newNote = [[self alloc]initWithUserid:userID AndNoteid:noteid AndContent:content AndDate:timeStamp];
    return newNote;
}

@end
