//
//  RegistViewController.m
//  51WorkNote
//
//  Created by Ivan_deng on 2017/9/25.
//  Copyright © 2017年 Ivan_deng. All rights reserved.
//

#define STATEBAR 20
#define NAVBAR 44
#define TEXTFIELDWIDTH 150
#define TEXTFIELDHEIGHT 44
#define LABELWIDTH 100
#define LOGINBUTTONWIDTH 100
#define LOGINBUTTONHEIGHT 44

#import "RegistViewController.h"
#import "USERFILE+CoreDataClass.h"
#import "NoteDAO.h"
#import "UserID.h"

@interface RegistViewController ()<UITextFieldDelegate>

{
    CGFloat screenWidth;
    CGFloat screenHeight;
    CGFloat topView;
}


@property(nonatomic,strong) UITextField *usernameField;
@property(nonatomic,strong) UITextField *passwordField;
@property(nonatomic,strong) UIButton *loginButton;
@property(nonatomic,strong) UIButton *registButton;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self UIBuild];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"Sign in/Sing up";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIBuild

- (void)UIBuild {
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    topView = NAVBAR + STATEBAR;
    [self configureLoginView];
    [self configureLoginButton];
    
}

- (void)configureLoginView {
    self.usernameField = [[UITextField alloc]init];
    self.passwordField = [[UITextField alloc]init];
    UILabel *labelUser = [[UILabel alloc]initWithFrame:CGRectMake((screenWidth - TEXTFIELDWIDTH - LABELWIDTH)/2,  topView + 100,LABELWIDTH, TEXTFIELDHEIGHT)];
    UILabel *labelPass = [[UILabel alloc]initWithFrame:CGRectMake(labelUser.frame.origin.x, labelUser.frame.origin.y + TEXTFIELDHEIGHT + 20, LABELWIDTH, TEXTFIELDHEIGHT)];
    [self.usernameField setFrame:CGRectMake(labelUser.frame.origin.x + LABELWIDTH, labelUser.frame.origin.y, TEXTFIELDWIDTH, TEXTFIELDHEIGHT)];
    [self.passwordField setFrame:CGRectMake(_usernameField.frame.origin.x, labelPass.frame.origin.y, TEXTFIELDWIDTH, TEXTFIELDHEIGHT)];
    labelUser.text = @"Username:";
    labelPass.text = @"Password:";
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(_usernameField.frame.origin.x, _usernameField.frame.origin.y + TEXTFIELDHEIGHT, TEXTFIELDWIDTH, 2)];
    line.backgroundColor = [UIColor grayColor];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(_passwordField.frame.origin.x, _passwordField.frame.origin.y + TEXTFIELDHEIGHT, TEXTFIELDWIDTH, 2)];
    line2.backgroundColor = [UIColor grayColor];
    
    [_passwordField setSecureTextEntry:true];
    _usernameField.delegate = self;
    _passwordField.delegate = self;
    
    [self.view addSubview:labelUser];
    [self.view addSubview:labelPass];
    [self.view addSubview:_usernameField];
    [self.view addSubview:_passwordField];
    [self.view addSubview:line];
    [self.view addSubview:line2];
}

- (void)configureLoginButton {
    _loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _registButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_loginButton setFrame:CGRectMake((screenWidth - LOGINBUTTONWIDTH)/2, screenHeight - topView - 2 * LOGINBUTTONHEIGHT, LOGINBUTTONWIDTH, LOGINBUTTONHEIGHT)];
    [_registButton setFrame:CGRectMake(_loginButton.frame.origin.x, _loginButton.frame.origin.y + 10 + LOGINBUTTONHEIGHT, LOGINBUTTONWIDTH, LOGINBUTTONHEIGHT)];
    [_loginButton setTitle:@"Sign In" forState:UIControlStateNormal];
    [_registButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(signInButtonAction:) forControlEvents:UIControlEventTouchDown];
    [_registButton addTarget:self action:@selector(signUpButtonAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_loginButton];
    [self.view addSubview:_registButton];
}

- (void)signInButtonAction:(UIButton *)sender {
    if([self signIn] == true) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Signed in sucess!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *warning = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:true completion:nil];
        }];
        [alert addAction:warning];
        [self presentViewController:alert animated:true completion:nil];
    }
}

- (void)signUpButtonAction:(UIButton *)sender {
    if([self signUp] == true) {
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

- (BOOL)signIn {
    //检测输入框内是否有文字
    if([_usernameField.text isEqualToString:@""] || [_usernameField.text length] == 0) {
        NSLog(@"UserName not input");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"please input your username" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *warning = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:warning];
        [self presentViewController:alert animated:true completion:nil];
        return false;
    }
    if([_passwordField.text isEqualToString:@""] || [_passwordField.text length] == 0) {
        NSLog(@"Password not input");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"please input your password" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *warning = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:warning];
        [self presentViewController:alert animated:true completion:nil];
        return false;
    }
    //若有文字，与ID库内注册的ID进行对比
    NoteDAO *dao = [NoteDAO sharedNoteDao];
    NSArray *IDStore = dao.IDStorage;
    if(IDStore.count < 1) {
        NSLog(@"No ID stored");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"please regist an new user" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *warning = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:warning];
        [self presentViewController:alert animated:true completion:nil];
        return false;
    }
    for(USERFILE *sample in IDStore) {
        if([sample.username isEqualToString:_usernameField.text] && [sample.password isEqualToString:_passwordField.text]) {
            sample.valid += 1;
            sample.issigned = true;
            [dao modifyUserFile:sample];
            dao.currentID = [[UserID alloc]initWithName:sample.username AndPassword:sample.password AndValid:sample.valid AndIssigned:sample.issigned];
            return true;
        }
    }
    NSLog(@"Incorrect username or password");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Incorrect username or password" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *warning = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:warning];
    [self presentViewController:alert animated:true completion:nil];
    return false;
}

- (BOOL)signUp {
    //检测输入框内是否有文字
    if([_usernameField.text isEqualToString:@""] || [_usernameField.text length] == 0) {
        NSLog(@"UserName not input");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"please input your username" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *warning = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:warning];
        [self presentViewController:alert animated:true completion:nil];
        return false;
    }
    if([_passwordField.text isEqualToString:@""] || [_passwordField.text length] == 0) {
        NSLog(@"Password not input");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"please input your password" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *warning = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:warning];
        [self presentViewController:alert animated:true completion:nil];
        return false;
    }
    NoteDAO *dao = [NoteDAO sharedNoteDao];
    [dao registUserIDwithName:_usernameField.text AndPassword:_passwordField.text AndValid:1 AndIssigned:true];
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
