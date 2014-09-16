//
//  KPREditVideoViewController.h
//  SlowMoVideo
//
//  Created by Kyle Rand on 9/15/14.
//  Copyright (c) 2014 PracticeCoding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>

@interface KPREditVideoViewController : UIViewController <UIImagePickerControllerDelegate, MPMediaPickerControllerDelegate> {
    BOOL isSelectingAssetOne;
}

@property (strong, nonatomic) AVAsset *videoAssetOne;
@property (strong, nonatomic) AVAsset *videoAssetTwo;
@property (strong, nonatomic) AVAsset *audioAsset;
@property (weak, nonatomic) UIActivityIndicatorView *activityIndicator;

- (IBAction)loadAssetOneButtonPressed:(UIButton *)sender;
- (IBAction)loadAssetTwoButtonPressed:(UIButton *)sender;
- (IBAction)loadAudioButtonPressed:(UIButton *)sender;
- (IBAction)mergeButtonPressed:(UIButton *)sender;
- (IBAction)slowMoButtonPressed:(UIButton *)sender;

-(BOOL)startMediaBrowserFromViewController:(UIViewController*)controller usingDelegate:(id)delegate;
-(void)exportDidFinish:(AVAssetExportSession*)session;

@end
