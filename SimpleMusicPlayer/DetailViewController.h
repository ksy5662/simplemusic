//
//  DetailViewController.h
//  SimpleMusicPlayer
//
//  Created by 고 준일 on 12. 1. 2..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) MPMediaItemCollection *mediaItemCollection;

@end
