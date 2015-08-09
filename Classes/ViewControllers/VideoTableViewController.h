//
//  VideoTableViewController.h
//  bishibashi
//
//  Created by Eric on 29/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetVideo.h"
#import "Constants.h"
#import "VideoTVC.h"
@interface VideoTableViewController : UITableViewController <GetVideoDelegate> {
	GetVideo*	_videoGetter;
	NSArray*	_videos;
	int	_page;
}
@property (nonatomic, assign) int page;
@property (nonatomic, retain) GetVideo* videoGetter;
@property (nonatomic, retain) NSArray* videos;
@end
