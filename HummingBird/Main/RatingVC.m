//
//  RatingVC.m
//  HummingBird
//
//  Created by Star on 12/18/15.
//  Copyright (c) 2015 Star. All rights reserved.
//

#import "RatingVC.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "Utility.h"
#import "Common.h"
#import "AppDelegate.h"
#import "Message.h"
#import "userModel.h"

@interface RatingVC ()

@end

@implementation RatingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#ifdef humming_dev
    
    [imgLogo setImage:[UIImage imageNamed:@"splash_dev_icon"]];
#endif
    btnSubmit.clipsToBounds = YES;
    btnSubmit.layer.cornerRadius = 5;
    
    
    [self onUpdateStarUI];
    
    self.navigationItem.title = @"Rating";
    
    UIButton *btnCancel = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btnCancel setImage:[UIImage imageNamed:@"Cancel"] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(onCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barCancel = [[UIBarButtonItem alloc]initWithCustomView:btnCancel];
    
    self.navigationItem.rightBarButtonItem = barCancel;
    
}
-(IBAction)onCancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    
    if (btnStar2.tag == 2) {
        nRating++;
    }
    
    if (btnStar3.tag == 3) {
        nRating++;
    }
    
    if (btnStar4.tag == 4) {
        nRating++;
    }
    
    if (btnStar5.tag == 5) {
        nRating++;
    }
    
    return nRating;
}
-(IBAction)onSubmit:(id)sender{
    
    int nRating = [self getRating];
    if (nRating == 0) {
        [SVProgressHUD showErrorWithStatus:@"You can give star 1~5"];
    }else{
        [SVProgressHUD showWithStatus:REQUEST_WAITING];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,[NSString stringWithFormat:WEB_RATING_POST]];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        if (theAppDelegate.uDeviceToken == nil) {
            theAppDelegate.uDeviceToken = @"d6cdb99035f272c8a7bb774a2cdc8319e73a4c54caacf50bb0c0b84161f3c48c";
        }
        
        NSDictionary *paramterDic = @{@"question_id":[NSNumber numberWithInt:_mRatingQuestionMessage.msg_id],
                                      @"answer_id":[NSNumber numberWithInt:_mRatingAnswerMessage.msg_id],
                                      @"user_id":theAppDelegate.gUserData.user_id,
                                      @"rating":[NSNumber numberWithInt:[self getRating]]};
        
        [manager POST:urlString parameters:paramterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ( [responseObject count] > 0 ) {
                
                NSDictionary *responseDic = [responseObject objectAtIndex:0];
                if ([[responseDic objectForKey:@"status"] intValue] == 200) {
                    
                    if ([responseDic objectForKey:@"answer_id"] != nil) {
                        theAppDelegate.gUserData.user_last_rating_qID = [[responseDic objectForKey:@"answer_id"] intValue];
                    }
                    
                    [[Utility getInstance]saveUserData:theAppDelegate.gUserData];
                    
                    [self.delegate onRating:_mMessageData];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                    
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
    
}
@end
