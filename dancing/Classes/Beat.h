//
//  Beat.h
//  bishibashi
//
//  Created by Eric on 04/07/2010.
//  Copyright 2010 Red Soldier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediaManager.h"

typedef enum _beatType
{
	k2Beat=0,
	k4Beat=1,
	k8Beat=2,
	kFinishBeat =3
}BeatType;

@interface Beat : UIImageView {
	BeatType _theBeatType;
	
}

@property (nonatomic, assign) BeatType theBeatType;

-(NSTimeInterval) getTime:(float)constant;
- (void) show:(NSNumber*)constant;

@end
