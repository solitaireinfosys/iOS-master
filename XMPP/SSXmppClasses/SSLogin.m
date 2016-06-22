//
//  SSLogin.m
//  SSXmpp
//
//  Created by CANOPUS16 on 19/10/15.
//  Copyright (c) 2015 Sourabh. All rights reserved.
//

#import "SSLogin.h"
#import "SSAddFriend.h"
@implementation SSLogin

+(SSLogin *)shareInstance
{
    static SSLogin * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SSLogin alloc] init];
    });
    return instance;
}

-(void)login:(NSString*)username complition:(SSLoginblock)ssblock
{
    
    if(![username rangeOfString:Userpostfix].length>0)
    {
        username = [username stringByAppendingString:Userpostfix];
    }
    _aSSLoginblock = ssblock;
    
    if([[Reachability sharedReachability] internetConnectionStatus]==NotReachable)
    {
        if (ssblock)
        {
            ssblock(SSResponce(kInternetAlertMessage,kFailed,@""));
        }
    }
    else
    {
        [[SSConnectionClasses shareInstance] setupStream];
        
        if([[SSConnectionClasses shareInstance].xmppStream isConnected])
        {
            [[SSConnectionClasses shareInstance].xmppStream disconnect];
        }
        
        if (![[SSConnectionClasses shareInstance] connectWithJid:username])
        {
            [[SSConnectionClasses shareInstance] connectWithJid:username];
        }
 
        
        
        
        //       NSError *error = nil;
        
        //        if (![[SSConnectionClasses shareInstance].xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
        //        {
        //            NSLog(@"%@",error);
        //        }
        
        [[SSConnectionClasses shareInstance].xmppStream removeDelegate:self delegateQueue:dispatch_get_main_queue()];
        [[SSConnectionClasses shareInstance].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [[SSConnectionClasses shareInstance].xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    
}
-(void)Auth
{
    NSError *error = nil;

    if (![[SSConnectionClasses shareInstance].xmppStream authenticateWithPassword:UserPassword error:&error])
    {
        NSLog(@"Error authenticating: %@", error);
    }
}

#pragma mark XMPPStream Delegate

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    [SSConnectionClasses shareInstance].isXmppConnected = YES;
    
    NSError *error = nil;
    
    if (![[SSConnectionClasses shareInstance].xmppStream authenticateWithPassword:UserPassword error:&error])
    {
        NSLog(@"Error authenticating: %@", error);
    }
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    [SSConnectionClasses shareInstance].isXmppConnected = NO;
    if (![SSConnectionClasses shareInstance].isXmppConnected)
    {
        // DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
    }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    if (_aSSLoginblock)
    {
        _aSSLoginblock(SSResponce(kUserLogin,kSuccess,@""));
        _aSSLoginblock=nil;
        [self removeDelegate];
    }
//    [[[SSConnectionClasses shareInstance]xmppvCardTempModule]fetchvCardTempForJID:[XMPPJID jidWithString:UserJid] ignoreStorage:YES];
    [[SSConnectionClasses shareInstance] goOnline];

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Reload" object: nil];

}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    NSError *errors = nil;
    NSDictionary *data = [XMLReader dictionaryForXMLString:error.XMLString error:&errors];
    NSLog(@"%@",data);
    if (_aSSLoginblock)
    {
        _aSSLoginblock(SSResponce(kUserLoginInvalid,kFailed,@""));
        _aSSLoginblock=nil;
        [self removeDelegate];
    }
}


-(void)removeDelegate
{
    [[SSConnectionClasses shareInstance].xmppStream removeDelegate:self delegateQueue:dispatch_get_main_queue()];
    [[SSConnectionClasses shareInstance].xmppRoster removeDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    NSString *presenceType = [presence type];
    
    NSLog(@"%@",presenceType);
    
    if ([presenceType isEqualToString:@"subscribe"])
    {
        [[SSConnectionClasses shareInstance].xmppRoster acceptPresenceSubscriptionRequestFrom:presence.from andAddToRoster:YES];
    }
    
    if  ([presenceType isEqualToString:@"available"])
    {
        [[SSConnectionClasses shareInstance].xmppRoster acceptPresenceSubscriptionRequestFrom:[presence from] andAddToRoster:YES];
    }
    //    NSString *presenceType = [presence type]; // online/offline
    //    NSString *myUsername = [[sender myJID] user];
    //    NSString *presenceFromUser = [[presence from] user];
    //
    //    if (![presenceFromUser isEqualToString:myUsername]) {
    //
    //        if ([presenceType isEqualToString:@"available"]) {
    //
    //            [_chatDelegate newUSerOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, Userpostfix]];
    //
    //
    //
    //        } else if ([presenceType isEqualToString:@"unavailable"]) {
    //
    //            [_chatDelegate userWentOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, Userpostfix]];
    //
    //
    //        }
    //        
    //    }
}
@end
