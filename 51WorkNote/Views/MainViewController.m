//
//  MainViewController.m
//  51WorkNote
//
//  Created by Ivan_deng on 2017/9/22.
//  Copyright © 2017年 Ivan_deng. All rights reserved.
//
#define STATEBAR 20
#define NAVBAR 44
#define SLIDERWIDTH 100
#define BLUREFFECT 666
#define ADDVIEWHEIGHT 200

#import "MainViewController.h"
#import "RegistViewController.h"
#import "SimpleTabBar.h"
#import "USERFILE+CoreDataClass.h"
#import "NoteDAO.h"
#import "Note.h"
#import "UserID.h"



@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,SimpleTabBarDelegate,UITextViewDelegate>

{
    CGFloat screenWidth;
    CGFloat screenHeight;
    CGFloat topView;
}

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NoteDAO *dataCenter;
@property(nonatomic,strong) NSMutableArray *notesAlive;
@property(nonatomic,strong) UIView *sliderView;
@property(nonatomic,strong) SimpleTabBar *lowTab;
@property(nonatomic,strong) UITextView *input;
@property(nonatomic,strong) UILabel *userInfo;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIBuild];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    self.title = @"51WorkNote";
    [self setUpNoteDataAssistObject];
    if(self.userInfo) {
        _userInfo.text = [NoteDAO sharedNoteDao].currentID.username;
    }
    if(self.tableView) {
        [_tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - LoadDataBase

- (void)setUpNoteDataAssistObject {
    self.notesAlive = [[NSMutableArray alloc]init];
    self.dataCenter = [NoteDAO sharedNoteDao];
    [_dataCenter getAllIDs];
    if(![_dataCenter fliterQualifiedIDs]) {
        NSLog(@"No singed in ID aquired, entering regist view");
        RegistViewController *reg = [[RegistViewController alloc]init];
        [self presentViewController:reg animated:true completion:nil];
    }
    [_notesAlive addObjectsFromArray:[_dataCenter loadAllNote]];
}

#pragma mark - UIBuild

- (void)UIBuild {
    NSLog(@"Building User InterFace");
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    topView = NAVBAR + STATEBAR;
    [self configureTableView];
    [self configureSliderView];
    [self configureTopButtons];
    [self configureLowTab];
}

- (void)drawColorRect {
    UIView *colorRect = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 300, 150)];
    colorRect.backgroundColor = [UIColor redColor];
    [self.view addSubview:colorRect];
}

- (void)configureLowTab {
    NSLog(@"configuring low bar");
    self.lowTab = [[SimpleTabBar alloc]initWithFrame:CGRectMake(0, screenHeight - 45, screenWidth, 45)];
    self.lowTab.tabBarDelegate = self;
    [self.view addSubview:_lowTab];
}

- (void)configureAddView {
    NSLog(@"configuring add view");
    CGFloat addViewWidth = screenWidth - 40;
    //设置毛玻璃背景
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effect = [[UIVisualEffectView alloc]initWithEffect:blur];
    effect.frame = CGRectMake(0, screenHeight, screenWidth, screenHeight);
    effect.tag = BLUREFFECT;
    [self.view addSubview:effect];
    
    //设置添加框白板
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake((screenWidth - addViewWidth)/2, topView, addViewWidth, ADDVIEWHEIGHT)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 10;
    whiteView.layer.borderWidth = 1;
    whiteView.tag = 102;
     [effect.contentView addSubview:whiteView];
    
    //设置添加文本框
    UITextView *newInput = [[UITextView alloc]initWithFrame:CGRectMake(50, 0, addViewWidth - 100, ADDVIEWHEIGHT)];
    newInput.font = [UIFont systemFontOfSize:18];
    [newInput setKeyboardType:UIKeyboardTypeASCIICapable];
    [whiteView addSubview:newInput];
    _input = newInput;
    _input.delegate = self;
    
    //设置取消按钮
    UIImage *backIcon = [UIImage imageNamed:@"icons8-Cancel-50"];
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(addViewWidth - 50, 0, 50, 50)];
    [backButton setImage:backIcon forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchDown];
    whiteView.tag = 101;
    [whiteView addSubview:backButton];
    
    //设置添加按钮
    UIImage *confirmIcon = [UIImage imageNamed:@"icons8-Checked-50"];
    UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(addViewWidth - 50, ADDVIEWHEIGHT - 50, 50, 50)];
    [confirmButton setImage:confirmIcon forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchDown];
    [whiteView addSubview:confirmButton];
    
    //添加提示信息
    UILabel *hint = [[UILabel alloc]initWithFrame:CGRectMake((screenWidth - addViewWidth)/2, topView + 100, addViewWidth, 300)];
    [hint setText: @"Input any thing \nyou wanna take note"];
    hint.textAlignment = NSTextAlignmentCenter;
    hint.font = [UIFont systemFontOfSize:24];
    hint.numberOfLines = 10;
    [effect.contentView addSubview:hint];
}

- (void)confirmButtonAction:(UIButton *)sender {
    int noteID = (int)self.notesAlive.count + 1;
    NSString *currentUser = [NoteDAO sharedNoteDao].currentID.username;
    Note *newNote = [Note noteWithCurrentTimeStamp:noteID userid:currentUser content:_input.text];
    [[NoteDAO sharedNoteDao] addANote:newNote];
    [_notesAlive addObject:newNote];
    [self.tableView reloadData];
    UIView *view = [self.view viewWithTag:BLUREFFECT];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [view setFrame:CGRectMake(0,screenHeight, screenWidth, screenHeight)];
    [UIView commitAnimations];
    _input = nil;
    [view removeFromSuperview];
}

- (void)cancelButtonAction:(UIButton *)sender {
    UIView *view = [self.view viewWithTag:BLUREFFECT];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [view setFrame:CGRectMake(0,screenHeight, screenWidth, screenHeight)];
    [UIView commitAnimations];
    _input = nil;
    [view removeFromSuperview];
}

- (void)simpleTabBarDidClickedPlusButton:(SimpleTabBar *)simpleBar {
    NSLog(@"Add an new note.");
    [self configureAddView];
    UIVisualEffectView *view = [self.view viewWithTag:BLUREFFECT];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [view setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [UIView commitAnimations];
}

- (void)configureSliderView {
    NSLog(@"Configuring Slider View");
    self.sliderView = [[UIView alloc]initWithFrame:CGRectMake(screenWidth, NAVBAR + STATEBAR, SLIDERWIDTH, screenHeight)];
    [self.sliderView setBackgroundColor:[UIColor lightGrayColor]];
    UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, topView, SLIDERWIDTH, NAVBAR)];
    _userInfo = userLabel;
    userLabel.backgroundColor = [UIColor whiteColor];
    userLabel.text = [NoteDAO sharedNoteDao].currentID.username;
    _sliderView.layer.shadowColor = [UIColor blackColor].CGColor;
    _sliderView.layer.shadowOpacity = 0.8f;
    _sliderView.layer.shadowRadius = 4.f;
    _sliderView.layer.shadowOffset = CGSizeMake(1, 1);
    [self.sliderView addSubview:userLabel];
    [self.view addSubview:_sliderView];
}

- (void)configureTopButtons {
    NSLog(@"configuring top view buttons");
    UIImage *rightButtonIcon = [UIImage imageNamed:@"icons8-User-48"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:rightButtonIcon style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction:)];
    UIImage *leftButtonIcon = [UIImage imageNamed:@"icons8-Export-26"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage: leftButtonIcon style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction:)];
}

//用户界面按钮
- (void)rightBarButtonAction:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    if(_sliderView.frame.origin.x == screenWidth) {
        [self.sliderView setFrame:CGRectMake(screenWidth - SLIDERWIDTH, topView, SLIDERWIDTH, screenHeight)];
    }else if(_sliderView.frame.origin.x == (screenWidth - SLIDERWIDTH)) {
        [self.sliderView setFrame:CGRectMake(screenWidth, topView, SLIDERWIDTH, screenHeight)];
    }else {
        NSLog(@"Slider View has bugs");
    }
    [UIView commitAnimations];
    //[self drawColorRect];
}
//退出登录按钮
- (void)leftBarButtonAction:(id)sender {
    NoteDAO *dao = [NoteDAO sharedNoteDao];
    NSArray *IDList = [dao IDStorage];
    for(USERFILE *currentID in IDList) {
        currentID.issigned = false;
        [dao modifyUserFile:currentID];
        dao.currentID = nil;
    }
    RegistViewController *reg = [[RegistViewController alloc]init];
    [self presentViewController:reg animated:true completion:nil];
}

- (void)configureTableView {
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"noteCell"];
    [self.view addSubview:_tableView];
}


#pragma mark - TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.notesAlive.count > 0) {
        return self.notesAlive.count;
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"noteCell" forIndexPath:indexPath];
    Note *targetNote = _notesAlive[indexPath.row];
    cell.textLabel.text = targetNote.content;
    cell.detailTextLabel.text = targetNote.timestamp;
    [cell setAccessoryType:UITableViewCellAccessoryDetailButton];
    
    [cell setHighlighted:false];
    return cell;
}

#pragma mark - scrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.lowTab setHidden:true];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(decelerate) {
        [self.lowTab setHidden:false];
    }
}

#pragma mark - textViewDelegate

//- (void)textViewDidChange:(UITextView *)textView {
//    NSLog(@"Text View did change");
//    static CGFloat maxHeight = ADDVIEWHEIGHT;
//    CGRect frame = textView.frame;
//    CGSize constraintSize = CGSizeMake(frame.size.width, maxHeight);
//    CGSize size = [textView sizeThatFits:constraintSize];
//    if(size.height < maxHeight) {
//        size.height = maxHeight;
//    }
//    textView.scrollEnabled = false;
//    textView.frame = CGRectMake(frame.origin.x, frame.origin.y,frame.size.width,size.height);
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_input endEditing:true];
}

@end
