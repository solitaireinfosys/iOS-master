//
//  questionCell.m
//  umami
//
//  Created by Star on 9/7/15.
//  Copyright (c) 2015 Star. All rights reserved.
//

#import "questionCell.h"
#import "userModel.h"
#import "questionModel.h"
#import "NSDate+TimeAgo.h"


@import GoogleMobileAds;

static NSString *kBaseDateFormat = @"yyyy-MM-dd HH:mm:ss";

@implementation questionCell

-(void)setShowUI{
    
    _questionView.hidden = NO;
    _bannerView.hidden = YES;
    
    NSDateFormatter *pstFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *pstTimezone = [NSTimeZone timeZoneWithName:@"America/Los_Angeles"];
    [pstFormatter setTimeZone:pstTimezone];
    [pstFormatter setDateFormat:kBaseDateFormat];
    NSDate *pstDate = [pstFormatter dateFromString:_mQuestionData.question_date];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.timeZone = [NSTimeZone systemTimeZone];
    [fmt setDateFormat:kBaseDateFormat];
    NSString *local = [fmt stringFromDate:pstDate];
    NSDate *localDate = [fmt dateFromString:local];

    
    NSString *ago = [localDate timeAgo];

    
    [lblQuestion setText:_mQuestionData.question_text];
    imgPhoto.clipsToBounds = YES;
    imgPhoto.layer.cornerRadius = _btnUserProfile.frame.size.width/2.0;
    
    [lblDate setText:ago];
}

-(void)setShowAd:(int)nIndex{
    
    _questionView.hidden = YES;
    _bannerView.hidden = NO;
    
    switch (nIndex) {
        case 0:
            self.bannerView.adUnitID = @"ca-app-pub-2226631469558843/1696947412";
            
            break;
        case 1:
            self.bannerView.adUnitID = @"ca-app-pub-2226631469558843/3336314219";
            
            break;
        case 2:
            self.bannerView.adUnitID = @"ca-app-pub-2226631469558843/6289780614";
            
            break;
            
        default:
            break;
    }
    
    self.bannerView.rootViewController = _rootControl;
    [self.bannerView loadRequest:[GADRequest request]];
    
////    self.bannerView.rootViewController = _rootControl;
////    
////    GADRequest *request = [GADRequest request];
////    
////    [self.bannerView loadRequest:request];
//    [self.bannerView loadRequest:[GADRequest request]];
//    // [END gmp_banner_example]
//    self.bannerView.rootViewController = _rootControl;
//    // [START gmp_interstitial_example]
//    self.interstitial = [self createAndLoadInterstitial];
}

//- (GADInterstitial *)createAndLoadInterstitial {
//    GADInterstitial *interstitial = [[GADInterstitial alloc]
//                                     initWithAdUnitID:self.bannerView.adUnitID];
//    interstitial.delegate = self;
//    [interstitial loadRequest:[GADRequest request]];
//    return interstitial;
//}
//
//- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
//    self.interstitial = [self createAndLoadInterstitial];
//}
//
//- (IBAction)didTapInterstitialButton:(id)sender {
//    if ([self.interstitial isReady]) {
//        [self.interstitial presentFromRootViewController:_rootControl];
//    }
//}
@end
