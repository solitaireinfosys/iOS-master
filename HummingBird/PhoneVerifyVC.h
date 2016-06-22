//
//  PhoneVerifyVC.h
//  HummingBird
//
//  Created by Star on 1/7/16.
//  Copyright (c) 2016 Star. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol verifyDelegate

-(void)onSuccessVerify:(int)swtType;

@end

@interface PhoneVerifyVC : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *txtVerify;
    IBOutlet UIButton *btnSkip;
    
    IBOutlet UIImageView *imgLogo;
}

@property (nonatomic,retain)NSString *phoneNumber;

@property (nonatomic,readwrite)int pageFlag;

@property (nonatomic,retain) id<verifyDelegate> delegate;

@property (nonatomic,readwrite)int swtType;

@end
