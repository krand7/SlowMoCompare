//
//  KPRViewController.m
//  SlowMoVideo
//
//  Created by Kyle Rand on 9/15/14.
//  Copyright (c) 2014 PracticeCoding. All rights reserved.
//

#import "KPRViewController.h"
#import "KPREditVideoViewController.h"
#import "KPRChooseMoveTableViewController.h"

@interface KPRViewController () <UIActionSheetDelegate>

@end

@implementation KPRViewController

double frameRateScaleFactor;
CMTime demoVideoDuration;
CMTime trainingVideoDuration;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.playSloMoButton.enabled = NO;
    self.slowMoVideoDemo = self.basicMotion.video;
    [self initializeSlowMoVideoPlayerDemo:YES andTraining:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Slow motion controls

- (IBAction)playSlowMoButtonPressed:(UIButton *)sender {

    /* I need to make the videos initialize after playback is complete, so the play button only makes the videos play
    
    [self initializeSlowMoVideoPlayerDemo:YES andTraining:YES];
    
     */
    
    
    [self.slowMoPlayer play];
    [self.slowMoPlayerTwo play];
}

- (IBAction)frameRateStepperChanged:(UIStepper *)sender {
    
    self.playSloMoButton.enabled = NO;
    
    
    // Adjust frame rate
    frameRateScaleFactor = self.frameRateStepper.value;
    self.frameRateLabel.text = [NSString stringWithFormat:@"1/%0.0f", frameRateScaleFactor];
    
    // Create AVMutableComposition
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    AVMutableComposition *mixCompositionTwo = [[AVMutableComposition alloc] init];
    
    // Create video track
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *videoTrackTwo = [mixCompositionTwo addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // Insert video into track, watching for errors
    NSError *error = nil;
    BOOL videoInsertResult = [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.basicMotion.video.duration) ofTrack:[[self.basicMotion.video tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:&error];
    
    NSError *errorTwo = nil;
    BOOL videoInsertResultTwo = [videoTrackTwo insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.submittedVideo.duration) ofTrack:[[self.submittedVideo tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:&errorTwo];
    
    if (error || !videoInsertResult) {
        NSLog(@"%@", error);
    }
    
    if (error || !videoInsertResultTwo) {
        NSLog(@"%@", errorTwo);
    }
    
    
    // Scale video
    CMTime videoDuration = self.basicMotion.video.duration;
    [videoTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, videoDuration) toDuration:CMTimeMake(videoDuration.value*frameRateScaleFactor, videoDuration.timescale)];
    
    CMTime videoDurationTwo = self.submittedVideo.duration;
    [videoTrackTwo scaleTimeRange:CMTimeRangeMake(kCMTimeZero, videoDurationTwo) toDuration:CMTimeMake(videoDurationTwo.value*frameRateScaleFactor, videoDurationTwo.timescale)];
    
    demoVideoDuration = mixComposition.duration;
    trainingVideoDuration = mixCompositionTwo.duration;
    
    self.slowMoVideoDemo = mixComposition;
    self.slowMoVideoTraining = mixCompositionTwo;
    
    self.playSloMoButton.enabled = YES;
    
    [self initializeSlowMoVideoPlayerDemo:YES andTraining:YES];
    
}



#pragma mark - Video playback interface

- (IBAction)demoFrameSliderValueChanged:(UISlider *)sender {
    
    CMTime newTime = CMTimeMakeWithSeconds(CMTimeGetSeconds(demoVideoDuration) * self.demoFrameSlider.value/100, demoVideoDuration.timescale);
    
    [self updateTimeForDemo:YES toTime:newTime andTraining:NO toTime:newTime];
    
}

- (void)videoPlaybackTimeChanged {
    self.demoFrameSlider.value = round(CMTimeGetSeconds(self.slowMoPlayer.currentTime) / CMTimeGetSeconds(demoVideoDuration));
}


#pragma mark - Helper methods

-(void)updateTimeForDemo:(BOOL)updateDemo toTime:(CMTime)demoTime andTraining:(BOOL)updateTraining toTime:(CMTime)trainingTime
{
    if (updateDemo) {
        
        // Seek to time, using a 20% tolerance
        
//        NSLog(@"Current time: %f", CMTimeGetSeconds(self.slowMoPlayer.currentTime));
//        NSLog(@"Seek to time: %f", CMTimeGetSeconds(demoTime));
//        NSLog(@"With tolerance: %f", CMTimeGetSeconds(CMTimeMakeWithSeconds(CMTimeGetSeconds(demoTime)*.2, demoTime.timescale)));
        
        [self.slowMoPlayer seekToTime:demoTime toleranceBefore:CMTimeMakeWithSeconds(CMTimeGetSeconds(demoTime)*.2, demoTime.timescale) toleranceAfter:CMTimeMakeWithSeconds(CMTimeGetSeconds(demoTime)*.2, demoTime.timescale) completionHandler:^(BOOL finished) {
                    NSLog(@"New time: %f", CMTimeGetSeconds(self.slowMoPlayer.currentTime));
        }];
        

        
        
    }
    
    if (updateTraining) {
        [self.slowMoPlayerTwo seekToTime:trainingTime];
    }
}

-(BOOL)selectMovieToPlayFromViewController:(UIViewController *)controller usingDelegate:(id)delegate
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] || delegate==nil || controller==nil) {
        return NO;
    }
    else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.delegate = delegate;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        [controller presentViewController:picker animated:YES completion:nil];
        return YES;
    }
}

-(void)initializeSlowMoVideoPlayerDemo:(BOOL)demoPlay andTraining:(BOOL)trainingPlay
{
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] init];
    [activityIndicator startAnimating];
    
    if (demoPlay) {
        // Create AVPlayerItem from current video asset
        AVPlayerItem *slowMoPlayerItem = [[AVPlayerItem alloc] initWithAsset:self.slowMoVideoDemo];
        NSLog(@"Can play reverse: %hhd",slowMoPlayerItem.canPlayReverse);
        
        // Initialize AVPlayer if necessary, otherwise replace the current AVPlayerItem
        if (!self.slowMoPlayer) {
            self.slowMoPlayer = [[AVPlayer alloc] initWithPlayerItem:slowMoPlayerItem];
            AVPlayerLayer *slowMoPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.slowMoPlayer];
            [slowMoPlayerLayer setFrame:CGRectMake(self.demoView.frame.origin.x, self.demoView.frame.origin.y, self.demoView.frame.size.width, self.demoView.frame.size.height)];
            [self.view.layer addSublayer:slowMoPlayerLayer];
            
            demoVideoDuration = self.slowMoVideoDemo.duration;
            
        }
        else [self.slowMoPlayer replaceCurrentItemWithPlayerItem:slowMoPlayerItem];
        
    }
    
    if (trainingPlay) {
        AVPlayerItem *slowMoPlayerItemTwo = [[AVPlayerItem alloc] initWithAsset:self.slowMoVideoTraining];
        
        if (!self.slowMoPlayerTwo) {
            self.slowMoPlayerTwo = [[AVPlayer alloc] initWithPlayerItem:slowMoPlayerItemTwo];
            AVPlayerLayer *slowMoPlayerLayerTwo = [AVPlayerLayer playerLayerWithPlayer:self.slowMoPlayerTwo];
            [slowMoPlayerLayerTwo setFrame:CGRectMake(self.trainingView.frame.origin.x, self.trainingView.frame.origin.y, self.trainingView.frame.size.width, self.trainingView.frame.size.height)];
            [self.view.layer addSublayer:slowMoPlayerLayerTwo];
        }
        else [self.slowMoPlayerTwo replaceCurrentItemWithPlayerItem:slowMoPlayerItemTwo];
        
    }
    
    [activityIndicator stopAnimating];
}



#pragma mark - UIImagePickerController Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"finished picking");
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if (CFStringCompare((__bridge_retained CFStringRef)mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        
        self.submittedVideo = [AVAsset assetWithURL:[info objectForKey:UIImagePickerControllerMediaURL]];
        
        self.slowMoVideoTraining = self.submittedVideo;
        [self initializeSlowMoVideoPlayerDemo:NO andTraining:YES];
        
        self.playSloMoButton.enabled = YES;
        self.frameRateStepper.enabled = YES;
        
    } else {
        NSLog(@"Something went wrong");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"cancelled picking");
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - UIActionSheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self selectMovieToPlayFromViewController:self usingDelegate:self];
    } else if (buttonIndex==1) {
        [self performSegueWithIdentifier:@"toRecordVideoViewController" sender:self];
    } else {
        NSLog(@"Press a button");
    }
}


#pragma mark - Navigation

- (IBAction)selectMovieButtonPressed:(UIBarButtonItem *)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Import video from where?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Library", @"Camera", nil];
    [actionSheet showInView:self.view];
    
}


@end
