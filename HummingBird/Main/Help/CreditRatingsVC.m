//
//  CreditRatingsVC.m
//  HummingBird
//
//  Created by Star on 5/13/16.
//  Copyright © 2016 Star. All rights reserved.
//

#import "CreditRatingsVC.h"

@interface CreditRatingsVC ()

@end

@implementation CreditRatingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIColor *mainColor = [UIColor blackColor];
    
    UIFont *mainFont = [UIFont systemFontOfSize:15];
    UIFont *subFont = [UIFont boldSystemFontOfSize:15];
    
    NSDictionary *main_name = [NSDictionary dictionaryWithObjectsAndKeys:mainColor, NSForegroundColorAttributeName,subFont,NSFontAttributeName, nil];
    
    NSMutableAttributedString *mainValue = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"HummingBird Connect "] attributes:main_name];
    
    NSDictionary *sub_name = [NSDictionary dictionaryWithObjectsAndKeys:mainColor, NSForegroundColorAttributeName,mainFont,NSFontAttributeName, nil];
    
    NSMutableAttributedString *subValue = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"gives users the ability to answer questions. Each answers gets credit which can be redeemed, if you qualify. After you answer, your answer can be rated either by users or by special reviewers at Hummingbird. The answers are rated based on accuracy  and adherence to the Hummingbird Guidelines on how to answer questions.. All your answer ratings are averaged out to give you your USER RATING.\n\nYour USER RATING means EVERYTHING to how you earn money.\n\nHummingbird chooses the best answers based on the user’s USER RATING. We believe that a users that has consistently answered well deserves the benefit of answering the next question.\n\nGood Luck!"] attributes:sub_name];
    
    [mainValue appendAttributedString:subValue];
    
    [lblText setAttributedText:mainValue];
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
