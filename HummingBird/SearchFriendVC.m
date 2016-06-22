//
//  SearchFriendVC.m
//  HummingBird
//
//  Created by LaNet on 6/14/16.
//  Copyright © 2016 Star. All rights reserved.
//

#import "SearchFriendVC.h"
#import "inviteFriendCell.h"
#import "facebookFriends.h"
#import "SVProgressHUD.h"
#import "Contact.h"
#import <FacebookUserManager.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <AddressBook/AddressBook.h>

@interface SearchFriendVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tbl_frieds;
@property (strong, nonatomic) NSMutableArray *friends;
@property (strong, nonatomic) NSMutableArray *contacts;
@end

@implementation SearchFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _friends = [[NSMutableArray alloc] init];
    _contacts = [[NSMutableArray alloc] init];
    _tbl_frieds.delegate = self;
    [_tbl_frieds registerNib:[UINib nibWithNibName:@"inviteFriendCell" bundle:NULL] forCellReuseIdentifier:@"inviteFriendCell"];
    _tbl_frieds.contentOffset = CGPointMake(0, 0);
    [SVProgressHUD show];
//    [self fetchAllFriends];
//    [self fetchContats];
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 -(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self checkContactPermission];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - get friend list
-(void)fetchAllFriends
{
    NSDictionary *params = @{@"fields": @"id, first_name, last_name, middle_name, name, friend_email, picture"};
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"me/invitable_friends"
                                  parameters:params
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        
        if (!error)
        {
            NSArray * friendList = [result objectForKey:@"data"];
            for (NSDictionary * friend in friendList)
            {
                facebookFriends *FBfriend = [[facebookFriends alloc] init];
                if (![[friend objectForKey:@"first_name"] isEqual:[NSNull class]])
                {
                    FBfriend.first_name = (NSString *)[friend valueForKey:@"first_name"];
                }
                if (![[friend objectForKey:@"id"] isEqual:[NSNull class]])
                {
                    FBfriend.friend_id = (NSString *)[friend valueForKey:@"id"];
                }
                if (![[friend objectForKey:@"last_name"] isEqual:[NSNull class]])
                {
                    FBfriend.last_name = (NSString *)[friend valueForKey:@"last_name"];
                }
                if (![[friend objectForKey:@"name"] isEqual:[NSNull class]])
                {
                    FBfriend.name = (NSString *)[friend valueForKey:@"name"];
                }
                if (![[friend objectForKey:@"email"] isEqual:[NSNull class]])
                {
                    FBfriend.friend_email = (NSString *)[friend valueForKey:@"email"];
                }
                if (![[friend objectForKey:@"middle_name"] isEqual:[NSNull class]])
                {
                    FBfriend.middle_name = (NSString *)[friend valueForKey:@"middle_name"];
                }
                if (![[friend objectForKey:@"picture"] isEqual:[NSNull class]])
                {
                    NSDictionary *picture = [[NSDictionary alloc] init];
                    picture = (NSDictionary *)[friend valueForKey:@"picture"];
                    
                    if (![[picture objectForKey:@"data"] isEqual:[NSNull class]])
                    {
                        NSDictionary *data = [[NSDictionary alloc] init];
                        data = (NSDictionary *)[picture valueForKey:@"data"];
                        if (![[data objectForKey:@"url"] isEqual:[NSNull class]])
                        {
                            FBfriend.friend_picture_url = (NSString *)[data valueForKey:@"url"];
                        }
                    }
                    /*data =         {
                     "is_silhouette" = 1;
                     url = "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xla1/v/t1.0-1/c15.0.50.50/p50x50/1379841_10150004552801901_469209496895221757_n.jpg?oh=41eda0af5152a6d5673b221f24b4c2a4&oe=57C7B633&__gda__=1476915386_08a9b54bdeaaf0e5daf7e1ca4206d3bc ";
                     };*/
                }
                [self.friends addObject:FBfriend];
            }
        }
        
        // Handle the result
    }];
}

#pragma mark - contacts
-(void) fetchContats
{
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    NSArray *allPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    NSInteger numberOfPeople = [allPeople count];
    
    for (NSInteger i = 0; i < numberOfPeople; i++) {
        Contact *contact = [[Contact alloc] init];
        ABRecordRef person = (__bridge ABRecordRef)allPeople[i];
        
        NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName  = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
        NSLog(@"Name:%@ %@", firstName, lastName);
        contact.name = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        CFIndex numberOfPhoneNumbers = ABMultiValueGetCount(phoneNumbers);
        for (CFIndex i = 0; i < numberOfPhoneNumbers; i++) {
            NSString *phoneNumber = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNumbers, i));
            NSLog(@"  phone:%@", phoneNumber);
            [arr addObject:phoneNumber];
        }
        contact.ph_no = arr;
        CFRelease(phoneNumbers);
        
        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
        
        arr = [[NSMutableArray alloc] init];
        CFIndex numberOfEmails = ABMultiValueGetCount(emails);
        for (CFIndex i = 0; i < numberOfEmails; i++) {
            NSString *email = CFBridgingRelease(ABMultiValueCopyValueAtIndex(emails, i));
            NSLog(@"  email:%@", email);
            [arr addObject:email];
            
        }
        contact.email = arr;
        
        CFRelease(emails);
        
        NSData  *imgData = (__bridge NSData *)ABPersonCopyImageData(person);
        
        UIImage  *img = [UIImage imageWithData:imgData];
        
        NSLog(@"image:%@", img);
        if (img != nil)
        {
            contact.image = img;
        }
        else
        {
            contact.image = [UIImage imageNamed:@"profile.png"];
        }
        NSLog(@"=============================================");
        [_contacts addObject:contact];
    }
    [_tbl_frieds reloadData];
}//

-(void) checkContactPermission
{
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted){
        [self takePermission];
        NSLog(@"Denied");
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        
        NSLog(@"Authorized");
        [self fetchContats];
    } else{ //ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined
        
        NSLog(@"Not determined");
        ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
            if (!granted){
                NSLog(@"Just denied");
                [self takePermission];
                return;
            }
            NSLog(@"Just authorized");
            [self fetchContats];
        });
    }
}

-(void) takePermission
{
    UIAlertView *cantAddContactAlert = [[UIAlertView alloc] initWithTitle: @"Cannot Add Contact" message: @"You must give the app permission to add the contact first." delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
    [cantAddContactAlert show];
}
#pragma mark - table datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contacts.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    inviteFriendCell *cell = (inviteFriendCell *)[tableView dequeueReusableCellWithIdentifier:@"inviteFriendCell" forIndexPath:indexPath];
    cell.friendImage.image = ((Contact *)[_contacts objectAtIndex:indexPath.row]).image;
    cell.lblFriendName.text = ((Contact *)[_contacts objectAtIndex:indexPath.row]).name;
    if (((Contact *)[_contacts objectAtIndex:indexPath.row]).email.count > 0)
    {
        cell.email = [((Contact *)[_contacts objectAtIndex:indexPath.row]).email objectAtIndex:0];
    }
    else{
        cell.email = @"no email";
    }
    return cell;
}

@end
