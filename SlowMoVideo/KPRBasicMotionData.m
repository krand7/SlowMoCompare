//
//  KPRBasicMotionData.m
//  SlowMoVideo
//
//  Created by Kyle Rand on 9/16/14.
//  Copyright (c) 2014 PracticeCoding. All rights reserved.
//

#import "KPRBasicMotionData.h"

@implementation KPRBasicMotionData

+(NSArray *)allBasicMotions
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"learning_block" ofType:@"mov"];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    AVAsset *videoAsset = [AVAsset assetWithURL:fileURL];
    NSLog(@"AVAsset loaded: %@", videoAsset);
    
    NSDictionary *strikeOne = @{MOTION_NAME: @"Body Punch", MOTION_EXPLANATION: @"Strike to center of the sternum using the fist (aiming with the first two, top knuckles)", MOTION_DEMO: videoAsset};
    
    NSDictionary *strikeTwo = @{MOTION_NAME: @"Face Punch", MOTION_EXPLANATION: @"Strike to the bridge of the nose using the fist (aiming with the first two, top knuckles)", MOTION_DEMO: videoAsset};
    
    NSDictionary *strikeThree = @{MOTION_NAME: @"Palm Hit", MOTION_EXPLANATION: @"Strike to the bridge of the nose using the heel of the palm", MOTION_DEMO: videoAsset};
    
    NSDictionary *strikeFour = @{MOTION_NAME: @"Neck Hit", MOTION_EXPLANATION: @"Strike to the side of the neck using the blade of an open hand (palm up)", MOTION_DEMO: videoAsset};
    
    NSMutableArray *basicMotions = [[NSMutableArray alloc] initWithObjects:strikeOne, strikeTwo, strikeThree, strikeFour, nil];
    
    return [basicMotions copy];
}

@end
