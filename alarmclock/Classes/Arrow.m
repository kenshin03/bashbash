//
//  arrow.m
//  bishibashi
//
//  Created by Eric on 14/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Arrow.h"
#include <math.h>

@implementation Arrow
@synthesize longArrow = _longArrow;
@synthesize speed = _speed;
@synthesize angle = _angle;
@synthesize owner = _owner;
@synthesize orientation = _orientation;
@synthesize startTime = _startTime;

static inline double radians (double degrees) {return degrees * M_PI/180;}

static const CGRect startLongArrowRectP = {{177, 161}, {20, 60}};
static const CGRect startLongArrowRectL = {{152, 113}, {20, 45}};
static const CGRect startLongArrowRectR = {{75, 90}, {10, 60}};
static const CGRect startLongArrowRectI = {{115, 130}, {20, 60}};

static const CGRect startShortArrowRectP = {{177, 172}, {20, 35}};
static const CGRect startShortArrowRectL = {{152, 124}, {20, 25}};
static const CGRect startShortArrowRectR = {{75, 100}, {10, 35}};
static const CGRect startShortArrowRectI = {{115, 141}, {20, 35}};

- (id)initWithOwner:(id)owner ForLong:(BOOL)longArrow AndAngle:(float)angle	AndSpeed:(float)speed AndOrientation:(UIInterfaceOrientation) orientation{
	self.startTime = 	[NSDate date];
	self.orientation = orientation;
	self.owner = owner;
	self.speed = speed;
	self.angle = angle;
	self.longArrow = longArrow;
	UIImage *tmpImage = [UIImage imageNamed:@"arrow.png"];
	self = [super initWithImage:tmpImage];
	switch (self.orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
			if (self.longArrow)
				[self setFrame:startLongArrowRectP];
			else
				[self setFrame:startShortArrowRectP];
			break;
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
			if (self.longArrow)
				[self setFrame:startLongArrowRectL];
			else
				[self setFrame:startShortArrowRectL];
			break;
		case (10):
			if (self.longArrow)
				[self setFrame:startLongArrowRectR];
			else
				[self setFrame:startShortArrowRectR];
			break;
		case (11):
			if (self.longArrow)
				[self setFrame:startLongArrowRectI];
			else
				[self setFrame:startShortArrowRectI];
			break;
	}
	

	[self.layer setAnchorPoint:CGPointMake(0.5, 1.0)];
	return self;
}

- (void)setAngle:(float)angle	AndSpeed:(float)speed
{
	self.startTime = 	[NSDate date];
	self.speed = speed;
	self.angle = angle;
	
	[self.layer setAnchorPoint:CGPointMake(0.5, 1.0)];
	return self;
}

- (void) dealloc
{
	NSLog(@"dealloc arrow");
	[super dealloc];
}


- (void) showTime
{
	NSDate* now = [NSDate date];
	NSTimeInterval timeDiff = [now timeIntervalSinceDate:self.startTime];
	if (self.longArrow)
		self.transform = CGAffineTransformMakeRotation(radians(self.angle)+radians(360.*timeDiff/(self.speed*3.)));
	else
		self.transform = CGAffineTransformMakeRotation(radians(self.angle)+radians(30.*timeDiff/(self.speed*3.)));
}


@end
