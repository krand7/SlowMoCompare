//
//  KPRChooseMoveTableViewController.h
//  SlowMoVideo
//
//  Created by Kyle Rand on 9/16/14.
//  Copyright (c) 2014 PracticeCoding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPRBasicMotionData.h"
#import "KPRBasicMotionObject.h"

@protocol KPRChooseMoveTableViewController <NSObject>

-(void)retrieveVideoAsset:(AVAsset *)video;

@end

@interface KPRChooseMoveTableViewController : UITableViewController

@property (weak, nonatomic) id <KPRChooseMoveTableViewController> delegate;

@property (strong, nonatomic) NSMutableArray *basicMotions;

@end
