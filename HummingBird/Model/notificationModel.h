//
//  notificationModel.h
//  HummingBird
//
//  Created by Star on 3/17/16.
//  Copyright (c) 2016 Star. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface notificationModel : NSObject

@property (nonatomic,readwrite)int notification_user_id;
@property (nonatomic,readwrite)int notification_type;
@property (nonatomic,readwrite)int notification_question_id;
@property (nonatomic,readwrite)int notification_answer_id;
@property (nonatomic,readwrite)int notification_flag;
@property (nonatomic,retain)NSString *notification_date_time;
@property (nonatomic,retain)NSString *notification_question_text;
@property (nonatomic,retain)NSString *notification_answer_text;
@property (nonatomic,retain)NSString *notification_question_date;
@property (nonatomic,retain)NSString *notification_answer_date;
@property (nonatomic,readwrite)float notification_rating;
@property (nonatomic,readwrite)float notification_rating_date;


@end
