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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.playSloMoButton.enabled = NO;
    self.frameRateStepper.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Slow motion

- (IBAction)playSlowMoButtonPressed:(UIButton *)sender {
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] init];
    [activityIndicator startAnimating];
    
    // Create AVPlayerItem from current video asset
    AVPlayerItem *slowMoPlayerItem = [[AVPlayerItem alloc] initWithAsset:self.slowMoVideoDemo];
    
    // Initialize AVPlayer if necessary, otherwise replace the current AVPlayerItem
    if (!self.slowMoPlayer) {
        self.slowMoPlayer = [[AVPlayer alloc] initWithPlayerItem:slowMoPlayerItem];
        AVPlayerLayer *slowMoPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.slowMoPlayer];
        [slowMoPlayerLayer setFrame:CGRectMake(self.demoView.frame.origin.x, self.demoView.frame.origin.y, self.demoView.frame.size.width, self.demoView.frame.size.height)];
        [self.view.layer addSublayer:slowMoPlayerLayer];
    }
    else [self.slowMoPlayer replaceCurrentItemWithPlayerItem:slowMoPlayerItem];
    
//    [self.slowMoPlayer seekToTime:kCMTimeZero];
    
    
    
    AVPlayerItem *slowMoPlayerItemTwo = [[AVPlayerItem alloc] initWithAsset:self.slowMoVideoTraining];
    
    if (!self.slowMoPlayerTwo) {
        self.slowMoPlayerTwo = [[AVPlayer alloc] initWithPlayerItem:slowMoPlayerItemTwo];
        AVPlayerLayer *slowMoPlayerLayerTwo = [AVPlayerLayer playerLayerWithPlayer:self.slowMoPlayerTwo];
        [slowMoPlayerLayerTwo setFrame:CGRectMake(self.trainingView.frame.origin.x, self.trainingView.frame.origin.y, self.trainingView.frame.size.width, self.trainingView.frame.size.height)];
        [self.view.layer addSublayer:slowMoPlayerLayerTwo];
    }
    else [self.slowMoPlayerTwo replaceCurrentItemWithPlayerItem:slowMoPlayerItemTwo];
    
//    [self.slowMoPlayerTwo seekToTime:kCMTimeZero];

    
//    self.slowMoPlayer.actionAtItemEnd = 1;
//    self.slowMoPlayerTwo.actionAtItemEnd = 1;
    
    [activityIndicator stopAnimating];
    
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
    
    self.slowMoVideoDemo = mixComposition;
    self.slowMoVideoTraining = mixCompositionTwo;
    
    self.playSloMoButton.enabled = YES;
    
    [self initializeSlowMoVideoPlayers];
    
}



#pragma mark - Helper methods

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

-(void)initializeSlowMoVideoPlayers
{
    // Create AVPlayerItem from current video asset
    AVPlayerItem *slowMoPlayerItem = [[AVPlayerItem alloc] initWithAsset:self.slowMoVideoDemo];
    
    // Initialize AVPlayer if necessary, otherwise replace the current AVPlayerItem
    if (!self.slowMoPlayer) {
        self.slowMoPlayer = [[AVPlayer alloc] initWithPlayerItem:slowMoPlayerItem];
        AVPlayerLayer *slowMoPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.slowMoPlayer];
        [slowMoPlayerLayer setFrame:CGRectMake(self.demoView.frame.origin.x, self.demoView.frame.origin.y, self.demoView.frame.size.width, self.demoView.frame.size.height)];
        [self.view.layer addSublayer:slowMoPlayerLayer];
    }
    else [self.slowMoPlayer replaceCurrentItemWithPlayerItem:slowMoPlayerItem];
    
    //    [self.slowMoPlayer seekToTime:kCMTimeZero];
    
    
    
    AVPlayerItem *slowMoPlayerItemTwo = [[AVPlayerItem alloc] initWithAsset:self.slowMoVideoTraining];
    
    if (!self.slowMoPlayerTwo) {
        self.slowMoPlayerTwo = [[AVPlayer alloc] initWithPlayerItem:slowMoPlayerItemTwo];
        AVPlayerLayer *slowMoPlayerLayerTwo = [AVPlayerLayer playerLayerWithPlayer:self.slowMoPlayerTwo];
        [slowMoPlayerLayerTwo setFrame:CGRectMake(self.trainingView.frame.origin.x, self.trainingView.frame.origin.y, self.trainingView.frame.size.width, self.trainingView.frame.size.height)];
        [self.view.layer addSublayer:slowMoPlayerLayerTwo];
    }
    else [self.slowMoPlayerTwo replaceCurrentItemWithPlayerItem:slowMoPlayerItemTwo];
}



#pragma mark - UIImagePickerController Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"finished picking");
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if (CFStringCompare((__bridge_retained CFStringRef)mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        
        self.submittedVideo = [AVAsset assetWithURL:[info objectForKey:UIImagePickerControllerMediaURL]];

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
