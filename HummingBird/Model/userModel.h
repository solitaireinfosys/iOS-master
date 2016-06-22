//
//  userModel.h
//  HummingBird
//
//  Created by Star on 12/5/15.
//  Copyright © 2015 Star. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userModel : NSObject

@property (nonatomic,retain)NSString *user_id;
@property (nonatomic,retain)NSString *user_email;
@property (nonatomic,retain)NSString *user_device;
@property (nonatomic,retain)NSString *user_name;
@property (nonatomic,retain)NSString *user_photo;
@property (nonatomic,retain)NSString *user_password;
@property (nonatomic,readwrite)int user_last_rating_qID;
@property (nonatomic,readwrite)float user_rating;
@property (nonatomic,readwrite)int user_answer_count;
@property (nonatomic,retain)NSString* user_phone;


@property (nonatomic,readwrite)int user_setting_question_push;
@property (nonatomic,readwrite)int user_setting_question_email;
@property (nonatomic,readwrite)int user_setting_question_phone;


@property (nonatomic,readwrite)int user_setting_answer_push;
@property (nonatomic,readwrite)int user_setting_answer_email;
@property (nonatomic,readwrite)int user_setting_answer_phone;
//@property (nonatomic,readwrite)int user_answer_count;

@property (nonatomic,readwrite)float user_credit;

@property (nonatomic,readwrite)int user_type;

@property (nonatomic,retain)NSString *user_fb_token;

@property (nonatomic,readwrite)int user_history_badge;

@property (nonatomic,readwrite)int user_voice_flag;

@end
