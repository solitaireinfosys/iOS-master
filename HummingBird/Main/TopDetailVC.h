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

@class topModel;

@interface TopDetailVC : SOMessagingAnswerViewController<UIAlertViewDelegate>
//@interface AnswerVC : SOMessagingViewController
{
    
}

@property (nonatomic,retain)topModel *mTopData;

@end
