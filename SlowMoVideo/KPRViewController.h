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

@interface KPRViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, KPRChooseMoveTableViewControllerDelegate>

@property (strong, nonatomic) KPRBasicMotionObject *basicMotion;
@property (strong, nonatomic) AVAsset *submittedVideo;
@property (strong, nonatomic) AVAsset *slowMoVideoDemo;
@property (strong, nonatomic) AVAsset *slowMoVideoTraining;
@property (strong, nonatomic) AVPlayer *slowMoPlayerDemo;
@property (strong, nonatomic) AVPlayer *slowMoPlayerTraining;

@property (strong, nonatomic) IBOutlet UIView *demoView;
@property (strong, nonatomic) IBOutlet UIView *trainingView;
@property (strong, nonatomic) IBOutlet UIButton *playSloMoButton;

// Slow motion controls
@property (strong, nonatomic) IBOutlet UILabel *frameRateLabel;
@property (strong, nonatomic) IBOutlet UIStepper *frameRateStepper;
- (IBAction)frameRateStepperChanged:(UIStepper *)sender;

- (IBAction)demoFrameSliderValueChanged:(UISlider *)sender;
@property (strong, nonatomic) IBOutlet UISlider *demoFrameSlider;



// Main User Interface
- (IBAction)selectMovieButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)playSlowMoButtonPressed:(UIButton *)sender;

- (BOOL)selectMovieToPlayFromViewController:(UIViewController *)controller usingDelegate:(id)delegate;

@end
