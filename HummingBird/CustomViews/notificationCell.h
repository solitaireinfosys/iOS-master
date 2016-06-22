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
@class notificationModel;

@interface notificationCell : UITableViewCell{//<GADInterstitialDelegate> {
    
    IBOutlet UIImageView *imgStatus;
    IBOutlet UILabel *lblNotification;
    IBOutlet UILabel *lblDate;
}

@property (nonatomic,retain)notificationModel *mNotificationData;


@property (nonatomic,retain)IBOutlet UIView *notificationView;
@property (nonatomic, weak) IBOutlet GADBannerView *bannerView;

@property (nonatomic,retain)UIViewController *rootControl;
//@property(nonatomic, strong) GADInterstitial *interstitial;
-(void)setShowUI;
-(void)setShowAd:(int)nIndex;

@end
