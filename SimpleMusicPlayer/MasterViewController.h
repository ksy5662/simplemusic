//
//  MasterViewController.h
//  SimpleMusicPlayer
//
//  Created by 고 준일 on 12. 1. 2..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) MPMediaQuery *mediaQuery;
@end
