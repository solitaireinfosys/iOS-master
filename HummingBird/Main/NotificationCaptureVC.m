//
//  NotificationCaptureVC.m
//  HummingBird
//
//  Created by Star on 3/17/16.
//  Copyright (c) 2016 Star. All rights reserved.
//

#import "NotificationCaptureVC.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "Common.h"
#import "AppDelegate.h"
#import "userModel.h"
#import "notificationModel.h"
#import "loadmoreCell.h"
#import "notificationCell.h"
#import "TopDetailVC.h"
#import "topModel.h"
#import "questionModel.h"
#import "AnswerVC.h"

#define cell_default_height 70
#define cell_ad_height 50

@interface NotificationCaptureVC ()

@end

@implementation NotificationCaptureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    nCurrentPageNumber = 1;
    
    ad_space_limit = -1;
    
    nLoadmoreFlag = 0;
    
    _mNotificationData = [[NSMutableArray alloc]init];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    [self getNotifcationCaptureInfo];
    
    self.title = @"Notifications";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.refreshTimer) {
        [self.refreshTimer invalidate];
        
        self.refreshTimer = nil;
    }
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(getNotifcationCaptureInfo) userInfo:nil repeats:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushReceived:)
                                                 name:kNotificationDidReceiveRemoteMessageNotification
                                               object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    if (self.refreshTimer) {
        [self.refreshTimer invalidate];
        
        self.refreshTimer = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationDidReceiveRemoteMessageNotification object:nil];
    
}
-(void)getNotifcationCaptureInfo{
    
    if ([_mNotificationData count] == 0) {
        [SVProgressHUD showWithStatus:REQUEST_WAITING];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_GET_NOTIFICATION]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    long currentTime = (long)CFAbsoluteTimeGetCurrent();
    
    NSDictionary *paramterDic = @{@"user_id":theAppDelegate.gUserData.user_id,
                                  @"time":[NSString stringWithFormat:@"%ld",currentTime]};
    
    manager.requestSerializer = [AFHTTPRequestSerializer new];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    [manager GET:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD dismiss];
        
        if ( [responseObject count] > 0 ) {
            
            NSDictionary *responseDic = [responseObject objectAtIndex:0];
            
            if ([[responseDic objectForKey:@"status"] intValue] == 200) {
                
                [_mNotificationData removeAllObjects];
                
                if ([responseDic objectForKey:@"ad_space_value"] != nil) {
                    ad_space_limit = [[responseDic objectForKey:@"ad_space_value"] intValue];
                }
                
                for (int i=0; i<[responseObject count]; i++) {
                    
                    NSDictionary *objDic = [responseObject objectAtIndex:i];
                    
                    notificationModel *nData = [[notificationModel alloc]init];
                    
                    if ([objDic objectForKey:@"notification_user_id"] != nil) {
                        nData.notification_user_id = [[objDic objectForKey:@"notification_user_id"] intValue];
                    }
                    
                    if ([objDic objectForKey:@"notification_type"] != nil) {
                        nData.notification_type = [[objDic objectForKey:@"notification_type"] intValue];
                    }
                    
                    if ([objDic objectForKey:@"notification_question_id"] != nil) {
                        nData.notification_question_id = [[objDic objectForKey:@"notification_question_id"] doubleValue];
                    }
                    
                    if ([objDic objectForKey:@"notification_flag"] != nil) {
                        nData.notification_flag = [[objDic objectForKey:@"notification_flag"] intValue];
                    }
                    
                    if ([objDic objectForKey:@"notification_date_time"] != nil) {
                        nData.notification_date_time = [objDic objectForKey:@"notification_date_time"];
                    }
                    
                    if ([objDic objectForKey:@"notification_answer_id"] != nil) {
                        nData.notification_answer_id = [[objDic objectForKey:@"notification_answer_id"] intValue];
                    }
                    
                    if ([objDic objectForKey:@"notification_question_text"] != nil) {
                        nData.notification_question_text = [objDic objectForKey:@"notification_question_text"];
                    }
                    
                    if ([objDic objectForKey:@"notification_answer_text"] != nil) {
                        nData.notification_answer_text = [objDic objectForKey:@"notification_answer_text"];
                    }
                    
                    if ([objDic objectForKey:@"notification_question_date"] != nil) {
                        nData.notification_question_date = [objDic objectForKey:@"notification_question_date"];
                    }
                    
                    if ([objDic objectForKey:@"notification_answer_date"] != nil) {
                        nData.notification_answer_date = [objDic objectForKey:@"notification_answer_date"];
                    }
                    
                    if ([objDic objectForKey:@"notification_rating"] != nil) {
                        nData.notification_rating = [[objDic objectForKey:@"notification_rating"] floatValue];
                    }
                    
                    if ([objDic objectForKey:@"notification_rating_date"] != nil) {
                        nData.notification_rating_date = [[objDic objectForKey:@"notification_rating_date"] floatValue];
                    }
                    
                    [_mNotificationData addObject:nData];
                    
                }
                
                [tblNotification reloadData];
                
            }else{
                
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseString);
        [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        
        
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
        int nCount = (int)([_mNotificationData count]+nLoadmoreFlag+(int)([_mNotificationData count]/ad_space_limit)+1);
        return nCount;
    }
    return [_mNotificationData count]+nLoadmoreFlag;
}

- (NSDictionary *)postForTableViewIndex:(NSInteger)index
{
    return nil;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (nLoadmoreFlag == 1) {
        if (indexPath.row == [_mNotificationData count]) {
            //            [self getInformation:nCurrentPageNumber+1 loadingFlag:1];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % ad_space_limit == 0 && ad_space_limit != -1) {
        
        return cell_ad_height;
        
    }else {
        cell_default_height;
    }
    return cell_default_height;
    
}

#pragma mark Cells and Headers

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *newCell = nil;
    
    if (nLoadmoreFlag != 0) {
        if (indexPath.row == [_mNotificationData count]) {
            
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
            NSString  *cellType = @"notificationCell";
            
            notificationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellType];
            
            if (cell == nil) {
                
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"notificationCell" owner:nil options:nil];
                
                for(id currentObject in topLevelObjects)
                {
                    if([currentObject isKindOfClass:[UITableViewCell class]])
                    {
                        cell = (notificationCell *) currentObject;
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        break;
                    }
                }
                
            }
            
            if ([_mNotificationData count] >0) {
                
                if (indexPath.row % ad_space_limit == 0) {
                    cell.rootControl = self;
                    [cell setShowAd:(indexPath.row / ad_space_limit)%3];
                }else{
                    notificationModel *nData = [_mNotificationData objectAtIndex:indexPath.row-indexPath.row/ad_space_limit-1];
                    
                    cell.mNotificationData = nData;
                    
                    [cell setShowUI];
                }
                
            }
            
            newCell = cell;
            
            [cell setBackgroundColor:[UIColor clearColor]];
            
        }
    }else{
        NSString  *cellType = @"notificationCell";
        
        notificationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellType];
        
        if (cell == nil) {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"notificationCell" owner:nil options:nil];
            
            for(id currentObject in topLevelObjects)
            {
                if([currentObject isKindOfClass:[UITableViewCell class]])
                {
                    cell = (notificationCell *) currentObject;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                }
            }
            
        }
        
        if ([_mNotificationData count] >0) {
            
            if (indexPath.row % ad_space_limit == 0) {
                cell.rootControl = self;
                [cell setShowAd:(indexPath.row / ad_space_limit)%3];
            }else{
                notificationModel *nData = [_mNotificationData objectAtIndex:indexPath.row-indexPath.row/ad_space_limit-1];
                
                cell.mNotificationData = nData;
                
                [cell setShowUI];
            }
            
        }
        
        newCell = cell;
        
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    return newCell;
}
- (void)pushReceived:(NSNotification *)notification {
    
    [self getNotifcationCaptureInfo];
}

-(void)onCheckQuestionData:(notificationModel*)notificationData{

    [SVProgressHUD showWithStatus:REQUEST_WAITING];


    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_CHECK_QUESTION]];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    long currentTime = (long)CFAbsoluteTimeGetCurrent();
    
    NSDictionary *paramterDic = @{@"user_id":theAppDelegate.gUserData.user_id,
                                  @"question_id":[NSString stringWithFormat:@"%d",notificationData.notification_question_id],
                                  @"time":[NSString stringWithFormat:@"%ld",currentTime]};

    manager.requestSerializer = [AFHTTPRequestSerializer new];
    manager.securityPolicy.allowInvalidCertificates = YES;

    [manager GET:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD dismiss];
        
        if ( [responseObject count] > 0 ) {
            
            NSDictionary *responseDic = [responseObject objectAtIndex:0];
            
            if ([[responseDic objectForKey:@"status"] intValue] == 200) {
                
                questionModel *questionData = [[questionModel alloc]init];
                
                if ([responseDic objectForKey:@"question_id"] != nil) {
                    questionData.question_id = [[responseDic objectForKey:@"question_id"] intValue];
                }
                
                if ([responseDic objectForKey:@"question_text"] != nil) {
                    questionData.question_text = [responseDic objectForKey:@"question_text"];
                }
                
                if ([responseDic objectForKey:@"question_date"] != nil) {
                    questionData.question_date = [responseDic objectForKey:@"question_date"];
                }
                
                if ([responseDic objectForKey:@"user_id"] != nil) {
                    questionData.question_user_id = [responseDic objectForKey:@"user_id"];
                }
                
                if ([responseObject count] == 1) {
                    
                    AnswerVC *mAnswerVC = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"AnswerVC"];
                    
                    mAnswerVC.mQuestionData = questionData;
                    
                    mAnswerVC.messageWindowType = MESSAGE_ANSWER_CHAT;
                    
                    [self.navigationController pushViewController:mAnswerVC animated:YES];
                    
                }else{
                    
                    NSDictionary *answerDic = [responseObject objectAtIndex:1];
                    questionModel *answerData = [[questionModel alloc]init];
                    
                    if ([answerDic objectForKey:@"question_id"] != nil) {
                        answerData.question_id = [[answerDic objectForKey:@"question_id"] intValue];
                    }
                    
                    if ([answerDic objectForKey:@"question_text"] != nil) {
                        answerData.question_text = [answerDic objectForKey:@"question_text"];
                    }
                    
                    if ([answerDic objectForKey:@"question_date"] != nil) {
                        answerData.question_date = [answerDic objectForKey:@"question_date"];
                    }
                    
                    if ([answerDic objectForKey:@"user_id"] != nil) {
                        answerData.question_user_id = [answerDic objectForKey:@"user_id"];
                    }
                    
                    TopDetailVC *mDetailVC = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"TopDetailVC"];
                    
                    topModel *topData = [[topModel alloc]init];
                    
                    topData.top_answer_id = answerData.question_id;
                    topData.top_answer_text = answerData.question_text;
                    topData.top_question_text = questionData.question_text;
                    
                    mDetailVC.mTopData = topData;
                    mDetailVC.messageWindowType = MESSAGE_ANSWER_TOP;
                    [self.navigationController pushViewController:mDetailVC animated:YES];
                    
                }
                
                
                
                
            }else{
                
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseString);
        [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        
        
    }];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row % ad_space_limit != 0) {
        
        notificationModel *notificationData = [_mNotificationData objectAtIndex:indexPath.row-indexPath.row/ad_space_limit-1];
        
        if (notificationData.notification_type == 0) {
            
            [self onCheckQuestionData:notificationData];
            
            
        }
        
    }
    
}
@end
