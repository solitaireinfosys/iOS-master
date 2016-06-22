//
//  ConversationVC.h
//  HummingBird
//
//  Created by Star on 12/5/15.
//  Copyright © 2015 Star. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SOMessagingAnswerViewController.h"
#import "SOMessagingViewController.h"
#import "CustomIOS7AlertView.h"

@protocol answerDelegate

-(void)onAnswered:(int)nIndex;

@end

@class questionModel;

@interface AnswerVC : SOMessagingAnswerViewController<UIAlertViewDelegate,CustomIOS7AlertViewDelegate>
//@interface AnswerVC : SOMessagingViewController
{
    
    IBOutlet UILabel *lblInfo;
    CustomIOS7AlertView *infoAlertView;
}

@property (nonatomic,retain)questionModel *mQuestionData;
@property (nonatomic,readwrite)int mQuestionIndex;

@property (nonatomic,retain) id<answerDelegate> delegate;

@end
