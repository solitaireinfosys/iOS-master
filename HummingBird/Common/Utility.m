//
//  Utility.m
//  HummingBird
//
//  Created by Star on 12/5/15.
//  Copyright © 2015 Star. All rights reserved.
//

#import "Utility.h"
#import "AppDelegate.h"
#import "userModel.h"

@implementation Utility

+ (Utility *) getInstance {
    
    static Utility* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Utility alloc] init];
    });
    
    return instance;
}

- (id) init {
    self = [super init];
    
    if (self) {
    }
    
    return self;
}

-(void)saveUserData:(userModel*)uData{
    
    [[NSUserDefaults standardUserDefaults] setObject:uData.user_id forKey:@"user_id"];
    [[NSUserDefaults standardUserDefaults] setObject:uData.user_name forKey:@"user_name"];
    [[NSUserDefaults standardUserDefaults] setObject:uData.user_email forKey:@"user_email"];
    [[NSUserDefaults standardUserDefaults] setObject:uData.user_password forKey:@"user_password"];
    
    [[NSUserDefaults standardUserDefaults] setInteger:uData.user_last_rating_qID forKey:@"user_last_rating_qID"];
    [[NSUserDefaults standardUserDefaults] setFloat:uData.user_rating forKey:@"user_rating"];
    [[NSUserDefaults standardUserDefaults] setInteger:uData.user_answer_count forKey:@"user_answers"];
    
    [[NSUserDefaults standardUserDefaults] setInteger:uData.user_setting_question_email forKey:@"user_setting_qt_email"];
    [[NSUserDefaults standardUserDefaults] setInteger:uData.user_setting_question_phone forKey:@"user_setting_qt_phone"];
    [[NSUserDefaults standardUserDefaults] setInteger:uData.user_setting_question_push forKey:@"user_setting_qt_push"];
    
    [[NSUserDefaults standardUserDefaults] setInteger:uData.user_setting_answer_email forKey:@"user_setting_aw_email"];
    [[NSUserDefaults standardUserDefaults] setInteger:uData.user_setting_answer_phone forKey:@"user_setting_aw_phone"];
    [[NSUserDefaults standardUserDefaults] setInteger:uData.user_setting_answer_push forKey:@"user_setting_aw_push"];
    
    [[NSUserDefaults standardUserDefaults] setInteger:uData.user_history_badge forKey:@"user_history_badge"];
    
    [[NSUserDefaults standardUserDefaults] setInteger:uData.user_type forKey:@"user_type"];
    
    [[NSUserDefaults standardUserDefaults] setFloat:uData.user_credit forKey:@"user_credit"];
    
    [[NSUserDefaults standardUserDefaults] setObject:uData.user_phone forKey:@"user_phone"];
    
    [[NSUserDefaults standardUserDefaults] setObject:theAppDelegate.gUserData.user_fb_token forKey:@"user_fb_token"];
    
    [[NSUserDefaults standardUserDefaults] setInteger:theAppDelegate.gUserData.user_voice_flag forKey:@"user_voice_flag"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)getUserData{
    
    theAppDelegate.gUserData.user_voice_flag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user_voice_flag"] intValue];
    
    theAppDelegate.gUserData.user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    theAppDelegate.gUserData.user_name = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
    theAppDelegate.gUserData.user_email = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_email"];
    theAppDelegate.gUserData.user_password = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_password"];
    
    theAppDelegate.gUserData.user_last_rating_qID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user_last_rating_qID"] intValue];
    theAppDelegate.gUserData.user_rating = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user_rating"] floatValue];
    theAppDelegate.gUserData.user_answer_count = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user_answers"] intValue];
    
    theAppDelegate.gUserData.user_setting_question_email = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user_setting_qt_email"] intValue];
    theAppDelegate.gUserData.user_setting_question_phone = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user_setting_qt_phone"] intValue];
    theAppDelegate.gUserData.user_setting_question_push = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user_setting_qt_push"] intValue];
    
    theAppDelegate.gUserData.user_setting_answer_email = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user_setting_aw_email"] intValue];
    theAppDelegate.gUserData.user_setting_answer_phone = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user_setting_aw_phone"] intValue];
    theAppDelegate.gUserData.user_setting_answer_push = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user_setting_aw_push"] intValue];
    
    theAppDelegate.gUserData.user_credit = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user_credit"] floatValue];
    
    theAppDelegate.gUserData.user_phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_phone"];
    
    theAppDelegate.gUserData.user_fb_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_fb_token"];
    
    
    theAppDelegate.gUserData.user_type = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user_type"] intValue];
    
    theAppDelegate.gUserData.user_history_badge = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user_history_badge"] intValue];
}

-(userModel*)onParseUser:(NSDictionary*)dic{
    
    userModel *userData = [[userModel alloc]init];
    
    if ([dic objectForKey:@"user_voice_flag"] != nil && [dic objectForKey:@"user_voice_flag"] != [NSNull null]) {
        userData.user_voice_flag = [[dic objectForKey:@"user_voice_flag"] intValue];
    }
    
    if ([dic objectForKey:@"user_history_badge"] != nil && [dic objectForKey:@"user_history_badge"] != [NSNull null]) {
        userData.user_history_badge = [[dic objectForKey:@"user_history_badge"] intValue];
    }
    
    if ([dic objectForKey:@"user_type"] != nil && [dic objectForKey:@"user_type"] != [NSNull null]) {
        userData.user_type = [[dic objectForKey:@"user_type"] intValue];
    }
    
    if ([dic objectForKey:@"user_phone"] != nil && [dic objectForKey:@"user_phone"] != [NSNull null]) {
        userData.user_phone = [dic objectForKey:@"user_phone"];
    }
    
    if ([dic objectForKey:@"user_credit"] != nil && [dic objectForKey:@"user_credit"] != [NSNull null]) {
        userData.user_credit = [[dic objectForKey:@"user_credit"] floatValue];
    }
    
    if ([dic objectForKey:@"user_id"] != nil && [dic objectForKey:@"user_id"] != [NSNull null]) {
        userData.user_id = [dic objectForKey:@"user_id"];
    }
    
    if ([dic objectForKey:@"user_name"] != nil && [dic objectForKey:@"user_name"] != [NSNull null]) {
        userData.user_name = [dic objectForKey:@"user_name"];
    }
    
    if ([dic objectForKey:@"user_email"] != nil && [dic objectForKey:@"user_email"] != [NSNull null]) {
        userData.user_email = [dic objectForKey:@"user_email"];
    }
    
    if ([dic objectForKey:@"user_photo"] != nil && [dic objectForKey:@"user_photo"] != [NSNull null]) {
        userData.user_photo = [dic objectForKey:@"user_photo"];
    }
    
    if ([dic objectForKey:@"user_device"] != nil && [dic objectForKey:@"user_device"] != [NSNull null]) {
        userData.user_device = [dic objectForKey:@"user_device"];
    }
    
    if ([dic objectForKey:@"user_last_rating_qID"] != nil && [dic objectForKey:@"user_last_rating_qID"] != [NSNull null]) {
        userData.user_last_rating_qID = [[dic objectForKey:@"user_last_rating_qID"] intValue];
    }
    
    if ([dic objectForKey:@"user_rating"] != nil && [dic objectForKey:@"user_rating"] != [NSNull null]) {
        userData.user_rating = [[dic objectForKey:@"user_rating"] floatValue];
    }
    
    if ([dic objectForKey:@"user_answers"] != nil && [dic objectForKey:@"user_answers"] != [NSNull null]) {
        userData.user_answer_count = [[dic objectForKey:@"user_answers"] intValue];
    }
    
    if ([dic objectForKey:@"user_setting_qt_push"] != nil && [dic objectForKey:@"user_setting_qt_push"] != [NSNull null]) {
        userData.user_setting_question_push = [[dic objectForKey:@"user_setting_qt_push"] intValue];
    }
    
    if ([dic objectForKey:@"user_setting_qt_email"] != nil && [dic objectForKey:@"user_setting_qt_email"] != [NSNull null]) {
        userData.user_setting_question_email = [[dic objectForKey:@"user_setting_qt_email"] intValue];
    }
    
    if ([dic objectForKey:@"user_setting_qt_phone"] != nil && [dic objectForKey:@"user_setting_qt_phone"] != [NSNull null]) {
        userData.user_setting_question_phone = [[dic objectForKey:@"user_setting_qt_phone"] intValue];
    }
    
    if ([dic objectForKey:@"user_setting_aw_push"] != nil && [dic objectForKey:@"user_setting_aw_push"] != [NSNull null]) {
        userData.user_setting_answer_push = [[dic objectForKey:@"user_setting_aw_push"] intValue];
    }
    
    if ([dic objectForKey:@"user_setting_aw_email"] != nil && [dic objectForKey:@"user_setting_aw_email"] != [NSNull null]) {
        userData.user_setting_answer_email = [[dic objectForKey:@"user_setting_aw_email"] intValue];
    }
    
    if ([dic objectForKey:@"user_setting_aw_phone"] != nil && [dic objectForKey:@"user_setting_aw_phone"] != [NSNull null]) {
        userData.user_setting_answer_phone = [[dic objectForKey:@"user_setting_aw_phone"] intValue];
    }
    
    if ([dic objectForKey:@"user_password"] != nil && [dic objectForKey:@"user_password"] != [NSNull null]) {
        userData.user_password = [dic objectForKey:@"user_password"];
    }
    

    
    return userData;
}
@end
