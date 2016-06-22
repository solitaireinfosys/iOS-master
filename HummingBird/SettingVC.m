//
//  SettingVC.m
//  HummingBird
//
//  Created by Star on 12/28/15.
//  Copyright (c) 2015 Star. All rights reserved.
//

#import "SettingVC.h"
#import "AppDelegate.h"
#import "userModel.h"
#import "SVProgressHUD.h"
#import "Common.h"
#import "Utility.h"
#import "AFNetworking.h"
#import "PhoneVerifyVC.h"
#import "EmailVerifyVC.h"

#ifdef humming_dist
#import "Analytics.h"
#endif

@interface SettingVC ()

@end

@implementation SettingVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
#ifdef humming_dist
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
    
    [tracker set:kGAIScreenName value:@"Setting Page"];
    [tracker send:[[[GAIDictionaryBuilder createScreenView]
                    set:@"Setting Page"
                    forKey:[GAIFields customDimensionForIndex:1]] build]];
#endif
}
-(void) imgSlideInFromLeft:(UIView *)vew
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromLeft;
    transition.delegate = self;
    [vew.layer addAnimation:transition forKey:nil];
}

-(IBAction)onBack:(id)sender{
    
    CATransition *transition = [CATransition animation];
    transition.duration = .2;
    transition.type = kCATransitionMoveIn;
    transition.subtype= kCATransitionFromRight;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self imgSlideInFromLeft:self.view];
#ifdef humming_dev
    
    [imgLogo setImage:[UIImage imageNamed:@"splash_dev_icon"]];
#endif
    
//    voiceTypesData = [[NSMutableArray alloc]init];
//    
//    for (AVSpeechSynthesisVoice *voice in [AVSpeechSynthesisVoice speechVoices]) {
//        
//        if ([voice.language rangeOfString:@"en"].location != NSNotFound) {
//            [voiceTypesData addObject:voice.language];
//        }
//    }
//    
//    NSString *strData = [[NSUserDefaults standardUserDefaults]objectForKey:@"voice_type"];
//    if (strData.length == 0) {
//        [[NSUserDefaults standardUserDefaults] setObject:@"en-US" forKey:@"voice_type"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//    }
//    
//    [voicePicker reloadAllComponents];
    
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout)];
    self.navigationItem.leftBarButtonItem = btnDone;
    
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc]initWithTitle:@"Back >" style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.rightBarButtonItem = backBarItem;
    
    [self.navigationItem setHidesBackButton:YES];
    
    [txtEmail setText:theAppDelegate.gUserData.user_email];
    [txtPassword setText:theAppDelegate.gUserData.user_password];
    
    txtEmail.enabled = false;
    txtPassword.enabled = false;
   
    if (theAppDelegate.gUserData.user_setting_question_email == 1 && theAppDelegate.gUserData.user_email.length != 0) {
        [swtQtEmail setOn:true];
    }else{
        [swtQtEmail setOn:false];
    }
    
    if (theAppDelegate.gUserData.user_setting_question_phone == 1) {
        [swtQtSMS setOn:true];
    }else{
        [swtQtSMS setOn:false];
    }
    
    if (theAppDelegate.gUserData.user_setting_question_push == 1) {
        [swtQtPush setOn:true];
    }else{
        [swtQtPush setOn:false];
    }
    
    
    if (theAppDelegate.gUserData.user_setting_answer_email == 1 && theAppDelegate.gUserData.user_email.length != 0) {
        [swtAwEmail setOn:true];
    }else{
        [swtAwEmail setOn:false];
    }
    
    if (theAppDelegate.gUserData.user_setting_answer_phone == 1) {
        [swtAwSMS setOn:true];
    }else{
        [swtAwSMS setOn:false];
    }
    
    if (theAppDelegate.gUserData.user_setting_answer_push == 1) {
        [swtAwPush setOn:true];
    }else{
        [swtAwPush setOn:false];
    }
    
    [lblVoiceValue setText:[NSString stringWithFormat:@"Voice Value: %.2f",[[NSUserDefaults standardUserDefaults] floatForKey:@"voice_rate"]]];
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        
        
        sliderVoice.maximumValue = 0.3;
        sliderVoice.minimumValue = 0;
        
    }else{
        sliderVoice.maximumValue = 0.6;
        sliderVoice.minimumValue = 0.4;
        
    }
    
    sliderVoice.value = [[NSUserDefaults standardUserDefaults] floatForKey:@"voice_rate"];
    
    
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
    }else{
        [txtEmail resignFirstResponder];
        [txtPassword resignFirstResponder];
    }
    
    return YES;
}

-(IBAction)onSwitchChange:(id)sender{
    
}

#pragma mark - logout
-(void)onLogout{
    
    UIAlertController *_alertView = [UIAlertController alertControllerWithTitle:nil message:@"You want to logout?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* logout_cancel = [UIAlertAction
                                    actionWithTitle:@"Cancel"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Do some thing here
                                        [_alertView dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
    
    [_alertView addAction:logout_cancel];
    
    UIAlertAction* logout_yes = [UIAlertAction
                                 actionWithTitle:@"Yes"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     //Do some thing here
                                     
                                     theAppDelegate.gUserData.user_voice_flag = 0;
                                     [[Utility getInstance]saveUserData:theAppDelegate.gUserData];
                                     
                                     [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"FBShareFlag"];
                                     
                                     [[NSUserDefaults standardUserDefaults] synchronize];
                                     
                                     [SVProgressHUD showWithStatus:REQUEST_WAITING];
                                     
                                     NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_LOGOUT]];
                                     
                                     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                                     
                                     NSDictionary *paramterDic = @{@"user_id":theAppDelegate.gUserData.user_id};
                                     
                                     manager.requestSerializer = [AFHTTPRequestSerializer new];
                                     manager.securityPolicy.allowInvalidCertificates = YES;
                                     
                                     [manager POST:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         
                                         [SVProgressHUD dismiss];
                                         
                                         [STANDARD_DEFAULT_STRING setInteger:0 forKey:@"stock_login"];
                                         [STANDARD_DEFAULT_STRING synchronize];
                                         
                                         [theAppDelegate switchRootViewController:login_check_false];
                                         
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         
                                         [SVProgressHUD dismiss];
                                         
                                         [STANDARD_DEFAULT_STRING setInteger:0 forKey:@"stock_login"];
                                         [STANDARD_DEFAULT_STRING synchronize];
                                         
                                         [theAppDelegate switchRootViewController:login_check_false];
                                     }];
                                     
                                     
                                     
                                 }];
    
    [_alertView addAction:logout_yes];
    
    
    [self presentViewController:_alertView animated:YES completion:nil];
    
}


#pragma mark - delegate to uialertview
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        [STANDARD_DEFAULT_STRING setInteger:0 forKey:@"stock_login"];
        [STANDARD_DEFAULT_STRING synchronize];
        
        [theAppDelegate switchRootViewController:login_check_false];
        
    }
}

-(IBAction)onDone:(id)sender{
    
//    if (txtEmail.text.length != 0 && txtPassword.text.length != 0) {
//        
//        [self updateUserInfo];
//        
//    }else{
//        
//        if (txtEmail.text.length == 0) {
//            [SVProgressHUD showErrorWithStatus:EMAIL_WARNING];
//        }else{
//            [SVProgressHUD showErrorWithStatus:PASSWORD_WARNING];
//        }
//    }
    
    [self updateUserInfo];
    
}

-(void)updateUserInfo{

    [SVProgressHUD showWithStatus:REQUEST_WAITING];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_UPDATE_USER]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if (theAppDelegate.uDeviceToken == nil) {
        theAppDelegate.uDeviceToken = @"d6cdb99035f272c8a7bb774a2cdc8319e73a4c54caacf50bb0c0b84161f3c48c";
    }
    
    NSDictionary *paramterDic;
    
    paramterDic = @{
                    @"user_id":theAppDelegate.gUserData.user_id,
                    
                    @"user_device":theAppDelegate.uDeviceToken,
                    @"qt_push_val":[NSNumber numberWithBool:swtQtPush.on],
                    @"qt_sms_val":[NSNumber numberWithBool:swtQtSMS.on],
                    @"qt_email_val":[NSNumber numberWithBool:swtQtEmail.on],
                    @"aw_push_val":[NSNumber numberWithBool:swtAwPush.on],
                    @"aw_sms_val":[NSNumber numberWithBool:swtAwSMS.on],
                    @"aw_email_val":[NSNumber numberWithBool:swtAwEmail.on],};
    
    
    [manager POST:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ( [responseObject count] > 0 ) {
            
            NSDictionary *responseDic = [responseObject objectAtIndex:0];
            int nStatus = [[responseDic objectForKey:@"status"] intValue];
            if (nStatus == 200) {
                
                [SVProgressHUD dismiss];
                
                theAppDelegate.gUserData.user_email = txtEmail.text;
                
                theAppDelegate.gUserData.user_setting_question_email = swtQtEmail.on;
                theAppDelegate.gUserData.user_setting_question_phone = swtQtSMS.on;
                theAppDelegate.gUserData.user_setting_question_push = swtQtPush.on;
                
                theAppDelegate.gUserData.user_setting_answer_email = swtAwEmail.on;
                theAppDelegate.gUserData.user_setting_answer_phone = swtAwSMS.on;
                theAppDelegate.gUserData.user_setting_answer_push = swtAwPush.on;
                
                [[Utility getInstance] saveUserData:theAppDelegate.gUserData];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
//                if (nStatus == 202) {
//                    [SVProgressHUD showErrorWithStatus:@"Email already exist, please try again."];
//                }else{
//                    [SVProgressHUD showErrorWithStatus:LOGIN_FAILED];
//                }
                [SVProgressHUD showErrorWithStatus:WEB_FAILED];
                
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseString);
        [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        
        
    }];
}

-(IBAction)onChangeOption:(id)sender{
    
    UISwitch *swt = (UISwitch*)sender;
    
    if (swt == swtAwSMS) {
    
        if (swt.isOn) {
            if (theAppDelegate.gUserData.user_phone.length == 0) {
                
                UIAlertController *_alertView = [UIAlertController alertControllerWithTitle:nil message:@"Phone number required for SMS alerts." preferredStyle:UIAlertControllerStyleAlert];
                
                [_alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    textField.placeholder = @"Phone number";
                }];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    txtPhone = _alertView.textFields.firstObject;
                    if (txtPhone.text.length != 0) {
                        
                        [self onRequestUpdatePhoneNumber:txtPhone.text swtType:swt_answer_sms];
                        
                    }else{
                        
                        [_alertView dismissViewControllerAnimated:YES completion:nil];
                        
                        [swt setOn:false];
                    }
                }];
                
                UIAlertAction *cancelAction = [UIAlertAction
                                              actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleDefault
                                              handler:^(UIAlertAction * action)
                                              {
                                                  //Do some thing here
                                                  [_alertView dismissViewControllerAnimated:YES completion:nil];
                                                  
                                                  [swt setOn:false];
                                              }];
                
  
                [_alertView addAction:okAction];
                [_alertView addAction:cancelAction];
                
                [self presentViewController:_alertView animated:YES completion:nil];
            }
        }
    }else if (swt == swtQtSMS){
        if (swt.isOn) {
            if (theAppDelegate.gUserData.user_phone.length == 0) {
                
                UIAlertController *_alertView = [UIAlertController alertControllerWithTitle:nil message:@"Phone number required for SMS alerts." preferredStyle:UIAlertControllerStyleAlert];
                
                [_alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    textField.placeholder = @"Phone number";
                }];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    txtPhone = _alertView.textFields.firstObject;
                    
                    if (txtPhone.text.length != 0) {
                        
                        [self onRequestUpdatePhoneNumber:txtPhone.text swtType:swt_question_sms];
                        
                        
                    }else{
                        
                        [_alertView dismissViewControllerAnimated:YES completion:nil];
                        
                        [swt setOn:false];
                    }
                    
                }];
                
                UIAlertAction *cancelAction = [UIAlertAction
                                               actionWithTitle:@"Cancel"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                                               {
                                                   //Do some thing here
                                                   [_alertView dismissViewControllerAnimated:YES completion:nil];
                                                   
                                                   [swt setOn:false];
                                               }];
                
                
                
                [_alertView addAction:cancelAction];
                [_alertView addAction:okAction];
                
                [self presentViewController:_alertView animated:YES completion:nil];
            }
        }
    }else if (swt == swtAwEmail){
        
        if (swtAwEmail.on) {
            
            if (theAppDelegate.gUserData.user_email.length == 0) {
                
                UIAlertController *_alertView = [UIAlertController alertControllerWithTitle:nil message:@"Email address required for Email alerts." preferredStyle:UIAlertControllerStyleAlert];
                
                [_alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    textField.placeholder = @"Email address";
                }];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    UITextField *alertEmail = _alertView.textFields.firstObject;
                    if (alertEmail.text.length != 0) {
                        
                        [self onRequestEmailVerify:alertEmail.text swtType:swt_answer_email];
                        
                    }else{
                        
                        [_alertView dismissViewControllerAnimated:YES completion:nil];
                        
                        [swt setOn:false];
                    }
                }];
                
                UIAlertAction *cancelAction = [UIAlertAction
                                               actionWithTitle:@"Cancel"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                                               {
                                                   //Do some thing here
                                                   [_alertView dismissViewControllerAnimated:YES completion:nil];
                                                   
                                                   [swt setOn:false];
                                               }];
                
                
                [_alertView addAction:okAction];
                [_alertView addAction:cancelAction];
                
                [self presentViewController:_alertView animated:YES completion:nil];
                
            }
        }
    }else if (swt == swtQtEmail){
        
        if (swtQtEmail.on) {
            
            if (theAppDelegate.gUserData.user_email.length == 0) {
                
                UIAlertController *_alertView = [UIAlertController alertControllerWithTitle:nil message:@"Email address required for Email alerts." preferredStyle:UIAlertControllerStyleAlert];
                
                [_alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    textField.placeholder = @"Email address";
                }];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    UITextField *alertEmail = _alertView.textFields.firstObject;
                    if (alertEmail.text.length != 0) {
                        
                        [self onRequestEmailVerify:alertEmail.text swtType:swt_question_email];
                        
                    }else{
                        
                        [_alertView dismissViewControllerAnimated:YES completion:nil];
                        
                        [swt setOn:false];
                    }
                }];
                
                UIAlertAction *cancelAction = [UIAlertAction
                                               actionWithTitle:@"Cancel"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                                               {
                                                   //Do some thing here
                                                   [_alertView dismissViewControllerAnimated:YES completion:nil];
                                                   
                                                   [swt setOn:false];
                                               }];
                
                
                [_alertView addAction:okAction];
                [_alertView addAction:cancelAction];
                
                [self presentViewController:_alertView animated:YES completion:nil];
                
            }
        }
    }
}

//-(void)alertTextFieldDidChange:(UITextField*)sender{
//
//    UIAlertController *alertController = (UIAlertController*)self.presentedViewController;
//    
//    if (alertController) {
//        txtPhone = alertController.textFields.firstObject;
//        
//        UIAlertAction *okAction = alertController.actions.lastObject;
//        
//        okAction.enabled = txtPhone.text.length>10;
//    }
//}

-(void)onRequestUpdatePhoneNumber:(NSString*)userPhone swtType:(int)swtType{
    [SVProgressHUD showWithStatus:REQUEST_WAITING];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_VERIFY_SENT_SMS]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *paramterDic;
    
    paramterDic = @{
                    @"user_id":theAppDelegate.gUserData.user_id,
                    @"user_phone":userPhone};
    
    
    [manager POST:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ( [responseObject count] > 0 ) {
            
            NSDictionary *responseDic = [responseObject objectAtIndex:0];
            int nStatus = [[responseDic objectForKey:@"status"] intValue];
            if (nStatus == 200) {
                
                [SVProgressHUD dismiss];
                
                PhoneVerifyVC *nConfirmVC = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"PhoneVerifyVC"];
                
                nConfirmVC.swtType = swtType;
                nConfirmVC.delegate = self;
                nConfirmVC.phoneNumber = txtPhone.text;
                nConfirmVC.pageFlag = verify_sms;
                [self.navigationController pushViewController:nConfirmVC animated:YES];
                
                if (swtType == swt_answer_sms) {
                    [swtAwSMS setOn:false];
                }else{
                    [swtQtSMS setOn:false];
                }
                
            }else{
                
                if (nStatus == 201) {
                    [SVProgressHUD showErrorWithStatus:@"Phone number is incorrect"];
                }else{
                    [SVProgressHUD showErrorWithStatus:WEB_FAILED];
                }
                
                if (swtType == swt_answer_sms) {
                    [swtAwSMS setOn:false];
                }else{
                    [swtQtSMS setOn:false];
                }
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseString);
        [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        if (swtType == swt_answer_sms) {
            [swtAwSMS setOn:false];
        }else{
            [swtQtSMS setOn:false];
        }
        
    }];
}

-(void)onSuccessVerify:(int)swtType{
    
    if (swtType == swt_question_sms) {
        [swtQtSMS setOn:true];
    }else if (swtType == swt_answer_sms){
        [swtAwSMS setOn:true];
    }
}

-(void)onRequestEmailVerify:(NSString*)userEmail swtType:(int)swtType{
    [SVProgressHUD showWithStatus:REQUEST_WAITING];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_VERIFY_SENT_EMAIL]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *paramterDic;
    
    paramterDic = @{
                    @"user_id":theAppDelegate.gUserData.user_id,
                    @"user_email":userEmail,
                    @"swt_type":[NSNumber numberWithInt:swtType]};
    
    
    [manager POST:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ( [responseObject count] > 0 ) {
            
            NSDictionary *responseDic = [responseObject objectAtIndex:0];
            int nStatus = [[responseDic objectForKey:@"status"] intValue];
            if (nStatus == 200) {
                
//                [SVProgressHUD dismiss];
                
//                EmailVerifyVC *nConfirmVC = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"EmailVerifyVC"];
//                
//                nConfirmVC.swtType = swtType;
//                nConfirmVC.delegate = self;
//                nConfirmVC.emailAddress = userEmail;
//                
//                [self.navigationController pushViewController:nConfirmVC animated:YES];

                
                [SVProgressHUD showSuccessWithStatus:@"Please confirm e-mail"];
                
                theAppDelegate.gUserData.user_email = userEmail;
                
                [[Utility getInstance]saveUserData:theAppDelegate.gUserData];
                
                [txtEmail setText:theAppDelegate.gUserData.user_email];
                
                if (swtType == swt_question_email) {
                    [swtQtEmail setOn:false];
                }else{
                    [swtAwEmail setOn:false];
                }
                
            }else{
                
                [SVProgressHUD showErrorWithStatus:WEB_FAILED];
                
                if (swtType == swt_question_email) {
                    [swtQtEmail setOn:false];
                }else{
                    [swtAwEmail setOn:false];
                }
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseString);
        [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        if (swtType == swt_question_email) {
            [swtQtEmail setOn:false];
        }else{
            [swtAwEmail setOn:false];
        }
        
    }];
}
-(void)onSuccessEmailVerify:(int)swtType{
    
    [txtEmail setText:theAppDelegate.gUserData.user_email];

    if (swtType == swt_question_email) {
        [swtQtEmail setOn:true];
    }else{
        [swtAwEmail setOn:true];
    }
}

-(IBAction)onFeedback:(id)sender{
    UIAlertController *_alertView = [UIAlertController alertControllerWithTitle:nil message:@"Feedback" preferredStyle:UIAlertControllerStyleAlert];
    
    [_alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Share your thoughts with us";
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UITextField *alertEmail = _alertView.textFields.firstObject;
        alertEmail.frame = CGRectMake(alertEmail.frame.origin.x, alertEmail.frame.origin.y, alertEmail.frame.size.width, 30);
        
        if (alertEmail.text.length != 0) {
            
            [self onRequestFeedback:alertEmail.text feedbackView:_alertView];
            
        }else{
            
            [_alertView dismissViewControllerAnimated:YES completion:nil];
            
            
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       //Do some thing here
                                       [_alertView dismissViewControllerAnimated:YES completion:nil];
                                       
                                   }];
    
    
    [_alertView addAction:okAction];
    [_alertView addAction:cancelAction];
    
    [self presentViewController:_alertView animated:YES completion:nil];
}

-(void)onRequestFeedback:(NSString*)feedback feedbackView:(UIAlertController*)feedbackView{
    [SVProgressHUD showWithStatus:REQUEST_WAITING];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_SENT_FEEDBACK]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *paramterDic;
    
    paramterDic = @{
                    @"user_id":theAppDelegate.gUserData.user_id,
                    @"user_feedback":feedback};
    
    
    [manager POST:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ( [responseObject count] > 0 ) {
            
            NSDictionary *responseDic = [responseObject objectAtIndex:0];
            int nStatus = [[responseDic objectForKey:@"status"] intValue];
            if (nStatus == 200) {
                
                [SVProgressHUD showSuccessWithStatus:@"Thank you!"];
                
                [feedbackView dismissViewControllerAnimated:YES completion:nil];
                
            }else{
                
                [SVProgressHUD showErrorWithStatus:WEB_FAILED];
                
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:WEB_FAILED];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseString);
        
        [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        
        
    }];
}

-(IBAction)onInfo:(id)sender{
    NSString *strMessage = @"Set your alerts so you get alerted when a user asks questions in the community, or when when users answer your questions. Incredibly convenient, these alerts lets you stay plugged in without needing to watch the application.\n\n*note: SMS alerts will send text messages to your phone ";
    
    [lblInfo setText:strMessage];
    
    [lblInfo sizeToFit];
    
    if (!infoAlertView) {
        
        UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, lblInfo.frame.size.height + 20)];
        lblInfo.frame = CGRectMake(10, 10, lblInfo.frame.size.width, lblInfo.frame.size.height);
        [infoView addSubview:lblInfo];
        
        infoAlertView = [[CustomIOS7AlertView alloc] init];
        [infoAlertView setContainerView:infoView];
        
        [infoAlertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Ok", nil]];
        [infoAlertView setDelegate:self];
        [infoAlertView setUseMotionEffects:true];
    }
    
    [infoAlertView show];
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [alertView close];
        
    }
}

-(IBAction)onVoiceChange:(id)sender{
    
    [[NSUserDefaults standardUserDefaults] setFloat:sliderVoice.value forKey:@"voice_rate"];
    [[NSUserDefaults standardUserDefaults]synchronize];

    [lblVoiceValue setText:[NSString stringWithFormat:@"Voice Value: %.2f",[[NSUserDefaults standardUserDefaults] floatForKey:@"voice_rate"]]];
    
    
}

//-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
//    return 1;
//}
//
//-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
//    
//    return [voiceTypesData count];
//}
//
//-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//
//    UILabel *lblVoice = (UILabel*)view;
//    
//    if (pickerView == voicePicker) {
//        
//        NSString *strData = [voiceTypesData objectAtIndex:row];
//        
//        if (!lblVoice) {
//            lblVoice = [[UILabel alloc]init];
//            [lblVoice setFont:[UIFont systemFontOfSize:12]];
//            [lblVoice setText:strData];
//            lblVoice.textAlignment = NSTextAlignmentCenter;
//        }
//        
//        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"voice_type"] isEqualToString:strData]) {
//            [pickerView selectRow:row inComponent:component animated:YES];
//        }
//        
//    }
//    return lblVoice;
//}
//
//-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
//    
//    NSString *strData = [voiceTypesData objectAtIndex:row];
//    
//    [[NSUserDefaults standardUserDefaults] setObject:strData forKey:@"voice_type"];
//    
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}



@end
