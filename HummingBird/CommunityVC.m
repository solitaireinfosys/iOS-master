//
//  CommunityVC.m
//  HummingBird
//
//  Created by Star on 12/5/15.
//  Copyright © 2015 Star. All rights reserved.
//

#import "CommunityVC.h"
#import "questionCell.h"
#import "loadmoreCell.h"
#import "questionModel.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "Common.h"
#import "AppDelegate.h"
#import "userModel.h"
#import "ConversationVC.h"
#import "AnswerVC.h"
#import "HistoryVC.h"
#import "Utility.h"
#import "BBBadgeBarButtonItem.h"

#import "MenuVC.h"

#import "HistoryVC.h"
#import "TopVC.h"

#import "NotificationCaptureVC.h"

#ifdef humming_dist
#import "Analytics.h"
#endif

#define cell_default_height 54
#define cell_ad_height 50

#define menu_show_x 215

@interface CommunityVC ()

@end

@implementation CommunityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
//    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
//    
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//                            @"appview", kGAIHitType, @"Community Page", kGAIScreenName, nil];
//    [tracker send:params];
    
    tapMenuHide.enabled = NO;
    
    tempRect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-70, 0);
    
    nCurrentPageNumber = 1;
    nLoadmoreFlag = 0;
    
    ad_space_limit = -1;
    
    _mQuestionData = [[NSMutableArray alloc]init];
    
    
    menuStartX.constant = [UIScreen mainScreen].bounds.size.width;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    
}
-(IBAction)onBack:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
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
                         }
                         completion:NULL
         ];
        tapMenuHide.enabled = YES;
    }else{
        tapMenuHide.enabled = NO;
        [UIView animateWithDuration:0.5f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             menuStartX.constant = 0;
                         }
                         completion:NULL
         ];
    }
    
    
}

-(void)activeApp{
 
    [self getUserRating];
    [self loadMessages1];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationDidActiveAppNotification object:nil];
    
    if (self.refreshTimer) {
        
        [self.refreshTimer invalidate];
        self.refreshTimer = nil;
        
    }
    
    if (self.refreshTimer_userInfo) {
        [self.refreshTimer_userInfo invalidate];
        
        self.refreshTimer_userInfo = nil;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    if (self.refreshTimer) {
        
        [self.refreshTimer invalidate];
        self.refreshTimer = nil;
        
    }
    
    if (self.refreshTimer_userInfo) {
        [self.refreshTimer_userInfo invalidate];
        
        self.refreshTimer_userInfo = nil;
    }
    
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(loadMessages1) userInfo:nil repeats:YES];
    
    self.refreshTimer_userInfo = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(getUserRating) userInfo:nil repeats:YES];
    
#ifdef humming_dist
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
    
    [tracker set:kGAIScreenName value:@"Community Page"];
    [tracker send:[[[GAIDictionaryBuilder createScreenView]
                    set:@"Community Page"
                    forKey:[GAIFields customDimensionForIndex:1]] build]];
#endif
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(activeApp)
                                                 name:kNotificationDidActiveAppNotification
                                               object:nil];
    
    [self loadMessages];
    
    [self getUserRating];
    
    [self setUserInfo];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadMessages
{
    
    [SVProgressHUD showWithStatus:REQUEST_WAITING];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_COMMUNITY_GET]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    long currentTime = (long)CFAbsoluteTimeGetCurrent();
    
    NSDictionary *paramterDic = @{@"user_id":theAppDelegate.gUserData.user_id,
                                  @"time":[NSString stringWithFormat:@"%ld",currentTime]};
    
    [manager GET:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD dismiss];
        
        if ( [responseObject count] > 0 ) {
            [_mQuestionData removeAllObjects];
            NSDictionary *responseDic = [responseObject objectAtIndex:0];
            if ([[responseDic objectForKey:@"status"] intValue] == 200) {
                
//                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                
//                formatter.dateFormat = kBaseDateFormat;
                
                if ([responseDic objectForKey:@"ad_space_value"] != nil) {
                    ad_space_limit = [[responseDic objectForKey:@"ad_space_value"] intValue];
                }

                for (int i=0; i<[responseObject count]; i++) {
                    
                    NSDictionary *objDic = [responseObject objectAtIndex:i];
                    
                    questionModel *chatData = [[questionModel alloc]init];
                    
                    if ([objDic objectForKey:@"question_text"] != nil) {
                        chatData.question_text = [objDic objectForKey:@"question_text"];
                    }
                    
                    if ([objDic objectForKey:@"question_date"] != nil) {
                        chatData.question_date = [objDic objectForKey:@"question_date"];
                    }
                    
                    if ([objDic objectForKey:@"question_id"] != nil) {
                        chatData.question_id = [[objDic objectForKey:@"question_id"] intValue];
                    }
                    
                    if ([objDic objectForKey:@"user_id"] != nil) {
                        chatData.question_user_id = [objDic objectForKey:@"user_id"];
                    }
                    
                    if ([objDic objectForKey:@"question_lat"] != nil) {
                        chatData.question_lat = [[objDic objectForKey:@"question_lat"] doubleValue];
                    }
                    
                    if ([objDic objectForKey:@"question_long"] != nil) {
                        chatData.question_long = [[objDic objectForKey:@"question_long"] doubleValue];
                    }
                    
                    if ([objDic objectForKey:@"question_permanent"] != nil) {
                        chatData.question_permanent = [[objDic objectForKey:@"question_permanent"] intValue];
                    }
                    [_mQuestionData addObject:chatData];
                    
                }
                
                [tblQuestion reloadData];
                
//                NSIndexPath* ipath = [NSIndexPath indexPathForRow: _mQuestionData.count-1 inSection:0];
//                [tblQuestion scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
                
                
            }else{
//                [SVProgressHUD showErrorWithStatus:WEB_FAILED];
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        
    }];
}

- (void)loadMessages1
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_COMMUNITY_GET]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    long currentTime = (long)CFAbsoluteTimeGetCurrent();
    
    NSDictionary *paramterDic = @{@"user_id":theAppDelegate.gUserData.user_id,
                                  @"time":[NSString stringWithFormat:@"%ld",currentTime]};
    
    [manager GET:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ( [responseObject count] > 0 ) {
            [_mQuestionData removeAllObjects];
            NSDictionary *responseDic = [responseObject objectAtIndex:0];
            if ([[responseDic objectForKey:@"status"] intValue] == 200) {
                
                //                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                
                //                formatter.dateFormat = kBaseDateFormat;
                
                if ([responseDic objectForKey:@"ad_space_value"] != nil) {
                    ad_space_limit = [[responseDic objectForKey:@"ad_space_value"] intValue];
                }
                
                for (int i=0; i<[responseObject count]; i++) {
                    
                    NSDictionary *objDic = [responseObject objectAtIndex:i];
                    
                    questionModel *chatData = [[questionModel alloc]init];
                    
                    if ([objDic objectForKey:@"question_text"] != nil) {
                        chatData.question_text = [objDic objectForKey:@"question_text"];
                    }
                    
                    if ([objDic objectForKey:@"question_date"] != nil) {
                        chatData.question_date = [objDic objectForKey:@"question_date"];
                    }
                    
                    if ([objDic objectForKey:@"question_id"] != nil) {
                        chatData.question_id = [[objDic objectForKey:@"question_id"] intValue];
                    }
                    
                    if ([objDic objectForKey:@"user_id"] != nil) {
                        chatData.question_user_id = [objDic objectForKey:@"user_id"];
                    }
                    
                    if ([objDic objectForKey:@"question_lat"] != nil) {
                        chatData.question_lat = [[objDic objectForKey:@"question_lat"] doubleValue];
                    }
                    
                    if ([objDic objectForKey:@"question_long"] != nil) {
                        chatData.question_long = [[objDic objectForKey:@"question_long"] doubleValue];
                    }
                    
                    if ([objDic objectForKey:@"question_permanent"] != nil) {
                        chatData.question_permanent = [[objDic objectForKey:@"question_permanent"] intValue];
                    }
                    [_mQuestionData addObject:chatData];
                    
                }
                
                [tblQuestion reloadData];
                
                //                NSIndexPath* ipath = [NSIndexPath indexPathForRow: _mQuestionData.count-1 inSection:0];
                //                [tblQuestion scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
                
                
            }else{
                //                [SVProgressHUD showErrorWithStatus:WEB_FAILED];
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark Table View Layout and Sizes

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (ad_space_limit != -1) {
        int nCount = (int)[_mQuestionData count]+nLoadmoreFlag+(int)([_mQuestionData count]/ad_space_limit)+1;
        return nCount;
    }
    return [_mQuestionData count]+nLoadmoreFlag;
}

- (NSDictionary *)postForTableViewIndex:(NSInteger)index
{
    return nil;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (nLoadmoreFlag == 1) {
        if (indexPath.row == [_mQuestionData count]) {
            //            [self getInformation:nCurrentPageNumber+1 loadingFlag:1];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row % ad_space_limit == 0 && ad_space_limit != -1) {
        
        return cell_ad_height;
        
    }else if (indexPath.row != [_mQuestionData count]) {
        if ([_mQuestionData count] >indexPath.row) {
            
            questionModel *qData = [_mQuestionData objectAtIndex:indexPath.row];
            
            lblTemplate.frame = tempRect;
            [lblTemplate setText:qData.question_text];
            [lblTemplate sizeToFit];
            if (lblTemplate.frame.size.height<=cell_default_height) {
                return cell_default_height;
            }else{
                
                return lblTemplate.frame.size.height+cell_default_height;
            }
            
        }
        
        
    }
    return cell_default_height;
    
}

#pragma mark Cells and Headers

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *newCell = nil;
    
    if (nLoadmoreFlag != 0) {
        if (indexPath.row == [_mQuestionData count]) {
            
            NSString  *cellType = @"loadmoreCell";
            
            loadmoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cellType];
            
            if (cell == nil) {
                
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"loadmoreCell" owner:nil options:nil];
                
                for(id currentObject in topLevelObjects)
                {
                    if([currentObject isKindOfClass:[UITableViewCell class]])
                    {
                        cell = (loadmoreCell *) currentObject;
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        break;
                    }
                }
                
            }
            
            [cell.mLoadmore startAnimating];
            
            newCell = cell;
            
            [cell setBackgroundColor:[UIColor clearColor]];
            
        }else{
            NSString  *cellType = @"questionCell";
            
            questionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellType];
            
            if (cell == nil) {
                
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"questionCell" owner:nil options:nil];
                
                for(id currentObject in topLevelObjects)
                {
                    if([currentObject isKindOfClass:[UITableViewCell class]])
                    {
                        cell = (questionCell *) currentObject;
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        break;
                    }
                }
                
            }
            
            if ([_mQuestionData count] >0) {
                
                
                if (indexPath.row % ad_space_limit == 0) {
                    cell.rootControl = self;
                    [cell setShowAd:(indexPath.row / ad_space_limit)%3];
                }else{
                    
                    questionModel *qData = [_mQuestionData objectAtIndex:indexPath.row+indexPath.row/ad_space_limit];
                    
                    cell.mQuestionData = qData;
                    
                    cell.btnUserProfile.tag = indexPath.row;
                    [cell.btnUserProfile addTarget:self action:@selector(onUserPage:) forControlEvents:UIControlEventTouchUpInside];
                
                    
                    [cell setShowUI];
                }
                
                
            }
            
            newCell = cell;
            
            [cell setBackgroundColor:[UIColor clearColor]];
            
        }
    }else{
        NSString  *cellType = @"questionCell";
        
        questionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellType];
        
        if (cell == nil) {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"questionCell" owner:nil options:nil];
            
            for(id currentObject in topLevelObjects)
            {
                if([currentObject isKindOfClass:[UITableViewCell class]])
                {
                    cell = (questionCell *) currentObject;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                }
            }
            
        }
        
        if ([_mQuestionData count] >0) {
            
            
            if (indexPath.row % ad_space_limit == 0) {
                
                cell.rootControl = self;
                
                [cell setShowAd:(indexPath.row / ad_space_limit)%3];
                
            }else{
                
                questionModel *qData = [_mQuestionData objectAtIndex:indexPath.row-indexPath.row/ad_space_limit-1];
                
                cell.mQuestionData = qData;
                
                cell.btnUserProfile.tag = indexPath.row;
                [cell.btnUserProfile addTarget:self action:@selector(onUserPage:) forControlEvents:UIControlEventTouchUpInside];
            
                [cell setShowUI];
            }
            
        }
        
        newCell = cell;
        
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    
    return newCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row % ad_space_limit != 0) {
    
        AnswerVC *mAnswerVC = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"AnswerVC"];
        mAnswerVC.mQuestionData = [_mQuestionData objectAtIndex:indexPath.row-indexPath.row/ad_space_limit-1];
        mAnswerVC.delegate = self;
        mAnswerVC.mQuestionIndex = (int)(indexPath.row-indexPath.row/ad_space_limit-1);
        mAnswerVC.messageWindowType = MESSAGE_ANSWER_CHAT;
        [self.navigationController pushViewController:mAnswerVC animated:YES];
        
    }
    
    
}

-(void)onAnswered:(int)nIndex{
    
    questionModel *qData = [self.mQuestionData objectAtIndex:nIndex];
    if (qData.question_permanent != 1) {
        [self.mQuestionData removeObjectAtIndex:nIndex];
        [tblQuestion reloadData];
    }
    
}
#pragma mark - logout
-(IBAction)onLogout:(id)sender{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"You want to logout?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    [alertView show];
}

#pragma mark - delegate to uialertview
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        [STANDARD_DEFAULT_STRING setInteger:0 forKey:@"stock_login"];
        [STANDARD_DEFAULT_STRING synchronize];
        
        [theAppDelegate switchRootViewController:login_check_false];
        
    }
}
-(IBAction)onUserPage:(id)sender{
    
}

-(IBAction)onHistory:(id)sender{
    
    [UIView animateWithDuration:0.5f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         menuStartX.constant = 0;
                     }
                     completion:NULL
     ];
    
    HistoryVC *mHistoryVC = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"HistoryVC"];
    [self.navigationController pushViewController:mHistoryVC animated:YES];
}

-(void)setUserInfo{
    
    [lblRating setText:[NSString stringWithFormat:@"Rating: %.2f", theAppDelegate.gUserData.user_rating]];
    
    [lblAnswers setText:[NSString stringWithFormat:@"Answers: %d",theAppDelegate.gUserData.user_answer_count]];
    
    [lblCredit setText:[NSString stringWithFormat:@"Credit: $%.2f", theAppDelegate.gUserData.user_credit]];
    
    barMenu.badgeValue = [NSString stringWithFormat:@"%d",0];//theAppDelegate.gUserData.user_history_badge];
    
    
}

-(void)getUserRating{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_USERINFO_GET]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    long currentTime = (long)CFAbsoluteTimeGetCurrent();
    
    NSDictionary *paramterDic = @{@"user_id":theAppDelegate.gUserData.user_id,
                                  @"time":[NSString stringWithFormat:@"%ld",currentTime]};
    
    [manager GET:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ( [responseObject count] > 0 ) {
            
            NSDictionary *responseDic = [responseObject objectAtIndex:0];
            if ([[responseDic objectForKey:@"status"] intValue] == 200) {
                
                if ([responseDic objectForKey:@"user_credit"] != nil && [responseDic objectForKey:@"user_credit"] != [NSNull null]) {
                    theAppDelegate.gUserData.user_credit = [[responseDic objectForKey:@"user_credit"] floatValue];
                }
                
                
                if ([responseDic objectForKey:@"user_history_badge"] != nil && [responseDic objectForKey:@"user_history_badge"] != [NSNull null]) {
                    theAppDelegate.gUserData.user_history_badge = [[responseDic objectForKey:@"user_history_badge"] floatValue];
                }
                
                if ([responseDic objectForKey:@"user_answers"] != nil && [responseDic objectForKey:@"user_answers"] != [NSNull null]) {
                    theAppDelegate.gUserData.user_answer_count = [[responseDic objectForKey:@"user_answers"] intValue];
                }
                
                if ([responseDic objectForKey:@"user_rating"] != nil) {
                    theAppDelegate.gUserData.user_rating = [[responseDic objectForKey:@"user_rating"] floatValue];
                    
                    [[Utility getInstance] saveUserData:theAppDelegate.gUserData];
                    
                    [self setUserInfo];
                }
                
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",operation.responseString);
    }];
}

-(IBAction)onTopQuestion:(id)sender{
    
    [UIView animateWithDuration:0.5f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         menuStartX.constant = 0;
                     }
                     completion:NULL
     ];
    
    TopVC *mTopVC = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"TopVC"];

    [self.navigationController pushViewController:mTopVC animated:YES];
}

-(IBAction)onNotificationCapture:(id)sender{

    [UIView animateWithDuration:0.5f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         menuStartX.constant = 0;
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
                     }
                     completion:NULL
     ];
}
@end
