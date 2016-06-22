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

static NSString *kBaseDateFormat = @"yyyy-MM-dd HH:mm:ss";
#import "OneOnOneChatVC.h"
#import "SSMessageControl.h"
@interface OneOnOneChatVC ()<SSMessageDelegate>

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) UIImage *myImage;
@property (strong, nonatomic) UIImage *partnerImage;

@end

@implementation OneOnOneChatVC

-(void)shouldReloadTable:(NSMutableArray *)data
{
    
}

-(void)shouldReloadTable1:(NSMutableArray *)data
{
    
    
    NSLog(@"%@",data);
    [self removeAllobjs];
    [self.dataSource removeAllObjects];
    for (int i=0;i<[data count];i++) {
        NSMutableDictionary *dict=[data objectAtIndex:i];
        
        Message *msg = [[Message alloc] init];
        msg.text = [dict valueForKey:@"messageText"];
        if ([[dict valueForKey:@"outgoing"] integerValue]==0)
        {
            msg.fromMe = NO;
            [self receiveMessage:msg];
        }
        else
        {
            msg.fromMe = YES;
            [self sendMessage:msg];
        }
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    rating_y.constant = rating_hide;
    
    btnSubmit.clipsToBounds = YES;
    btnSubmit.layer.cornerRadius = 5;
    
    self.dataSource = [NSMutableArray array];
    
    self.messageInputView.textView.placeholderText = NSLocalizedString(@"What is your question...", nil);
    
    if (theAppDelegate.gUserData.user_voice_flag == 1) {
        
        [self.imgBrand setImage:[UIImage imageNamed:@"bird_green"]];
        
    }else{
        
        [self.imgBrand setImage:[UIImage imageNamed:@"splash_icon"]];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
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
    [SSMessageControl shareInstance].otherjid=@"user2@server.hummb.com";
    [[SSMessageControl shareInstance] setDelegate:self];
    [[SSMessageControl shareInstance] setSSMessageDelegate];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationDidReceiveRemoteMessageNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kNotificationDidActiveAppNotification
                                                  object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    }else{
        cell.btnMediaImage.tag = index;
    }
    
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
    
    
    [[SSMessageControl shareInstance] sendMessage:msg.text to:@"user2"];
    _mMessageData = msg;
//        [self sendMessage:msg];
    
}

-(void)activeApp{
//    [self loadMessages1];
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
    
}

@end

