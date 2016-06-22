//
//  questionModel.h
//  HummingBird
//
//  Created by Star on 12/5/15.
//  Copyright © 2015 Star. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface questionModel : NSObject

@property (nonatomic,readwrite)int question_id;
@property (nonatomic,retain)NSString *question_text;
@property (nonatomic,retain)NSString *question_user_id;
@property (nonatomic,retain)NSString *question_date;
@property (nonatomic,readwrite)double user_rating;

@property (nonatomic,readwrite)int user_answer_count;

@property (nonatomic,readwrite)double question_lat;
@property (nonatomic,readwrite)double question_long;
@property (nonatomic,readwrite)int question_permanent;

@end
