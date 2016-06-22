//
//  FacebookUserManager.m
//  umami
//
//  Created by Ying Han on 9/5/15.
//  Copyright (c) 2015 Ying Han. All rights reserved.
//

#import "FacebookUserManager.h"

#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Security/Security.h>
#import "SVProgressHUD.h"

#define kFacebookUserKey        @"FacebookUser"

@interface FacebookUserManager ()

@end

@implementation FacebookUserManager

+ (instancetype)sharedManager
{
    static FacebookUserManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[FacebookUserManager alloc] init];
    });
    
    return _sharedManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.accessToken = [self loadAccessToken];
    }
    
    return self;
}

- (void)saveAccessToken
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.accessToken];
    
    NSDictionary *keychainQuery = @{
                                    (__bridge id)kSecAttrAccount : kFacebookUserKey,
                                    (__bridge id)kSecValueData : data,
                                    (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                                    (__bridge id)kSecAttrAccessible : (__bridge id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                                    };
    
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, nil);
}

- (void)deleteAccessToken
{
    self.accessToken = nil;
    
    NSDictionary *keychainQuery = @{
                                    (__bridge id)kSecAttrAccount : kFacebookUserKey,
                                    (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                                    (__bridge id)kSecAttrAccessible : (__bridge id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                                    };
    OSStatus result = SecItemDelete((__bridge CFDictionaryRef) keychainQuery);
    if(result != noErr){
        return;
    }
}

- (FBSDKAccessToken *)loadAccessToken
{
    NSDictionary *keychainQuery = @{
                                    (__bridge id)kSecAttrAccount : kFacebookUserKey,
                                    (__bridge id)kSecReturnData : (__bridge id)kCFBooleanTrue,
                                    (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword
                                    };
    
    CFDataRef serializedDictionaryRef;
    OSStatus result = SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&serializedDictionaryRef);
    if(result == noErr) {
        NSData *data = (__bridge_transfer NSData*)serializedDictionaryRef;
        if (data) {
            return [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    return nil;
}


- (void)requestLogin:(void (^)(id))completion
{
    
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    
    login.loginBehavior = FBSDKLoginBehaviorNative;

    [login logInWithReadPermissions:@[@"email",@"user_friends"] fromViewController:_fromViewController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
     {
         
         if (error || result.isCancelled)
         {
             if (completion){
                 error = [NSError errorWithDomain:@"facebook" code:200 userInfo:nil];
                 completion(error);
             }
             return;
         }
         self.accessToken = result.token;
         
         [[[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:nil] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"fetched user:%@ and Email : %@",result, result[@"email"]);
                 
                 if (completion){
                     
                     if ([result objectForKey:@"id"] != nil && [result objectForKey:@"id"] != [NSNull null]) {
                         self.fb_user_id = [result objectForKey:@"id"];
                     }
                     
                     if ([result objectForKey:@"name"] != nil && [result objectForKey:@"name"] != [NSNull null]) {
                         self.fb_user_name = [result objectForKey:@"name"];
                     }
                     
                     completion(nil);
                     
                 }else{
                     if (completion){
                         error = [NSError errorWithDomain:@"facebook" code:200 userInfo:nil];
                         completion(error);
                     }
                     
                 }
             }else{
                 if (completion){
                     error = [NSError errorWithDomain:@"facebook" code:200 userInfo:nil];
                     completion(error);
                 }
                 
             }
             return;
         }];
         
         
         
     }];
}

@end
