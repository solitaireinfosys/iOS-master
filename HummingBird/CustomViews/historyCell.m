//
//  historyCell.m
//  umami
//
//  Created by Star on 9/7/15.
//  Copyright (c) 2015 Star. All rights reserved.
//

#import "historyCell.h"
#import "userModel.h"
#import "questionModel.h"
#import "NSDate+TimeAgo.h"

@import GoogleMobileAds;
@implementation historyCell

-(void)setShowUI{

    
    [lblQuestion setText:_mQuestionData.question_text];
    imgPhoto.clipsToBounds = YES;
    imgPhoto.layer.cornerRadius = _btnUserProfile.frame.size.width/2.0;
    
    _starView.hidden = NO;
    
    if (_mQuestionData.user_rating >= 4.5) {
        [_imgStar1 setImage:[UIImage imageNamed:@"star"]];
        [_imgStar2 setImage:[UIImage imageNamed:@"star"] ];
        [_imgStar3 setImage:[UIImage imageNamed:@"star"] ];
        [_imgStar4 setImage:[UIImage imageNamed:@"star"] ];
        [_imgStar5 setImage:[UIImage imageNamed:@"star"] ];
        
    }else if (_mQuestionData.user_rating >= 3.5){
        [_imgStar1 setImage:[UIImage imageNamed:@"star"] ];
        [_imgStar2 setImage:[UIImage imageNamed:@"star"] ];
        [_imgStar3 setImage:[UIImage imageNamed:@"star"] ];
        [_imgStar4 setImage:[UIImage imageNamed:@"star"] ];
        [_imgStar5 setImage:[UIImage imageNamed:@"unstar"] ];
        
    }else if (_mQuestionData.user_rating >= 2.5){
        [_imgStar1 setImage:[UIImage imageNamed:@"star"] ];
        [_imgStar2 setImage:[UIImage imageNamed:@"star"] ];
        [_imgStar3 setImage:[UIImage imageNamed:@"star"] ];
        [_imgStar4 setImage:[UIImage imageNamed:@"unstar"] ];
        [_imgStar5 setImage:[UIImage imageNamed:@"unstar"] ];
        
    }else if (_mQuestionData.user_rating >= 1.5){
        [_imgStar1 setImage:[UIImage imageNamed:@"star"] ];
        [_imgStar2 setImage:[UIImage imageNamed:@"star"] ];
        [_imgStar3 setImage:[UIImage imageNamed:@"unstar"] ];
        [_imgStar4 setImage:[UIImage imageNamed:@"unstar"] ];
        [_imgStar5 setImage:[UIImage imageNamed:@"unstar"] ];
        
    }else if (_mQuestionData.user_rating >= 0.5){
        [_imgStar1 setImage:[UIImage imageNamed:@"star"] ];
        [_imgStar2 setImage:[UIImage imageNamed:@"unstar"] ];
        [_imgStar3 setImage:[UIImage imageNamed:@"unstar"] ];
        [_imgStar4 setImage:[UIImage imageNamed:@"unstar"] ];
        [_imgStar5 setImage:[UIImage imageNamed:@"unstar"] ];
        
    }else{
        [_imgStar1 setImage:[UIImage imageNamed:@"unstar"] ];
        [_imgStar2 setImage:[UIImage imageNamed:@"unstar"] ];
        [_imgStar3 setImage:[UIImage imageNamed:@"unstar"] ];
        [_imgStar4 setImage:[UIImage imageNamed:@"unstar"] ];
        [_imgStar5 setImage:[UIImage imageNamed:@"unstar"] ];
        
        _starView.hidden = YES;
        
    }
}
-(void)setShowAd:(int)nIndex{
    
    _historyView.hidden = YES;
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
    // [END gmp_banner_example]
    // [START gmp_interstitial_example]
    
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
