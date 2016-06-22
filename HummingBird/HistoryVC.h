//
//  HistoryVC.h
//  HummingBird
//
//  Created by Star on 12/5/15.
//  Copyright © 2015 Star. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class GADBannerView;

@interface HistoryVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>
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

}

@property (nonatomic,retain)NSMutableArray *mQuestionData;

//@property(nonatomic, weak) IBOutlet GADBannerView *bannerView;

@end
