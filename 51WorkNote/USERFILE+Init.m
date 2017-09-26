//
//  USERFILE+Init.m
//  51WorkNote
//
//  Created by Ivan_deng on 2017/9/26.
//  Copyright © 2017年 Ivan_deng. All rights reserved.
//

#import "USERFILE+Init.h"

@implementation USERFILE (Init)

- (instancetype)initWithName:(NSString *)userName AndPassword:(NSString *)passWord AndValid:(int)valid AndIssigned:(BOOL)issigned {
    self = [super init];
    self.username = userName;
    self.password = passWord;
    self.valid = valid;
    self.issigned = issigned;
    return self;
}

@end
