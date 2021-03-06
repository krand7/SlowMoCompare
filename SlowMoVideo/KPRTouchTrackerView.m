//
//  KPRTouchTrackerView.m
//  SlowMoVideo
//
//  Created by Kyle Rand on 9/24/14.
//  Copyright (c) 2014 PracticeCoding. All rights reserved.
//

#import "KPRTouchTrackerView.h"

@implementation KPRTouchTrackerView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) self.multipleTouchEnabled = NO;
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [[UIColor greenColor] setStroke];
    [path stroke];
    
}



// When touch begins, initialize a path
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate drawingIsEnabled]) {
        NSLog(@"Touched view");
        path = [UIBezierPath bezierPath];
        path.lineWidth = 4.0f;
        
        UITouch *touch = [touches anyObject];
        [path moveToPoint:[touch locationInView:self]];
    }
    
    else if ([self.delegate erasingIsEnabled]) {
        // Clear touchTracker view
        path = NULL;
//        duplicatePath = NULL;
        [self setNeedsDisplay];
        
        // Determine if user selected a path
        NSLog(@"Prepared to erase bezierPath");
        UITouch *touch = [touches anyObject];
        CGPoint tapPoint = [touch locationInView:self];
        [self.delegate checkForPathSelected:tapPoint];
        
    }
}

// When user moves finger, update path
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate drawingIsEnabled]) {
        UITouch *touch = [touches anyObject];
        [path addLineToPoint:[touch locationInView:self]];
        [self setNeedsDisplay];
    }
}

// When user releases finger, still update path
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate drawingIsEnabled]) {
        UITouch *touch = [touches anyObject];
        [path addLineToPoint:[touch locationInView:self]];
        [self setNeedsDisplay];
        [self.delegate getNewBezierPath:path];
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}


-(void)clearTouchTrackerView
{
    path = NULL;
    //    duplicatePath = NULL;
    [self setNeedsDisplay];
}

@end
