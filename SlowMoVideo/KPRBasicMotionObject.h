//
//  KPRBasicMotionObject.h
//  SlowMoVideo
//
//  Created by Kyle Rand on 9/16/14.
//  Copyright (c) 2014 PracticeCoding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPRBasicMotionData.h"

@interface KPRBasicMotionObject : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) AVAsset *video;

-(id)initWithData:(NSDictionary *)data;

@end
