//
//  RatingVC.h
//  HummingBird
//
//  Created by Star on 12/18/15.
//  Copyright (c) 2015 Star. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Message.h"

@protocol ratingDelegate <NSObject>

-(void)onRating:(Message*)msg;

@end

@interface RatingVC : UIViewController
{
    IBOutlet UIButton *btnStar1;
    IBOutlet UIButton *btnStar2;
    IBOutlet UIButton *btnStar3;
    IBOutlet UIButton *btnStar4;
    IBOutlet UIButton *btnStar5;
    
    IBOutlet UIButton *btnSubmit;
    
    IBOutlet UIImageView *imgLogo;
}

@property (nonatomic,retain)id<ratingDelegate> delegate;

@property (nonatomic,retain)Message *mMessageData;

@property (nonatomic,retain)Message *mRatingQuestionMessage;
@property (nonatomic,retain)Message *mRatingAnswerMessage;


@end
