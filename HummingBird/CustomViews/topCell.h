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
@class topModel;

@interface topCell : UITableViewCell{//<GADInterstitialDelegate> {
    
    IBOutlet UIButton *btnLike;
    IBOutlet UILabel *lblQuestion;
    IBOutlet UILabel *lblLike;
}

@property (nonatomic,retain)topModel *mTopData;

@property (nonatomic,retain)IBOutlet UIView *questionView;
@property (nonatomic, weak) IBOutlet GADBannerView *bannerView;

@property (nonatomic,retain)UIViewController *rootControl;
//@property(nonatomic, strong) GADInterstitial *interstitial;
-(void)setShowUI;
-(void)setShowAd:(int)nIndex;

@end
