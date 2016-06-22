//
//  MapVC.m
//  HummingBird
//
//  Created by Star on 12/22/15.
//  Copyright (c) 2015 Star. All rights reserved.
//

#import "MapVC.h"
#import "questionModel.h"
#import "SVProgressHUD.h"
#import "Common.h"

#ifdef humming_dist
#import "Analytics.h"
#endif

#define METERS_PER_MILE 1609.344
#define MAX_GOOGLE_LEVELS 20


@interface MapVC ()

@end

@implementation MapVC


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
#ifdef humming_dist
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
    
    [tracker set:kGAIScreenName value:@"Map Page"];
    [tracker send:[[[GAIDictionaryBuilder createScreenView]
                    set:@"Map Page"
                    forKey:[GAIFields customDimensionForIndex:1]] build]];
#endif
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
//    
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//                            @"appview", kGAIHitType, @"Map Page", kGAIScreenName, nil];
//    [tracker send:params];
    
//    [SVProgressHUD showWithStatus:@"Waiting..."];
    
//    self.currentLocationAddress = @"";
//    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
//    
    
//    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
//        if ([placemarks count]>0) {
//            CLPlacemark *placemark = [placemarks objectAtIndex:0];
//            self.currentLocationAddress = [NSString stringWithFormat:@"%@",[placemark.addressDictionary valueForKey:@"City"]];
//            
//            
//            [self setMapView];
//            
//            [SVProgressHUD dismiss];
//        }
//        
//    }];
    
    [self setMapView];
    
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

-(void)setMapView{

    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = _mQuestionData.question_lat;
    zoomLocation.longitude = _mQuestionData.question_long;
    
    viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    [mapView setRegion:viewRegion animated:YES];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    [annotation setCoordinate:zoomLocation];

//    [annotation setTitle:self.currentLocationAddress];
    
    [mapView addAnnotation:annotation];
    
}

@end
