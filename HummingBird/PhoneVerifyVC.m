//
//  PhoneVerifyVC.m
//  HummingBird
//
//  Created by Star on 1/7/16.
//  Copyright (c) 2016 Star. All rights reserved.
//

#import "PhoneVerifyVC.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "userModel.h"
#import "AFNetworking.h"
#import "ConfirmVC.h"
#import "Common.h"
#import "Utility.h"

@interface PhoneVerifyVC ()

@end

@implementation PhoneVerifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#ifdef humming_dev
    
    [imgLogo setImage:[UIImage imageNamed:@"splash_dev_icon"]];
#endif
    self.navigationItem.title = @"Verfiy Code";
    
    if (_pageFlag == verify_sms) {
        self.navigationItem.hidesBackButton = NO;
        btnSkip.hidden = YES;
    }else{
        self.navigationItem.hidesBackButton = YES;
        btnSkip.hidden = NO;
    }

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

-(IBAction)onVerify:(id)sender{
    
    [txtVerify resignFirstResponder];
    
    if (txtVerify.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"Please input the verify code"];
    }else{
        [self onRequestVerify];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [txtVerify resignFirstResponder];
    
    return YES;
}
-(void)onRequestVerify{
    
    [SVProgressHUD showWithStatus:REQUEST_WAITING];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_VERIFY_PHONE]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    NSDictionary *paramterDic;
    
    paramterDic = @{@"user_id":theAppDelegate.gUserData.user_id,
                    @"user_phone":_phoneNumber,
                    @"verify_code":txtVerify.text};
    
    manager.requestSerializer = [AFHTTPRequestSerializer new];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    [manager POST:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ( [responseObject count] > 0 ) {
            
            NSDictionary *responseDic = [responseObject objectAtIndex:0];
            int nStatus = [[responseDic objectForKey:@"status"] intValue];
            if (nStatus == 200) {
                
                [SVProgressHUD dismiss];
                
                theAppDelegate.gUserData.user_phone = _phoneNumber;
                
                [[Utility getInstance]saveUserData:theAppDelegate.gUserData];
                
                if (_pageFlag == verify_sms) {
                    
                
                    __strong id<verifyDelegate> strongDelegate = _delegate;
                    [strongDelegate onSuccessVerify:_swtType];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else{
                    ConfirmVC *nConfirmVC = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"ConfirmVC"];
                    
                    nConfirmVC.mUserData = theAppDelegate.gUserData;
                    
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:nConfirmVC];
                    
                    [self presentViewController:nav animated:YES completion:^{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }];
                }
                
            }else{
                if (nStatus == 201) {
                    [SVProgressHUD showErrorWithStatus:@"Verify code is incorrect"];
                }else{
                    [SVProgressHUD showErrorWithStatus:WEB_FAILED];
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

-(IBAction)onSkip:(id)sender{
    
    [txtVerify resignFirstResponder];
    
    ConfirmVC *nConfirmVC = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"ConfirmVC"];
    
    nConfirmVC.mUserData = theAppDelegate.gUserData;
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:nConfirmVC];
    
    [self presentViewController:nav animated:YES completion:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

@end
