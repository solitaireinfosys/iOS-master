//
//  QuestionsVC.h
//  HummingBird
//
//  Created by Star on 12/5/15.
//  Copyright © 2015 Star. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AnswerVC.h"
@class GADBannerView;
@class BBBadgeBarButtonItem;

@interface CommunityVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate,answerDelegate>
{
    IBOutlet UITableView *tblQuestion;
    IBOutlet UILabel *lblTemplate;
    int nLoadmoreFlag;
    int nCurrentPageNumber;
    CGRect tempRect;
    
    IBOutlet UILabel *lblRating;
    IBOutlet UILabel *lblAnswers;
    IBOutlet UILabel *lblCredit;
    
    int ad_space_limit;
    
    BBBadgeBarButtonItem *barMenu;
    
    IBOutlet UIView *menuView;
    IBOutlet UIView *rootView;
    
    IBOutlet NSLayoutConstraint *menuStartX;
    
    IBOutlet UITapGestureRecognizer *tapMenuHide;
}

@property (nonatomic,retain)NSMutableArray *mQuestionData;
@property (nonatomic,retain)NSTimer *refreshTimer;

@property (nonatomic,retain)NSTimer *refreshTimer_userInfo;
//@property(nonatomic, weak) IBOutlet GADBannerView *bannerView;

@end

