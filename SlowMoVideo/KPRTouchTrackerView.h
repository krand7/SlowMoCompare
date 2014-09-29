//
//  KPRTouchTrackerView.h
//  SlowMoVideo
//
//  Created by Kyle Rand on 9/24/14.
//  Copyright (c) 2014 PracticeCoding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KPRTouchTrackerViewDelegate <NSObject>

-(void)getNewBezierPath:(UIBezierPath *)path;
-(BOOL)drawingIsEnabled;
-(BOOL)erasingIsEnabled;
-(void)checkForPathSelected:(CGPoint)tapPoint;

@end

@interface KPRTouchTrackerView : UIView
{
    UIBezierPath *path;
}

@property (weak, nonatomic) id <KPRTouchTrackerViewDelegate> delegate;

-(void)clearTouchTrackerView;

@end
