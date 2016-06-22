//
//  PhoneVerifyVC.h
//  HummingBird
//
//  Created by Star on 1/7/16.
//  Copyright (c) 2016 Star. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol verifyEmailDelegate

-(void)onSuccessEmailVerify:(int)swtType;

@end

@interface EmailVerifyVC : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *txtVerify;
    IBOutlet UIImageView *imgLogo;
}

@property (nonatomic,retain)NSString *emailAddress;

@property (nonatomic,retain) id<verifyEmailDelegate> delegate;

@property (nonatomic,readwrite)int swtType;

@end
