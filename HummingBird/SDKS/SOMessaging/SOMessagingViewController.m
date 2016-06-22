//
//  SOMessagingViewController.m
//  SOMessaging
//
// Created by : arturdev
// Copyright (c) 2014 SocialObjects Software. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE

#import "SOMessagingViewController.h"
#import "SOMessage.h"
#import "SOMessageCell.h"

#import "NSString+Calculation.h"

#import "SOImageBrowserView.h"
#import <MediaPlayer/MediaPlayer.h>

#import "Common.h"

#define kMessageMaxWidth 240.0f

#define brand_width 108
#define brand_height 108
#define slogan_width 200
#define slogan_height 20

#define community_height 30

@interface SOMessagingViewController () <UITableViewDelegate, SOMessageCellDelegate>
{

}

@property (strong, nonatomic) UIImage *balloonSendImage;
@property (strong, nonatomic) UIImage *balloonReceiveImage;

@property (strong, nonatomic) UIView *tableViewHeaderView;

@property (strong, nonatomic) NSMutableArray *conversation;


@property (strong, nonatomic) SOImageBrowserView *imageBrowser;
@property (strong, nonatomic) MPMoviePlayerViewController *moviePlayerController;

@end

@implementation SOMessagingViewController {
    dispatch_once_t onceToken;
}

- (void)setup
{
    
    UIView *logoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, brand_height+84+10+slogan_height+10)];
    logoView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:1 green:1 blue:1 alpha:0.92];
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.alpha = 0.8;
    
    visualEffectView.frame = logoView.bounds;
    [logoView addSubview:visualEffectView];
    
    
    UILabel *lblSlogan;
    _imgBrand = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2.0-brand_width/2.0, 84, brand_width, brand_height)];

#ifdef humming_dist
    [_imgBrand setImage:[UIImage imageNamed:@"splash_icon"]];
#else
    [_imgBrand setImage:[UIImage imageNamed:@"splash_dev_icon"]];
#endif
    [logoView addSubview:_imgBrand];
    
    self.btnBird = [[UIButton alloc]initWithFrame:_imgBrand.frame];
    self.btnBird.backgroundColor = [UIColor clearColor];
    [logoView addSubview:self.btnBird];
    
    lblSlogan = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2.0-slogan_width/2.0, _imgBrand.frame.origin.y+_imgBrand.frame.size.height+10, slogan_width, slogan_height)];
    [lblSlogan setText:@"How can I help you?"];
    [lblSlogan setTextAlignment:NSTextAlignmentCenter];
    [logoView addSubview:lblSlogan];
    
    _btnInfo = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60, lblSlogan.frame.origin.y-10, 30, 30)];
    [_btnInfo setImage:[UIImage imageNamed:@"green_microphone"] forState:UIControlStateNormal];
    [logoView addSubview:_btnInfo];
    
    [self.view addSubview:logoView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-community_height-10-64) style:UITableViewStyleGrouped];
    
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, lblSlogan.frame.origin.y+lblSlogan.frame.size.height+10, self.view.bounds.size.width, self.view.bounds.size.height-community_height-( lblSlogan.frame.origin.y+lblSlogan.frame.size.height+10)-10) style:UITableViewStyleGrouped];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, logoView.frame.size.height-84+10)];
    self.tableViewHeaderView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = self.tableViewHeaderView;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:self.tableView];
    
    
    self.messageInputView = [[SOMessageInputView alloc] init];
    [self.messageInputView setInit:MESSAGE_COMMUNITY];
    self.messageInputView.delegate = self;
    self.messageInputView.tableView = self.tableView;
    [self.view addSubview:self.messageInputView];
    [self.messageInputView adjustPosition];
    
    self.btnArrow = [[UIButton alloc]initWithFrame:CGRectMake(0, self.messageInputView.frame.origin.y-community_height, self.view.bounds.size.width, community_height)];
    [self.btnArrow setTitle:@"" forState:UIControlStateNormal];
    [self.btnArrow setImage:[UIImage imageNamed:@"pair_arrow_up"] forState:UIControlStateNormal];
    [self.btnArrow setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.btnArrow.titleLabel.font = [UIFont systemFontOfSize:12];
    
    self.messageInputView.btnArrow = self.btnArrow;
    [self.view addSubview:self.btnArrow];
    
    [self.view bringSubviewToFront:logoView];
    
}

#pragma mark - View lifecicle
- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [self setup];
    
    self.balloonSendImage    = [self balloonImageForSending];
    self.balloonReceiveImage = [self balloonImageForReceiving];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.conversation = [self grouppedMessages];
    
    [self.tableView reloadData];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    dispatch_once(&onceToken, ^{
        if ([self.conversation count]) {
            NSInteger section = self.conversation.count - 1;
            NSInteger row = [self.conversation[section] count] - 1;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
             if ( indexPath.row !=-1) {
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
             }
        }
    });
}

// This code will work only if this vc hasn't navigation controller
- (BOOL)shouldAutorotate
{
    if (self.messageInputView.viewIsDragging) {
        return NO;
    }
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.conversation.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < 0) {
        return 0;
    }
    // Return the number of rows in the section.
    return [self.conversation[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    
    id<SOMessage> message = self.conversation[indexPath.section][indexPath.row];
    int index = (int)[[self messages] indexOfObject:message];
    height = [self heightForMessageForIndex:index];
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self intervalForMessagesGrouping])
        return 40;
    
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (![self intervalForMessagesGrouping])
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    view.backgroundColor = [UIColor clearColor];
    
    id<SOMessage> firstMessageInGroup = [self.conversation[section] firstObject];
    NSDate *date = [firstMessageInGroup date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM, eee, HH:mm"];
    UILabel *label = [[UILabel alloc] init];
    label.text = [formatter stringFromDate:date];
    
    label.textColor = [UIColor grayColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    [label sizeToFit];
    
    label.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
    label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    [view addSubview:label];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"sendCell";

    SOMessageCell *cell;

    id<SOMessage> message = self.conversation[indexPath.section][indexPath.row];
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SOMessageCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellIdentifier
                                    messageMaxWidth:[self messageMaxWidth]];
    }
    [cell setMediaImageViewSize:[self mediaThumbnailSize]];
    [cell setUserImageViewSize:[self userImageSize]];
    cell.tableView = self.tableView;
    cell.balloonMinHeight = [self balloonMinHeight];
    cell.balloonMinWidth  = [self balloonMinWidth];
    cell.delegate = self;
    cell.messageFont = [self messageFont];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.balloonImage = message.fromMe ? self.balloonSendImage : self.balloonReceiveImage;
    cell.textView.textColor = message.fromMe ? [UIColor whiteColor] : [UIColor blackColor];
    cell.message = message;
    // For user customization
    int index = (int)[[self messages] indexOfObject:message];
    [self configureMessageCell:cell forMessageAtIndex:index];
    
    [cell adjustCell];
    
    return cell;
}

#pragma mark - SOMessaging datasource
- (NSMutableArray *)messages
{
    return nil;
}

- (CGFloat)heightForMessageForIndex:(NSInteger)index
{
    CGFloat height;
    
    id<SOMessage> message = [self messages][index];
    
    if (message.type == SOMessageTypeText)
    {
        CGSize size = [message.text usedSizeForMaxWidth:[self messageMaxWidth] withFont:[self messageFont]];
        if (message.attributes)
        {
            size = [message.text usedSizeForMaxWidth:[self messageMaxWidth] withAttributes:message.attributes];
        }
        
        if (self.balloonMinWidth)
        {
            CGFloat messageMinWidth = self.balloonMinWidth - [SOMessageCell messageLeftMargin] - [SOMessageCell messageRightMargin];
            if (size.width <  messageMinWidth)
            {
                size.width = messageMinWidth;

                CGSize newSize = [message.text usedSizeForMaxWidth:messageMinWidth withFont:[self messageFont]];
                if (message.attributes)
                {
                    newSize = [message.text usedSizeForMaxWidth:messageMinWidth withAttributes:message.attributes];
                }
                
                size.height = newSize.height;
            }
        }
        
        CGFloat messageMinHeight = self.balloonMinHeight - ([SOMessageCell messageTopMargin] + [SOMessageCell messageBottomMargin]);
        if ([self balloonMinHeight] && size.height < messageMinHeight)
        {
            size.height = messageMinHeight;
        }
        
        size.height += [SOMessageCell messageTopMargin] + [SOMessageCell messageBottomMargin];
        
        if (!CGSizeEqualToSize([self userImageSize], CGSizeZero))
        {
            if (size.height < [self userImageSize].height)
            {
                size.height = [self userImageSize].height;
            }
        }
        
        height = size.height + kBubbleTopMargin + kBubbleBottomMargin;
        
    }
    else
    {
        CGSize size = [self mediaThumbnailSize];
        if (size.height < [self userImageSize].height)
        {
            size.height = [self userImageSize].height;
        }
        height = size.height + kBubbleTopMargin + kBubbleBottomMargin;
    }
    return height;
}

- (NSTimeInterval)intervalForMessagesGrouping
{
    return 0;
}

- (UIImage *)balloonImageForReceiving
{
    UIImage *bubble = [UIImage imageNamed:@"bubbleReceive.png"];
    UIColor *color = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:215.0/255.0 alpha:1.0];
//    UIColor *color = [UIColor grayColor];
    bubble = [self tintImage:bubble withColor:color];
    return [bubble resizableImageWithCapInsets:UIEdgeInsetsMake(17, 27, 21, 17)];
}

- (UIImage *)balloonImageForSending
{
    UIImage *bubble = [UIImage imageNamed:@"bubble.png"];
    UIColor *color = [UIColor colorWithRed:74.0/255.0 green:186.0/255.0 blue:251.0/255.0 alpha:1.0];
//    UIColor *color = [UIColor blueColor];
    
    bubble = [self tintImage:bubble withColor:color];
    return [bubble resizableImageWithCapInsets:UIEdgeInsetsMake(17, 21, 16, 27)];
}

- (void)configureMessageCell:(SOMessageCell *)cell forMessageAtIndex:(NSInteger)index
{

}

- (CGFloat)messageMaxWidth
{
    return kMessageMaxWidth;
}

- (CGFloat)balloonMinHeight
{
    return 0;
}

- (CGFloat)balloonMinWidth
{
    return 0;
}

- (UIFont *)messageFont
{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
}

- (CGSize)mediaThumbnailSize
{
    return CGSizeMake(90, 44);
}

- (CGSize)userImageSize
{
    return CGSizeMake(0, 0);
}

#pragma mark - Public methods
- (void)sendMessage:(id<SOMessage>) message
{
    message.fromMe = YES;
    NSMutableArray *messages = [self messages];
    [messages addObject:message];

    [self refreshMessages:true];
}

- (void)receiveMessage:(id<SOMessage>) message
{
    message.fromMe = NO;

    NSMutableArray *messages = [self messages];
    [messages addObject:message];

    [self refreshMessages:true];
}

- (void)refreshMessages:(BOOL)nFlag
{
    self.conversation = [self grouppedMessages];
    [self.tableView reloadData];
    
    NSInteger section = [self numberOfSectionsInTableView:self.tableView] - 1;
    NSInteger row     = [self tableView:self.tableView numberOfRowsInSection:section] - 1;

    if (row >= 0 && nFlag == true) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - Private methods
- (NSMutableArray *)grouppedMessages
{
    NSMutableArray *conversation = [NSMutableArray new];
    
    if (![self intervalForMessagesGrouping]) {
        if ([self messages]) {
            [conversation addObject:[self messages]];
        }
    } else {
        int groupIndex = 0;
        NSMutableArray *allMessages = [self messages];

        for (int i = 0; i < allMessages.count; i++) {
            if (i == 0) {
                NSMutableArray *firstGroup = [NSMutableArray new];
                [firstGroup addObject:allMessages[i]];
                [conversation addObject:firstGroup];
            } else {
                id<SOMessage> prevMessage    = allMessages[i-1];
                id<SOMessage> currentMessage = allMessages[i];
                
                NSDate *prevMessageDate    = prevMessage.date;
                NSDate *currentMessageDate = currentMessage.date;
                
                NSTimeInterval interval = [currentMessageDate timeIntervalSinceDate:prevMessageDate];
                if (interval < [self intervalForMessagesGrouping]) {
                    NSMutableArray *group = conversation[groupIndex];
                    [group addObject:currentMessage];
                    
                } else {
                    NSMutableArray *newGroup = [NSMutableArray new];
                    [newGroup addObject:currentMessage];
                    [conversation addObject:newGroup];
                    groupIndex++;
                }
            }
        }
    }
    
    return conversation;
}

#pragma mark - SOMessaging delegate
- (void)messageCell:(SOMessageCell *)cell didTapMedia:(NSData *)media
{
    [self didSelectMedia:media inMessageCell:cell];
}

- (void)didSelectMedia:(NSData *)media inMessageCell:(SOMessageCell *)cell
{
    if (cell.message.type == SOMessageTypePhoto) {
        self.imageBrowser = [[SOImageBrowserView alloc] init];
        
        self.imageBrowser.image = [UIImage imageWithData:cell.message.media];

        self.imageBrowser.startFrame = [cell convertRect:cell.containerView.frame toView:self.view];
        
        [self.imageBrowser show];
    } else if (cell.message.type == SOMessageTypeVideo) {
        
        NSString *appFile = [NSTemporaryDirectory() stringByAppendingPathComponent:@"video.mp4"];
        [cell.message.media writeToFile:appFile atomically:YES];
        

        self.moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:appFile]];
        [self.moviePlayerController.moviePlayer prepareToPlay];
        [self.moviePlayerController.moviePlayer setShouldAutoplay:YES];

        [self presentViewController:self.moviePlayerController animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
}
#pragma mark - Helper methods
- (UIImage *)tintImage:(UIImage *)image withColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)removeAllobjs
{
    [self.conversation removeAllObjects];
    [self.tableView reloadData];
}
@end
