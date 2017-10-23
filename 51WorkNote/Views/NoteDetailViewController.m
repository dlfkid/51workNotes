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
#import "Note.h"
#import "NoteDAO.h"

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

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title = [NSString stringWithFormat:@"%@'s notes",self.currentNote.userid];
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
}

- (void)rightBarButtonAction:(UIBarButtonItem *)sender {
    if([_contentView.text isEqualToString:_currentNote.content] && [_contentView.text length] == [_currentNote.content length]) {
        [_contentView resignFirstResponder];
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Note content changed, save the note?" preferredStyle:UIAlertControllerStyleAlert];
        //保存对笔记内容的修改
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _currentNote.content = _contentView.text;
            [[NoteDAO sharedNoteDao] modifyNote:_currentNote];
            [[NoteDAO sharedNoteDao] modifyNotesFromServer:_currentNote];
            [_contentView resignFirstResponder];
        }];
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:yes];
        [alert addAction:no];
        [self presentViewController:alert animated:true completion:^{
            [_contentView resignFirstResponder];
        }];
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
    
    UILabel *noteIDLabel = [[UILabel alloc]initWithFrame:CGRectMake(contentView.frame.origin.x, contentView.frame.origin.y + contentView.frame.size.height, contentView.frame.size.width, NAVBAR)];
    noteIDLabel.font = [UIFont systemFontOfSize:16];
    noteIDLabel.text = [NSString stringWithFormat:@"ID : %@",_currentNote.noteid];
    
    [self.view addSubview:timeStamp];
    [self.view addSubview:contentView];
    [self.view addSubview:noteIDLabel];
}

#pragma mark - TextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Finish" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonAction:)];
    return true;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    self.navigationItem.rightBarButtonItem = nil;
    return true;
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
