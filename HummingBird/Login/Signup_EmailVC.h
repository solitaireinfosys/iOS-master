//
//  Signup_EmailVC.h
//  HummingBird
//
//  Created by Star on 12/5/15.
//  Copyright © 2015 Star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Signup_EmailVC : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *txtEmail;
 
    IBOutlet UIImageView *imgLogo;
    
    IBOutlet UIButton *btnFlag;
}

-(IBAction)onSignup:(id)sender;
@end
