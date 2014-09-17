//
//  KPRBasicMotionObject.m
//  SlowMoVideo
//
//  Created by Kyle Rand on 9/16/14.
//  Copyright (c) 2014 PracticeCoding. All rights reserved.
//

#import "KPRBasicMotionObject.h"

@implementation KPRBasicMotionObject

-(id)init
{
    self = [self initWithData:nil];
    return self;
}

-(id)initWithData:(NSDictionary *)data
{
    self = [super init];
    
    self.name = data[MOTION_NAME];
    self.description = data[MOTION_EXPLANATION];
    self.video = data[MOTION_DEMO];
    
    return self;
}

@end
