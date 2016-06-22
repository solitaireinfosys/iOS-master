//
//  MenuVC.m
//  HummingBird
//
//  Created by Star on 3/7/16.
//  Copyright © 2016 Star. All rights reserved.
//

#import "MenuVC.h"
#import "HistoryVC.h"
#import "AppDelegate.h"
#import "TopVC.h"

@interface MenuVC ()

@end

@implementation MenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.title = @"Menu";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)onMenu:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(IBAction)onHistory:(id)sender{
    HistoryVC *mHistoryVC = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"HistoryVC"];
    [self.navigationController pushViewController:mHistoryVC animated:YES];
}

-(IBAction)onTopQuestion:(id)sender{
    TopVC *mTopVC = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"TopVC"];
    [self.navigationController pushViewController:mTopVC animated:YES];
}
@end
