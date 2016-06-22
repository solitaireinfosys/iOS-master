//
//  ConversationVC.h
//  HummingBird
//
//  Created by Star on 12/5/15.
//  Copyright © 2015 Star. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SOMessagingViewController.h"

#import "RatingVC.h"

#import "CustomIOS7AlertView.h"

#import "ISSpeechRecognition.h"

#import <AVFoundation/AVFoundation.h>

@class questionModel;

@interface ConversationVC : SOMessagingViewController<ratingDelegate,CustomIOS7AlertViewDelegate,AVSpeechSynthesizerDelegate,ISSpeechRecognitionDelegate>
{
    
    IBOutlet UIView *ratingView;
    IBOutlet NSLayoutConstraint *rating_y;
    
    IBOutlet UIButton *btnStar1;
    IBOutlet UIButton *btnStar2;
    IBOutlet UIButton *btnStar3;
    IBOutlet UIButton *btnStar4;
    IBOutlet UIButton *btnStar5;
    
    IBOutlet UIButton *btnSubmit;
    IBOutlet UILabel *lblTopAnswer;
    
    IBOutlet UIView *shareView;
    IBOutlet UISwitch *swtShare;
    __weak IBOutlet UIView *uiview1;
    
    IBOutlet UILabel *lblInfo;
    CustomIOS7AlertView *infoAlertView;
    
    BOOL nCheckRatingFlag;
    
    IBOutlet UIView *menuView;
    
    IBOutlet NSLayoutConstraint *menuStartX;

    IBOutlet UIButton *btnMenu;
    IBOutlet UITapGestureRecognizer *tapMenuHide;
}
@property (nonatomic,retain)questionModel *mQuestionData;
@property (nonatomic,retain)NSTimer *refreshTimer;
@property (nonatomic,retain)Message *mSelectedRatingQuestionMessage;
@property (nonatomic,retain)Message *mSelectedRatingAnswerMessage;

@property (nonatomic,retain)Message *mMessageData;

@property (nonatomic,readwrite)int nSelectPlayIndex;
@property (nonatomic,readwrite)int nSelectPlayFlag;

@end
