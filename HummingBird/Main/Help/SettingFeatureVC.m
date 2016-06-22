//
//  SettingFeatureVC.m
//  HummingBird
//
//  Created by Star on 5/13/16.
//  Copyright © 2016 Star. All rights reserved.
//

#import "SettingFeatureVC.h"

@interface SettingFeatureVC ()

@end

@implementation SettingFeatureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}
-(IBAction)onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
