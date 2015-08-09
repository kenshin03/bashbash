//
//  VersusResultView.h
//  bishibashi
//
//  Created by ktang on 9/28/10.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediaManager.h"


@interface VersusResultView : UIView {
	MediaManager *sharedSoundEffectsManager;
	UIImageView *koImageView;
	UIImageView *youWinImageView;
	UIImageView *youLoseImageView;
}
@property (nonatomic, assign) UIImageView *koImageView;
@property (nonatomic, assign) UIImageView *youWinImageView;
@property (nonatomic, assign) UIImageView *youLoseImageView;

- (void)showKOMessage;
- (void)showYouWinMessage;
- (void)showYouLoseMessage;

@end