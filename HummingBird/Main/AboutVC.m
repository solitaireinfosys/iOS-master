//
//  AboutVC.m
//  HummingBird
//
//  Created by Star on 5/12/16.
//  Copyright © 2016 Star. All rights reserved.
//

#import "AboutVC.h"

@interface AboutVC ()

@end

@implementation AboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIColor *mainColor = [UIColor blackColor];
    
    UIFont *mainFont = [UIFont systemFontOfSize:15];
    UIFont *subFont = [UIFont boldSystemFontOfSize:15];
    
    NSDictionary *main_name = [NSDictionary dictionaryWithObjectsAndKeys:mainColor, NSForegroundColorAttributeName,subFont,NSFontAttributeName, nil];
    
    NSMutableAttributedString *mainValue = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"HummingBird Connect "] attributes:main_name];
    
    NSDictionary *sub_name = [NSDictionary dictionaryWithObjectsAndKeys:mainColor, NSForegroundColorAttributeName,mainFont,NSFontAttributeName, nil];
    
    NSMutableAttributedString *subValue = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"is a mobile based application that is here to save you time, money, and make life simpler.\n\nYou ask questions, and we’ll provide you with the precise answers your looking for, along with a reference WEB LINK."] attributes:sub_name];
    
    [mainValue appendAttributedString:subValue];
    
    [lblAbout setAttributedText:mainValue];
    
    [lblAbout1 setText:@"Want to know the cheapest airfare to London? No more web searching for best prices! HummingBird will find the best price for you and send you the WEB LINK. HummingBird also has powerful options like SMS, automatic alerts, automatic voice answers.\n\nAsk us anything!"];
    
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
-(IBAction)onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

@end
