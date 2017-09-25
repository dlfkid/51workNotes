//
//  NOTEDATA+CoreDataProperties.m
//  51WorkNote
//
//  Created by Ivan_deng on 2017/9/25.
//  Copyright © 2017年 Ivan_deng. All rights reserved.
//
//

#import "NOTEDATA+CoreDataProperties.h"

@implementation NOTEDATA (CoreDataProperties)

+ (NSFetchRequest<NOTEDATA *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"NOTEDATA"];
}

@dynamic content;
@dynamic noteid;
@dynamic timestamp;
@dynamic userid;

@end
