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
    
    NSDictionary *strikeOne = @{MOTION_NAME: @"Body Punch", MOTION_EXPLANATION: @"Strike to center of the sternum using the fist (aiming with the first two, top knuckles)", MOTION_DEMO: [self convertMovToAssetFromVideoName:@"bodypunch_front"]};
    
    NSDictionary *strikeTwo = @{MOTION_NAME: @"Face Punch", MOTION_EXPLANATION: @"Strike to the bridge of the nose using the fist (aiming with the first two, top knuckles)", MOTION_DEMO: [self convertMovToAssetFromVideoName:@"facepunch_front"]};
    
    NSDictionary *strikeThree = @{MOTION_NAME: @"Palm Hit", MOTION_EXPLANATION: @"Strike to the bridge of the nose using the heel of the palm", MOTION_DEMO: [self convertMovToAssetFromVideoName:@"palmhit_front"]};
    
    NSDictionary *strikeFour = @{MOTION_NAME: @"Neck Hit", MOTION_EXPLANATION: @"Strike to the side of the neck using the blade of an open hand (palm up)", MOTION_DEMO: [self convertMovToAssetFromVideoName:@"neckhit_front"]};
    
    NSDictionary *taegeukOne = @{MOTION_NAME: @"Taegeuk Il-Jang", MOTION_EXPLANATION: @"this used to be beginner yellow", MOTION_DEMO: [self convertMovToAssetFromVideoName:@"taegeuk1"]};
    
    NSMutableArray *basicMotions = [[NSMutableArray alloc] initWithObjects:strikeOne, strikeTwo, strikeThree, strikeFour, taegeukOne, nil];
    
    return [basicMotions copy];
}

+(AVAsset *)convertMovToAssetFromVideoName:(NSString *)name
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"MOV"];
    return [AVAsset assetWithURL:[NSURL fileURLWithPath:filePath]];
}

@end
