//
//  OneOnOneChatVC.h
//  HummingBird
//
//  Created by LaNet on 6/9/16.
//  Copyright © 2016 Star. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SOMessagingViewController.h"

#import "RatingVC.h"

#import "CustomIOS7AlertView.h"

#import "ISSpeechRecognition.h"

#import <AVFoundation/AVFoundation.h>

@class questionModel;

@interface OneOnOneChatVC : SOMessagingViewController<ratingDelegate,CustomIOS7AlertViewDelegate,AVSpeechSynthesizerDelegate,ISSpeechRecognitionDelegate>
{
//    IBOutlet UIView *ratingView;
    IBOutlet NSLayoutConstraint *rating_y;
    IBOutlet UIButton *btnSubmit;
    
    IBOutlet UIView *shareView;
    IBOutlet UISwitch *swtShare;
    __weak IBOutlet UIView *uiview1;
    
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
