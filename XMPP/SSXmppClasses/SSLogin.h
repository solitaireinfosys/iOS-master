//
//  SSLogin.h
//  SSXmpp
//
//  Created by CANOPUS16 on 19/10/15.
//  Copyright (c) 2015 Sourabh. All rights reserved.
//

#import "SSXmppConstant.h"

@interface SSLogin : NSObject

@property (nonatomic, strong) SSLoginblock aSSLoginblock;


+(SSLogin *)shareInstance;

-(void)login:(NSString*)username complition:(SSLoginblock)ssblock;
-(void)Auth;
@end
