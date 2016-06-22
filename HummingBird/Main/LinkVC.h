//
//  LinkVC.h
//  HummingBird
//
//  Created by Star on 5/12/16.
//  Copyright © 2016 Star. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GADBannerView;

@interface LinkVC : UIViewController<UISearchBarDelegate>
{
    IBOutlet UIWebView *mWebView;
    IBOutlet UISearchBar *nSearchBar;
    IBOutlet UIButton *btnBack;
    IBOutlet UIView *navView;
    
    IBOutlet NSLayoutConstraint *nSearchBarLeft;
    IBOutlet NSLayoutConstraint *nSearchBarRight;
    
    IBOutlet UIView *adsenseView;
    IBOutlet UIWebView *adsenseWebView;
}
@property (nonatomic,retain)NSString *strWeblink;
@property (nonatomic, weak) IBOutlet GADBannerView *bannerView;
@end
