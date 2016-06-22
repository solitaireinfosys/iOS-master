//
//  facebookFriends.h
//  HummingBird
//
//  Created by LaNet on 6/14/16.
//  Copyright © 2016 Star. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface facebookFriends : NSObject
@property (strong , nonatomic) NSString *name;
@property (strong , nonatomic) NSString *first_name;
@property (strong , nonatomic) NSString *last_name;
@property (strong , nonatomic) NSString *middle_name;
@property (strong , nonatomic) NSString *friend_id;
@property (strong , nonatomic) NSString *friend_picture_url;
@property (strong , nonatomic) NSString *friend_email;
@end
