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

@interface KPRViewController ()

@end

@implementation KPRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.playMovieButton.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

- (IBAction)selectMovieButtonPressed:(UIBarButtonItem *)sender {
    [self selectMovieToPlayFromViewController:self usingDelegate:self];
}

#pragma mark - Slow motion

- (IBAction)playSlowMoButtonPressed:(UIButton *)sender {
    AVPlayerItem *slowMoPlayerItem = [[AVPlayerItem alloc] initWithAsset:self.basicMotion.video];
    AVPlayer *slowMoPlayer = [[AVPlayer alloc] initWithPlayerItem:slowMoPlayerItem];
    
    AVPlayerLayer *slowMoPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:slowMoPlayer];
    [slowMoPlayerLayer setFrame:CGRectMake(self.demoView.frame.origin.x, self.demoView.frame.origin.y, self.demoView.frame.size.width, self.demoView.frame.size.height)];
    [self.view.layer addSublayer:slowMoPlayerLayer];
    [slowMoPlayer seekToTime:kCMTimeZero];
    
    [slowMoPlayer play];
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

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[KPREditVideoViewController class]]) {
        KPREditVideoViewController *targetViewController = segue.destinationViewController;
        targetViewController.delegate = self;
        NSLog(@"target view controller set as %@", targetViewController.delegate);
    }
}

#pragma mark - KPREditVideoViewController - Delegate methods

-(void)retrieveSloMoVideo:(AVAsset *)video
{
    self.slowMoVideo = video;
    NSLog(@"set slowMoVideo asset from editor view");
}

#pragma mark - KPRChooseMotionTableViewController - Delegate methods

-(void)retrieveVideoAsset:(AVAsset *)video
{
    NSLog(@"Retrieved slowmotion video");
}





@end
