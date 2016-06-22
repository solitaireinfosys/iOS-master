//
//  AppDelegate.h
//  HummingBird
//
//  Created by Star on 12/5/15.
//  Copyright © 2015 Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>

@class userModel;

#define theAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;



#pragma mark - define tabbar controller
@property (nonatomic,retain)UITabBarController *tabBarController;
@property (nonatomic,retain)UIStoryboard *gMainStoryboard;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

#pragma mark - method to switch root view controller
-(void)switchRootViewController:(int)nFlag;
-(void)getLocation;
-(NSString*)getIpAddress;

#pragma mark - device token
@property (nonatomic,retain)NSString *uDeviceToken;

@property (nonatomic,retain)userModel *gUserData;

@property (nonatomic,retain)CLLocationManager *locationManager;

@property (nonatomic,readwrite)double uLat;
@property (nonatomic,readwrite)double uLong;

@property (nonatomic,readwrite)UIBackgroundTaskIdentifier background_online;

@property (nonatomic,retain)AVSpeechSynthesizer *synth;


@end

