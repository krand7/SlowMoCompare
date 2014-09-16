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

@interface KPRViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) MPMoviePlayerController *selectedMovie;
@property (strong, nonatomic) IBOutlet UIView *demoView;
@property (strong, nonatomic) IBOutlet UIView *trainingView;
@property (strong, nonatomic) IBOutlet UIButton *playMovieButton;

- (IBAction)playMovieButtonPressed:(UIButton *)sender;
- (IBAction)selectMovieButtonPressed:(UIBarButtonItem *)sender;

-(BOOL)selectMovieToPlayFromViewController:(UIViewController *)controller usingDelegate:(id)delegate;

@end
