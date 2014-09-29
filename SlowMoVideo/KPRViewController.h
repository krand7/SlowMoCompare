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
#import "KPRTouchTrackerView.h"
#import "KPRExistingPathsView.h"

@interface KPRViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, KPRChooseMoveTableViewControllerDelegate, KPRTouchTrackerViewDelegate>

// Video and player properties
@property (strong, nonatomic) KPRBasicMotionObject *basicMotion;
@property (strong, nonatomic) AVAsset *submittedVideo;
@property (strong, nonatomic) AVAsset *slowMoVideoDemo;
@property (strong, nonatomic) AVAsset *slowMoVideoTraining;
@property (strong, nonatomic) AVPlayer *slowMoPlayerDemo;
@property (strong, nonatomic) AVPlayer *slowMoPlayerTraining;

@property (strong, nonatomic) IBOutlet UIView *demoView;
@property (strong, nonatomic) IBOutlet UIView *trainingView;
@property (strong, nonatomic) IBOutlet UIButton *playSloMoButton;

/* Slow motion controls */
// Frame rate
@property (strong, nonatomic) IBOutlet UILabel *frameRateLabel;
@property (strong, nonatomic) IBOutlet UIStepper *frameRateStepper;
- (IBAction)frameRateStepperChanged:(UIStepper *)sender;
// Frame slider
- (IBAction)demoFrameSliderValueChanged:(UISlider *)sender;
@property (strong, nonatomic) IBOutlet UISlider *demoFrameSlider;
- (IBAction)trainingFrameSliderValueChanged:(UISlider *)sender;
@property (strong, nonatomic) IBOutlet UISlider *trainingFrameSlider;
// Time labels
@property (strong, nonatomic) IBOutlet UILabel *demoTimeStartLabel;
@property (strong, nonatomic) IBOutlet UILabel *demoTimeEndLabel;
@property (strong, nonatomic) IBOutlet UILabel *trainingTimeStartLabel;
@property (strong, nonatomic) IBOutlet UILabel *trainingTimeEndLabel;



// Main User Interface
- (IBAction)selectMovieButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)playSlowMoButtonPressed:(UIButton *)sender;

- (BOOL)selectMovieToPlayFromViewController:(UIViewController *)controller usingDelegate:(id)delegate;


// Drawing interface
@property (strong, nonatomic) IBOutlet KPRTouchTrackerView *touchTrackerView;
@property (strong, nonatomic) IBOutlet KPRExistingPathsView *existingPathsView;

@property (strong, nonatomic) NSMutableArray *storedPaths;

@property (strong, nonatomic) IBOutlet UIButton *drawButton;
@property (strong, nonatomic) IBOutlet UIButton *eraseButton;
- (IBAction)drawButtonPressed:(UIButton *)sender;
- (IBAction)eraseButtonPressed:(UIButton *)sender;



@end
