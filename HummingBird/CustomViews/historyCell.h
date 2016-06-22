//
//  historyCell.h
//  umami
//
//  Created by Star on 9/7/15.
//  Copyright (c) 2015 Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class GADBannerView;

@class questionModel;


@interface historyCell : UITableViewCell{//<GADInterstitialDelegate> {
    
    IBOutlet UIImageView *imgPhoto;
    IBOutlet UILabel *lblQuestion;
}

@property (nonatomic,retain)questionModel *mQuestionData;
@property (nonatomic,retain)IBOutlet UIButton *btnUserProfile;

@property (nonatomic,retain)IBOutlet UIImageView *imgStar1;
@property (nonatomic,retain)IBOutlet UIImageView *imgStar2;
@property (nonatomic,retain)IBOutlet UIImageView *imgStar3;
@property (nonatomic,retain)IBOutlet UIImageView *imgStar4;
@property (nonatomic,retain)IBOutlet UIImageView *imgStar5;

@property (nonatomic,retain)IBOutlet UIView *starView;

@property (nonatomic,retain)IBOutlet UIView *historyView;

@property (nonatomic, weak) IBOutlet GADBannerView *bannerView;
//@property(nonatomic, strong) GADInterstitial *interstitial;

@property (nonatomic,retain)UIViewController *rootControl;

-(void)setShowUI;
-(void)setShowAd:(int)nIndex;

@end
