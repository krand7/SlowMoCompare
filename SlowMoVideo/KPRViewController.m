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
    self.playMovieButton.enabled = NO;
    self.playSloMoButton.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Slow motion

- (IBAction)playMovieButtonPressed:(UIButton *)sender {
    if (self.selectedMovie) {
        NSLog(@"movie passed was: %@", self.selectedMovie);
        [[self.selectedMovie view] setFrame:CGRectMake(self.trainingView.frame.origin.x, self.trainingView.frame.origin.y, self.trainingView.frame.size.width, self.trainingView.frame.size.height)];
        [self.view addSubview:self.selectedMovie.view];
        self.selectedMovie.shouldAutoplay = YES;
        
        [self.selectedMovie play];
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.selectedMovie];
    } else {
    }
}

- (IBAction)playSlowMoButtonPressed:(UIButton *)sender {
    
    // Create AVPlayerItem from current video asset
    AVPlayerItem *slowMoPlayerItem = [[AVPlayerItem alloc] initWithAsset:self.slowMoVideo];
    
    // Initialize AVPlayer if necessary, otherwise replace the current AVPlayerItem
    if (!self.slowMoPlayer) {
        self.slowMoPlayer = [[AVPlayer alloc] initWithPlayerItem:slowMoPlayerItem];
        AVPlayerLayer *slowMoPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.slowMoPlayer];
        [slowMoPlayerLayer setFrame:CGRectMake(self.demoView.frame.origin.x, self.demoView.frame.origin.y, self.demoView.frame.size.width, self.demoView.frame.size.height)];
        [self.view.layer addSublayer:slowMoPlayerLayer];
    }
    else [self.slowMoPlayer replaceCurrentItemWithPlayerItem:slowMoPlayerItem];
    
    [self.slowMoPlayer seekToTime:kCMTimeZero];
    [self.slowMoPlayer play];
    
}

- (IBAction)frameRateStepperChanged:(UIStepper *)sender {

    self.playSloMoButton.enabled = NO;
    

    
    // Adjust frame rate
    frameRateScaleFactor = self.frameRateStepper.value;
    self.frameRateLabel.text = [NSString stringWithFormat:@"1/%0.0f", frameRateScaleFactor];
    
    // Create AVMutableComposition
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    // Create video track
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // Insert video into track, watching for errors
    NSError *error = nil;
    BOOL videoInsertResult = [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.basicMotion.video.duration) ofTrack:[[self.basicMotion.video tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:&error];
    
    if (error || !videoInsertResult) {
        NSLog(@"%@", error);
    }
    
    
    // Scale video
    CMTime videoDuration = self.basicMotion.video.duration;
    [videoTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, videoDuration) toDuration:CMTimeMake(videoDuration.value*frameRateScaleFactor, videoDuration.timescale)];
    
    self.slowMoVideo = mixComposition;
    
    self.playSloMoButton.enabled = YES;
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



#pragma mark - UIImagePickerController Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"finished picking");
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if (CFStringCompare((__bridge_retained CFStringRef)mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        self.selectedMovie = [[MPMoviePlayerController alloc] initWithContentURL:[info objectForKey:UIImagePickerControllerMediaURL]];
        NSLog(@"%@", self.selectedMovie);
        self.playMovieButton.enabled = YES;
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
