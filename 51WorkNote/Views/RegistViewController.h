//
//  RegistViewController.h
//  51WorkNote
//
//  Created by Ivan_deng on 2017/9/25.
//  Copyright © 2017年 Ivan_deng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReturnValue)(BOOL value);

@interface RegistViewController : UIViewController

- (void)copyBlockContent:(ReturnValue)returnBlock;

@end
