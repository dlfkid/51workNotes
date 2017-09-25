//
//  SimpleTabBar.h
//  51WorkNote
//
//  Created by Ivan_deng on 2017/9/25.
//  Copyright © 2017年 Ivan_deng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SimpleTabBar;

@protocol SimpleTabBarDelegate<UITabBarDelegate>

@optional

- (void)simpleTabBarDidClickedPlusButton:(SimpleTabBar *)simpleBar;

@end

@interface SimpleTabBar : UITabBar

@property (nonatomic, strong) UIButton *plusBtn;
@property (nonatomic, weak) id <SimpleTabBarDelegate> tabBarDelegate;

@end
