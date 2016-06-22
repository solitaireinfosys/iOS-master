//
//  inviteFriendCell.m
//  HummingBird
//
//  Created by LaNet on 6/14/16.
//  Copyright © 2016 Star. All rights reserved.
//

#import "inviteFriendCell.h"

@implementation inviteFriendCell
- (void)awakeFromNib {
    [super awakeFromNib];
    _friendImage.layer.cornerRadius = _friendImage.frame.size.width/2;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)OnbtnInviteClicked:(id)sender {
    NSLog(@"invited");
    NSLog(@"%@",self.email);
}

@end