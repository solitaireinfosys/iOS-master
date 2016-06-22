//
//  HistoryVC.m
//  HummingBird
//
//  Created by Star on 12/5/15.
//  Copyright © 2015 Star. All rights reserved.
//

#import "HistoryVC.h"
#import "historyCell.h"
#import "loadmoreCell.h"
#import "questionModel.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "Common.h"
#import "AppDelegate.h"
#import "userModel.h"
#import "ConversationVC.h"
#import "AnswerVC.h"
#import "Utility.h"

#ifdef humming_dist
#import "Analytics.h"
#endif

#define cell_default_height 70
#define cell_ad_height 50

@interface HistoryVC ()

@end

@implementation HistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
//    
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//                            @"appview", kGAIHitType, @"History Page", kGAIScreenName, nil];
//    [tracker send:params];
    
    tempRect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-70, 0);
    
    nCurrentPageNumber = 1;
    
    nLoadmoreFlag = 0;
    
    ad_space_limit = -1;
    
    _mQuestionData = [[NSMutableArray alloc]init];
    
    self.navigationItem.title = @"History";
//    [self.navigationItem setHidesBackButton:YES];
//    
//    UIButton *btnBack = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
//    [btnBack setImage:[UIImage imageNamed:@"Community"] forState:UIControlStateNormal];
//    [btnBack addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *barBack = [[UIBarButtonItem alloc]initWithCustomView:btnBack];
//    
//    self.navigationItem.leftBarButtonItem = barBack;
    
    [self loadMessages];
}

-(IBAction)onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
#ifdef humming_dist
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
    
    [tracker set:kGAIScreenName value:@"History Page"];
    [tracker send:[[[GAIDictionaryBuilder createScreenView]
                    set:@"History Page"
                    forKey:[GAIFields customDimensionForIndex:1]] build]];
#endif
    [self getUserRating];
    
    [self setUserInfo];
    
    [self onShowAd];
}

-(void)onShowAd{

}

- (void)loadMessages
{
    
    [SVProgressHUD showWithStatus:REQUEST_WAITING];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_HISTORY_GET]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    long currentTime = (long)CFAbsoluteTimeGetCurrent();
    
    NSDictionary *paramterDic = @{@"user_id":theAppDelegate.gUserData.user_id,
                                  @"time":[NSString stringWithFormat:@"%ld",currentTime]};
//    NSDictionary *paramterDic = @{@"user_id":@"10156289838920008"};
    
    manager.requestSerializer = [AFHTTPRequestSerializer new];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    [manager GET:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD dismiss];
        
        if ( [responseObject count] > 0 ) {
            
            NSDictionary *responseDic = [responseObject objectAtIndex:0];
            
            if ([[responseDic objectForKey:@"status"] intValue] == 200) {
                
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
                    
                    if ([objDic objectForKey:@"user_rating"] != nil) {
                        chatData.user_rating = [[objDic objectForKey:@"user_rating"] doubleValue];
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
                    
                    if ([objDic objectForKey:@"user_answers"] != nil) {
                        chatData.user_answer_count = [[objDic objectForKey:@"user_answers"] intValue];
                    }
                    
                    [_mQuestionData addObject:chatData];
                    
                }
                
                [tblQuestion reloadData];
                
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
        int nCount = [_mQuestionData count]+nLoadmoreFlag+[_mQuestionData count]/ad_space_limit+1;
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
            NSString  *cellType = @"historyCell";
            
            historyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellType];
            
            if (cell == nil) {
                
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"historyCell" owner:nil options:nil];
                
                for(id currentObject in topLevelObjects)
                {
                    if([currentObject isKindOfClass:[UITableViewCell class]])
                    {
                        cell = (historyCell *) currentObject;
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
    }else{
        NSString  *cellType = @"historyCell";
        
        historyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellType];
        
        if (cell == nil) {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"historyCell" owner:nil options:nil];
            
            for(id currentObject in topLevelObjects)
            {
                if([currentObject isKindOfClass:[UITableViewCell class]])
                {
                    cell = (historyCell *) currentObject;
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
    
    if (indexPath.row % ad_space_limit !=0 ) {
        AnswerVC *mAnswerVC = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"AnswerVC"];
        mAnswerVC.mQuestionData = [_mQuestionData objectAtIndex:indexPath.row-indexPath.row/ad_space_limit-1];
        mAnswerVC.delegate = nil;
        
        if (mAnswerVC.mQuestionData.user_rating != 0) {
            mAnswerVC.messageWindowType = MESSAGE_ANSWER_HISTORY;
            
        }else{
            mAnswerVC.messageWindowType = MESSAGE_ANSWER_NORATING;
            
        }
        
        [self.navigationController pushViewController:mAnswerVC animated:YES];
    }
    
    
}

-(IBAction)onUserPage:(id)sender{
    
}
-(void)setUserInfo{
    
    [lblRating setText:[NSString stringWithFormat:@"Rating: %.2f", theAppDelegate.gUserData.user_rating]];
    
    [lblAnswers setText:[NSString stringWithFormat:@"Answers: %d",theAppDelegate.gUserData.user_answer_count]];
    
    [lblCredit setText:[NSString stringWithFormat:@"Credit: $%.2f", theAppDelegate.gUserData.user_credit]];
    
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
@end
