//
//  Message.m
//  SOSimpleChatDemo
//
//  Created by Artur Mkrtchyan on 6/3/14.
//  Copyright (c) 2014 SocialOjbects Software. All rights reserved.
//

#import "Message.h"

@implementation Message
@synthesize attributes,text,date,fromMe,media,thumbnail,type;
@synthesize msg_id,msg_user_id,msg_active;
@synthesize msg_link,msg_link_type,msg_link_id,msg_type;
- (id)init
{
    if (self = [super init]) {
        self.date = [NSDate date];
    }
    
    return self;
}

@end
