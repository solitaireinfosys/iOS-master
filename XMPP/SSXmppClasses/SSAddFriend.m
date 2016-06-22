//
//  SSAddFriend.m
//  SSXmpp
//
//  Created by CANOPUS16 on 20/10/15.
//  Copyright (c) 2015 Sourabh. All rights reserved.
//

#import "SSAddFriend.h"

@implementation SSAddFriend

+(SSAddFriend *)shareInstance
{
    static SSAddFriend * instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SSAddFriend alloc] init];
    });
        
    return instance;
}

-(void)addFriendWithJid:(NSString *)friendname complition:(SSAddFriendsblock)ssblock
{
    if(!([friendname rangeOfString:Userpostfix].length>0))
    {
        friendname = [friendname stringByAppendingString:Userpostfix];
    }
    
    _ssblock = ssblock;
    if([[Reachability sharedReachability] internetConnectionStatus]==NotReachable)
    {
        if (ssblock)
        {
            ssblock(SSResponce(kInternetAlertMessage,kFailed,@""));
        }
        
    }
    else
    {
        
        //        NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
        //
        //        NSXMLElement *item = [NSXMLElement elementWithName:@"item"];
        //
        //        NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
        //
        //        [item addAttributeWithName:@"jid" stringValue:[friendname stringByAppendingString:Userpostfix]];
        //        [item addAttributeWithName:@"name" stringValue:friendname];
        //
        //        [query addChild:item];
        //
        //        [iq addAttributeWithName:@"type" stringValue:@"set"];
        //        [iq addChild:query];
        //
        
        [[[SSConnectionClasses shareInstance] xmppStream] removeDelegate:self delegateQueue:dispatch_get_main_queue()];
        [[[SSConnectionClasses shareInstance] xmppStream] addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
         [[[SSConnectionClasses shareInstance] xmppRoster] removeDelegate:self delegateQueue:dispatch_get_main_queue()];
        [[[SSConnectionClasses shareInstance] xmppRoster] addDelegate:self delegateQueue:dispatch_get_main_queue()];

        
        // [[SSConnectionClasses shareInstance].xmppStream sendElement:iq];
        
        [[[SSConnectionClasses shareInstance] xmppRoster] addUser:[XMPPJID jidWithString:friendname] withNickname:friendname];
        
    }
    
}
-(void)deleteFriendWithJid:(NSString *)friendname
{
    if(!([friendname rangeOfString:Userpostfix].length>0))
    {
        friendname = [friendname stringByAppendingString:Userpostfix];
    }
    
    if([[Reachability sharedReachability] internetConnectionStatus]!= NotReachable)
    {
        [[[SSConnectionClasses shareInstance] xmppRoster] removeUser:[XMPPJID jidWithString:friendname]];
    }
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    NSError *errors = nil;
    NSDictionary *data = [XMLReader dictionaryForXMLString:iq.XMLString error:&errors];
    if(_ssblock)
    {
        _ssblock(SSResponce(kAddFriendSuccess,kSuccess,data));
        _ssblock = nil;
    }
    return YES;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)error
{
    if(_ssblock)
    {
        _ssblock(SSResponce(kAddFriendFailled,kFailed,@""));
        _ssblock = nil;
    }
}

- (void)xmppStream:(XMPPStream *)sender didFailToSendIQ:(XMPPIQ *)iq error:(NSError *)error
{
    if(_ssblock)
    {
        _ssblock(SSResponce(kAddFriendFailled,kFailed,@""));
        _ssblock = nil;
    }
}
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    [sender subscribePresenceToUser:[presence from]];
    //  NSString *friendJid = [[presence from] bare];
    //    [self addFriendWithJid:friendJid complition:^(NSDictionary *result) {
    //        NSLog(@"SSAddFriend class add friend response= %@",result);
    //
    //    }];
    
}


@end
