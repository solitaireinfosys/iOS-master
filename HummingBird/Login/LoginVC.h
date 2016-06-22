//
//  LoginVC.h
//  HummingBird
//
//  Created by Star on 12/5/15.
//  Copyright © 2015 Star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtPassword;
    
    IBOutlet UIView *loginView;
    
    IBOutlet UIImageView *imgLogo;
    
}

-(IBAction)onLogin:(id)sender;
-(IBAction)onSignup:(id)sender;

@end
