//
//  TopVC.h
//  HummingBird
//
//  Created by Star on 3/7/16.
//  Copyright © 2016 Star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    IBOutlet UITableView *tblTop;
    int ad_space_limit;
    int nLoadmoreFlag;
    int nCurrentPageNumber;
    CGRect tempRect;
    
    IBOutlet UILabel *lblTemplate;
    IBOutlet UISearchBar *searchBarTop;
    IBOutlet NSLayoutConstraint *searchBarSize;
    
}

@property (nonatomic,retain)NSMutableArray *mTopArray;
@end
