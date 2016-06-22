//
//  Ragistraion.m
//  SSXmpp
//
//  Created by CANOPUS16 on 17/10/15.
//  Copyright (c) 2015 Sourabh. All rights reserved.
//

#import "SSRagistraion.h"
#import "SSLogin.h"
#import "AppDelegate.h"
#import "userModel.h"
#import "SSAddFriend.h"

@implementation SSRagistraion

+(SSRagistraion *)shareInstance
{
    static SSRagistraion * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SSRagistraion alloc] init];
    });
    return instance;
}
-(void)Unregistration:(NSString*)username complition:(SSUnRegistrationblock)ssblock
{
    if([username rangeOfString:Userpostfix].length==0)
    {
        username = [username stringByAppendingString:Userpostfix];
    }
    _aSSUnRegistrationblock = ssblock;
    if([[Reachability sharedReachability] internetConnectionStatus]==NotReachable)
    {
        if (ssblock)
        {
            ssblock(SSResponce(kInternetAlertMessage,kFailed,@""));
        }
    }
    else
    {
//        [[SSConnectionClasses shareInstance] setupStream];
        
//        if([[SSConnectionClasses shareInstance].xmppStream isConnected])
//        {
//            [[SSConnectionClasses shareInstance].xmppStream disconnect];
//        }
        
//        if (![[SSConnectionClasses shareInstance] connectWithJid:username]) {
//            [[SSConnectionClasses shareInstance] connectWithJid:username];
//        }
//        
//        NSError *error = nil;
//        
//        if (![[SSConnectionClasses shareInstance].xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
//        {
//            
//        }
        
        
//        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
//        [body setStringValue:messageStr];
//        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
//        [message addAttributeWithName:@"type" stringValue:@"chat"];
//        [message addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@%@",self.cls.UserId,Xmppserver]];
//        [message addChild:body];
//        [appDelegate.xmppStream sendElement:message];
        
        
//        NSError *error1 = [[NSError alloc] init];
//        NSXMLElement *query = [[NSXMLElement alloc] initWithXMLString:@"<command xmlns='http://jabber.org/protocol/commands' action='execute' node='delete-user'/>" error:&error1];
        
         NSXMLElement *remove = [NSXMLElement elementWithName:@"remove"];
        
        NSXMLElement *query = [NSXMLElement elementWithName:@"query"];
        [query addAttributeWithName:@"xmlns" stringValue:@"jabber:iq:register"];
        [query addChild:remove];
        
        NSXMLElement *message = [NSXMLElement elementWithName:@"iq"];
        [message addAttributeWithName:@"type" stringValue:@"set"];
        [message addAttributeWithName:@"id" stringValue:username];
        [message addChild:[query copy]];
//        <iq type='set' id='unreg1'>
//        <query xmlns='jabber:iq:register'>
//        <remove/>
//        </query>
//        </iq>
        

        [[SSConnectionClasses shareInstance].xmppStream sendElement:message];
        
        
        [[SSConnectionClasses shareInstance].xmppStream removeDelegate:self delegateQueue:dispatch_get_main_queue()];
        [[SSConnectionClasses shareInstance].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
}



-(void)registration:(NSString*)username complition:(SSRegistrationblock)ssblock
{
    if([username rangeOfString:Userpostfix].length==0)
    {
        username = [username stringByAppendingString:Userpostfix];
    }
    _aSSRegistrationblock = ssblock;
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
        
        if (![[SSConnectionClasses shareInstance] connectWithJid:username]) {
            [[SSConnectionClasses shareInstance] connectWithJid:username];
        }
        
        NSError *error = nil;
        
        if (![[SSConnectionClasses shareInstance].xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
        {
            
        }
        
        [[SSConnectionClasses shareInstance].xmppStream removeDelegate:self delegateQueue:dispatch_get_main_queue()];
        [[SSConnectionClasses shareInstance].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
}

#pragma mark XMPPStream Delegate

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    
    [SSConnectionClasses shareInstance].isXmppConnected = YES;
    
    NSError *errorr = nil;
    if([[SSConnectionClasses shareInstance].xmppStream registerWithPassword:UserPassword error:&errorr])
    {
  
        // register
    }
    else
    {
        // error
    }
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    [SSConnectionClasses shareInstance].isXmppConnected = NO;

    if (![SSConnectionClasses shareInstance].isXmppConnected)
    {
        
        
        // DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
    }
    if (_aSSUnRegistrationblock)
    {
        _aSSUnRegistrationblock(SSResponce(kUserUnRagistered,kSuccess,@""));
        _aSSUnRegistrationblock=nil;
        [self removeDelegate];
    }
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    if (_aSSRegistrationblock)
    {
        _aSSRegistrationblock(SSResponce(kUserRagistered,kSuccess,@""));
        _aSSRegistrationblock=nil;
        [self removeDelegate];
    }
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    NSError *errors = nil;
    NSDictionary *data = [XMLReader dictionaryForXMLString:error.XMLString error:&errors];
    
    if([[[[data valueForKey:@"iq"]valueForKey:@"error"]valueForKey:@"code"] isEqualToString:@"409"])
    {
        if (_aSSRegistrationblock)
        {
            _aSSRegistrationblock(SSResponce(kUserExist,kFailed,@""));
            _aSSRegistrationblock=nil;
            [self removeDelegate];
            userModel *userData = [[userModel alloc] init];
            userData = theAppDelegate.gUserData;
            NSString *name = theAppDelegate.gUserData.user_email;
            NSString *strg = [[NSString alloc] init];
            NSArray *comp = [[NSArray alloc] init];
            comp = [name componentsSeparatedByString:@"@"];
            strg = [comp objectAtIndex:0];
            NSString *userName = [[NSString alloc] init];
            userName = [userName stringByAppendingFormat:@"%@_%@",strg,theAppDelegate.gUserData.user_id];
//            AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            [[SSLogin shareInstance] login:userName complition:^(NSDictionary *result) {
                NSLog(@"%@",result);
            }];
        }
    }
    else if([[[[data valueForKey:@"iq"]valueForKey:@"error"]valueForKey:@"code"] isEqualToString:@"500"])
    {
        if (_aSSRegistrationblock)
        {
            _aSSRegistrationblock(SSResponce(kServiceError,kFailed,@""));
            _aSSRegistrationblock=nil;
            [self removeDelegate];
        }
    }
    else
    {
        if (_aSSRegistrationblock)
        {
            _aSSRegistrationblock(SSResponce(@"didNotRegister",kFailed,@""));
            _aSSRegistrationblock=nil;
            [self removeDelegate];
        }
    }
}

-(void)removeDelegate
{
    [[SSConnectionClasses shareInstance].xmppStream removeDelegate:self delegateQueue:dispatch_get_main_queue()];
    [[SSConnectionClasses shareInstance].xmppRoster removeDelegate:self delegateQueue:dispatch_get_main_queue()];
}

@end