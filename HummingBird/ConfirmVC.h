//
//  ConfirmVC.h
//  HummingBird
//
//  Created by Star on 12/11/15.
//  Copyright (c) 2015 Star. All rights reserved.
//

#import <UIKit/UIKit.h>

@class userModel;

@interface ConfirmVC : UIViewController
{
    IBOutlet UIButton *btnContinue;
    IBOutlet UIButton *btnBack;
    IBOutlet UIButton *btnResend;
    
    IBOutlet UIImageView *imgLogo;
}

@property (nonatomic,retain)userModel *mUserData;

@end
