//
//  UserID.m
//  51WorkNote
//
//  Created by Ivan_deng on 2017/9/27.
//  Copyright © 2017年 Ivan_deng. All rights reserved.
//

#import "UserID.h"

@implementation UserID

- (instancetype)initWithName:(NSString *)name AndPassword:(NSString *)passWord AndValid:(int)valid AndIssigned:(BOOL)issigned {
    self = [super init];
    self.username = name;
    self.password = passWord;
    self.valid = valid;
    self.issigned = issigned;
    return self;
}

+ (UserID *)userIDWithName:(NSString *)name AndPassword:(NSString *)passWord AndValid:(int)valid AndIssigned:(BOOL)issigned {
    UserID *newID = [[self alloc] initWithName:name AndPassword:passWord AndValid:valid AndIssigned:issigned];
    return newID;
}

@end
