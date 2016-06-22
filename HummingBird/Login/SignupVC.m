//
//  SignupVC.m
//  HummingBird
//
//  Created by Star on 12/5/15.
//  Copyright © 2015 Star. All rights reserved.
//

#import "SignupVC.h"
#import "AppDelegate.h"
#import "userModel.h"
#import "Common.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "Utility.h"
#import "ConfirmVC.h"
#import "PhoneVerifyVC.h"
#import "SSAddFriend.h"


@interface SignupVC ()

@end

@implementation SignupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#ifdef humming_dev
    
    [imgLogo setImage:[UIImage imageNamed:@"splash_dev_icon"]];
#endif
    self.navigationItem.title = @"Country";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
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
    
    [txtPhoneNumber resignFirstResponder];
    
    return YES;
}
-(IBAction)onSignup:(id)sender{
    
    [txtPhoneNumber resignFirstResponder];

    [self onRequestSignup];

}

#pragma mark - request api to Signup
-(void)onRequestSignup{
    
    [SVProgressHUD showWithStatus:REQUEST_WAITING];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_SIGNUP]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if (theAppDelegate.uDeviceToken == nil) {
        theAppDelegate.uDeviceToken = @"d6cdb99035f272c8a7bb774a2cdc8319e73a4c54caacf50bb0c0b84161f3c48c";
    }
    int nIpFlag = 0;
    if (![[theAppDelegate getIpAddress] isEqualToString:@"error"]) {
        nIpFlag = 1;
    }
    
    NSDictionary *paramterDic;
    
    NSString *strPhone = txtPhoneNumber.text;
    
    if (strPhone.length == 0) {
        
        paramterDic = @{@"user_email":_mUserEmail,
                        @"user_password":_mUserPassword,
                        @"user_device":theAppDelegate.uDeviceToken,
                        @"user_country":picker_country.selectedCountryName,
                        @"user_lat":[NSString stringWithFormat:@"%f",theAppDelegate.uLat],
                        @"user_long":[NSString stringWithFormat:@"%f",theAppDelegate.uLong],
                        @"phone_flag":[NSNumber numberWithInt:0],
                        @"user_ip":[theAppDelegate getIpAddress],
                        @"ip_flag":[NSNumber numberWithInt:nIpFlag]};
        
    }else{
      
        paramterDic = @{@"user_email":_mUserEmail,
                        @"user_password":_mUserPassword,
                        @"user_device":theAppDelegate.uDeviceToken,
                        @"user_country":picker_country.selectedCountryName,
                        @"user_lat":[NSString stringWithFormat:@"%f",theAppDelegate.uLat],
                        @"user_long":[NSString stringWithFormat:@"%f",theAppDelegate.uLong],
                        @"user_phone":txtPhoneNumber.text,
                        @"phone_flag":[NSNumber numberWithInt:1],
                        @"user_ip":[theAppDelegate getIpAddress],
                        @"ip_flag":[NSNumber numberWithInt:nIpFlag]};
    }
    
    manager.requestSerializer = [AFHTTPRequestSerializer new];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    [manager POST:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ( [responseObject count] > 0 ) {
            
            NSDictionary *responseDic = [responseObject objectAtIndex:0];
            int nStatus = [[responseDic objectForKey:@"status"] intValue];
            if (nStatus == 200) {
                
                [SVProgressHUD dismiss];
                
                theAppDelegate.gUserData = [[Utility getInstance] onParseUser:responseDic];
                
                if (strPhone.length != 0) {
                    
                    PhoneVerifyVC *nConfirmVC = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"PhoneVerifyVC"];
                    
                    nConfirmVC.phoneNumber = strPhone;
                    nConfirmVC.pageFlag = verify_signup;
                    [self.navigationController pushViewController:nConfirmVC animated:YES];
//                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:nConfirmVC];
//                    
//                    [self presentViewController:nav animated:YES completion:^{
//                        [self.navigationController popToRootViewControllerAnimated:YES];
//                    }];
                    
                }else{
                    
                    ConfirmVC *nConfirmVC = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"ConfirmVC"];
                    
                    nConfirmVC.mUserData = theAppDelegate.gUserData;
                    
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:nConfirmVC];
                    
                    [self presentViewController:nav animated:YES completion:^{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }];
                    
                }
                
            }else{
                
                if (nStatus == 202) {
                     [SVProgressHUD showErrorWithStatus:@"Email already exist, please try again."];
                }else if (nStatus == 203){
                    
                    [SVProgressHUD showErrorWithStatus:@"Phone number is incorrect"];
                }else{
                    [SVProgressHUD showErrorWithStatus:LOGIN_FAILED];
                }
               
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseString);
        [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        
        
    }];
}

- (void)countryPicker:(__unused CountryPicker *)picker didSelectCountryWithName:(NSString *)name code:(NSString *)code
{
    
    NSLog(@"%@",picker_country.selectedCountryName);
//    self.nameLabel.text = name;
//    self.codeLabel.text = code;
}
@end
