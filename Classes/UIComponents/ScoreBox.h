//
//  ScoreBox.h
//  bishibashi
//
//  Created by Eric on 05/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediaManager.h"

@interface ScoreBox : UIImageView {
	int	_score;
	MediaManager *sharedSoundEffectsManager;
	
	
}

@property (nonatomic, assign) int score;

@end
