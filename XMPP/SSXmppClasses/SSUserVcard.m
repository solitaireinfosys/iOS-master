//
//  SSSetUserVcard.m
//  SSXmpp
//
//  Created by CANOPUS16 on 02/12/15.
//  Copyright © 2015 Sourabh. All rights reserved.
//

#import "SSUserVcard.h"

@implementation SSUserVcard

+(SSUserVcard *)shareInstance
{
    static SSUserVcard * instance = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SSUserVcard alloc] init];
    });
    return instance;
}

-(void)getVcardOfUser:(SSUserVcardblock)ssblock
{
    _aSSUserVcardblock = ssblock;
    if([[Reachability sharedReachability] internetConnectionStatus]==NotReachable)
    {
        if (ssblock)
        {
            ssblock(SSResponce(kInternetAlertMessage,kFailed,@""));
        }
    }
    else
    {
        XMPPvCardTemp *myvCardTempw = [[[SSConnectionClasses shareInstance] xmppvCardTempModule] myvCardTemp];
        
        if (_aSSUserVcardblock)
        {
            ssblock(SSResponce(kSuccess,kSuccess,myvCardTempw.photo));
        }
    }
}

-(void)setVcardOfUser:(NSString *)username imageData:(NSData*)imageData1 complition:(SSUserVcardblock)ssblock
{
    _aSSUserVcardblock = ssblock;
    if([[Reachability sharedReachability] internetConnectionStatus]==NotReachable)
    {
        if (_aSSUserVcardblock)
        {
            _aSSUserVcardblock(SSResponce(kInternetAlertMessage,kFailed,@""));
            _aSSUserVcardblock=nil;
        }
    }
    else
    {
        [[[SSConnectionClasses shareInstance] xmppStream] addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [[[SSConnectionClasses shareInstance] xmppRoster] addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [[[SSConnectionClasses shareInstance] xmppvCardTempModule] addDelegate:self delegateQueue:dispatch_get_main_queue()];
        //
        XMPPvCardTemp *myvCardTemp = [[[SSConnectionClasses shareInstance] xmppvCardTempModule] myvCardTemp];

        if(myvCardTemp == nil)
            myvCardTemp = [XMPPvCardTemp vCardTemp];
            
            if (myvCardTemp)
            {
                UIImage *resizeImage = [UIImage imageWithData:imageData1];
                if (resizeImage == nil){
                    resizeImage = [UIImage imageNamed:@"NavProfile"];
                }
                resizeImage = [self imageWithImage:resizeImage scaledToFitToSize:CGSizeMake(100, 100)];
               NSData *newImageData = UIImagePNGRepresentation(resizeImage);
              
                //[myvCardTemp setName:username];
                [myvCardTemp setNickname:username];
                [myvCardTemp setPhoto:newImageData];
                [[[SSConnectionClasses shareInstance] xmppvCardTempModule] updateMyvCardTemp:myvCardTemp];
            }
        
        //  NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
        //        [iq addAttributeWithName:@"type" stringValue:@"set"];
        //        [iq addAttributeWithName:@"id" stringValue:@"vcardset"];
        //        // [iq addAttributeWithName:@"from" stringValue:KMyXmppId];
        //
        //        NSXMLElement *vCardXML = [NSXMLElement elementWithName:@"vCard" xmlns:@"vcard-temp"];
        //        XMPPvCardTemp *newvCardTemp = [XMPPvCardTemp vCardTempFromElement:vCardXML];
        //        if(newvCardTemp == nil)	newvCardTemp = [[XMPPvCardTemp alloc] init];
        //
        //        ///[newvCardTemp setPhoto:UIImagePNGRepresentation(buttonForImage.currentImage)];
        //
        //        [newvCardTemp setNickname:username];
        //        [newvCardTemp setPhoto:imageData1];
        //        [iq addChild:newvCardTemp];
        //
        //        [[[SSConnectionClasses shareInstance] xmppStream]sendElement:iq];
    }
    
}

- (void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule
{
    
}

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule
        didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp
                     forJID:(XMPPJID *)jid
{
    
}

#pragma mark - Image Resize
-(UIImage *)imageWithImage:(UIImage *)image scaledToFitToSize : (CGSize)newSize
{
    //Only scale images down
    if (image.size.width < newSize.width && image.size.height < newSize.height) {
        return image;
    }
    
    //Determine the scale factors
    CGFloat widthScale = newSize.width/image.size.width;
    CGFloat heightScale = newSize.height/image.size.height;
    
    CGFloat scaleFactor = 0.0;
    
    //The smaller scale factor will scale more (0 < scaleFactor < 1) leaving the other dimension inside the newSize rect
    widthScale < heightScale ? (scaleFactor = widthScale) : (scaleFactor = heightScale);
    
    CGSize scaledSize = CGSizeMake(image.size.width * scaleFactor, image.size.height * scaleFactor);
    
    CGRect rect = CGRectMake(0.0, 0.0, scaledSize.width, scaledSize.height);
        //Determine whether the screen is retina
    if ([UIScreen mainScreen].scale == 2.0) {
            UIGraphicsBeginImageContextWithOptions(newSize, false, 2.0);
        }
        else
        {
            UIGraphicsBeginImageContext(newSize);
        }
        
        //Draw image in provided rect
        [image drawInRect:rect];
    
    UIImage *newImage  = UIGraphicsGetImageFromCurrentImageContext();
    
        //Pop this context
    UIGraphicsEndImageContext();
    
    return newImage;
    
}


@end
