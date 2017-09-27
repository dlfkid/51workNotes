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

#import "MainViewController.h"
#import "RegistViewController.h"
#import "SimpleTabBar.h"
#import "USERFILE+CoreDataClass.h"
#import "NoteDAO.h"
#import "Note.h"
#import "UserID.h"



@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,SimpleTabBarDelegate>

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

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNoteDataAssistObject];
    [self UIBuild];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    self.title = @"51WorkNote";
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
    self.dataCenter = [NoteDAO sharedNoteDao];
    [_dataCenter getAllIDs];
    if(![_dataCenter fliterQualifiedIDs]) {
        NSLog(@"No singed in ID aquired, entering regist view");
        RegistViewController *reg = [[RegistViewController alloc]init];
        [self presentViewController:reg animated:true completion:nil];
    }
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

- (void)configureLowTab {
    NSLog(@"configuring low bar");
    self.lowTab = [[SimpleTabBar alloc]initWithFrame:CGRectMake(0, screenHeight - 45, screenWidth, 45)];
    self.lowTab.tabBarDelegate = self;
    [self.view addSubview:_lowTab];
}

- (void)simpleTabBarDidClickedPlusButton:(SimpleTabBar *)simpleBar {
    NSLog(@"Add an new note.");
}

- (void)configureSliderView {
    NSLog(@"Configuring Slider View");
    self.sliderView = [[UIView alloc]initWithFrame:CGRectMake(screenWidth, NAVBAR + STATEBAR, SLIDERWIDTH, screenHeight)];
    [self.sliderView setBackgroundColor:[UIColor lightGrayColor]];
    UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, topView, SLIDERWIDTH, NAVBAR)];
    userLabel.backgroundColor = [UIColor whiteColor];
    userLabel.text = [NoteDAO sharedNoteDao].currentID.username;
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

@end
