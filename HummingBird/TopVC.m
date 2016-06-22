//
//  TopVC.m
//  HummingBird
//
//  Created by Star on 3/7/16.
//  Copyright © 2016 Star. All rights reserved.
//

#import "TopVC.h"
#import "topModel.h"
#import "topCell.h"

#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "Common.h"
#import "loadmoreCell.h"
#import "TopDetailVC.h"
#import "AppDelegate.h"
#import "userModel.h"

#ifdef humming_dist
#import "Analytics.h"
#endif

#define cell_default_height 54
#define cell_ad_height 50

#define search_bar_size 44

@interface TopVC ()

@end

@implementation TopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _mTopArray = [[NSMutableArray alloc]init];
    tempRect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-70, 0);
    
    self.title = @"Questions & Answers";
//
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    ad_space_limit = -1;
    nCurrentPageNumber = 1;
    nLoadmoreFlag = 0;
    
    [self getInformation];
}

-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (searchBarSize.constant == search_bar_size) {
        self.navigationController.navigationBarHidden = YES;
    }else{
        self.navigationController.navigationBarHidden = NO;
    }
    
    UIButton *btnSearch = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btnSearch setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [btnSearch addTarget:self action:@selector(onSearch) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barSearch = [[UIBarButtonItem alloc]initWithCustomView:btnSearch];
    
    self.navigationItem.rightBarButtonItem = barSearch;
    

    
#ifdef humming_dist
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
    
    [tracker set:kGAIScreenName value:@"Top Question and Answer Page"];
    [tracker send:[[[GAIDictionaryBuilder createScreenView]
                    set:@"Top Question and Answer Page"
                    forKey:[GAIFields customDimensionForIndex:1]] build]];
#endif
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

-(void)getInformation{
    
    [SVProgressHUD showWithStatus:REQUEST_WAITING];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_TOP_GET]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    long currentTime = (long)CFAbsoluteTimeGetCurrent();
    
    
    NSDictionary *paramterDic = @{@"user_id":theAppDelegate.gUserData.user_id,
                                  @"time":[NSString stringWithFormat:@"%ld",currentTime]};
    
    [manager GET:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ( [responseObject count] > 0 ) {
            
            [SVProgressHUD dismiss];
            
            [_mTopArray removeAllObjects];
            
            NSDictionary *responseDic = [responseObject objectAtIndex:0];
            if ([[responseDic objectForKey:@"status"] intValue] == 200) {
                
                if ([responseDic objectForKey:@"ad_space_value"] != nil) {
                    ad_space_limit = [[responseDic objectForKey:@"ad_space_value"] intValue];
                }
                
                for (int i=0; i<[responseObject count]; i++) {
                    
                    NSDictionary *objDic = [responseObject objectAtIndex:i];
                    
                    topModel *topData = [[topModel alloc]init];
                    
                    if ([objDic objectForKey:@"answer_id"] != nil && [objDic objectForKey:@"answer_id"] != [NSNull null]) {
                        topData.top_answer_id = [[objDic objectForKey:@"answer_id"] intValue];
                    }
                    
                    if ([objDic objectForKey:@"question_text"] != nil && [objDic objectForKey:@"question_text"] != [NSNull null]) {
                        topData.top_question_text = [objDic objectForKey:@"question_text"];
                    }
                    
                    if ([objDic objectForKey:@"answer_text"] != nil && [objDic objectForKey:@"answer_text"] != [NSNull null]) {
                        topData.top_answer_text = [objDic objectForKey:@"answer_text"];
                    }
                    
                    if ([objDic objectForKey:@"rating"] != nil && [objDic objectForKey:@"rating"] != [NSNull null]) {
                        topData.top_rating = [[objDic objectForKey:@"rating"] floatValue];
                    }
                    
                    if ([objDic objectForKey:@"likes"] != nil && [objDic objectForKey:@"likes"] != [NSNull null]) {
                        topData.top_likes = [[objDic objectForKey:@"likes"] intValue];
                    }
                    
                    if ([objDic objectForKey:@"comments"] != nil && [objDic objectForKey:@"comments"] != [NSNull null]) {
                        topData.top_comments = [[objDic objectForKey:@"comments"] intValue];
                    }
                    
                    [_mTopArray addObject:topData];
                    
                }
                
                [tblTop reloadData];
                
                
            }else{
               
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:WEB_FAILED];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
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
    
    if ([_mTopArray count] == 0) {
        return 0;
    }else if (ad_space_limit != -1) {
        int nCount = (int)[_mTopArray count]+nLoadmoreFlag+(int)([_mTopArray count]/ad_space_limit)+1;
        return nCount;
    }
    return [_mTopArray count]+nLoadmoreFlag;
}

- (NSDictionary *)postForTableViewIndex:(NSInteger)index
{
    return nil;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (nLoadmoreFlag == 1) {
        if (indexPath.row == [_mTopArray count]) {
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row % ad_space_limit == 0 && ad_space_limit != -1) {
        
        return cell_ad_height;
        
    }else if (indexPath.row != [_mTopArray count]) {
        if ([_mTopArray count] >indexPath.row) {
            
            topModel *topData = [_mTopArray objectAtIndex:indexPath.row];
            
            lblTemplate.frame = tempRect;
            [lblTemplate setText:topData.top_question_text];
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
        if (indexPath.row == [_mTopArray count]) {
            
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
            NSString  *cellType = @"topCell";
            
            topCell *cell = [tableView dequeueReusableCellWithIdentifier:cellType];
            
            if (cell == nil) {
                
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"topCell" owner:nil options:nil];
                
                for(id currentObject in topLevelObjects)
                {
                    if([currentObject isKindOfClass:[UITableViewCell class]])
                    {
                        cell = (topCell *) currentObject;
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        break;
                    }
                }
                
            }
            
            if ([_mTopArray count] >0) {
                
                
                if (indexPath.row % ad_space_limit == 0) {
                    cell.rootControl = self;
                    [cell setShowAd:(indexPath.row / ad_space_limit)%3];
                }else{
                    
                    topModel *topData = [_mTopArray objectAtIndex:indexPath.row+indexPath.row/ad_space_limit];
                    
                    cell.mTopData = topData;
                    
                    [cell setShowUI];
                }
                
                
            }
            
            newCell = cell;
            
            [cell setBackgroundColor:[UIColor clearColor]];
            
        }
    }else{
        NSString  *cellType = @"topCell";
        
        topCell *cell = [tableView dequeueReusableCellWithIdentifier:cellType];
        
        if (cell == nil) {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"topCell" owner:nil options:nil];
            
            for(id currentObject in topLevelObjects)
            {
                if([currentObject isKindOfClass:[UITableViewCell class]])
                {
                    cell = (topCell *) currentObject;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                }
            }
            
        }
        
        if ([_mTopArray count] >0) {
            
            
            if (indexPath.row % ad_space_limit == 0) {
                
                cell.rootControl = self;
                
                [cell setShowAd:(indexPath.row / ad_space_limit)%3];
                
            }else{
                
                topModel *topData = [_mTopArray objectAtIndex:indexPath.row-indexPath.row/ad_space_limit-1];
                
                cell.mTopData = topData;
                
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
        
        TopDetailVC *mDetailVC = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"TopDetailVC"];
        mDetailVC.mTopData = [_mTopArray objectAtIndex:indexPath.row-indexPath.row/ad_space_limit-1];
        mDetailVC.messageWindowType = MESSAGE_ANSWER_TOP;
        [self.navigationController pushViewController:mDetailVC animated:YES];
        
    }
    
    
}

-(void)onSearch{
    
    self.navigationController.navigationBarHidden = YES;
    searchBarSize.constant = search_bar_size;
    
    [searchBarTop becomeFirstResponder];
}

-(IBAction)onCancel:(id)sender{
    [searchBarTop resignFirstResponder];
    self.navigationController.navigationBarHidden = NO;
    searchBarSize.constant = 0;
    
    [self getInformation];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [SVProgressHUD showWithStatus:REQUEST_WAITING];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_TOP_SEARCH]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    long currentTime = (long)CFAbsoluteTimeGetCurrent();
    
    NSDictionary *paramterDic = @{@"user_id":theAppDelegate.gUserData.user_id,
                                  @"word":searchBar.text,
                                  @"time":[NSString stringWithFormat:@"%ld",currentTime]};
    
    [manager GET:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        [searchBarTop resignFirstResponder];
        
        if ( [responseObject count] > 0 ) {
            
            [SVProgressHUD dismiss];
            
            [_mTopArray removeAllObjects];
            
            NSDictionary *responseDic = [responseObject objectAtIndex:0];
            
            if ([[responseDic objectForKey:@"status"] intValue] == 200) {
                
                if ([responseDic objectForKey:@"ad_space_value"] != nil) {
                    ad_space_limit = [[responseDic objectForKey:@"ad_space_value"] intValue];
                }
                
                for (int i=0; i<[responseObject count]; i++) {
                    
                    NSDictionary *objDic = [responseObject objectAtIndex:i];
                    
                    topModel *topData = [[topModel alloc]init];
                    
                    if ([objDic objectForKey:@"answer_id"] != nil && [objDic objectForKey:@"answer_id"] != [NSNull null]) {
                        topData.top_answer_id = [[objDic objectForKey:@"answer_id"] intValue];
                    }
                    
                    if ([objDic objectForKey:@"question_text"] != nil && [objDic objectForKey:@"question_text"] != [NSNull null]) {
                        topData.top_question_text = [objDic objectForKey:@"question_text"];
                    }
                    
                    if ([objDic objectForKey:@"answer_text"] != nil && [objDic objectForKey:@"answer_text"] != [NSNull null]) {
                        topData.top_answer_text = [objDic objectForKey:@"answer_text"];
                    }
                    
                    if ([objDic objectForKey:@"rating"] != nil && [objDic objectForKey:@"rating"] != [NSNull null]) {
                        topData.top_rating = [[objDic objectForKey:@"rating"] floatValue];
                    }
                    
                    if ([objDic objectForKey:@"likes"] != nil && [objDic objectForKey:@"likes"] != [NSNull null]) {
                        topData.top_likes = [[objDic objectForKey:@"likes"] intValue];
                    }
                    
                    if ([objDic objectForKey:@"comments"] != nil && [objDic objectForKey:@"comments"] != [NSNull null]) {
                        topData.top_comments = [[objDic objectForKey:@"comments"] intValue];
                    }
                    
                    [_mTopArray addObject:topData];
                    
                }
                
                [tblTop reloadData];
                
                
            }else{
                [_mTopArray removeAllObjects];
                
                [tblTop reloadData];
            }
            
        }else{
            
            
            [SVProgressHUD showErrorWithStatus:WEB_FAILED];
            
            [_mTopArray removeAllObjects];
            
            [tblTop reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [searchBarTop resignFirstResponder];
        [SVProgressHUD showErrorWithStatus:WEB_FAILED];
    }];
}

-(IBAction)onback:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
