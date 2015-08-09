//
//  UFO.m
//  bishibashi
//
//  Created by Eric on 14/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UFO.h"


@implementation UFO
@synthesize speed = _speed;
@synthesize color = _color;
@synthesize toLeft = _toLeft;
@synthesize orientation = _orientation;

static const CGRect leftRectP = {{320, 260}, {80, 30}};
static const CGRect leftRectL = {{220, 150}, {80, 20}};
static const CGRect leftRectR = {{100, 150}, {40, 20}};
static const CGRect leftRectI = {{180, 165}, {60, 18}};

static const CGRect rightRectP = {{0, 260}, {80, 30}};
static const CGRect rightRectL = {{0, 150}, {80, 20}};
static const CGRect rightRectR = {{0, 150}, {40, 20}};
static const CGRect rightRectI = {{0, 165}, {60, 18}};

- (id)copyWithZone:(NSZone *)zone	{
	NSLog(@"copy UFO");
	UFO* new = [[UFO alloc] initWithImage:self.image];
	new.speed = self.speed;
	new.color = self.color;
	new.toLeft = self.toLeft;
	new.orientation = self.orientation;
	return new;
}

- (id)initWithSeq:(int)seq AndToLeft:(BOOL)toLeft AndOrientation:(UIInterfaceOrientation)orientation {
	NSLog(@"alloc UFO");
	self.orientation = orientation;
	self.toLeft = toLeft;
	
	NSString* filename;
	if (toLeft)
		filename= [[NSString alloc] initWithFormat:@"goleft%d.png", (seq+1)];
	else
		filename= [[NSString alloc] initWithFormat:@"goright%d.png", (seq+1)];

	
	UIImage* tmpImage = [UIImage imageNamed:filename];
	[filename release];
	self = [super initWithImage:tmpImage];
	return self;
}


- (void) dealloc
{
	NSLog(@"dealloc UFO");
	[super dealloc];
}


- (void) show
{
	switch (self.orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
			if (self.toLeft)	{
				[self setFrame:leftRectP];
			}
			else {
				[self setFrame:rightRectP];
			}
			break;
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
			if (self.toLeft)	{
				[self setFrame:leftRectL];
			}
			else {
				[self setFrame:rightRectL];
			}
			break;
		case (10):
			if (self.toLeft)	{
				[self setFrame:leftRectR];
			}
			else {
				[self setFrame:rightRectR];
			}
			break;
		case (11):
			if (self.toLeft)	{
				[self setFrame:leftRectI];
			}
			else {
				[self setFrame:rightRectI];
			}
		break;	}
	

	[UIView beginAnimations:@"show" context:nil];
	[UIView setAnimationDuration:self.speed];
	switch (self.orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
			if (self.toLeft)	{
				[self setFrame:rightRectP];
			}
			else {
				[self setFrame:leftRectP];
			}
			break;
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
			if (self.toLeft)	{
				[self setFrame:rightRectL];
			}
			else {
				[self setFrame:leftRectL];
			}
			break;
		case (10):
			if (self.toLeft)	{
				[self setFrame:rightRectR];
			}
			else {
				[self setFrame:leftRectR];
			}
			break;
		case (11):
			if (self.toLeft)	{
				[self setFrame:rightRectI];
			}
			else {
				[self setFrame:leftRectI];
			}
		break;	}
	

	[UIView commitAnimations];
											  
}

@end
