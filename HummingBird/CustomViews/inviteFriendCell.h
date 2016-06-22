//
//  inviteFriendCell.h
//  HummingBird
//
//  Created by LaNet on 6/14/16.
//  Copyright © 2016 Star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface inviteFriendCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *friendImage;
@property (strong, nonatomic) IBOutlet UILabel *lblFriendName;
@property (strong, nonatomic) IBOutlet UIButton *btnInvite;
@property (strong, nonatomic) NSString *email;
@end
