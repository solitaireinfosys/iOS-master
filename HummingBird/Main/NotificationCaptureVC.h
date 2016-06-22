//
//  NotificationCaptureVC.h
//  HummingBird
//
//  Created by Star on 3/17/16.
//  Copyright (c) 2016 Star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationCaptureVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
{

    IBOutlet UITableView *tblNotification;
    
    int ad_space_limit;
    int nLoadmoreFlag;
    int nCurrentPageNumber;
}

@property (nonatomic,retain)NSMutableArray *mNotificationData;
@property (nonatomic,retain)NSTimer *refreshTimer;

@end
