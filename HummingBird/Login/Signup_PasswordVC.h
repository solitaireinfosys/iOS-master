//
//  Signup_PasswordVC.h
//  HummingBird
//
//  Created by Star on 12/5/15.
//  Copyright © 2015 Star. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Signup_PasswordVC : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *txtPassword;
    
    IBOutlet UIImageView *imgLogo;
}

@property (nonatomic,retain)NSString *mUserEmail;
-(IBAction)onSignup:(id)sender;
@end
