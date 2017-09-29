//
//  NoteDetailViewController.m
//  51WorkNote
//
//  Created by Ivan_deng on 2017/9/29.
//  Copyright © 2017年 Ivan_deng. All rights reserved.
//

#define STATEBAR 20
#define NAVBAR 44
#define SLIDERWIDTH 100
#define BLUREFFECT 666
#define ADDVIEWHEIGHT 200

#import "NoteDetailViewController.h"

@interface NoteDetailViewController ()<UITextViewDelegate>

{
    CGFloat screenWidth;
    CGFloat screenHeight;
    CGFloat topView;
}

@property(nonatomic, strong)UITextView *contentView;

@end

@implementation NoteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIBuild];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIBuild

- (void)UIBuild {
    NSLog(@"Building User InterFace");
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    topView = NAVBAR + STATEBAR;
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureInfoView];
    [self configureNavBarButton];
}

- (void)configureNavBarButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Finish" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonAction:)];
}

- (void)rightBarButtonAction:(UIBarButtonItem *)sender {
    if(_contentView) {
        [_contentView resignFirstResponder];
    }
}

- (void)configureInfoView {
    UILabel *timeStamp = [[UILabel alloc]initWithFrame:CGRectMake(0, screenHeight - NAVBAR, screenWidth, NAVBAR)];
    timeStamp.backgroundColor = [UIColor lightGrayColor];
    timeStamp.text = _currentNote.timestamp;
    timeStamp.textAlignment = NSTextAlignmentCenter;
    timeStamp.font = [UIFont systemFontOfSize:16];
    
    UITextView *contentView = [[UITextView alloc]initWithFrame:CGRectMake(0, NAVBAR + STATEBAR, screenWidth, screenHeight - 2 * NAVBAR - STATEBAR)];
    contentView.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBlack];
    contentView.text = _currentNote.content;
    _contentView = contentView;
    _contentView.delegate = self;
    [self.view addSubview:timeStamp];
    [self.view addSubview:contentView];
}

#pragma mark - TextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    NSLog(@"textViewShouldBeginEditing");
    return true;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"textViewDidChange");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
