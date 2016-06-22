//
//  FacebookUserManager.h
//  umami
//
//  Created by Ying Han on 9/5/15.
//  Copyright (c) 2015 Ying Han. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface FacebookUserManager : NSObject

@property (nonatomic, strong) FBSDKAccessToken *accessToken;

@property (nonatomic,retain)NSString *fb_user_id;
@property (nonatomic,retain)NSString *fb_user_name;

@property (nonatomic,retain)UIViewController *fromViewController;

+ (instancetype)sharedManager;

- (void)requestLogin:(void (^)(id))completion;
- (void)saveAccessToken;
- (void)deleteAccessToken;

@end
