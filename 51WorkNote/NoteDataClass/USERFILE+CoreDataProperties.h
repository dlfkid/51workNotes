//
//  USERFILE+CoreDataProperties.h
//  51WorkNote
//
//  Created by Ivan_deng on 2017/9/25.
//  Copyright © 2017年 Ivan_deng. All rights reserved.
//
//

#import "USERFILE+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface USERFILE (CoreDataProperties)

+ (NSFetchRequest<USERFILE *> *)fetchRequest;

@property (nonatomic) BOOL issigned;
@property (nullable, nonatomic, copy) NSString *password;
@property (nullable, nonatomic, copy) NSString *username;
@property (nonatomic) int16_t valid;

@end

NS_ASSUME_NONNULL_END
