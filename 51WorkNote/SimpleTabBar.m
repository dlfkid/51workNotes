//
//  SimpleTabBar.m
//  51WorkNote
//
//  Created by Ivan_deng on 2017/9/25.
//  Copyright © 2017年 Ivan_deng. All rights reserved.
//

#import "SimpleTabBar.h"

@implementation SimpleTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        // 添加一个按钮到tabbar中
        UIButton *plusBtn = [[UIButton alloc] init];
        [plusBtn setImage:[UIImage imageNamed:@"icons8-Plus-50"] forState:UIControlStateNormal];
        CGRect temp = plusBtn.frame;
        temp.size=plusBtn.currentImage.size;
        CGFloat imageWidth = temp.size.width;
        CGFloat imageHeight = temp.size.height;
        CGFloat selfWidth = self.frame.size.width;
        CGFloat selfHeight = self.frame.size.height;
        plusBtn.frame = CGRectMake((selfWidth - imageWidth)/2, -imageHeight + selfHeight, imageWidth, imageHeight);
        plusBtn.backgroundColor = [UIColor lightGrayColor];
        plusBtn.layer.cornerRadius = plusBtn.frame.size.width/2;
        [plusBtn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
        self.backgroundColor = [UIColor lightGrayColor];
        [self setTranslucent:true];
    }
    return self;
}

- (void)plusClick {
    [self.tabBarDelegate simpleTabBarDidClickedPlusButton:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
