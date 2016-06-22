#import <UIKit/UIKit.h>
#import "ConversationVC.h"
#import "AppDelegate.h"
#import "Common.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "Message.h"
#import "questionModel.h"
#import "userModel.h"
#import "CommunityVC.h"
#import "SOPlaceholderedTextView.h"
#import "RatingVC.h"
#import "Utility.h"
#import "SettingVC.h"
#import "OneOnOneChatVC.h"
#import "SearchFriendVC.h"

#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Social/Social.h>
#import <Foundation/Foundation.h>

#import "CustomIOS7AlertView.h"

#import <AVFoundation/AVFoundation.h>

#import "TopVC.h"
#import "HistoryVC.h"
#import "NotificationCaptureVC.h"

#import "LinkVC.h"
#import "AboutVC.h"

#ifdef humming_dist
#import "Analytics.h"
#endif

#define rating_show 0
#define rating_hide -210

#define play_start 0
#define play_end 1
#define menu_show_x 215

#define weblink_url @"http://www.hummb.com/link.php?"
#import "ISSpeechRecognition.h"
#import "SSMessageControl.h"

static NSString *kBaseDateFormat = @"yyyy-MM-dd HH:mm:ss";



@interface ConversationVC ()<SSMessageDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) UIImage *myImage;
@property (strong, nonatomic) UIImage *partnerImage;

@end

@implementation ConversationVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    [self testRequest];
    
    nCheckRatingFlag = false;
    
    tapMenuHide.enabled = NO;
    
    theAppDelegate.synth.delegate = self;
    
    menuStartX.constant = 0;
    
    shareView.hidden = NO;
    [swtShare setThumbTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_fb"]]];
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"FBShareFlag"] == 1) {
        [swtShare setOn:true];
    }else{
        
        [swtShare setOn:false];
    }
    
    //[theAppDelegate.window bringSubviewToFront:menuView];
    [self.view bringSubviewToFront:ratingView];
    [self.view bringSubviewToFront:menuView];
    
    rating_y.constant = rating_hide;
    
    btnSubmit.clipsToBounds = YES;
    btnSubmit.layer.cornerRadius = 5;
    
    [self onUpdateStarUI];
    
    [self xmppSetDelegate];
    
    self.dataSource = [NSMutableArray array];
    [self.btnArrow addTarget:self action:@selector(onShowRate:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnInfo addTarget:self action:@selector(recognize:) forControlEvents:UIControlEventTouchUpInside];
    
    self.messageInputView.textView.placeholderText = NSLocalizedString(@"What is your question...", nil);
    
    [self.messageInputView.mediaButton addTarget:self action:@selector(recognize:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnBird addTarget:self action:@selector(onBird:) forControlEvents:UIControlEventTouchUpInside];
    
    if (theAppDelegate.gUserData.user_voice_flag == 1) {
        
        [self.imgBrand setImage:[UIImage imageNamed:@"bird_green"]];
        
    }else{
        
        [self.imgBrand setImage:[UIImage imageNamed:@"splash_icon"]];
    }
}

-(void)xmppSetDelegate
{
    
    [SSMessageControl shareInstance].otherjid = @"admin@server.hummb.com";
    [SSMessageControl shareInstance].delegate = self;
    [[SSMessageControl shareInstance] setSSMessageDelegate];
}

-(void)voiceChangeRequest:(int)nType{//1:voice on 0:voice off
    [SVProgressHUD showWithStatus:@"Sending..."];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_VOICE_CHANGE]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *paramterDic = @{@"user_id":theAppDelegate.gUserData.user_id,
                                  @"voice_flag":[NSNumber numberWithInt:nType]};
    
    manager.requestSerializer = [AFHTTPRequestSerializer new];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    [manager POST:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ( [responseObject count] > 0 ) {
            
            if (nType == 0) {
                [SVProgressHUD showSuccessWithStatus:@"Voice Off"];
                AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:[NSString stringWithFormat:@"Voice Off"]];
                
                utterance.rate = [[NSUserDefaults standardUserDefaults] floatForKey:@"voice_rate"];
                
                NSString*lang = @"en-US";
                utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:lang];
                
                [theAppDelegate.synth speakUtterance:utterance];
                
                [self.imgBrand setImage:[UIImage imageNamed:@"splash_icon"]];
                
                theAppDelegate.gUserData.user_voice_flag = 0;
                
            }else{
                
                [SVProgressHUD showSuccessWithStatus:@"Voice On"];
                AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:[NSString stringWithFormat:@"Voice On"]];
                
                utterance.rate = [[NSUserDefaults standardUserDefaults] floatForKey:@"voice_rate"];
                
                NSString*lang = @"en-US";
                utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:lang];
                
                [theAppDelegate.synth speakUtterance:utterance];
                
                [self.imgBrand setImage:[UIImage imageNamed:@"bird_green"]];
                theAppDelegate.gUserData.user_voice_flag = 1;
            }
            
            [[Utility getInstance]saveUserData:theAppDelegate.gUserData];
            
        }else{
            [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",operation.responseString);
        [SVProgressHUD showErrorWithStatus:WEB_FAILED];
    }];
}


-(IBAction)onBird:(id)sender{
    
    if (theAppDelegate.gUserData.user_voice_flag == 1) {
        
        [self voiceChangeRequest:0];
        
        
    }else{
        
        [self voiceChangeRequest:1];
        
    }
    
}
-(IBAction)onHideRate:(id)sender{
    [UIView animateWithDuration:0.4
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction|
                                 UIViewAnimationOptionBeginFromCurrentState)
                     animations:^(void) {
                         rating_y.constant = rating_hide;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         self.tableView.userInteractionEnabled = YES;
                     }];
}

-(IBAction)onShowRate:(id)sender{
    
    btnStar1.tag = 0;
    btnStar2.tag = 0;
    btnStar3.tag = 0;
    btnStar4.tag = 0;
    btnStar5.tag = 0;
    
    [self onUpdateStarUI];
    
    if (self.dataSource.count > 1) {
        
        [self onSetQuestionAndAnswer];
    }
    if (nCheckRatingFlag) {
        
        [btnSubmit setBackgroundColor:[UIColor lightGrayColor]];
        
        [lblTopAnswer setText:@"No answer to rate"];
        
    }else{
        
        [btnSubmit setBackgroundColor:[UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1.0]];
        
        [lblTopAnswer setText:_mSelectedRatingAnswerMessage.text];
        
    }
    //    [SVProgressHUD showWithStatus:@"Waiting..."];
    //
    //    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_CHECK_RATING]];
    //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //
    //    NSDictionary *paramterDic = @{@"user_id":theAppDelegate.gUserData.user_id};
    //
    //    [manager GET:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //
    //        [SVProgressHUD dismiss];
    //
    //        if ( [responseObject count] > 0 ) {
    //
    //            NSDictionary *responseDic = [responseObject objectAtIndex:0];
    //
    //            if ([[responseDic objectForKey:@"status"] intValue] == 200) {
    //
    //                [btnSubmit setBackgroundColor:[UIColor lightGrayColor]];
    //
    //                [lblTopAnswer setText:@"No answer to rate"];
    //
    //            }else{
    //
    //                [btnSubmit setBackgroundColor:[UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1.0]];
    //
    //                [lblTopAnswer setText:_mSelectedRatingAnswerMessage.text];
    //
    //            }
    //
    //        }
    //
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //
    //        NSLog(@"%@",operation.responseString);
    //        [SVProgressHUD showErrorWithStatus:@"Failed. Try again"];
    //    }];
    //    if([self onCheckRatingPage]){
    //
    //
    //
    //    }else{
    //
    //
    //    }
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"FBShareFlag"] == 1) {
        [swtShare setOn:true];
    }else{
        
        [swtShare setOn:false];
    }
    
    [UIView animateWithDuration:0.4
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction|
                                 UIViewAnimationOptionBeginFromCurrentState)
                     animations:^(void) {
                         rating_y.constant = rating_show;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         
                         self.tableView.userInteractionEnabled = NO;
                         ratingView.userInteractionEnabled = YES;
                     }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    if (self.refreshTimer) {
//        [self.refreshTimer invalidate];
//        
//        self.refreshTimer = nil;
//    }
//    
//    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(loadMessages1) userInfo:nil repeats:YES];
    
    
#ifdef humming_dist
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
    
    [tracker set:kGAIScreenName value:@"User Page"];
    [tracker send:[[[GAIDictionaryBuilder createScreenView]
                    set:@"User Page"
                    forKey:[GAIFields customDimensionForIndex:1]] build]];
#endif
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushReceived:)
                                                 name:kNotificationDidReceiveRemoteMessageNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(activeApp)
                                                 name:kNotificationDidActiveAppNotification
                                               object:nil];
    
    [self loadMessages];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
//    if (self.refreshTimer) {
//        [self.refreshTimer invalidate];
//        
//        self.refreshTimer = nil;
//    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationDidReceiveRemoteMessageNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kNotificationDidActiveAppNotification
                                                  object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)shouldReloadTable1:(NSMutableArray *)data
{
    NSLog(@"%@",data);
    [self loadMessages1];
    
}
-(void)loadBeepSound{
    // Get the path to the beep.mp3 file and convert it to a NSURL object.
   }
-(void) playSound
{
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"Beep" ofType:@"mp3"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
    AudioServicesPlaySystemSound (soundID);
//    [soundPath release];
    
//    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"Beep" ofType:@"mp3"];
//    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
//    
//    NSError *error;
//    
//    // Initialize the audio player object using the NSURL object previously set.
//    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
//    if (error) {
//        // If the audio player cannot be initialized then log a message.
//        NSLog(@"Could not play beep file.");
//        NSLog(@"%@", [error localizedDescription]);
//    }
//    else{
//        // If the audio player was successfully initialized then load it in memory.
//        [_audioPlayer prepareToPlay];
//    }
//
//    NSString *path  = [[NSBundle mainBundle] pathForResource:@"Beep" ofType:@"mp3"];
//    NSURL *pathURL = [NSURL fileURLWithPath : path];
//    
//    SystemSoundID audioEffect;
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
//    AudioServicesPlaySystemSound(audioEffect);
//    
//    // call the following function when the sound is no longer used
//    // (must be done AFTER the sound is done playing)
//    AudioServicesDisposeSystemSoundID(audioEffect);
    
    
}

- (void)loadMessages
{
    if (self.dataSource.count == 0) {
        [SVProgressHUD showWithStatus:REQUEST_WAITING];
    }
    
    long currentTime = (long)CFAbsoluteTimeGetCurrent();
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_QUESTION_GET]];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *paramterDic = @{@"user_id":theAppDelegate.gUserData.user_id,
                                  @"time":[NSString stringWithFormat:@"%ld",currentTime]};
    
    [manager GET:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ( [responseObject count] > 0 ) {
            
            [SVProgressHUD dismiss];
            
            [self.dataSource removeAllObjects];
            
            NSDictionary *responseDic = [responseObject objectAtIndex:0];
            if ([[responseDic objectForKey:@"status"] intValue] == 200) {
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                
                formatter.dateFormat = kBaseDateFormat;
                
                for (int i=0; i<[responseObject count]; i++) {
                    
                    NSDictionary *objDic = [responseObject objectAtIndex:i];
                    
                    Message *chatData = [[Message alloc]init];
                    
                    if ([objDic objectForKey:@"rating_flag"] != nil) {
                        
                        int nFlag = [[objDic objectForKey:@"rating_flag"] intValue];
                        
                        if (nFlag == 200) {
                            nCheckRatingFlag = true;
                        }else{
                            nCheckRatingFlag = false;
                        }
                    }
                    
                    if ([objDic objectForKey:@"question_id"] != nil) {
                        chatData.msg_id = [[objDic objectForKey:@"question_id"] intValue];
                    }
                    
                    if ([objDic objectForKey:@"question_text"] != nil) {
                        chatData.text = [objDic objectForKey:@"question_text"];
                    }
                    
                    if ([objDic objectForKey:@"question_date"] != nil) {
                        chatData.date = [formatter dateFromString:[objDic objectForKey:@"question_date"]];
                    }
                    
                    if ([objDic objectForKey:@"user_id"] != nil) {
                        chatData.msg_user_id = [objDic objectForKey:@"user_id"];
                    }
                    
                    if ([objDic objectForKey:@"question_active"] != nil) {
                        chatData.msg_active = [[objDic objectForKey:@"question_active"] intValue];
                    }
                    chatData.type = SOMessageTypeText;
                    
                  if ([objDic objectForKey:@"question_type"] != nil) {
                        
                        int nType = [[objDic objectForKey:@"question_type"] intValue];
                        if (nType == 3) {//link
                            chatData.fromMe = NO;
                            chatData.msg_type = nType;
                            
                            chatData.type = SOMessageTypePhoto;
                            chatData.msg_link = [objDic objectForKey:@"answer_link"];
                            chatData.msg_link_id = [objDic objectForKey:@"link_id"];
                            chatData.msg_link_type = [[objDic objectForKey:@"link_type"] intValue];
                            if (chatData.msg_link_type == 0) {
                                
                                chatData.thumbnail = [UIImage imageNamed:@"WEBLINK"];
                            }else if (chatData.msg_link_type == 1){
                                chatData.thumbnail = [UIImage imageNamed:@"PRICELINEicon"];
                            }else {
                                chatData.thumbnail = [UIImage imageNamed:@"AmazonIcon"];
                            }
                        }
                        else if (nType == 1) {//question
                            chatData.fromMe = YES;
                            
                            chatData.msg_type = nType;
                        }else{//answer
                            chatData.fromMe = NO;
                            
                            chatData.msg_type = nType;
                        }
                    }else{
                        chatData.fromMe = NO;
                        
                        chatData.msg_type = 1;
                    }
                    
                    
                    [self.dataSource addObject:chatData];
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self refreshMessages:true];
                });
            }else{
                //                [SVProgressHUD showErrorWithStatus:WEB_FAILED];
                
                nCheckRatingFlag = true;
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",operation.responseString);
        [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        
    }];
}
- (void)loadMessages1
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_QUESTION_GET]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    long currentTime = (long)CFAbsoluteTimeGetCurrent();
    
    NSDictionary *paramterDic = @{@"user_id":theAppDelegate.gUserData.user_id,
                                  @"time":[NSString stringWithFormat:@"%ld",currentTime]};
    
    [manager GET:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ( [responseObject count] > 0 ) {
            
            [self.dataSource removeAllObjects];
            
            NSDictionary *responseDic = [responseObject objectAtIndex:0];
            if ([[responseDic objectForKey:@"status"] intValue] == 200) {
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                
                formatter.dateFormat = kBaseDateFormat;
                
                for (int i=0; i<[responseObject count]; i++) {
                    
                    NSDictionary *objDic = [responseObject objectAtIndex:i];
                    
                    Message *chatData = [[Message alloc]init];
                    
                    if ([objDic objectForKey:@"rating_flag"] != nil) {
                        
                        int nFlag = [[objDic objectForKey:@"rating_flag"] intValue];
                        
                        if (nFlag == 200) {
                            nCheckRatingFlag = true;
                        }else{
                            nCheckRatingFlag = false;
                        }
                    }
                    
                    if ([objDic objectForKey:@"question_id"] != nil) {
                        chatData.msg_id = [[objDic objectForKey:@"question_id"] intValue];
                    }
                    
                    if ([objDic objectForKey:@"question_text"] != nil) {
                        chatData.text = [objDic objectForKey:@"question_text"];
                    }
                    
                    if ([objDic objectForKey:@"date_time"] != nil) {
                        chatData.date = [formatter dateFromString:[objDic objectForKey:@"date_time"]];
                    }
                    
                    if ([objDic objectForKey:@"user_id"] != nil) {
                        chatData.msg_user_id = [objDic objectForKey:@"user_id"];
                    }
                    
                    if ([objDic objectForKey:@"question_active"] != nil) {
                        chatData.msg_active = [[objDic objectForKey:@"question_active"] intValue];
                    }
                    chatData.type = SOMessageTypeText;
                    
                    if ([objDic objectForKey:@"question_type"] != nil) {
                        
                        int nType = [[objDic objectForKey:@"question_type"] intValue];
                        if (nType == 3) {//link
                            chatData.fromMe = NO;
                            chatData.msg_type = nType;
                            
                            chatData.type = SOMessageTypePhoto;
                            
                            chatData.msg_link_type = [[objDic objectForKey:@"link_type"] intValue];
                            
                            chatData.msg_link = [objDic objectForKey:@"answer_link"];
                            
                            if (chatData.msg_link_type == 0) {
                                
                                chatData.thumbnail = [UIImage imageNamed:@"WEBLINK"];
                            }else if (chatData.msg_link_type == 1){
                                chatData.thumbnail = [UIImage imageNamed:@"PRICELINEicon"];
                            }else {
                                chatData.thumbnail = [UIImage imageNamed:@"AmazonIcon"];
                            }

                        }
                        else if (nType == 1) {//question
                            chatData.fromMe = YES;
                            
                            chatData.msg_type = nType;
                        }else{//answer
                            
                            chatData.fromMe = NO;
                            
                            chatData.msg_type = nType;
                        }
                    }else{
                        chatData.fromMe = NO;
                        
                        chatData.msg_type = 1;
                    }
                    
                    
                    [self.dataSource addObject:chatData];
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self refreshMessages:false];
                    [self playSound];
                });
            }else{
                //                [SVProgressHUD showErrorWithStatus:WEB_FAILED];
                nCheckRatingFlag = true;
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",operation.responseString);
        
        
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
    
    if (message.msg_type != 3) {
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
        
        cell.btnPlay.tag = index;
        [cell.btnPlay addTarget:self action:@selector(onMessagePlay:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        cell.btnMediaImage.tag = index;
        [cell.btnMediaImage addTarget:self action:@selector(onMediaImageTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

-(IBAction)onMediaImageTap:(id)sender{
    UIButton *btn = (UIButton*)sender;
    Message *message = self.dataSource[btn.tag];
//    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:message.msg_link]];
    
    LinkVC *nLinkVC = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"LinkVC"];
    nLinkVC.strWeblink = [NSString stringWithFormat:@"%@link=%@",weblink_url,message.msg_link];//;
    [self.navigationController pushViewController:nLinkVC animated:YES];
    
    
//    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_LINK_CHECKED]];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    long currentTime = (long)CFAbsoluteTimeGetCurrent();
//    
//    NSDictionary *paramterDic = @{@"link_id":message.msg_link_id,
//                                  @"time":[NSString stringWithFormat:@"%ld",currentTime]};
//    
//    [manager GET:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        NSLog(@"%@",operation.responseString);
//        
//    }];
}

-(IBAction)onMessagePlay:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    
    if ((int)btn.tag == _nSelectPlayIndex) {
        
        if (_nSelectPlayFlag == play_start) {
            [theAppDelegate.synth stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
            _nSelectPlayFlag = play_end;
            
        }else{
            Message *message = self.dataSource[btn.tag];
            
            if (theAppDelegate.gUserData.user_voice_flag == 1) {
                
                _nSelectPlayIndex = (int)btn.tag;
                _nSelectPlayFlag = play_start;
                
                AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:[NSString stringWithFormat:@"%@",message.text]];
                
                utterance.rate = [[NSUserDefaults standardUserDefaults] floatForKey:@"voice_rate"];
                
                NSString*lang = @"en-US";
                utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:lang];
                
                [theAppDelegate.synth speakUtterance:utterance];
                
            }
        }
    }else{
        
        [theAppDelegate.synth stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        
        Message *message = self.dataSource[btn.tag];
        
        if (theAppDelegate.gUserData.user_voice_flag == 1) {
            
            _nSelectPlayFlag = play_start;
            
            _nSelectPlayIndex = (int)btn.tag;
            
            AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:[NSString stringWithFormat:@"%@",message.text]];
            
            utterance.rate = [[NSUserDefaults standardUserDefaults] floatForKey:@"voice_rate"];
            
            NSString*lang = @"en-US";
            utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:lang];
            
            [theAppDelegate.synth speakUtterance:utterance];
            
        }
    }
    
}

-(void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
    
    _nSelectPlayFlag = play_end;
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
    
    if ([[message lowercaseString]rangeOfString:@"where"].location != NSNotFound && (theAppDelegate.uLat == 0 && theAppDelegate.uLong == 0)) {
        
        [SVProgressHUD showInfoWithStatus:@"Application would like to use your current location to help question"];
        
        [theAppDelegate getLocation];
        
        return;
    }
    
    Message *msg = [[Message alloc] init];
    msg.text = message;
    msg.fromMe = YES;
    
    [inputView.textView resignFirstResponder];
    
    _mMessageData = msg;
    
    if (self.dataSource.count > 1) {
        
        [self onSetQuestionAndAnswer];
    }
    
    if (nCheckRatingFlag) {
        
        [self sendMessage:msg];
        [self onRating:msg];
        
    }else{
        
        [lblTopAnswer setText:_mSelectedRatingAnswerMessage.text];
        
        [UIView animateWithDuration:0.4
                              delay:0
                            options:(UIViewAnimationOptionAllowUserInteraction|
                                     UIViewAnimationOptionBeginFromCurrentState)
                         animations:^(void) {
                             rating_y.constant = rating_show;
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             
                             self.tableView.userInteractionEnabled = NO;
                             ratingView.userInteractionEnabled = YES;
                         }];
        
    }
    
    
}

-(void)onRating:(Message*)msg{
    
    [self onRequestSend:msg];
    
    btnStar1.tag = 0;
    btnStar2.tag = 0;
    btnStar3.tag = 0;
    btnStar4.tag = 0;
    btnStar5.tag = 0;
    
    [self onUpdateStarUI];
}

-(void)onRequestSend:(Message*)msg{
    
    //    [SVProgressHUD showWithStatus:@"Sending..."];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_QUESTION_POST]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    long currentTime = (long)CFAbsoluteTimeGetCurrent();
    
    
    NSDictionary *paramterDic = @{@"user_id":theAppDelegate.gUserData.user_id,
                                  @"question":msg.text,
                                  @"question_lat":[NSString stringWithFormat:@"%f",theAppDelegate.uLat],
                                  @"question_long":[NSString stringWithFormat:@"%f",theAppDelegate.uLong],
                                  @"time":[NSString stringWithFormat:@"%ld",currentTime]};
    
    manager.requestSerializer = [AFHTTPRequestSerializer new];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    [manager POST:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD dismiss];
        
        _mMessageData = nil;
        
        if ( [responseObject count] > 0 ) {
            
            
            
            NSDictionary *responseDic = [responseObject objectAtIndex:0];
            
            if ([responseDic objectForKey:@"filter_violation"] != nil) {
                
            }
            
            //            [self sendMessage:msg];
            
        }else{
            [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",operation.responseString);
        [SVProgressHUD showErrorWithStatus:WEB_FAILED];
    }];
}

- (void)messageInputViewDidSelectMediaButton:(SOMessageInputView *)inputView
{
    // Take a photo/video or choose from gallery
}

-(IBAction)onCommunity:(id)sender{
    
    tapMenuHide.enabled = NO;
    [UIView animateWithDuration:0.5f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         menuStartX.constant = 0;
                         btnMenu.frame = CGRectMake(btnMenu.frame.origin.x, btnMenu.frame.origin.y, 22, btnMenu.frame.size.height);
                     }
                     completion:NULL
     ];
    
    CommunityVC *mCommunityVC = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"CommunityVC"];
    [self.navigationController pushViewController:mCommunityVC animated:YES];
    //    [self postWithText:5];
}
#pragma mark - logout
-(void)onLogout{
    
    UIAlertController *_alertView = [UIAlertController alertControllerWithTitle:nil message:@"You want to logout?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* logout_cancel = [UIAlertAction
                                    actionWithTitle:@"Cancel"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Do some thing here
                                        [_alertView dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
    
    [_alertView addAction:logout_cancel];
    
    UIAlertAction* logout_yes = [UIAlertAction
                                 actionWithTitle:@"Yes"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     //Do some thing here
                                     [STANDARD_DEFAULT_STRING setInteger:0 forKey:@"stock_login"];
                                     [STANDARD_DEFAULT_STRING synchronize];
                                     
                                     [theAppDelegate switchRootViewController:login_check_false];
                                     
                                 }];
    
    [_alertView addAction:logout_yes];
    
    
    [self presentViewController:_alertView animated:YES completion:nil];
    
}


#pragma mark - delegate to uialertview
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        [STANDARD_DEFAULT_STRING setInteger:0 forKey:@"stock_login"];
        [STANDARD_DEFAULT_STRING synchronize];
        
        [theAppDelegate switchRootViewController:login_check_false];
        
    }
}

-(void)activeApp{
    [self loadMessages];
}
- (void)pushReceived:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    Message *chatData = [[Message alloc]init];
    
    if ([userInfo objectForKey:@"question_id"] != nil) {
        chatData.msg_id = [[userInfo objectForKey:@"question_id"] intValue];
    }
    
    if ([userInfo objectForKey:@"answer_text"] != nil) {
        chatData.text = [userInfo objectForKey:@"answer_text"];
    }
    
    chatData.date = [NSDate date];
    
    chatData.type = SOMessageTypeText;
    chatData.fromMe = NO;
    
    int nFlag = 0;
    for (int i=0; i<[self.dataSource count]; i++) {
        Message *mData = [self.dataSource objectAtIndex:i];
        if (mData.msg_id == chatData.msg_id) {
            nFlag = 1;
            break;
        }
    }
    if (nFlag == 0) {
        
        [self.dataSource addObject:chatData];
        
        [self refreshMessages:true];
    }
    
    //    [self loadMessages];
}
-(IBAction)onStar:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    
    if (btn == btnStar1) {
        
        btnStar1.tag = 1;
        btnStar2.tag = 0;
        btnStar3.tag = 0;
        btnStar4.tag = 0;
        btnStar5.tag = 0;
        
    }else if (btn == btnStar2){
        
        btnStar1.tag = 1;
        btnStar2.tag = 1;
        btnStar3.tag = 0;
        btnStar4.tag = 0;
        btnStar5.tag = 0;
        
    }else if (btn == btnStar3){
        
        btnStar1.tag = 1;
        btnStar2.tag = 1;
        btnStar3.tag = 1;
        btnStar4.tag = 0;
        btnStar5.tag = 0;
        
    }else if (btn == btnStar4){
        
        btnStar1.tag = 1;
        btnStar2.tag = 1;
        btnStar3.tag = 1;
        btnStar4.tag = 1;
        btnStar5.tag = 0;
        
    }else if (btn == btnStar5){
        
        btnStar1.tag = 1;
        btnStar2.tag = 1;
        btnStar3.tag = 1;
        btnStar4.tag = 1;
        btnStar5.tag = 1;
        
    }
    
    [self onUpdateStarUI];
}

-(void)onUpdateStarUI{
    
    if (btnStar1.tag == 0) {
        [btnStar1 setImage:[UIImage imageNamed:@"unstar"] forState:UIControlStateNormal];
    }else{
        [btnStar1 setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    }
    
    if (btnStar2.tag == 0) {
        [btnStar2 setImage:[UIImage imageNamed:@"unstar"] forState:UIControlStateNormal];
    }else{
        [btnStar2 setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    }
    
    if (btnStar3.tag == 0) {
        [btnStar3 setImage:[UIImage imageNamed:@"unstar"] forState:UIControlStateNormal];
    }else{
        [btnStar3 setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    }
    
    if (btnStar4.tag == 0) {
        [btnStar4 setImage:[UIImage imageNamed:@"unstar"] forState:UIControlStateNormal];
    }else{
        [btnStar4 setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    }
    
    if (btnStar5.tag == 0) {
        [btnStar5 setImage:[UIImage imageNamed:@"unstar"] forState:UIControlStateNormal];
    }else{
        [btnStar5 setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    }
    
}
-(int)getRating{
    
    int nRating = 0;
    
    if (btnStar1.tag == 1) {
        nRating++;
    }
    
    if (btnStar2.tag == 1) {
        nRating++;
    }
    
    if (btnStar3.tag == 1) {
        nRating++;
    }
    
    if (btnStar4.tag == 1) {
        nRating++;
    }
    
    if (btnStar5.tag == 1) {
        nRating++;
    }
    
    return nRating;
}
-(IBAction)onSubmit:(id)sender{
    
    //    [SVProgressHUD showWithStatus:@"Waiting..."];
    
    if (self.dataSource.count > 1) {
        
        [self onSetQuestionAndAnswer];
    }
    if (nCheckRatingFlag) {
        
        [SVProgressHUD showErrorWithStatus:@"There is no question/answer to rate"];
        
    }else{
        int nRating = [self getRating];
        if (_mMessageData != nil) {
            [SVProgressHUD dismiss];
            
            [self sendMessage:_mMessageData];
            
            [UIView animateWithDuration:0.4
                                  delay:0
                                options:(UIViewAnimationOptionAllowUserInteraction|
                                         UIViewAnimationOptionBeginFromCurrentState)
                             animations:^(void) {
                                 rating_y.constant = rating_hide;
                                 [self.view layoutIfNeeded];
                             }
                             completion:^(BOOL finished) {
                                 self.tableView.userInteractionEnabled = YES;
                             }];
        }else if(nRating != 0){
            [SVProgressHUD showWithStatus:REQUEST_WAITING];
        }
        
        if (nRating == 0) {
            [SVProgressHUD showErrorWithStatus:@"You can give star 1~5"];
        }else{
            //            [SVProgressHUD showWithStatus:REQUEST_WAITING];
            
            NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_RATING_POST]];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            if (theAppDelegate.uDeviceToken == nil) {
                theAppDelegate.uDeviceToken = @"d6cdb99035f272c8a7bb774a2cdc8319e73a4c54caacf50bb0c0b84161f3c48c";
            }
            
            NSDictionary *paramterDic = @{@"question_id":[NSNumber numberWithInt:_mSelectedRatingQuestionMessage.msg_id],
                                          @"answer_id":[NSNumber numberWithInt:_mSelectedRatingAnswerMessage.msg_id],
                                          @"user_id":_mSelectedRatingAnswerMessage.msg_user_id,
                                          @"rating":[NSNumber numberWithInt:[self getRating]],
                                          @"user_own_id":theAppDelegate.gUserData.user_id};
            
            [manager POST:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                if ( [responseObject count] > 0 ) {
                    
                    NSDictionary *responseDic = [responseObject objectAtIndex:0];
                    if ([[responseDic objectForKey:@"status"] intValue] == 200) {
                        
                        nCheckRatingFlag = true;
                        
                        if ([responseDic objectForKey:@"answer_id"] != nil) {
                            theAppDelegate.gUserData.user_last_rating_qID = [[responseDic objectForKey:@"answer_id"] intValue];
                        }
                        
                        [[Utility getInstance]saveUserData:theAppDelegate.gUserData];
                        
                        if (_mMessageData != nil) {
                            [SVProgressHUD dismiss];
                            
                            [self onRating:_mMessageData];
                        }else{
                            [SVProgressHUD dismiss];
                        }
                        
                        [UIView animateWithDuration:0.4
                                              delay:0
                                            options:(UIViewAnimationOptionAllowUserInteraction|
                                                     UIViewAnimationOptionBeginFromCurrentState)
                                         animations:^(void) {
                                             rating_y.constant = rating_hide;
                                             [self.view layoutIfNeeded];
                                         }
                                         completion:^(BOOL finished) {
                                             self.tableView.userInteractionEnabled = YES;
                                         }];
                        
                    }else{
                        [SVProgressHUD showErrorWithStatus:WEB_FAILED];
                    }
                    
                    if (swtShare.isOn && shareView.hidden == NO) {
                        
                        //                        NSString *strShareText = [NSString stringWithFormat:@"%@ - This answer was rated %d Stars with HummingBird(www.hummb.com)\n%@\n\nAnswer: %@" , theAppDelegate.gUserData.user_name , nRating , _mSelectedRatingQuestionMessage.text , _mSelectedRatingAnswerMessage.text];
                        
                        [self postWithText:nRating];
                    }
                }else{
                    [SVProgressHUD showErrorWithStatus:WEB_FAILED];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"%@",operation.responseString);
                [SVProgressHUD showErrorWithStatus:WEB_FAILED];
                
                
            }];
        }
        
        
    }
    
}

-(IBAction)onSetting:(id)sender{
    

//    SettingVC *mSettingVC = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"SettingVC"];
//    //    [self.navigationController pushViewController:mSettingVC animated:NO];
//    CATransition *transition = [CATransition animation];
//    transition.duration = .2;
//    transition.type = kCATransitionMoveIn;
//    transition.subtype= kCATransitionFromLeft;
//    
//    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
//    
//    [self.navigationController pushViewController:mSettingVC animated:NO];
    
    
}

-(UIImage*) drawText:(NSString*) text
             inImage:(UIImage*)  image
             imgRect:(CGRect)    imgRect
             txtRect:(CGRect)    txtRect
                view: (UIView*)  view
{
    
    UIFont *font = [UIFont boldSystemFontOfSize:12];
    UIGraphicsBeginImageContext(view.frame.size);
    [image drawInRect:imgRect];
    [[UIColor blackColor] set];
    NSDictionary *attributes = @{ NSFontAttributeName: font};
    [text drawInRect:txtRect withAttributes:attributes];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
-(void)postWithText:(int)nRating{
    //
    //    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]initWithGraphPath:@"/me/feed" parameters:@{@"message":message} tokenString:theAppDelegate.gUserData.user_fb_token version:nil HTTPMethod:@"POST"];
    //
    //
    //    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
    //
    //        NSLog(@"123");
    //    }];
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        NSString *title = [NSString stringWithFormat:@"This answer was rated %d Stars with HummingBird(www.hummb.com)\n\nQuestion: %@\n\nAnswer: %@" ,  nRating , _mSelectedRatingQuestionMessage.text , _mSelectedRatingAnswerMessage.text];
        //        NSString *title = [NSString stringWithFormat:@"John - This answer was rated 4 Stars with HummingBird(www.hummb.com)\n\nQuestion\n\nAnswer: Answer Test"];
        
        UIImage *imgIcon = [UIImage imageNamed:@"logo.jpg"];
        CGRect imgRect = CGRectMake(0, 0, 93, 93);
        //        CGRect txtRect = CGRectMake(100, 10, 500, 85);
        //for (NSNumber *n in @[@(12.0f), @(14.0f), @(18.0f)]) {
        NSNumber *n = @16.0;
        CGFloat fontSize = [n floatValue];
        CGRect r = [title boundingRectWithSize:CGSizeMake(500, 0)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}
                                       context:nil];
        NSLog(@"fontSize = %f\tbounds = (%f x %f)",
              fontSize,
              r.size.width,
              r.size.height);
        CGRect txtRect = CGRectMake(100, 10, 500, r.size.height);
        
        CGRect viewRect = CGRectMake(0,0,600, r.size.height + 5);
        UIView *myView = [[UIView alloc] initWithFrame:viewRect];
        
        UIImage* imgResult = [self drawText:title inImage:imgIcon imgRect:imgRect txtRect:txtRect view:myView];
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [controller addImage:imgResult];
        [self presentViewController:controller animated:YES completion:Nil];
    }
    
    //    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
    //    dialog.fromViewController = self;
    //    dialog.content = content;
    //    dialog.mode = FBSDKShareDialogModeShareSheet;
    //    [dialog show];
    
}

-(void)testRequest{
    //AIzaSyA3eHOy8wVh-mYGwgpVezPBedltc1zGgo4
    NSString *urlString = [NSString stringWithFormat:@"https://www.googleapis.com/customsearch/v1?q=Christmas&key=AIzaSyA3eHOy8wVh-mYGwgpVezPBedltc1zGgo4"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:urlString parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ( [responseObject count] > 0 ) {
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",operation.responseString);
    }];
}

-(IBAction)onInfo:(id)sender{
    
    //    NSString *strMessage = @"Hummingbird is a search application that gives you simple, precise answers to the questions that you might have.\n\n-Where can I get the best fish in town? (requires location)\n-What is the best recipe for chocolate cake?\n-What is the cheapest fare to JFK from NYC?\n-What is El Nino?\n\nIt also lets you answer other users questions in the community section where you can earn credit, get your own answer rated!\n\nAsk us anything!";
    
    NSString *strMessage = @"Hummingbird is a question/answering application that gives you simple, precise answers for the questions you have.\n\n-Where can I get the best fish in town? (requires location)\n-What is the best recipe for chocolate cake?\n-What is the cheapest fare to JFK from NYC?\n-What is El Nino?\n\nHummingbird also lets you answer other user's questions in the 'community' section where you can earn credit, and get your answers rated!\n\nAsk us anything!";
    
    [lblInfo setText:strMessage];
    
    [lblInfo sizeToFit];
    //
    //    UIAlertController *_alertView = [UIAlertController alertControllerWithTitle:strMessage message:nil preferredStyle:UIAlertControllerStyleAlert];
    //
    //    UIAlertAction *okAction = [UIAlertAction
    //                                   actionWithTitle:@"Ok"
    //                                   style:UIAlertActionStyleDefault
    //                                   handler:^(UIAlertAction * action)
    //                                   {
    //                                       //Do some thing here
    //                                       [_alertView dismissViewControllerAnimated:YES completion:nil];
    //
    //                                   }];
    //    [_alertView addAction:okAction];
    //
    //    [self presentViewController:_alertView animated:YES completion:nil];
    
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
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [alertView close];
        
    }
}

- (IBAction)recognize:(id)sender {
    ISSpeechRecognition *recognition = [[ISSpeechRecognition alloc] init];
    [recognition setDelegate:self];
    
    NSError *error;
    
    if(![recognition listenAndRecognizeWithTimeout:10 error:&error]) {
        //        [self doSomethingWith:error];
    }
}
- (void)recognition:(ISSpeechRecognition *)speechRecognition didGetRecognitionResult:(ISSpeechRecognitionResult *)result {
    NSLog(@"Method: %@", NSStringFromSelector(_cmd));
    NSLog(@"Result: %@", result.text);
    
    [self.messageInputView.textView setText:result.text];
     [self.messageInputView adjustTextViewSize];
}

- (void)recognition:(ISSpeechRecognition *)speechRecognition didFailWithError:(NSError *)error {
    NSLog(@"Method: %@", NSStringFromSelector(_cmd));
    NSLog(@"Error: %@", error);
}

- (void)recognitionCancelledByUser:(ISSpeechRecognition *)speechRecognition {
    NSLog(@"Method: %@", NSStringFromSelector(_cmd));
}

- (void)recognitionDidBeginRecording:(ISSpeechRecognition *)speechRecognition {
    NSLog(@"Method: %@", NSStringFromSelector(_cmd));
}

- (void)recognitionDidFinishRecording:(ISSpeechRecognition *)speechRecognition {
    NSLog(@"Method: %@", NSStringFromSelector(_cmd));
}

-(void)speakFromText:(NSString*)strMessage{
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:strMessage];
    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc]init];
    [synth speakUtterance:utterance];
    
}

-(IBAction)onChangeFBShare:(id)sender{
    if (swtShare.isOn) {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"FBShareFlag"];
    }else{
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"FBShareFlag"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)onSetQuestionAndAnswer{
    
    if ([self.dataSource count] > 0) {
        
        for (int i=(int)self.dataSource.count-1; i>=0; i--) {
            
            Message *chatData = [self.dataSource objectAtIndex:i];
            if (chatData.msg_type == 1) {//question
                
                _mSelectedRatingQuestionMessage = [self.dataSource objectAtIndex:i];
                break;
                
            }
            
        }
        
        for (int i=(int)self.dataSource.count-1; i>=0; i--) {
            
            Message *chatData = [self.dataSource objectAtIndex:i];
            if (chatData.msg_type == 2) {//question
                
                _mSelectedRatingAnswerMessage = [self.dataSource objectAtIndex:i];
                break;
                
            }
            
        }
        
    }
    
    
}

-(IBAction)onMenu:(id)sender{
    if (menuStartX.constant != -menu_show_x) {
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:menuView.bounds];
        menuView.layer.masksToBounds = NO;
        menuView.layer.shadowColor = [UIColor blackColor].CGColor;
        menuView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
        menuView.layer.shadowOpacity = 0.5f;
        menuView.layer.shadowPath = shadowPath.CGPath;
        [UIView animateWithDuration:0.5f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             menuStartX.constant = -menu_show_x;
                             
                             btnMenu.frame = CGRectMake(btnMenu.frame.origin.x, btnMenu.frame.origin.y, menu_show_x-22, btnMenu.frame.size.height);
                         }
                         completion:NULL
         ];
        tapMenuHide.enabled = YES;
    }else{
        tapMenuHide.enabled = NO;
        [UIView animateWithDuration:0.5f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             menuStartX.constant = 0;
                             btnMenu.frame = CGRectMake(btnMenu.frame.origin.x, btnMenu.frame.origin.y, 22, btnMenu.frame.size.height);
                         }
                         completion:NULL
         ];
    }

}

-(IBAction)onTopQuestion:(id)sender{
    
    [UIView animateWithDuration:0.5f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         menuStartX.constant = 0;
                         btnMenu.frame = CGRectMake(btnMenu.frame.origin.x, btnMenu.frame.origin.y, 22, btnMenu.frame.size.height);
                     }
                     completion:NULL
     ];
    
    TopVC *mTopVC = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"TopVC"];
    
    [self.navigationController pushViewController:mTopVC animated:YES];
}

-(IBAction)onNotificationCapture:(id)sender{
    
    tapMenuHide.enabled = NO;
    [UIView animateWithDuration:0.5f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         menuStartX.constant = 0;
                         btnMenu.frame = CGRectMake(btnMenu.frame.origin.x, btnMenu.frame.origin.y, 22, btnMenu.frame.size.height);
                     }
                     completion:NULL
     ];
    
    NotificationCaptureVC *mNotificationVC = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"NotificationCaptureVC"];
    [self.navigationController pushViewController:mNotificationVC animated:YES];
}

-(IBAction)onTapHideMenu:(id)sender{
    tapMenuHide.enabled = NO;
    [UIView animateWithDuration:0.5f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         menuStartX.constant = 0;
                         btnMenu.frame = CGRectMake(btnMenu.frame.origin.x, btnMenu.frame.origin.y, 22, btnMenu.frame.size.height);
                     }
                     completion:NULL
     ];
}

-(IBAction)onHistory:(id)sender{
    
    tapMenuHide.enabled = NO;
    [UIView animateWithDuration:0.5f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         menuStartX.constant = 0;
                         btnMenu.frame = CGRectMake(btnMenu.frame.origin.x, btnMenu.frame.origin.y, 22, btnMenu.frame.size.height);
                     }
                     completion:NULL
     ];
    
    HistoryVC *mHistoryVC = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"HistoryVC"];
    [self.navigationController pushViewController:mHistoryVC animated:YES];
}

-(IBAction)onAbout:(id)sender{

    AboutVC *mAboutVC = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"AboutVC"];
    [self.navigationController pushViewController:mAboutVC animated:YES];
}
- (IBAction)OnSettings:(id)sender {
    SettingVC *mSettingVC = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"SettingVC"];
    CATransition *transition = [CATransition animation];
    transition.duration = .2;
    transition.type = kCATransitionMoveIn;
    transition.subtype= kCATransitionFromLeft;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController pushViewController:mSettingVC animated:NO];
    [self onMenu:nil];
}
- (IBAction)OnHome:(id)sender {
    
    //this is for setting change it to home
    SettingVC *mSettingVC = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"SettingVC"];
    CATransition *transition = [CATransition animation];
    transition.duration = .2;
    transition.type = kCATransitionMoveIn;
    transition.subtype= kCATransitionFromLeft;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController pushViewController:mSettingVC animated:NO];
}
- (IBAction)OnSearch:(id)sender {
    SearchFriendVC *friends = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"SearchFriendVC"];
    
    [self.navigationController pushViewController:friends animated:YES];
}

@end

