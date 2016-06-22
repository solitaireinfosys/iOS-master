//
//  ConnectionClasses.m
//  SSXmpp
//
//  Created by CANOPUS16 on 17/10/15.
//  Copyright (c) 2015 Sourabh. All rights reserved.
//

#import "SSConnectionClasses.h"

@class AppDelegate;

@interface SSConnectionClasses ()

@property (nonatomic, assign, readwrite) NSInteger  totalUnReadMsgcount;
@property (nonatomic, strong,  readwrite) NSMutableDictionary  *userUnreadCountDict;
@end

@implementation SSConnectionClasses
@synthesize xmppping;
@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppvCardTempModule;
@synthesize xmppvCardAvatarModule;
@synthesize xmppvCardStorage;
@synthesize xmppCapabilities;
@synthesize xmppCapabilitiesStorage;
@synthesize totalUnReadMsgcount;
@synthesize userUnreadCountDict;

+(SSConnectionClasses *)shareInstance
{
    static SSConnectionClasses * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SSConnectionClasses alloc] init];
        instance.userUnreadCountDict = [NSMutableDictionary new];
        instance.totalUnReadMsgcount = 0;
    });
    return instance;
}

#pragma mark Core Data

- (NSManagedObjectContext *)managedObjectContext_roster
{
    return [xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_capabilities
{
    return [xmppCapabilitiesStorage mainThreadManagedObjectContext];
}

#pragma mark Private

- (void)setupStream
{
    if(!xmppStream)
    {
        
        
        NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
        
        //    NSString *myjid =  [[NSUserDefaults standardUserDefaults]valueForKey:@"myjid"];
        //    [[NSUserDefaults standardUserDefaults]setValue:myjid forKey:kXMPPmyJID];
        //    [[NSUserDefaults standardUserDefaults] setValue:@"123" forKey:kXMPPmyPassword];
        //    [[NSUserDefaults standardUserDefaults] setValue:@"@canopus-pc" forKey:@"postfix"];
        //
        //    _username = [[NSUserDefaults standardUserDefaults]valueForKey:@"kXMPPmyJID"];
        //    NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
        //    _postfix = Userpostfix;
        // Setup xmpp stream
        //
        // The XMPPStream is the base class for all activity.
        // Everything else plugs into the xmppStream, such as modules/extensions and delegates.
        
        xmppStream = [[XMPPStream alloc] init];
        
#if !TARGET_IPHONE_SIMULATOR
        {
            // Want xmpp to run in the background?
            //
            // P.S. - The simulator doesn't support backgrounding yet.
            //        When you try to set the associated property on the simulator, it simply fails.
            //        And when you background an app on the simulator,
            //        it just queues network traffic til the app is foregrounded again.
            //        We are patiently waiting for a fix from Apple.
            //        If you do enableBackgroundingOnSocket on the simulator,
            //        you will simply see an error message from the xmpp stack when it fails to set the property.
            
            
            xmppStream.enableBackgroundingOnSocket = YES;
        }
#endif
        
        // Setup reconnect
        //
        // The XMPPReconnect module monitors for "accidental disconnections" and
        // automatically reconnects the stream for you.
        // There's a bunch more information in the XMPPReconnect header file.
        
        
        xmppReconnect = [[XMPPReconnect alloc] init];
        xmppReconnect.reconnectDelay=5.0;
        
        // Setup roster
        //
        // The XMPPRoster handles the xmpp protocol stuff related to the roster.
        // The storage for the roster is abstracted.
        // So you can use any storage mechanism you want.
        // You can store it all in memory, or use core data and store it on disk, or use core data with an in-memory store,
        // or setup your own using raw SQLite, or create your own storage mechanism.
        // You can do it however you like! It's your application.
        // But you do need to provide the roster with some storage facility.
        
//        xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
        xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];
        
        xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
        
        xmppRoster.autoFetchRoster = YES;
        xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
        
        // Setup vCard support
        //
        // The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
        // The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.
        
        
        
        
        
        
        //commented by ajeet
        
        
//        xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
//        xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
        
//        xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
        
        
        
        
        
        
        
        // Setup capabilities
        //
        // The XMPPCapabilities module handles all the complex hashing of the caps protocol (XEP-0115).
        // Basically, when other clients broadcast their presence on the network
        // they include information about what capabilities their client supports (audio, video, file transfer, etc).
        // But as you can imagine, this list starts to get pretty big.
        // This is where the hashing stuff comes into play.
        // Most people running the same version of the same client are going to have the same list of capabilities.
        // So the protocol defines a standardized way to hash the list of capabilities.
        // Clients then broadcast the tiny hash instead of the big list.
        // The XMPPCapabilities protocol automatically handles figuring out what these hashes mean,
        // and also persistently storing the hashes so lookups aren't needed in the future.
        //
        // Similarly to the roster, the storage of the module is abstracted.
        // You are strongly encouraged to persist caps information across sessions.
        //
        // The XMPPCapabilitiesCoreDataStorage is an ideal solution.
        // It can also be shared amongst multiple streams to further reduce hash lookups.
        xmppMessageArchivingModule = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:[XMPPMessageArchivingCoreDataStorage sharedInstance]];
        [xmppMessageArchivingModule setClientSideMessageArchivingOnly:YES];
        xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
        xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
        
        xmppLastActivity = [[XMPPLastActivity alloc] initWithDispatchQueue:dispatch_get_main_queue()];
        
        xmppCapabilities.autoFetchHashedCapabilities = YES;
        xmppCapabilities.autoFetchNonHashedCapabilities = NO;
        
        // Activate xmpp modules
        [xmppLastActivity activate:xmppStream];
        [xmppReconnect         activate:xmppStream];
        [xmppRoster            activate:xmppStream];
        [xmppvCardTempModule   activate:xmppStream];
        [xmppvCardAvatarModule activate:xmppStream];
        [xmppCapabilities      activate:xmppStream];
        [xmppMessageArchivingModule activate:xmppStream];
        
        
        [xmppReconnect addDelegate:self delegateQueue:dispatch_get_main_queue()];

        
        xmppping=[[XMPPAutoPing alloc]init];
        [xmppping activate:xmppStream];

        [xmppping addDelegate:self delegateQueue:dispatch_get_main_queue()];

        // Add ourself as a delegate to anything we may be interested in
        //    [xmppMessageArchivingModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
        //    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        //    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
        //    [xmppLastActivity addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        // Optional:
        //
        // Replace me with the proper domain and port.
        // The example below is setup for a typical google talk account.
        //
        // If you don't supply a hostName, then it will be automatically resolved using the JID (below).
        // For example, if you supply a JID like 'user@quack.com/rsrc'
        // then the xmpp framework will follow the xmpp specification, and do a SRV lookup for quack.com.
        //
        // If you don't specify a hostPort, then the default (5222) will be used.
        
        [xmppStream setHostName:HostName];
        [xmppStream setHostPort:HostPort];
        
        [self configureDelegateToRetrieveMessage];
        
        // You may need to alter these settings depending on the server you're connecting to
        customCertEvaluation = YES;
    }
}

- (void)teardownStream
{
    [xmppStream removeDelegate:self];
    [xmppRoster removeDelegate:self];
    
    [xmppReconnect         deactivate];
    [xmppRoster            deactivate];
    [xmppvCardTempModule   deactivate];
    [xmppvCardAvatarModule deactivate];
    [xmppCapabilities      deactivate];
    
    [xmppStream disconnect];
    
    xmppStream = nil;
    xmppReconnect = nil;
    xmppRoster = nil;
    xmppRosterStorage = nil;
    xmppvCardStorage = nil;
    xmppvCardTempModule = nil;
    xmppvCardAvatarModule = nil;
    xmppCapabilities = nil;
    xmppCapabilitiesStorage = nil;
}

#pragma mark Connect/disconnect

- (BOOL)connectWithJid:(NSString *)jid
{
    if (![xmppStream isDisconnected])
    {
        return YES;
    }
    
    if (jid == nil)
    {
        return NO;
    }
    
    [xmppStream setMyJID:[XMPPJID jidWithString:jid]];
    
    [[NSUserDefaults standardUserDefaults]setValue:jid forKey:UserJid];
    NSError *error = nil;
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
//                                                            message:@"See console for error details."
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"Ok"
//                                                  otherButtonTitles:nil];
//        [alertView show];
        
        //        DDLogError(@"Error connecting: %@", error);
        
        return NO;
    }
    return YES;
}

- (void)disconnect
{
    [self goOffline];
    [xmppStream disconnect];
    [self teardownStream];
}

#pragma mark else if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateBackground)
// {
// We are not active, so use a local notification instead
//  UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//   localNotification.alertAction = @"Ok";
//  localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",displayName,body];
//  localNotification.soundName = UILocalNotificationDefaultSoundName;

//   [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];

// }/goOffline

- (void)goOnline
{
    XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    
    //    NSString *domain = [xmppStream.myJID domain];
    
    //Google set their presence priority to 24, so we do the same to be compatible.
    
    //    if([domain isEqualToString:@"gmail.com"]
    //       || [domain isEqualToString:@"gtalk.com"]
    //       || [domain isEqualToString:@"talk.google.com"])
    //    {
    //        NSXMLElement *priority = [NSXMLElement elementWithName:@"priority" stringValue:@"24"];
    //        [presence addChild:priority];
    //    }
    
    [[self xmppStream] sendElement:presence];
}

- (void)goOffline
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
}
-(void)configureDelegateToRetrieveMessage
{
    [[SSConnectionClasses shareInstance].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

-(void)setDelegateNilForRetrieveMessage
{
    [[SSConnectionClasses shareInstance].xmppStream removeDelegate:self delegateQueue:dispatch_get_main_queue()];
}


-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    
    
    if ([message isChatMessageWithBody])
    {
        //ignore unknownUser message;
//        XMPPJID *userJID = [[message from] bareJID];
//        BOOL knownUser = [xmppRosterStorage userExistsWithJID:userJID xmppStream:xmppStream];
//        if (!knownUser)
//            return;
        
        NSString *fromName = [[message from] bare];
        fromName = [fromName stringByReplacingOccurrencesOfString:Userpostfix withString:@""];
        NSString *UserId = [[NSString alloc]init];
        NSArray *arrayLocal = [fromName componentsSeparatedByString:@"-"];
        if( arrayLocal.count>1)
        {
            fromName = arrayLocal.lastObject;
            UserId = arrayLocal.firstObject;
        }
        else
            fromName =@" ";
        
        //fromName = [fromName stringByReplacingOccurrencesOfString:@"$" withString:@" "];
        NSArray * arraySubStrings = [fromName componentsSeparatedByString:@"$"];
        
        NSString *RealName = arraySubStrings.firstObject;
        fromName = arraySubStrings.firstObject;
        fromName = [NSString stringWithFormat:@"%@ has sent you a new message",[fromName capitalizedString]];
        
        
        if([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
        {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                
                UIViewController *vc = (UIViewController *)[[UIApplication sharedApplication].keyWindow rootViewController].presentedViewController;
                
                UINavigationController *navController = (UINavigationController *)[vc.childViewControllers lastObject];
                if (![NSStringFromClass(navController.class) isEqualToString:@"Lihnk.MainMenuViewController"])
                {
                UIViewController *topVC = navController.topViewController;
                
                if([NSStringFromClass(topVC.class) isEqualToString:@"Lihnk.ChatViewController"])
                {
                    //check the chat session jid and viewcontroller class if user's jid is login user Jid then ignore to show message
                    NSString *toJid = [[message to] bare];
                    
                    NSString *currentUsrJid=[[SSConnectionClasses shareInstance].xmppStream.myJID bare];
                    
                    
                    if ([toJid isEqualToString:currentUsrJid])
                        return;
                    
                }
                }
                
                [self saveMessageCount:[[message from] bare]];
                
                NSInteger appIconBadgeCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"BadgeCount"];
                [UIApplication sharedApplication].applicationIconBadgeNumber = appIconBadgeCount + self.totalUnReadMsgcount;
                
            });
            
        }
        else if([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground)
        {
             [self saveMessageCount:[[message from] bare]];
            
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.alertAction = @"Ok";
            localNotification.alertBody = [NSString stringWithFormat:@"%@",fromName];
            
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:UserId forKey:@"UserId"];
            [dict setValue:[[message from] bare] forKey:@"otherJid"];
            [dict setValue:RealName.lowercaseString forKey:@"otherUserName"];
            localNotification.userInfo = dict;
            NSLog(@"%@ -- %@",localNotification.userInfo,dict);
            
            
            NSInteger appIconBadgeCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"BadgeCount"];
            [UIApplication sharedApplication].applicationIconBadgeNumber = appIconBadgeCount + self.totalUnReadMsgcount;
            
            //save unread badge count in document dir
            NSString *strPath = @"~/Documents/Saved.data";
            strPath = strPath.stringByExpandingTildeInPath;
            NSString *totalUnreadCount = [NSString stringWithFormat:@"%d",(int)totalUnReadMsgcount];
            [self.userUnreadCountDict setValue:totalUnreadCount forKey:@"key_totalUnreadCount"];
            [self.userUnreadCountDict  writeToFile:strPath atomically:YES];
            
            localNotification.soundName = UILocalNotificationDefaultSoundName;
                       [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
        }
    }
}

-(NSString*)saveMessageCount:(NSString *) friendJID
{
    friendJID = [friendJID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    totalUnReadMsgcount ++;
    NSString *count =[self getUnreadMessageCountFor:friendJID] ;
    count = [NSString stringWithFormat:@"%d",([count intValue]+1)];
    [self.userUnreadCountDict setValue:count forKey:friendJID];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"remoteDidUpdateUI" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"unreadMessageCountRefresh" object:nil];
    return count;
    
    
}
-(NSString *)getUnreadMessageCountFor:(NSString *) userFriendJid
{
    NSString *count = @"0" ;
    
    if ([userUnreadCountDict valueForKey:userFriendJid] == nil)
    {
        [self.userUnreadCountDict setValue:count forKey:userFriendJid];
    }
    else
    {
        count = [self.userUnreadCountDict valueForKey:userFriendJid];
    }
    return count;
}

-(void)updateUserUnreadMessageOfJID:(NSString *)friendJID
{
   
    NSString *count = [self getUnreadMessageCountFor:friendJID];
    self.totalUnReadMsgcount = self.totalUnReadMsgcount - [count intValue];
    
    if (self.totalUnReadMsgcount< 0)
        self.totalUnReadMsgcount = 0;
    
    count = @"0";
    
    [self.userUnreadCountDict removeObjectForKey:friendJID];
}
+(void)assignSavedTotalUnreadMessageCount:(NSMutableDictionary *) savedDict
{
    NSString *totalCount = [savedDict valueForKey:@"key_totalUnreadCount"];
    if(totalCount.intValue>0)
    [SSConnectionClasses shareInstance].totalUnReadMsgcount = totalCount.intValue;
    [savedDict removeObjectForKey:@"key_totalUnreadCount"];
    
    if (savedDict.allKeys.count >0)
    [SSConnectionClasses shareInstance].userUnreadCountDict = savedDict ;
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

#pragma mark:- xmppReconnect
- (BOOL)xmppReconnect:(XMPPReconnect *)sender shouldAttemptAutoReconnect:(SCNetworkReachabilityFlags)reachabilityFlags
{
    NSLog(@"Reconnect Called");
    //[[[UIApplication sharedApplication] delegate] performSelector:@selector(Reconnect)];
    return YES;
}


#pragma mark:- xmppAutoPing
- (void)xmppAutoPingDidSendPing:(XMPPAutoPing *)sender
{
    NSLog(@"AutoSendPing");
}
- (void)xmppAutoPingDidReceivePong:(XMPPAutoPing *)sender
{
            NSLog(@"AutoSendPong");
}

- (void)xmppAutoPingDidTimeout:(XMPPAutoPing *)sender
{
        NSLog(@"TimeOut");
}


@end
