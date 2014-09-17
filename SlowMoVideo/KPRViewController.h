//
//  KPRViewController.h
//  SlowMoVideo
//
//  Created by Kyle Rand on 9/15/14.
//  Copyright (c) 2014 PracticeCoding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import "KPREditVideoViewController.h"
#import "KPRChooseMoveTableViewController.h"

@interface KPRViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, KPRChooseMoveTableViewController>

@property (strong, nonatomic) AVAsset *slowMoVideo;
@property (strong, nonatomic) KPRBasicMotionObject *basicMotion;

@property (strong, nonatomic) MPMoviePlayerController *selectedMovie;
@property (strong, nonatomic) IBOutlet UIView *demoView;
@property (strong, nonatomic) IBOutlet UIView *trainingView;
@property (strong, nonatomic) IBOutlet UIButton *playMovieButton;

// Slow motion controls
@property (strong, nonatomic) IBOutlet UILabel *frameRateLabel;
@property (strong, nonatomic) IBOutlet UIStepper *frameRateStepper;
- (IBAction)frameRateStepperChanged:(UIStepper *)sender;


- (IBAction)playMovieButtonPressed:(UIButton *)sender;
- (IBAction)selectMovieButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)playSlowMoButtonPressed:(UIButton *)sender;

- (BOOL)selectMovieToPlayFromViewController:(UIViewController *)controller usingDelegate:(id)delegate;

@end
