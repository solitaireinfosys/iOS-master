//
//  Signup_EmailVC.m
//  HummingBird
//
//  Created by Star on 12/5/15.
//  Copyright © 2015 Star. All rights reserved.
//

#import "Signup_EmailVC.h"
#import "AppDelegate.h"
#import "userModel.h"
#import "Common.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "Utility.h"
#import "ConfirmVC.h"
#import "Signup_PasswordVC.h"

@interface Signup_EmailVC ()

@end

@implementation Signup_EmailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    btnFlag.hidden = YES;
    
#ifdef humming_dev
    
    [imgLogo setImage:[UIImage imageNamed:@"splash_dev_icon"]];
#endif
    self.navigationItem.title = @"Email";
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@""]) {
        
        if (textField.text.length <= 1) {
            btnFlag.hidden = YES;
        }else{
            
            btnFlag.hidden = NO;
            
            NSLog(@"%@",[NSString stringWithFormat:@"%@",[textField.text substringToIndex:textField.text.length-1]]);
            
            if ([self NSStringIsValidEmail:[NSString stringWithFormat:@"%@",[textField.text substringToIndex:textField.text.length-1]]]) {
                
                [btnFlag setImage:[UIImage imageNamed:@"Checked-rect"] forState:UIControlStateNormal];
            }else{
                
                [btnFlag setImage:[UIImage imageNamed:@"Close-rect"] forState:UIControlStateNormal];
            }
            
        }
        
        
    }else{
        if ([self NSStringIsValidEmail:[NSString stringWithFormat:@"%@%@",textField.text,string]]) {
            
            [btnFlag setImage:[UIImage imageNamed:@"Checked-rect"] forState:UIControlStateNormal];
        }else{
            
            [btnFlag setImage:[UIImage imageNamed:@"Close-rect"] forState:UIControlStateNormal];
        }
        
        if ([[NSString stringWithFormat:@"%@%@",textField.text,string] isEqualToString:@""]) {
            btnFlag.hidden = YES;
        }else{
            btnFlag.hidden = NO;
        }
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [txtEmail resignFirstResponder];
    
    return YES;
}
-(IBAction)onSignup:(id)sender{
    
    [txtEmail resignFirstResponder];
    
    if (txtEmail.text.length != 0) {
        
        [self onRequestCapture];
        
        
    }else{

        [SVProgressHUD showErrorWithStatus:EMAIL_WARNING];
    }
}

-(void)onRequestCapture{
    
    [SVProgressHUD showWithStatus:REQUEST_WAITING];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_CAPTURE_MAIL]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *paramterDic = @{@"user_email":txtEmail.text};
    
    manager.requestSerializer = [AFHTTPRequestSerializer new];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    [manager POST:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if (![self NSStringIsValidEmail:[NSString stringWithFormat:@"%@",txtEmail.text]]) {
            
            [SVProgressHUD showErrorWithStatus:@"You must have a valid e-mail address before you continue"];
            
        }else{
            if ( [responseObject count] > 0 ) {
                
                NSDictionary *responseDic = [responseObject objectAtIndex:0];
                if ([[responseDic objectForKey:@"status"] intValue] == 200) {
                    
                    [SVProgressHUD dismiss];
                    
                    Signup_PasswordVC *signVC = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"Signup_PasswordVC"];
                    
                    signVC.mUserEmail = txtEmail.text;
                    
                    [self.navigationController pushViewController:signVC animated:YES];
                    
                }else if ([[responseDic objectForKey:@"status"] intValue] == 201){
                    
                    [SVProgressHUD showErrorWithStatus:@"Email already exist"];
                }else {
                    
                    [SVProgressHUD showErrorWithStatus:WEB_FAILED];
                }
                
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",operation.responseString);
        if (![self NSStringIsValidEmail:[NSString stringWithFormat:@"%@",txtEmail.text]]) {
            
            
            [SVProgressHUD showErrorWithStatus:@"You must have a valid e-mail address before you continue"];
        }else{

            [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        }
        
        
    }];
    
    
}
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
@end
