//
//  topModel.h
//  HummingBird
//
//  Created by Star on 3/8/16.
//  Copyright (c) 2016 Star. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface topModel : NSObject

@property (nonatomic,readwrite)int top_answer_id;
@property (nonatomic,retain)NSString *top_question_text;
@property (nonatomic,retain)NSString *top_answer_text;
@property (nonatomic,readwrite)float top_rating;
@property (nonatomic,readwrite)int top_likes;
@property (nonatomic,readwrite)int top_comments;

@end
