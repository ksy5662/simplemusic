//
//  MusicPlayerViewController.m
//  SimpleMusicPlayer
//
//  Created by 고 준일 on 12. 1. 2..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "MusicPlayerViewController.h"

@interface MusicPlayerViewController (Private)
- (void)registerForMediaPlayerNotifications;
- (void)handleTapGesture:(UIGestureRecognizer *)sender;
- (NSString *)convertTimeIntervalToSecond:(NSTimeInterval)timeInterval;
@end

@implementation MusicPlayerViewController
@synthesize albumArtImageView;
@synthesize volumeSlider;
@synthesize prevButton;
@synthesize nextButton;
@synthesize playButton;
@synthesize controlPanel;
@synthesize remainTime;
@synthesize playTime;
@synthesize songIndex;
@synthesize progressSlider;
@synthesize shuffleButton;
@synthesize repeatButton;
@synthesize musicPlayer = _musicPlayer;
@synthesize totalSong = _totalSong;
@synthesize timer = _timer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
        self.musicPlayer.repeatMode = NO;
        self.musicPlayer.shuffleMode = NO;
        self.totalSong = 0;
        [self registerForMediaPlayerNotifications];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Volume 설정
    self.volumeSlider.value = self.musicPlayer.volume;
    
    // Navigation Bar 색상 변경
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    // UIGesture
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                 action:@selector(handleTapGesture:)];
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired = 1;
    [self.albumArtImageView addGestureRecognizer:tapGesture];
    
    UIBarButtonItem *pickerBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemOrganize
                                                                               target: self
                                                                               action: @selector(openMediaPicker:)];
    [self.navigationItem setLeftBarButtonItem: pickerBtn];
}

- (void)openMediaPicker:(id)sender {
    MPMediaPickerController *picker =
    [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAnyAudio];
    
    [picker setDelegate: self];
    [picker setAllowsPickingMultipleItems: YES];
    [self presentModalViewController: picker animated: YES];
}

- (void)viewDidUnload
{
    [self setAlbumArtImageView:nil];
    [self setVolumeSlider:nil];
    [self setPrevButton:nil];
    [self setNextButton:nil];
    [self setPlayButton:nil];
    [self setControlPanel:nil];
    [self setRemainTime:nil];
    [self setPlayTime:nil];
    [self setSongIndex:nil];
    [self setProgressSlider:nil];
    [self setShuffleButton:nil];
    [self setRepeatButton:nil];
    [self setMusicPlayer:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)volumeChanged:(id)sender {
    UISlider *volSlider = sender;
	
	if (volSlider.value >= 0.0 && volSlider.value <= 1.0) {
		self.musicPlayer.volume = volSlider.value;
	}
}

- (IBAction)skipToPrev:(id)sender {
    [self.musicPlayer skipToPreviousItem];
}

- (IBAction)skipToNext:(id)sender {
    [self.musicPlayer skipToNextItem];
}

- (IBAction)musicPlay:(id)sender {
    if (self.musicPlayer.playbackState == MPMoviePlaybackStatePlaying) {
		[self.musicPlayer pause];
	} else if (self.musicPlayer.playbackState == MPMoviePlaybackStatePaused) {
		[self.musicPlayer play];
	}
}

- (IBAction)progressChanged:(id)sender {
    UISlider *selSlider = sender;
    
    MPMediaItem *currentSong = self.musicPlayer.nowPlayingItem;
    NSTimeInterval songDuration = [[currentSong valueForProperty:MPMediaItemPropertyPlaybackDuration] intValue];
    
    NSTimeInterval newPlaybackTime = songDuration * [selSlider value];
    
    self.musicPlayer.currentPlaybackTime = newPlaybackTime;
}

- (IBAction)shuffleOnOff:(id)sender {
    if ([self.shuffleButton isSelected]) {
        [self.shuffleButton setSelected:NO];
        self.musicPlayer.shuffleMode = NO;
    } else {
        [self.shuffleButton setSelected:YES];
        self.musicPlayer.shuffleMode = YES;
    }
}

- (IBAction)repeatOnOff:(id)sender {
    if ([self.repeatButton isSelected]) {
        [self.repeatButton setSelected:NO];
        self.musicPlayer.repeatMode = NO;
    } else {
        [self.repeatButton setSelected:YES];
        self.musicPlayer.repeatMode = YES;
    }
}

- (void)setMediaItemCollection:(MPMediaItemCollection *)mediaItemCollection
                 withPlayIndex:(int)index {

    self.totalSong = [mediaItemCollection.items count];
    [self.musicPlayer setQueueWithItemCollection: mediaItemCollection];
    [self.musicPlayer setNowPlayingItem: [mediaItemCollection.items objectAtIndex: index]];
    [self.musicPlayer play];
    
}

- (void)handleTapGesture:(UIGestureRecognizer *)sender 
{
    if (self.controlPanel.hidden) {
        self.controlPanel.hidden = NO;
    } else {
        self.controlPanel.hidden = YES;
    }
}

- (void)registerForMediaPlayerNotifications {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	[notificationCenter addObserver: self
                           selector: @selector(handle_NowPlayingItemChanged:)
                               name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object: self.musicPlayer];
	
	[notificationCenter addObserver: self
                           selector: @selector(handle_PlaybackStateChanged:)
                               name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                             object: self.musicPlayer];
    
	[self.musicPlayer beginGeneratingPlaybackNotifications];
}

- (void)handle_NowPlayingItemChanged:(id)notification 
{
	MPMediaItem *currentItem = [self.musicPlayer nowPlayingItem];
	
	if (currentItem) {
		
		MPMediaItemArtwork *artwork = [currentItem valueForProperty:MPMediaItemPropertyArtwork];
		[albumArtImageView setImage:[artwork imageWithSize: CGSizeMake (320, 320)]];
        
        NSString *title = [currentItem valueForProperty: MPMediaItemPropertyTitle];
        self.navigationItem.title = title;
        
        NSString *sIndex = [NSString stringWithFormat: @"%d/%d", self.musicPlayer.indexOfNowPlayingItem, self.totalSong];
        self.songIndex.text = sIndex;
        
        self.playTime.text = @"";
        self.remainTime.text = @"";
	}
}

- (void)handle_PlaybackStateChanged:(id)notification
{
    
	if (self.musicPlayer.playbackState == MPMoviePlaybackStatePlaying) {
		[self.playButton setImage:[UIImage imageNamed:@"pausebtn_92x57.png"]
                      forState:UIControlStateNormal];
		[self.playButton setImage:[UIImage imageNamed:@"pausebtn_92x57_dim.png"]
                      forState:UIControlStateHighlighted];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                      target: self
                                                    selector: @selector(updatePlayTime:)
                                                    userInfo: nil
                                                     repeats: YES];
        
	} else if (self.musicPlayer.playbackState == MPMoviePlaybackStatePaused) {
		[self.playButton setImage:[UIImage imageNamed:@"playbtn_92x57.png"]
                      forState:UIControlStateNormal];
		[self.playButton setImage:[UIImage imageNamed:@"playbtn_92x57_dim.png"]
                      forState:UIControlStateHighlighted];
        [self.timer invalidate];
        [self setTimer: nil];
        
	}
    
}

- (void)updatePlayTime:(NSTimer *)timer
{
    MPMediaItem *currentSong = self.musicPlayer.nowPlayingItem;
    NSTimeInterval songDuration = [[currentSong valueForProperty:MPMediaItemPropertyPlaybackDuration] intValue];
    
    playTime.text = [self convertTimeIntervalToSecond: self.musicPlayer.currentPlaybackTime];
    remainTime.text = [self convertTimeIntervalToSecond: songDuration - self.musicPlayer.currentPlaybackTime];
    
    self.progressSlider.value = self.musicPlayer.currentPlaybackTime / songDuration;
    
}

- (NSString *)convertTimeIntervalToSecond:(NSTimeInterval)timeInterval
{
    int pastMin = floor(timeInterval /60);
    int pastSec = round(timeInterval - pastMin * 60);
    return [NSString stringWithFormat: @"%02d:%02d", pastMin, pastSec];
}

- (void) mediaPicker: (MPMediaPickerController *) mediaPicker
   didPickMediaItems: (MPMediaItemCollection *) collection {
	
    [self dismissModalViewControllerAnimated: YES];
    if (collection) {
        [self.musicPlayer stop];
        [self.musicPlayer setQueueWithItemCollection:collection];
        [self.musicPlayer setNowPlayingItem: [collection.items objectAtIndex: 0]];
        [self.musicPlayer play];
    }
}
- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
    [self dismissModalViewControllerAnimated: YES];
}


                       
@end
