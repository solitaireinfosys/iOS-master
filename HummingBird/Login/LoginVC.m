 //
//  LoginVC.m
//  HummingBird
//
//  Created by Star on 12/5/15.
//  Copyright © 2015 Star. All rights reserved.
//

#import "LoginVC.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "Common.h"
#import "AppDelegate.h"
#import "Utility.h"
#import "SignupVC.h"
#import "ForgotVC.h"
#import "FacebookUserManager.h"
#import "userModel.h"
#import "Signup_EmailVC.h"
#import "SSLogin.h"
#import "SSRagistraion.h"
@interface LoginVC ()

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
#ifdef humming_dev
   
    [imgLogo setImage:[UIImage imageNamed:@"splash_dev_icon"]];
#endif
    
    
    loginView.clipsToBounds = YES;
    loginView.layer.cornerRadius = 5;
    
    self.navigationItem.title = @"HummingBird";
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == txtEmail) {
        [txtPassword becomeFirstResponder];
    }else if(textField == txtPassword){
        [txtPassword resignFirstResponder];
    }
    return YES;
}
-(IBAction)onLogin:(id)sender{
    [txtPassword resignFirstResponder];
    [txtEmail resignFirstResponder];
    
    if (txtEmail.text.length  != 0 && txtPassword.text.length != 0) {
        
        [self onRequestLogin];
        
    }else{
        
        if (txtEmail.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:EMAIL_WARNING];
        }else{
            [SVProgressHUD showErrorWithStatus:PASSWORD_WARNING];
        }
        
    }
}
-(IBAction)onSignup:(id)sender{
    Signup_EmailVC *signVC = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"Signup_EmailVC"];
    [self.navigationController pushViewController:signVC animated:YES];
}

#pragma mark - request api to login
-(void)onRequestLogin{
    
    [SVProgressHUD showWithStatus:REQUEST_WAITING];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_LOGIN]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if (theAppDelegate.uDeviceToken == nil) {
        theAppDelegate.uDeviceToken = @"d6cdb99035f272c8a7bb774a2cdc8319e73a4c54caacf50bb0c0b84161f3c48c";
    }
    
    int nIpFlag = 0;
    if (![[theAppDelegate getIpAddress] isEqualToString:@"error"]) {
        nIpFlag = 1;
    }
    
    NSDictionary *paramterDic = @{@"user_email":txtEmail.text,
                                  @"user_password":txtPassword.text,
                                  @"user_device":theAppDelegate.uDeviceToken,
                                  @"user_ip":[theAppDelegate getIpAddress],
                                  @"ip_flag":[NSNumber numberWithInt:nIpFlag]};
    
    manager.requestSerializer = [AFHTTPRequestSerializer new];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    [manager POST:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ( [responseObject count] > 0 ) {
            
            NSDictionary *responseDic = [responseObject objectAtIndex:0];
            if ([[responseDic objectForKey:@"status"] intValue] == 200) {
                
                [SVProgressHUD dismiss];
                
                theAppDelegate.gUserData = [[Utility getInstance] onParseUser:responseDic];
                
                [[Utility getInstance] saveUserData:theAppDelegate.gUserData];
                
                if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
                    
                    [[NSUserDefaults standardUserDefaults] setFloat:0.15 forKey:@"voice_rate"];
                    
                }else{
                    
                    [[NSUserDefaults standardUserDefaults] setFloat:0.53 forKey:@"voice_rate"];
                    
                }
                
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [theAppDelegate switchRootViewController:login_check_true];
                
//                NSString *userName = [theAppDelegate.gUserData.user_email stringByReplacingOccurrencesOfString:@"@gmail.com" withString:@""];
//                [[SSRagistraion shareInstance] registration:userName complition:^(NSDictionary *result) {
//                    NSLog(@"%@",result);
//                    NSString *status = [[NSString alloc] init];
//                    if (((NSString *)[result objectForKey:@"status"]) != nil){
//                        status = (NSString *)[result objectForKey:@"status"];
//                        if ([status isEqualToString:@"Success"]){
//                            [[SSLogin shareInstance] login:userName complition:^(NSDictionary *result) {
//                                NSLog(@"%@",result);
//                            }];
//                        }
//                    }
//                }];
                
                
            }else if ([[responseDic objectForKey:@"status"] intValue] == 204){
                
                [SVProgressHUD showErrorWithStatus:CONFIRM_FAILED];
                
            }else{
                [SVProgressHUD showErrorWithStatus:LOGIN_FAILED];
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",operation.responseString);
        [SVProgressHUD showErrorWithStatus:LOGIN_FAILED];
        
        
    }];
}
#pragma mark - method to forgot password
-(IBAction)onForgotPassword:(id)sender{
    
    ForgotVC *forgotVC = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"ForgotVC"];
    [self.navigationController pushViewController:forgotVC animated:YES];
}

-(IBAction)onFacebookLogin:(id)sender{
    [FacebookUserManager sharedManager].fromViewController = self;
    [[FacebookUserManager sharedManager] requestLogin:^(NSError *error) {
        
        if (error != nil)
        {
            [SVProgressHUD dismiss];
            return;
        }else{

//            theAppDelegate.gUserData.user_answer_count = [FacebookUserManager sharedManager].accessToken.tokenString;
//            [STANDARD_DEFAULT_STRING setObject:theAppDelegate.gFacebookToken forKey:user_facebook_token];
//            [STANDARD_DEFAULT_STRING synchronize];
            
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            
            NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_FACEBOOK_LOGIN]];
            
            if (theAppDelegate.uDeviceToken == nil) {
                theAppDelegate.uDeviceToken = @"d6cdb99035f272c8a7bb774a2cdc8319e73a4c54caacf50bb0c0b84161f3c48c";
            }
            int nIpFlag = 0;
            if (![[theAppDelegate getIpAddress] isEqualToString:@"error"]) {
                nIpFlag = 1;
            }
            
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            NSDictionary *paramterDic = @{@"fb_user_id":[FacebookUserManager sharedManager].fb_user_id ,//[NSString stringWithFormat:@"%@test",[FacebookUserManager sharedManager].fb_user_id] ,
                                          @"fb_user_name":[FacebookUserManager sharedManager].fb_user_name,
                                          @"user_device":theAppDelegate.uDeviceToken,
                                          @"user_lat":[NSString stringWithFormat:@"%f",theAppDelegate.uLat],
                                          @"user_long":[NSString stringWithFormat:@"%f",theAppDelegate.uLong],
                                          @"fb_token":[FacebookUserManager sharedManager].accessToken.tokenString,
                                          @"user_ip":[theAppDelegate getIpAddress],
                                          @"ip_flag":[NSNumber numberWithInt:nIpFlag]};
            
            NSString *user_ID = [paramterDic objectForKey:@"fb_user_id"];
            
            [manager POST:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary *responseDic = [responseObject objectAtIndex:0];
                if ([[responseDic objectForKey:@"status"] intValue] == 200) {
                    
                    
                    [SVProgressHUD dismiss];
                    
                    theAppDelegate.gUserData = [[Utility getInstance] onParseUser:responseDic];
                    
                    theAppDelegate.gUserData.user_fb_token = [FacebookUserManager sharedManager].accessToken.tokenString;
                    NSLog(@"%@",theAppDelegate.gUserData.user_name);
                    [[Utility getInstance] saveUserData:theAppDelegate.gUserData];
                    
                    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
                        
                        [[NSUserDefaults standardUserDefaults] setFloat:0.15 forKey:@"voice_rate"];
                        
                    }else{
                        
                        [[NSUserDefaults standardUserDefaults] setFloat:0.53 forKey:@"voice_rate"];
                        
                    }
                    
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    if ([theAppDelegate.gUserData.user_name containsString:@" "])
                    {
                        [theAppDelegate.gUserData.user_name stringByReplacingOccurrencesOfString:@" " withString:@""];
                    }
                    
                    NSString *userName = [[NSString alloc] init];
                    userName = [userName stringByAppendingFormat:@"%@_%@",user_ID ,theAppDelegate.gUserData.user_id];
                    [theAppDelegate switchRootViewController:login_check_true];
                    [[SSRagistraion shareInstance] registration:userName complition:^(NSDictionary *result) {
                        NSLog(@"%@",result);
                        [[SSLogin shareInstance] login:userName complition:^(NSDictionary *result) {
                            NSLog(@"%@",result);
                        }];
                    }];
                    

                    
                    
                }else if ([[responseDic objectForKey:@"status"] intValue] == 204){
                    
                    [SVProgressHUD showErrorWithStatus:CONFIRM_FAILED];
                    
                }else{
                    [SVProgressHUD showErrorWithStatus:LOGIN_FAILED];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"%@",operation.responseString);
                [SVProgressHUD showErrorWithStatus:LOGIN_FAILED];
                
            }];
        }
        
    }];
}
-(IBAction)onResendActive:(id)sender{
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:@"Please input the email address to verify" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Resend", nil];
    [av setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    // Alert style customization
    [[av textFieldAtIndex:0] setPlaceholder:@"Email address"];
 
    [av show];
    
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex == 1) {
        
        if ([actionSheet textFieldAtIndex:0].text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"Please input the email addresss to verify"];
        }else{
            [self onRequestResendActive:[actionSheet textFieldAtIndex:0].text];
        }
    }
}

-(void)onRequestResendActive:(NSString*)strEmail{
    [SVProgressHUD showWithStatus:REQUEST_WAITING];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_RESENT_ACTIVE]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    NSDictionary *paramterDic = @{@"user_email":strEmail};
    
    [manager POST:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ( [responseObject count] > 0 ) {
            
            NSDictionary *responseDic = [responseObject objectAtIndex:0];
            
            if ([[responseDic objectForKey:@"status"] intValue] == 200) {
                
                [SVProgressHUD showSuccessWithStatus:@"Confirmation resent"];
                
            }else if ([[responseDic objectForKey:@"status"] intValue] == 204){
                
                [SVProgressHUD showErrorWithStatus:@"This email address already actived"];
                
            }else{
                
                [SVProgressHUD showErrorWithStatus:@"This email address is not exist"];
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        
        
    }];
}
@end
