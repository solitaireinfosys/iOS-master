//
//  ConfirmVC.m
//  HummingBird
//
//  Created by Star on 12/11/15.
//  Copyright (c) 2015 Star. All rights reserved.
//

#import "ConfirmVC.h"
#import "AppDelegate.h"
#import "Common.h"
#import "userModel.h"
#import "Utility.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "SSLogin.h"
#import "SSRagistraion.h"

@interface ConfirmVC ()

@end

@implementation ConfirmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#ifdef humming_dev
    
    [imgLogo setImage:[UIImage imageNamed:@"splash_dev_icon"]];
#endif
    btnBack.clipsToBounds = YES;
    btnBack.layer.cornerRadius = 5;
    
    btnContinue.clipsToBounds = YES;
    btnContinue.layer.cornerRadius = 5;
    
    btnResend.clipsToBounds = YES;
    btnResend.layer.cornerRadius = 5;
    
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
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

-(IBAction)onLoginBack:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(IBAction)onContinue:(id)sender{
    [SVProgressHUD showWithStatus:REQUEST_WAITING];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_CONFIRM]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    NSDictionary *paramterDic = @{@"user_id":_mUserData.user_id};
    
    [manager POST:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ( [responseObject count] > 0 ) {
            
            NSDictionary *responseDic = [responseObject objectAtIndex:0];
            
            if ([[responseDic objectForKey:@"status"] intValue] == 200) {
                
                [SVProgressHUD dismiss];
                
                [self onSuccessConfimed];
                
            }else if ([[responseDic objectForKey:@"status"] intValue] == 201){
                
                [SVProgressHUD showErrorWithStatus:CONFIRM_FAILED];
                
            }else{
                [SVProgressHUD showErrorWithStatus:WEB_FAILED];
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        
        
    }];
}

-(void)onSuccessConfimed{
    
    theAppDelegate.gUserData = _mUserData;
    
    [[Utility getInstance] saveUserData:theAppDelegate.gUserData];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        
        [[NSUserDefaults standardUserDefaults] setFloat:0.15 forKey:@"voice_rate"];
        
    }else{
        
        [[NSUserDefaults standardUserDefaults] setFloat:0.53 forKey:@"voice_rate"];
        
    }
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [theAppDelegate switchRootViewController:login_check_true];


}

-(IBAction)onResend:(id)sender{
    [SVProgressHUD showWithStatus:REQUEST_WAITING];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_RESEND]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    NSDictionary *paramterDic = @{@"uid":_mUserData.user_id,
                                  @"umail":_mUserData.user_email};
    
    [manager POST:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ( [responseObject count] > 0 ) {
            
            NSDictionary *responseDic = [responseObject objectAtIndex:0];
            
            if ([[responseDic objectForKey:@"status"] intValue] == 200) {
                
                [SVProgressHUD showSuccessWithStatus:@"Confirmation resent"];
                
            }else{
                
                [SVProgressHUD showErrorWithStatus:WEB_FAILED];
            
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        
        
    }];
}

@end
