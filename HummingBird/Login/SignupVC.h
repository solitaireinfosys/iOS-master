//
//  SignupVC.h
//  HummingBird
//
//  Created by Star on 12/5/15.
//  Copyright © 2015 Star. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CountryPicker.h"

@interface SignupVC : UIViewController<UITextFieldDelegate,CountryPickerDelegate>
{
    IBOutlet UITextField *txtPhoneNumber;
    IBOutlet UIImageView *imgLogo;
    
    IBOutlet CountryPicker *picker_country;
}

@property (nonatomic,retain)NSString *mUserEmail;
@property (nonatomic,retain)NSString *mUserPassword;

-(IBAction)onSignup:(id)sender;

@end
