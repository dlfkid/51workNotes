//
//  Note.h
//  51WorkNote
//
//  Created by Ivan_deng on 2017/9/22.
//  Copyright © 2017年 Ivan_deng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject

@property(nonatomic,copy) NSString * _Nullable userid;
@property(nonatomic,copy) NSString * _Nonnull content;
@property(nonatomic,copy) NSString * _Nullable timestamp;
@property(nonatomic,strong) NSNumber * _Nonnull noteid;

- (instancetype _Nonnull)initWithUserid:( NSString * _Nullable)userid
                     AndNoteid:(int)noteid
                    AndContent:(NSString * _Nonnull)content
                       AndDate:(NSString * _Nullable)timeStamp;

+ (Note * _Nonnull)noteWithCurrentTimeStamp:(int)noteid
                            userid:(NSString * _Nullable)userID
                           content:(NSString * _Nonnull)content;



@end
