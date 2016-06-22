//
//  ConnectionClasses.h
//  SSXmpp
//
//  Created by CANOPUS16 on 17/10/15.
//  Copyright (c) 2015 Sourabh. All rights reserved.
//

#import "SSXmppConstant.h"
#import "XMPPAutoPing.h"
@interface SSConnectionClasses : NSObject
{
    XMPPAutoPing *xmppping;
    XMPPStream *xmppStream;
    XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
    XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
    XMPPvCardTempModule *xmppvCardTempModule;
    XMPPvCardAvatarModule *xmppvCardAvatarModule;
    XMPPCapabilities *xmppCapabilities;
    XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
    XMPPMessageArchiving *xmppMessageArchivingModule;
    XMPPLastActivity *xmppLastActivity;
    BOOL customCertEvaluation;
    BOOL isXmppConnected;
}
@property (nonatomic, strong, readonly) XMPPAutoPing *xmppping;

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardCoreDataStorage *xmppvCardStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
@property (nonatomic, assign,readonly) NSInteger  totalUnReadMsgcount;
@property (nonatomic, strong, readonly) NSMutableDictionary  *userUnreadCountDict;

@property BOOL customCertEvaluation;
@property BOOL isXmppConnected;


+(SSConnectionClasses *)shareInstance;
- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;

- (void)setupStream;
- (void)teardownStream;
- (BOOL)connectWithJid:(NSString *)jid;
- (void)disconnect;

- (void)goOnline;
- (void)goOffline;
-(void)setDelegateNilForRetrieveMessage;
-(void)configureDelegateToRetrieveMessage;

-(void)updateUserUnreadMessageOfJID:(NSString *)friendJID;
-(NSString *)getUnreadMessageCountFor:(NSString *) userFriendJid;
+(void)assignSavedTotalUnreadMessageCount:(NSMutableDictionary *) savedDict;

@end
