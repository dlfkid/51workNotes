//
//  NSNumber+Messager.m
//  MyNoteNSURLSession
//
//  Created by Ivan_deng on 2017/1/18.
//  Copyright © 2017年 Ivan_deng. All rights reserved.
//

#import "NSNumber+Messager.h"

@implementation NSNumber (Messager)

- (NSString *)errMessage {
    NSString * errStr = @"";
    switch ([self integerValue]) {
        case -7:
            errStr = @"no data";
            break;
        case -6:
            errStr = @"no date";
            break;
        case -5:
            errStr = @"no content";
            break;
        case -4:
            errStr = @"no User ID";
            break;
        case -3:
            errStr = @"data request failed";
            break;
        case -2:
            errStr = @"you ID are only capable of contains 10 notes";
            break;
        case -1:
            errStr = @"Uer ID not exist";
            break;
        default:
            errStr = @"Unknown error";
            break;
    }
    return errStr;
}

@end
