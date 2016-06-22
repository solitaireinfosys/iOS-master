//
//  LinkVC.m
//  HummingBird
//
//  Created by Star on 5/12/16.
//  Copyright © 2016 Star. All rights reserved.
//

#import "LinkVC.h"

@import GoogleMobileAds;

@interface LinkVC ()

@end

@implementation LinkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    
//    self.bannerView.adUnitID = @"ca-app-pub-2226631469558843/1696947412";
//    self.bannerView.rootViewController = self;
//    [self.bannerView loadRequest:[GADRequest request]];
//    
//    NSString *scriptText = [NSString stringWithFormat:@"<script async src='//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js'></script><ins class='adsbygoogle' style='display:block' data-ad-client='ca-pub-2226631469558843' data-ad-slot='3898677413' data-ad-format='auto'></ins> <script> (adsbygoogle = window.adsbygoogle || []).push({}); </script>"];
//    
//    [adsenseWebView stringByEvaluatingJavaScriptFromString:scriptText];
//    [adsenseWebView loadHTMLString:scriptText baseURL:nil];
    
    [nSearchBar setText:self.strWeblink];
    
    [self loadUrl];
    
    
    nSearchBar.showsCancelButton = NO;
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], UITextAttributeTextColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 1)],UITextAttributeTextShadowOffset,nil] forState:UIControlStateNormal];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(IBAction)onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)loadUrl{
    
    //    self.strWeblink = [self escape:self.strWeblink];
    
    // Build the url and loadRequest
    //    NSString *urlString = [NSString stringWithFormat:@"%@",self.strWeblink];
    [mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.strWeblink]]];
}

- (NSString *)escape:(NSString *)text
{
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                        (__bridge CFStringRef)text, NULL,
                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                        kCFStringEncodingUTF8);
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    nSearchBarLeft.constant = -44;
    //    nSearchBarRight.constant = -64;
    
    nSearchBar.showsCancelButton = YES;
    
    return YES;
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    nSearchBarLeft.constant = 0;
    //    nSearchBarRight.constant = 0;
    nSearchBar.showsCancelButton = NO;
    [nSearchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    nSearchBarLeft.constant = 0;
    //    nSearchBarRight.constant = 0;
    nSearchBar.showsCancelButton = NO;
    [nSearchBar resignFirstResponder];
    
    if ([searchBar.text containsString:@"http://"]) {
        [mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:searchBar.text]]];
    }else{
        [mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",searchBar.text]]]];
    }
    
}
@end
