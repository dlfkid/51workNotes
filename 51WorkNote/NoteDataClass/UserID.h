//
//  UserID.h
//  51WorkNote
//
//  Created by Ivan_deng on 2017/9/27.
//  Copyright © 2017年 Ivan_deng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserID : NSObject

@property(nonatomic,copy) NSString *username;
@property(nonatomic,copy) NSString *password;
@property(nonatomic,assign) int valid;
@property(nonatomic,assign) BOOL issigned;

- (instancetype)initWithName:(NSString *)name
                 AndPassword:(NSString *)passWord
                    AndValid:(int)valid
                 AndIssigned:(BOOL)issigned;

+ (UserID *)userIDWithName:(NSString *)name AndPassword:(NSString *)passWord AndValid:(int)valid AndIssigned:(BOOL)issigned;

@end
