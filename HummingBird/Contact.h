//
//  Contact.h
//  HummingBird
//
//  Created by LaNet on 6/16/16.
//  Copyright © 2016 Star. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Contact : NSObject
@property (strong , nonatomic) NSString *name;
@property (strong , nonatomic) UIImage *image;
@property (strong , nonatomic) NSMutableArray *ph_no;
@property (strong , nonatomic) NSMutableArray *email;
@end
