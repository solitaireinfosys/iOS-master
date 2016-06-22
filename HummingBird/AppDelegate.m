//
//  AppDelegate.m
//  HummingBird
//
//  Created by Star on 12/5/15.
//  Copyright © 2015 Star. All rights reserved.
//

#import "AppDelegate.h"
#import "Common.h"
#import "LoginVC.h"
#import "ConversationVC.h"
#import "userModel.h"
#import "Utility.h"
#import "AFNetworking.h"
#import "SSLogin.h"
#import "SSRagistraion.h"
#import "FacebookUserManager.h"

#import <FBSDKCoreKit/FBSDKApplicationDelegate.h>
#import <AVFoundation/AVFoundation.h>

#include <ifaddrs.h>
#include <arpa/inet.h>

#ifdef humming_dist
    #import "Analytics.h"
    #import "ACTReporter.h"
#else

#endif
#import "iSpeechSDK.h"


@interface AppDelegate () <AVSpeechSynthesizerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
//    [self testRequest];
    
    
//    [[AVAudioSession sharedInstance] setDelegate:self];
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    UInt32 size = sizeof(CFStringRef);
    CFStringRef route;
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &size, &route);

    _synth = [[AVSpeechSynthesizer alloc]init];
    
    // Begin of codes added
    
    [_synth setDelegate:self];
    
    // End of codes added
    
    
    iSpeechSDK *sdk = [iSpeechSDK sharedSDK];
    sdk.APIKey = @"2f36e5ed19f61661f051e5ec7a35c2b8";
    
    [ACTAutomatedUsageTracker enableAutomatedUsageReportingWithConversionID:@"936570835"];

    [ACTConversionReporter reportWithConversionID:@"936570835" label:@"eGlLCOmZu2MQ09_LvgM" value:@"0.00" isRepeatable:NO];
    
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    NSDictionary *appDefaults = @{kAllowTracking:@(YES)};
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
  
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    _gUserData = [[userModel alloc]init];
    
    [self getLocation];
    
    [self requestDeviceToken];
    
    _gMainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //    set up tabbar
//    [self initalizeTabbar];
    
    return YES;
}

-(void)requestDeviceToken{
    NSString *reqSysVer = @"8.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer intValue]>=[reqSysVer intValue]) {
        //Right, that is the point
        
#ifdef __IPHONE_8_0
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
                                                                                             |UIUserNotificationTypeSound
                                                                                             |UIUserNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        
    }
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif

#pragma -- Remote Notifications --

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    _uDeviceToken = [NSString stringWithFormat:@"%@",token];
    _uDeviceToken = [_uDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [[NSUserDefaults standardUserDefaults] setObject:_uDeviceToken forKey:@"uDevice"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark - method to switch root view controller
-(void)switchRootViewController:(int)nFlag{
    
    UINavigationController *navController;
    
    if (nFlag == login_check_true) {
        
        [STANDARD_DEFAULT_STRING setInteger:1 forKey:@"stock_login"];
        [STANDARD_DEFAULT_STRING synchronize];
        
 
        [[Utility getInstance] getUserData];

        ConversationVC *conversationVC = [_gMainStoryboard instantiateViewControllerWithIdentifier:@"ConversationVC"];
        navController = [[UINavigationController alloc] initWithRootViewController:conversationVC] ;
        NSString *name = self.gUserData.user_email;
        NSString *strg = [[NSString alloc] init];
        NSArray *comp = [[NSArray alloc] init];
        comp = [name componentsSeparatedByString:@"@"];
        strg = [comp objectAtIndex:0];
        if (name.length == 0)
        {
            strg = [FacebookUserManager sharedManager].fb_user_id;
        }
        
        NSString *userName = [[NSString alloc] init];
        userName = [userName stringByAppendingFormat:@"%@_%@",strg,self.gUserData.user_id];
        [[SSRagistraion shareInstance] registration:userName complition:^(NSDictionary *result) {
            NSLog(@"%@",result);
            NSString *status = [[NSString alloc] init];
            if (((NSString *)[result objectForKey:@"status"]) != nil){
                status = (NSString *)[result objectForKey:@"status"];
                if ([status isEqualToString:@"Success"]){
                    [[SSLogin shareInstance] login:userName complition:^(NSDictionary *result) {
                        NSLog(@"%@",result);
                    }];
                }
            }
        }];
        
        //[[SSLogin shareInstance] login:@"user1" complition:^(NSDictionary *result) {
           //// NSLog(@"%@",result);
        //}];

        navController.navigationBar.hidden = NO;
        
    }else{
        
        [STANDARD_DEFAULT_STRING setInteger:0 forKey:@"stock_login"];
        [STANDARD_DEFAULT_STRING synchronize];
        
        LoginVC *_loginVC = [_gMainStoryboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        navController = [[UINavigationController alloc] initWithRootViewController:_loginVC] ;
        
        navController.navigationBar.hidden = YES;
    }
    
    
//    [navController setNavigationBarHidden:NO animated:NO ];

    navController.interactivePopGestureRecognizer.enabled = YES;

    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidActiveAppNotification
                                                        object:nil
                                                      userInfo:nil];
    
//    [GAI sharedInstance].optOut = ![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}
 
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.hummingbird.msg.HummingBird" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HummingBird" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"HummingBird.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

-(void)getLocation{
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    NSString *reqSysVer = @"8.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    
    if ([currSysVer intValue]>=[reqSysVer intValue]) {
#ifdef __IPHONE_8_0
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
#endif
    }
    
    [self.locationManager startUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    //    [locationManager stopUpdatingLocation];
    
    self.uLat = newLocation.coordinate.latitude;
    self.uLong = newLocation.coordinate.longitude;
    
    [[NSUserDefaults standardUserDefaults] setDouble:self.uLat forKey:@"uLat"];
    [[NSUserDefaults standardUserDefaults] setDouble:self.uLong forKey:@"uLog"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}

#pragma mark - delegate to open url from broswer
-(BOOL)application:(UIApplication*)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
    
    
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    
    
 
//    NSLog(@"push received");
//    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"Hello , World"];
//    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc]init];
//    [synth speakUtterance:utterance];
    
    /*
    if ([userInfo objectForKey:@"sync_need"] != nil && [userInfo objectForKey:@"sync_need"] != [NSNull null]) {
        
        int nFlag = [[userInfo objectForKey:@"sync_need"] intValue];
        
        int sync_type = 0;//question
        
        if ([userInfo objectForKey:@"answer_id"] != nil && [userInfo objectForKey:@"answer_id"] != [NSNull null]) {
            sync_type = 1;//answer
        }
        
        int questionID = -1;
        
        
        if ([userInfo objectForKey:@"question_id"] != nil && [userInfo objectForKey:@"question_id"] != [NSNull null]) {
            
            questionID = [[userInfo objectForKey:@"question_id"] intValue];//answer
        }
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"TEST" message:[userInfo objectForKey:@"answer_text"] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        [alertView show];
        
        if (nFlag == 1 && sync_type == 1 ) {
            
            NSLog(@"Silent Received");
            
     
//            UIApplication*    app = [UIApplication sharedApplication];
//            self.background_online = [app beginBackgroundTaskWithExpirationHandler:^{
//                [app endBackgroundTask:self.background_online];
//                self.background_online = UIBackgroundTaskInvalid;
//            }];
//            
//            NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:BACKGROUND_UPDATE]];
//            
//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//            
//            NSDictionary *paramterDic = @{@"user_id":theAppDelegate.gUserData.user_id,
//                                          @"sync_type":[NSNumber numberWithInt:sync_type],
//                                          @"question_id":[NSNumber numberWithInt:questionID]};
//            
//           
//            [manager POST:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                
//                [app endBackgroundTask:self.background_online];
//                self.background_online = UIBackgroundTaskInvalid;
//
//                
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                
//                NSLog(@"%@",operation.responseString);
//                [app endBackgroundTask:self.background_online];
//                self.background_online = UIBackgroundTaskInvalid;
//                
//            }];
            
        }
        
    }
    */
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    
       if ([userInfo objectForKey:@"sync_need"] != nil && [userInfo objectForKey:@"sync_need"] != [NSNull null]) {
           
           int nFlag = [[userInfo objectForKey:@"sync_need"] intValue];
           
           int sync_type = 0;//question
           
           if ([userInfo objectForKey:@"answer_id"] != nil && [userInfo objectForKey:@"answer_id"] != [NSNull null]) {
               sync_type = 1;//answer
           }
           
           int questionID = -1;
           
           if ([userInfo objectForKey:@"question_id"] != nil && [userInfo objectForKey:@"question_id"] != [NSNull null]) {
               
               questionID = [[userInfo objectForKey:@"question_id"] intValue];//answer
           }
           
           
           if (nFlag == 1 && sync_type == 1) {
               
               
               [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidReceiveRemoteMessageNotification
                                                                   object:nil
                                                                 userInfo:userInfo];
               
               if (theAppDelegate.gUserData.user_voice_flag == 1) {
                   
                   // Begin of codes added
                   
                   [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                                    withOptions:AVAudioSessionCategoryOptionInterruptSpokenAudioAndMixWithOthers |AVAudioSessionCategoryOptionDuckOthers
                                                          error:nil];
                   [[AVAudioSession sharedInstance] setActive:YES error:nil];
                   
                   // End of codes added
//                   NSString *strData = [[NSUserDefaults standardUserDefaults] objectForKey:@"voice_type"];
//                   if (strData.length != 0) {
//                       
//                       AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"answer_text"]]];
//                       
//                       utterance.rate = [[NSUserDefaults standardUserDefaults] floatForKey:@"voice_rate"];
//                       
//                       AVSpeechSynthesisVoice *voiceData;
//                       
//                       for (AVSpeechSynthesisVoice *voice in [AVSpeechSynthesisVoice speechVoices]) {
//                           
//                           if ([voice.language isEqualToString:strData]) {
//                               voiceData = voice;
//                               
//                               break;
//                           }
//                       }
//                       
//                       utterance.voice = voiceData;
//                       
//                       [_synth speakUtterance:utterance];
//                       
//                   }else{
//                       
//                       AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"answer_text"]]];
//                       
//                       utterance.rate = [[NSUserDefaults standardUserDefaults] floatForKey:@"voice_rate"];
//                       
//                       NSString*lang = @"en-US";
//                       utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:lang];
//                       
//                       
//                       [_synth speakUtterance:utterance];
//                   }
                   
                   NSLog(@"push received");
                   AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"answer_text"]]];
                   
                   utterance.rate = [[NSUserDefaults standardUserDefaults] floatForKey:@"voice_rate"];
                   
                   NSString*lang = @"en-US";
                   utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:lang];
                   
                   [_synth setDelegate:self];
                   [_synth speakUtterance:utterance];
                   
                   
                   dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                   
                   while (true) {
                       dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC));
                       
                       if (!_synth.speaking)
                           break;
                   }
                   
                   
               }
               
           }
           
       }
       
       // Check result of your operation and call completion block with the result
       completionHandler(UIBackgroundFetchResultNewData);
   
}

-(void)testRequest{
    NSString *urlString = [NSString stringWithFormat:@"%@test1.php",WEBSERVICE_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *paramterDic = @{@"user_email":@"111@gmail.com"};
    
    manager.requestSerializer = [AFHTTPRequestSerializer new];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    [manager GET:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",operation.responseString);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       NSLog(@"%@",operation.responseString);
        
    }];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)theEvent {
    
    if (theEvent.type == UIEventTypeRemoteControl)  {
        switch(theEvent.subtype)        {
            case UIEventSubtypeRemoteControlPlay:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TogglePlayPause" object:nil];
                break;
            case UIEventSubtypeRemoteControlPause:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TogglePlayPause" object:nil];
                break;
            case UIEventSubtypeRemoteControlStop:
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TogglePlayPause" object:nil];
                break;
            default:
                return;
        }
    }
}

#pragma mark - Speech Synthesizer Delegate

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}
-(NSString*)getIpAddress{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}
@end
