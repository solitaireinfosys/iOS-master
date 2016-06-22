//
//  questionCell.h
//  umami
//
//  Created by Star on 9/7/15.
//  Copyright (c) 2015 Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class GADBannerView;
@class questionModel;

@interface questionCell : UITableViewCell{//<GADInterstitialDelegate> {
    
    IBOutlet UIImageView *imgPhoto;
    IBOutlet UILabel *lblQuestion;
    IBOutlet UILabel *lblDate;
}

@property (nonatomic,retain)questionModel *mQuestionData;
@property (nonatomic,retain)IBOutlet UIButton *btnUserProfile;

@property (nonatomic,retain)IBOutlet UIView *questionView;
@property (nonatomic, weak) IBOutlet GADBannerView *bannerView;

@property (nonatomic,retain)UIViewController *rootControl;
//@property(nonatomic, strong) GADInterstitial *interstitial;
-(void)setShowUI;
-(void)setShowAd:(int)nIndex;

@end
