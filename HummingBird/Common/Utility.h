//
//  Utility.h
//  HummingBird
//
//  Created by Star on 12/5/15.
//  Copyright © 2015 Star. All rights reserved.
//

#import <Foundation/Foundation.h>

@class userModel;

@interface Utility : NSObject


+ (Utility *) getInstance;

-(void)saveUserData:(userModel*)uData;
-(void)getUserData;

-(userModel*)onParseUser:(NSDictionary*)dic;
@end
