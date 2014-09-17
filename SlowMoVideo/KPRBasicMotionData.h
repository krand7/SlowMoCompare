//
//  KPRBasicMotionData.h
//  SlowMoVideo
//
//  Created by Kyle Rand on 9/16/14.
//  Copyright (c) 2014 PracticeCoding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

#define MOTION_NAME @"Motion Name"
#define MOTION_EXPLANATION @"Motion explanation"
#define MOTION_DEMO @"Motion demo video"

@interface KPRBasicMotionData : NSObject

+(NSArray *)allBasicMotions;

@end
