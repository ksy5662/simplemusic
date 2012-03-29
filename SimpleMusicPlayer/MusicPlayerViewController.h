//
//  MusicPlayerViewController.h
//  SimpleMusicPlayer
//
//  Created by 고 준일 on 12. 1. 2..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface MusicPlayerViewController : UIViewController <UIGestureRecognizerDelegate, MPMediaPickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *albumArtImageView;
@property (strong, nonatomic) IBOutlet UISlider *volumeSlider;
@property (strong, nonatomic) IBOutlet UIButton *prevButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIView *controlPanel;
@property (strong, nonatomic) IBOutlet UILabel *remainTime;
@property (strong, nonatomic) IBOutlet UILabel *playTime;
@property (strong, nonatomic) IBOutlet UILabel *songIndex;
@property (strong, nonatomic) IBOutlet UISlider *progressSlider;
@property (strong, nonatomic) IBOutlet UIButton *shuffleButton;
@property (strong, nonatomic) IBOutlet UIButton *repeatButton;

@property (strong, nonatomic) MPMusicPlayerController *musicPlayer;
@property (assign) int totalSong;
@property (strong, nonatomic) NSTimer *timer;

- (IBAction)volumeChanged:(id)sender;
- (IBAction)skipToPrev:(id)sender;
- (IBAction)skipToNext:(id)sender;
- (IBAction)musicPlay:(id)sender;
- (IBAction)progressChanged:(id)sender;
- (IBAction)shuffleOnOff:(id)sender;
- (IBAction)repeatOnOff:(id)sender;

- (void)setMediaItemCollection:(MPMediaItemCollection *)mediaItemCollection
                 withPlayIndex:(int)index;
- (void)openMediaPicker:(id)sender;
@end
