//
//  TopDetailVC.m
//  HummingBird
//
//  Created by Star on 12/5/15.
//  Copyright © 2015 Star. All rights reserved.
//

#import "TopDetailVC.h"
#import "AppDelegate.h"
#import "Common.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "Message.h"
#import "topModel.h"
#import "userModel.h"
#import "CommunityVC.h"
#import "MapVC.h"

#import "Analytics.h"

static NSString *kBaseDateFormat = @"yyyy-MM-dd HH:mm:ss";

@interface TopDetailVC ()

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) UIImage *myImage;
@property (strong, nonatomic) UIImage *partnerImage;

@end

@implementation TopDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Top Questions & Answers";
    
    self.dataSource = [NSMutableArray array];
    
    Message *chatData1 = [[Message alloc]init];
    chatData1.text = _mTopData.top_question_text;
    chatData1.fromMe = NO;
    [self.dataSource addObject:chatData1];
    
    
    Message *chatData2 = [[Message alloc]init];
    chatData2.text = _mTopData.top_answer_text;
    chatData2.fromMe = YES;
    [self.dataSource addObject:chatData2];
    
    [self refreshMessages];
    
    [self.btnLike addTarget:self action:@selector(onTapLike:) forControlEvents:UIControlEventTouchUpInside];
    

}

-(IBAction)onTapLike:(id)sender{
//    
    [SVProgressHUD showWithStatus:REQUEST_WAITING];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,WEB_ANSWER_LIKE];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if (theAppDelegate.uDeviceToken == nil) {
        theAppDelegate.uDeviceToken = @"d6cdb99035f272c8a7bb774a2cdc8319e73a4c54caacf50bb0c0b84161f3c48c";
    }
    
    NSDictionary *paramterDic = @{@"answer_id":[NSNumber numberWithInt:_mTopData.top_answer_id],
                                  @"user_id":theAppDelegate.gUserData.user_id};
    
    [manager POST:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ( [responseObject count] > 0 ) {
            
            NSDictionary *responseDic = [responseObject objectAtIndex:0];
            if ([[responseDic objectForKey:@"status"] intValue] == 200) {
                
                [SVProgressHUD showSuccessWithStatus:@"Liked"];
                
                
            }else{
                [SVProgressHUD showErrorWithStatus:WEB_FAILED];
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",operation.responseString);
        [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
    [tracker set:kGAIScreenName value:@"Top Question and Answer Detail Page"];
    [tracker send:[[[GAIDictionaryBuilder createScreenView]
                    set:@"Top Question and Answer Detail Page"
                    forKey:[GAIFields customDimensionForIndex:1]] build]];

    

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



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
    
    
    [inputView.textView resignFirstResponder];
    
}



- (void)messageInputViewDidSelectMediaButton:(SOMessageInputView *)inputView
{
    // Take a photo/video or choose from gallery
}

@end
