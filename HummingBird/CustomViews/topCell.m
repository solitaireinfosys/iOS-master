//
//  topCell.m
//  umami
//
//  Created by Star on 9/7/15.
//  Copyright (c) 2015 Star. All rights reserved.
//

#import "topCell.h"
#import "userModel.h"
#import "topModel.h"


@import GoogleMobileAds;

@implementation topCell

-(void)setShowUI{
    
    _questionView.hidden = NO;
    _bannerView.hidden = YES;
    
    [lblQuestion setText:_mTopData.top_question_text];
    [lblLike setText:[NSString stringWithFormat:@"%d",_mTopData.top_likes]];
    
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
    
}

@end
