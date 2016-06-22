//
//  ForgotVC.m
//  HummingBird
//
//  Created by Star on 12/17/15.
//  Copyright (c) 2015 Star. All rights reserved.
//

#import "ForgotVC.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "Common.h"

@interface ForgotVC ()

@end

@implementation ForgotVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
#ifdef humming_dev
    
    [imgLogo setImage:[UIImage imageNamed:@"splash_dev_icon"]];
#endif
    self.navigationItem.title = @"Forgot Password";
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
    
    if (textField == txtEmail) {
        [txtEmail resignFirstResponder];
        [self onRequestSendPassword];
    }
    return YES;
}

-(IBAction)onSend:(id)sender{
 
    [self onRequestSendPassword];
}

-(void)onRequestSendPassword{
    
    [txtEmail resignFirstResponder];
    
    if (txtEmail.text.length != 0) {
        
        [SVProgressHUD showWithStatus:REQUEST_WAITING];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_FORGOT_PASSWORD]];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *paramterDic = @{@"user_email":txtEmail.text};
        
        [manager POST:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            //
            
            if ( [responseObject count] > 0 ) {
                
                NSDictionary *responseDic = [responseObject objectAtIndex:0];
                if ([[responseDic objectForKey:@"status"] intValue] == 200) {
                    
                    
                    [SVProgressHUD showSuccessWithStatus:@"Please check your mail."];
                    
                    
                }else if ([[responseDic objectForKey:@"status"] intValue] == 201){
                    
                    [SVProgressHUD showErrorWithStatus:@"Email is not exist"];
                    
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
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"Please input the email"];
    }
}
@end
