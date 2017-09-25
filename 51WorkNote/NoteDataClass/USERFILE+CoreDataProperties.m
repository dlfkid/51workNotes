//
//  USERFILE+CoreDataProperties.m
//  51WorkNote
//
//  Created by Ivan_deng on 2017/9/25.
//  Copyright © 2017年 Ivan_deng. All rights reserved.
//
//

#import "USERFILE+CoreDataProperties.h"

@implementation USERFILE (CoreDataProperties)

+ (NSFetchRequest<USERFILE *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"USERFILE"];
}

@dynamic issigned;
@dynamic password;
@dynamic username;
@dynamic valid;

@end
