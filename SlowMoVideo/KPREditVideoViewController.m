//
//  KPREditVideoViewController.m
//  SlowMoVideo
//
//  Created by Kyle Rand on 9/15/14.
//  Copyright (c) 2014 PracticeCoding. All rights reserved.
//

#import "KPREditVideoViewController.h"

@interface KPREditVideoViewController ()

@end

@implementation KPREditVideoViewController

@synthesize videoAssetOne, videoAssetTwo, audioAsset;
@synthesize activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBActions

- (IBAction)loadAssetOneButtonPressed:(UIButton *)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot find a saved photos album" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
        [alert show];
    } else {
        isSelectingAssetOne = TRUE;
        [self startMediaBrowserFromViewController:self usingDelegate:self];
    }
}

- (IBAction)loadAssetTwoButtonPressed:(UIButton *)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot find a saved photos album" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
        [alert show];
    } else {
        isSelectingAssetOne = FALSE;
        [self startMediaBrowserFromViewController:self usingDelegate:self];
    }
}

- (IBAction)loadAudioButtonPressed:(UIButton *)sender {
    MPMediaPickerController *audioPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAny];
    audioPicker.delegate = self;
    audioPicker.prompt = @"Select audio";
    [self presentViewController:audioPicker animated:YES completion:nil];
}

- (IBAction)mergeButtonPressed:(UIButton *)sender {
    // Begin activity indicator for UX
    [activityIndicator startAnimating];
    
    // Create AVMutableComposition, to hold Track instances
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    // Get video tracks
    if (videoAssetOne != nil && videoAssetTwo != nil) {
        AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetOne.duration) ofTrack:[[videoAssetOne tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetTwo.duration) ofTrack:[[videoAssetTwo tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:videoAssetOne.duration error:nil];
    }
    
    // Get audio track
    if (audioAsset!=nil){
        AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeAdd(videoAssetOne.duration, videoAssetTwo.duration)) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    }
    
    // Get paths
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideo-%d.mov", arc4random() % 1000]];
    NSURL *fileURL = [NSURL fileURLWithPath:myPathDocs];
    
    // Create exporter
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL = fileURL;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self exportDidFinish:exporter];
        });
    }];
    
}

- (IBAction)slowMoButtonPressed:(UIButton *)sender {
    // Create AVMutableComposition
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    // Create video track
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // Insert video into track, watching for errors
    NSError *error = nil;
    BOOL videoInsertResult = [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetOne.duration) ofTrack:[[videoAssetOne tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:&error];
    
    if (error || !videoInsertResult) {
        NSLog(@"%@", error);
    }
    
    // Scale video
    double videoScaleFactor = 2.0;
    CMTime videoDuration = videoAssetOne.duration;
    
    [videoTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, videoDuration) toDuration:CMTimeMake(videoDuration.value*videoScaleFactor, videoDuration.timescale)];

    // Prepare file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"slowmoVideo-%d.mov", arc4random() % 1000]];
    NSURL *fileURL = [NSURL fileURLWithPath:myPathDocs];
    
    // Send to delegate
    NSLog(@"Asset prepared");
    [self.delegate retrieveVideo:mixComposition];
    NSLog(@"Passed mixComposition to delegate");
    
    /*
    // Export
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL = fileURL;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self exportDidFinish:exporter];
        });
    }];
     */
}

#pragma mark - Helper Methods

-(BOOL)startMediaBrowserFromViewController:(UIViewController*)controller usingDelegate:(id)delegate
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] || controller == nil || delegate == nil) {
        return NO;
    } else {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
        picker.allowsEditing = YES;
        picker.delegate = delegate;
        
        [controller presentViewController:picker animated:YES completion:nil];
        return YES;
    }
}

-(void)exportDidFinish:(AVAssetExportSession*)session
{
    if (session.status == AVAssetExportSessionStatusCompleted) {
        NSURL *outputURL = session.outputURL;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
            [library writeVideoAtPathToSavedPhotosAlbum:outputURL completionBlock:^(NSURL *assetURL, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Problem saving video" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                    } else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Video saved successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                    }
                });
            }];
        }
    }
    
    audioAsset = nil;
    videoAssetOne = nil;
    videoAssetTwo = nil;
    [activityIndicator stopAnimating];
}


#pragma mark - UIImagePickerController Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if (CFStringCompare((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        if (isSelectingAssetOne) {
            NSLog(@"Video one loaded");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Video one loaded" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            videoAssetOne = [AVAsset assetWithURL:[info objectForKey:UIImagePickerControllerMediaURL]];
        } else {
            NSLog(@"Video two loaded");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Video two loaded" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            videoAssetTwo = [AVAsset assetWithURL:[info objectForKey:UIImagePickerControllerMediaURL]];
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"Cancelled asset upload");
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -MPMediaPickerController Delegate

-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    NSArray *selectedSong = [mediaItemCollection items];
    if ([selectedSong count]) {
        MPMediaItem *songItem = [selectedSong objectAtIndex:0];
        NSURL *songURL = [songItem valueForProperty:MPMediaItemPropertyAssetURL];
        audioAsset = [AVAsset assetWithURL:songURL];
        
        NSLog(@"Audio loaded");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Audio track selected" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    } else {
        NSLog(@"Audio could not load, please select a proper track asset");
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    NSLog(@"Cancelled audio selection");
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
