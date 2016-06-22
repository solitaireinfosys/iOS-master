//
//  MapVC.h
//  HummingBird
//
//  Created by Star on 12/22/15.
//  Copyright (c) 2015 Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class questionModel;

@interface MapVC : UIViewController
{
    IBOutlet MKMapView *mapView;
    
    MKCoordinateRegion viewRegion;
}

@property (nonatomic,retain)questionModel *mQuestionData;

@property (nonatomic,retain)NSString *currentLocationAddress;
@end
