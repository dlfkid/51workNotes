//
//  NOTEDATA+CoreDataProperties.h
//  51WorkNote
//
//  Created by Ivan_deng on 2017/9/25.
//  Copyright © 2017年 Ivan_deng. All rights reserved.
//
//

#import "NOTEDATA+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface NOTEDATA (CoreDataProperties)

+ (NSFetchRequest<NOTEDATA *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *content;
@property (nonatomic) int16_t noteid;
@property (nullable, nonatomic, copy) NSString *timestamp;
@property (nullable, nonatomic, copy) NSString *userid;

@end

NS_ASSUME_NONNULL_END
