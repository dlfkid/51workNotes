//
//  USERFILE+Init.h
//  51WorkNote
//
//  Created by Ivan_deng on 2017/9/26.
//  Copyright © 2017年 Ivan_deng. All rights reserved.
//

#import "USERFILE+CoreDataClass.h"

@interface USERFILE (Init)

- (instancetype)initWithName:(NSString *)userName
                 AndPassword:(NSString *)passWord
                    AndValid:(int)valid
                 AndIssigned:(BOOL)issigned;

@end
