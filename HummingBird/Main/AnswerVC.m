//
//  ConversationVC.m
//  HummingBird
//
//  Created by Star on 12/5/15.
//  Copyright © 2015 Star. All rights reserved.
//

#import "AnswerVC.h"
#import "AppDelegate.h"
#import "Common.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "Message.h"
#import "questionModel.h"
#import "userModel.h"
#import "CommunityVC.h"
#import "MapVC.h"

#import "Analytics.h"

static NSString *kBaseDateFormat = @"yyyy-MM-dd HH:mm:ss";

@interface AnswerVC ()

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) UIImage *myImage;
@property (strong, nonatomic) UIImage *partnerImage;

@end

@implementation AnswerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.dataSource = [NSMutableArray array];
    
//    self.navigationItem.title = @"Answer";
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    [backView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 110, 22)];
    [lblTitle setText:@"Answer"];
    [lblTitle setTextColor:[UIColor blackColor]];
    lblTitle.shadowColor = [UIColor whiteColor];
    lblTitle.shadowOffset = CGSizeMake(0, 1);
    lblTitle.font = [UIFont boldSystemFontOfSize:17];
    lblTitle.textAlignment = NSTextAlignmentRight;
    [backView addSubview:lblTitle];
    
    UIImageView *imgInfo = [[UIImageView alloc]initWithFrame:CGRectMake(120, 10, 20, 20)];
    [imgInfo setImage:[UIImage imageNamed:@"Information-icon"]];
    [backView addSubview:imgInfo];
    
    UIButton *btnInfo = [[UIButton alloc]initWithFrame:imgInfo.frame];
    [btnInfo setBackgroundColor:[UIColor clearColor]];
    [btnInfo addTarget:self action:@selector(onInfo:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btnInfo];
    self.navigationItem.titleView = backView;
    
    
    if (_mQuestionData.question_lat != 0 && _mQuestionData.question_long != 0) {
        self.btnMap.hidden = NO;
        [self.btnMap addTarget:self action:@selector(onMap:) forControlEvents:UIControlEventTouchUpInside];

        
    }else{
        self.btnMap.hidden = YES;
    }
    
    if (self.messageWindowType == MESSAGE_ANSWER_HISTORY || self.messageWindowType == MESSAGE_ANSWER_NORATING) {
        [self setUserInfo];
    }else{
        
        UIButton *btnBlock = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        [btnBlock setImage:[UIImage imageNamed:@"block"] forState:UIControlStateNormal];
        [btnBlock addTarget:self action:@selector(onBlock:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *barBlock = [[UIBarButtonItem alloc]initWithCustomView:btnBlock];

        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:barBlock, nil];
        
//        UIButton *btnInfo = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
//        [btnInfo setImage:[UIImage imageNamed:@"Information-icon"] forState:UIControlStateNormal];
//        [btnInfo addTarget:self action:@selector(onInfo:) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *barInfo = [[UIBarButtonItem alloc] initWithCustomView:btnInfo];
//        
//        
//        if (_mQuestionData.question_lat != 0 && _mQuestionData.question_long != 0) {
//            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:barBlock,barInfo, nil];
//            
//        }else{
//            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:barBlock,barInfo, nil];
//            
//        }
        
        
        UIButton *btnBack = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [btnBack setImage:[UIImage imageNamed:@"Community"] forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barBack = [[UIBarButtonItem alloc]initWithCustomView:btnBack];
        
        self.navigationItem.leftBarButtonItem = barBack;
        
        
    }
    
    self.messageInputView.textView.placeholderText = NSLocalizedString(@"What is your answer...", nil);

}

-(IBAction)onInfo:(id)sender{
    
    NSString *strMessage = @"Answer the question posed by the user and earn credit. If the question is sent back to the user you will be rated!  All answers are not posted to back to the user. The person who answers quickest, and has a highest user rating will be posted, so be quick!\n\n*notes: Use the Location icon to see where the user is located who asked the question.";
    
    [lblInfo setText:strMessage];
    
    [lblInfo sizeToFit];
    
    if (!infoAlertView) {
        
        UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, lblInfo.frame.size.height + 20)];
        lblInfo.frame = CGRectMake(10, 10, lblInfo.frame.size.width, lblInfo.frame.size.height);
        [infoView addSubview:lblInfo];
        
        infoAlertView = [[CustomIOS7AlertView alloc] init];
        [infoAlertView setContainerView:infoView];
        
        [infoAlertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Ok", nil]];
        [infoAlertView setDelegate:self];
        [infoAlertView setUseMotionEffects:true];
    }
    
    [infoAlertView show];
}

-(IBAction)onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)onSpace:(id)sender{
    
}

-(IBAction)onMap:(id)sender{
    MapVC *mMapVC = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"MapVC"];
    mMapVC.mQuestionData = _mQuestionData;
    [self.navigationController pushViewController:mMapVC animated:YES];
}

-(IBAction)onBlock:(id)sender{
    
    UIAlertController *_alertView = [UIAlertController alertControllerWithTitle:nil message:@"Do you want to remove this question from the community?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* report_cancel = [UIAlertAction
                                    actionWithTitle:@"Cancel"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Do some thing here
                                        [_alertView dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
    
    [_alertView addAction:report_cancel];
    
    UIAlertAction* report_yes = [UIAlertAction
                                 actionWithTitle:@"Yes"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     //Do some thing here
                                     [self onRequestBlock];
                                     
                                 }];
    
    [_alertView addAction:report_yes];
    
    
    [self presentViewController:_alertView animated:YES completion:nil];
    
}

-(void)onRequestBlock{
    [SVProgressHUD showWithStatus:REQUEST_WAITING];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_BLOCK_POST]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *paramterDic = @{@"question_id":[NSNumber numberWithInt:_mQuestionData.question_id],
                                  @"user_id":theAppDelegate.gUserData.user_id,
                                  @"question_user_id":_mQuestionData.question_user_id};
    
    [manager POST:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ( [responseObject count] > 0 ) {
            
            [SVProgressHUD showSuccessWithStatus:@"Reported"];
            
            NSDictionary *responseDic = [responseObject objectAtIndex:0];
            if ([[responseDic objectForKey:@"status"] intValue] == 200) {
                
                
            }else{
                
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:WEB_FAILED];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",operation.responseString);
        [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        
    }];
}

-(void)onSetQuestion{
    
    Message *chatData = [[Message alloc]init];
    chatData.text = _mQuestionData.question_text;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = kBaseDateFormat;
    
    chatData.date = [formatter dateFromString:_mQuestionData.question_date];
    chatData.fromMe = NO;
    
    [self.dataSource removeAllObjects];
    
    [self.dataSource addObject:chatData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshMessages];
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
    [tracker set:kGAIScreenName value:@"Answer Page"];
    [tracker send:[[[GAIDictionaryBuilder createScreenView]
                    set:@"Answer Page"
                    forKey:[GAIFields customDimensionForIndex:1]] build]];

    [self loadMessages];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)loadMessages
{
    
    [SVProgressHUD showWithStatus:REQUEST_WAITING];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_ANSWER_GET]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    long currentTime = (long)CFAbsoluteTimeGetCurrent();
    
    NSDictionary *paramterDic = @{@"question_id":[NSNumber numberWithInt:_mQuestionData.question_id],
                                  @"user_id":theAppDelegate.gUserData.user_id,
                                  @"time":[NSString stringWithFormat:@"%ld",currentTime]};
    
    [manager GET:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ( [responseObject count] > 0 ) {
            
            [SVProgressHUD dismiss];
            
            [self onSetQuestion];
            
            NSDictionary *responseDic = [responseObject objectAtIndex:0];
            if ([[responseDic objectForKey:@"status"] intValue] == 200) {
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                
                formatter.dateFormat = kBaseDateFormat;
                
                for (int i=0; i<[responseObject count]; i++) {
                    
                    NSDictionary *objDic = [responseObject objectAtIndex:i];
                    
                    Message *chatData = [[Message alloc]init];
                    
                    
                    if ([objDic objectForKey:@"question_id"] != nil) {
                        chatData.msg_id = [[objDic objectForKey:@"question_id"] intValue];
                    }
                    
                    if ([objDic objectForKey:@"question_text"] != nil) {
                        chatData.text = [objDic objectForKey:@"question_text"];
                    }
                    
                    if ([objDic objectForKey:@"question_date"] != nil) {
                        chatData.date = [formatter dateFromString:[objDic objectForKey:@"question_date"]];
                    }
                    
                    chatData.type = SOMessageTypeText;
                    
                    if ([objDic objectForKey:@"question_type"] != nil) {
                        
                        int nType = [[objDic objectForKey:@"question_type"] intValue];
                        if (nType == 1) {
                            chatData.fromMe = NO;
                        }else{
                            chatData.fromMe = YES;
                        }
                    }else{
                        chatData.fromMe = YES;
                    }
                    

                    [self.dataSource addObject:chatData];
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self refreshMessages];
                });
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        
        
    }];
}

#pragma mark - SOMessaging data source
- (NSMutableArray *)messages
{
    return self.dataSource;
}

- (NSTimeInterval)intervalForMessagesGrouping
{
    // Return 0 for disableing grouping
    return 2 * 24 * 3600;
}

- (void)configureMessageCell:(SOMessageCell *)cell forMessageAtIndex:(NSInteger)index
{
    Message *message = self.dataSource[index];
    
    // Adjusting content for 3pt. (In this demo the width of bubble's tail is 3pt)
    if (!message.fromMe) {
        cell.contentInsets = UIEdgeInsetsMake(0, 3.0f, 0, 0); //Move content for 3 pt. to right
        cell.textView.textColor = [UIColor blackColor];
    } else {
        cell.contentInsets = UIEdgeInsetsMake(0, 0, 0, 3.0f); //Move content for 3 pt. to left
        cell.textView.textColor = [UIColor whiteColor];
    }
    
    cell.userImageView.layer.cornerRadius = self.userImageSize.width/2;
    
    // Fix user image position on top or bottom.
    cell.userImageView.autoresizingMask = message.fromMe ? UIViewAutoresizingFlexibleTopMargin : UIViewAutoresizingFlexibleBottomMargin;
    
    // Setting user images
    cell.userImage = message.fromMe ? self.myImage : self.partnerImage;
}

- (CGFloat)messageMaxWidth
{
    return 140;
}

- (CGSize)userImageSize
{
    return CGSizeMake(40, 40);
}

- (CGFloat)messageMinHeight
{
    return 0;
}
#pragma mark - SOMessaging delegate
- (void)didSelectMedia:(NSData *)media inMessageCell:(SOMessageCell *)cell
{
    // Show selected media in fullscreen
    [super didSelectMedia:media inMessageCell:cell];
}

- (void)messageInputView:(SOMessageInputView *)inputView didSendMessage:(NSString *)message
{
    if (![[message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        return;
    }
    
    Message *msg = [[Message alloc] init];
    msg.text = message;
    msg.fromMe = YES;
    
    [self onRequestSend:msg];
    
    [inputView.textView resignFirstResponder];
    
}

-(void)onRequestSend:(Message*)msg{
    [SVProgressHUD showWithStatus:@"Sending..."];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_ANSWER_POST]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *paramterDic = @{@"user_id":theAppDelegate.gUserData.user_id,
                                  @"question_id":[NSNumber numberWithInt:_mQuestionData.question_id],
                                  @"answer":msg.text,
                                  @"question_user_id":_mQuestionData.question_user_id,
                                  @"answer_lat":[NSString stringWithFormat:@"%f",theAppDelegate.uLat],
                                  @"answer_long":[NSString stringWithFormat:@"%f",theAppDelegate.uLong]};
    
    [manager POST:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD dismiss];
        
        if ( [responseObject count] > 0 ) {
            
            NSDictionary *responseDic = [responseObject objectAtIndex:0];
            
            int filter_violation = -1;
            
            if ([responseDic objectForKey:@"filter_violation"] != nil) {
                filter_violation = [[responseDic objectForKey:@"filter_violation"] intValue];
                
//                if (filter_violation != 1) {
//                    
//                    UIAlertController *_alertView = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Warning - your response has be filtered by our automated system and has been recorded. Please refrain from using words that may be viewed as obscene." preferredStyle:UIAlertControllerStyleAlert];
//                    
//                    UIAlertAction* action_ok = [UIAlertAction
//                                                actionWithTitle:@"Ok"
//                                                style:UIAlertActionStyleDefault
//                                                handler:^(UIAlertAction * action)
//                                                {
//                                                    //Do some thing here
//                                                    [_alertView dismissViewControllerAnimated:YES completion:nil];
//                                                    
//                                                }];
//                    
//                    [_alertView addAction:action_ok];
//                    
//                    [self presentViewController:_alertView animated:YES completion:nil];
//                    
//                }
            }
            
            
            
            if (filter_violation != 1) {
                
                msg.text = @"Warning - your response has be filtered by our automated system and has been recorded. Please refrain from using words that may be viewed as obscene.";
                [self sendMessage:msg];
            }else{
                [self sendMessage:msg];
            }
            
            if (self.delegate != nil) {
                __strong id<answerDelegate> strongDelegate = _delegate;
                [strongDelegate onAnswered:self.mQuestionIndex];
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        
    }];
}

- (void)messageInputViewDidSelectMediaButton:(SOMessageInputView *)inputView
{
    // Take a photo/video or choose from gallery
}

-(void)setUserInfo{

    [self.lblRating setText:[NSString stringWithFormat:@"Rating: %.2f",theAppDelegate.gUserData.user_rating]];
    [self.lblAnswers setText:[NSString stringWithFormat:@"Answers: %d",theAppDelegate.gUserData.user_answer_count]];
    [self.lblCredit setText:[NSString stringWithFormat:@"Credit: $%.2f", theAppDelegate.gUserData.user_credit]];
    
    if (_mQuestionData.user_rating >= 4.5) {
        [self.imgStar1 setImage:[UIImage imageNamed:@"star"]];
        [self.imgStar2 setImage:[UIImage imageNamed:@"star"]];
        [self.imgStar3 setImage:[UIImage imageNamed:@"star"]];
        [self.imgStar4 setImage:[UIImage imageNamed:@"star"]];
        [self.imgStar5 setImage:[UIImage imageNamed:@"star"]];
        
    }else if (_mQuestionData.user_rating >= 3.5){
        [self.imgStar1 setImage:[UIImage imageNamed:@"star"] ];
        [self.imgStar2 setImage:[UIImage imageNamed:@"star"] ];
        [self.imgStar3 setImage:[UIImage imageNamed:@"star"] ];
        [self.imgStar4 setImage:[UIImage imageNamed:@"star"] ];
        [self.imgStar5 setImage:[UIImage imageNamed:@"unstar"] ];
        
    }else if (_mQuestionData.user_rating >= 2.5){
        [self.imgStar1 setImage:[UIImage imageNamed:@"star"] ];
        [self.imgStar2 setImage:[UIImage imageNamed:@"star"] ];
        [self.imgStar3 setImage:[UIImage imageNamed:@"star"] ];
        [self.imgStar4 setImage:[UIImage imageNamed:@"unstar"] ];
        [self.imgStar5 setImage:[UIImage imageNamed:@"unstar"] ];
        
    }else if (_mQuestionData.user_rating >= 1.5){
        [self.imgStar1 setImage:[UIImage imageNamed:@"star"] ];
        [self.imgStar2 setImage:[UIImage imageNamed:@"star"] ];
        [self.imgStar3 setImage:[UIImage imageNamed:@"unstar"] ];
        [self.imgStar4 setImage:[UIImage imageNamed:@"unstar"] ];
        [self.imgStar5 setImage:[UIImage imageNamed:@"unstar"] ];
        
    }else if (_mQuestionData.user_rating >= 0.5){
        [self.imgStar1 setImage:[UIImage imageNamed:@"star"] ];
        [self.imgStar2 setImage:[UIImage imageNamed:@"unstar"] ];
        [self.imgStar3 setImage:[UIImage imageNamed:@"unstar"] ];
        [self.imgStar4 setImage:[UIImage imageNamed:@"unstar"] ];
        [self.imgStar5 setImage:[UIImage imageNamed:@"unstar"] ];
        
    }else{
        [self.imgStar1 setImage:[UIImage imageNamed:@"unstar"] ];
        [self.imgStar2 setImage:[UIImage imageNamed:@"unstar"] ];
        [self.imgStar3 setImage:[UIImage imageNamed:@"unstar"] ];
        [self.imgStar4 setImage:[UIImage imageNamed:@"unstar"] ];
        [self.imgStar5 setImage:[UIImage imageNamed:@"unstar"] ];
        
        //        _starView.hidden = YES;
        
    }

}
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [alertView close];
        
    }
}
@end
