//
//  SplashVC.m
//  HummingBird
//
//  Created by Star on 12/5/15.
//  Copyright © 2015 Star. All rights reserved.
//

#import "SplashVC.h"
#import "AppDelegate.h"
#import "Common.h"

@interface SplashVC ()

@end

@implementation SplashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
#ifdef humming_dev
    
    [imgLogo setImage:[UIImage imageNamed:@"splash_dev_icon"]];
#endif
    
    self.navigationController.navigationBarHidden = YES;
    [self checkUserLogin];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - check the user login status
-(void)checkUserLogin{
    
    NSInteger nStatus = [STANDARD_DEFAULT_STRING integerForKey:@"stock_login"];
    
    [theAppDelegate switchRootViewController:(int)nStatus];
    
}
@end
