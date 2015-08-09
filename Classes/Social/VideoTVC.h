//
//  Video.h
//  bishibashi
//
//  Created by Eric on 29/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetVideo.h"
#import "WebImageView.h"
#import "YouTubeView.h"

@interface VideoTVC : UITableViewCell {
	YouTubeView*	_youTubeView;
	
	UILabel*	_titleLbl;
	UILabel*	_submitterLbl;
	UILabel*	_submitdateLbl;
}
@property (nonatomic, retain) YouTubeView* youTubeView;
@property (nonatomic, retain) UILabel* titleLbl;
@property (nonatomic, retain) UILabel* submitterLbl;
@property (nonatomic, retain) UILabel* submitdateLbl;
@end
