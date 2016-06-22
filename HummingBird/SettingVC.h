//
//  SettingVC.h
//  HummingBird
//
//  Created by Star on 12/28/15.
//  Copyright (c) 2015 Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhoneVerifyVC.h"
#import "EmailVerifyVC.h"
#import "CustomIOS7AlertView.h"

@interface SettingVC : UIViewController<UITextFieldDelegate,verifyDelegate,verifyEmailDelegate,CustomIOS7AlertViewDelegate>//,UIPickerViewDataSource,UIPickerViewDelegate>
{
    
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtPassword;
    
    IBOutlet UISwitch *swtQtEmail;
    IBOutlet UISwitch *swtQtPush;
    IBOutlet UISwitch *swtQtSMS;
    
    IBOutlet UISwitch *swtAwEmail;
    IBOutlet UISwitch *swtAwPush;
    IBOutlet UISwitch *swtAwSMS;
    
    UITextField *txtPhone;
    
    IBOutlet UIImageView *imgLogo;
    
    IBOutlet UILabel *lblInfo;
    CustomIOS7AlertView *infoAlertView;
    
    IBOutlet UILabel *lblVoiceValue;
    IBOutlet UISlider *sliderVoice;
    
//    IBOutlet UIPickerView *voicePicker;
//    NSMutableArray *voiceTypesData;
}
@end
