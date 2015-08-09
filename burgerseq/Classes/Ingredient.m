//
//  Ingredient.m
//  bishibashi
//
//  Created by Eric on 21/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Ingredient.h"


@implementation Ingredient
@synthesize color = _color;
@synthesize pos = _pos;
@synthesize sample = _sample;
@synthesize orientation = _orientation;

static const CGRect startRectP = {{40, 30}, {120, 25}};
static const CGRect startRectL = {{40, 30}, {120, 16}};
static const CGRect startRectR = {{15, 30}, {60, 16}};
static const CGRect startRectI = {{0, 30}, {110, 25}};

static const CGRect startSampleRectP = {{180, 30}, {120, 25}};
static const CGRect startSampleRectL = {{180, 30}, {120, 16}};
static const CGRect startSampleRectR = {{35, 30}, {80, 16}};
static const CGRect startSampleRectI = {{130, 30}, {110, 25}};

- (void) dealloc
{
	NSLog(@"dealloc ingredient");
	[super dealloc];
}

- (id)initWithColor:(ButState)color	AndPos:(int)pos AndSample:(BOOL)isSample AndOrientation:(UIInterfaceOrientation)orientation
{
	self.orientation = orientation;
	self.color = color;
	self.pos = pos;
	self.sample = isSample;
	UIImage *tmpImage;
		switch (self.color)	{
			case (kRed):
				tmpImage = [UIImage imageNamed:@"tomato.png"];
				self = [super initWithImage:tmpImage];
				break;
			case (kBlue):
				tmpImage = [UIImage imageNamed:@"meat.png"];
				self = [super initWithImage:tmpImage];
				break;
			case (kGreen):
				tmpImage = [UIImage imageNamed:@"vegatable.png"];
				self = [super initWithImage:tmpImage];
				break;
			case (-1):
				tmpImage = [UIImage imageNamed:@"top.png"];
				self = [super initWithImage:tmpImage];
				break;
			case (-2):
				tmpImage = [UIImage imageNamed:@"bottom.png"];
				self = [super initWithImage:tmpImage];
				break;
		}
	self.frame = CGRectMake(0,0,0,0);

	return self;
}



- (void) show
{
	if (self.sample)	{
		switch (self.orientation)	{
			case (UIInterfaceOrientationPortrait):
			case (UIInterfaceOrientationPortraitUpsideDown):
				self.frame = startRectP;
				break;
			case (UIInterfaceOrientationLandscapeLeft):
			case (UIInterfaceOrientationLandscapeRight):
				self.frame = startRectL;
				break;
			case (11):
				self.frame = startRectI;
				break;
			case (10):
				[self setHidden:YES];
				break;
		}
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		switch (self.orientation)	{
			case (UIInterfaceOrientationPortrait):
			case (UIInterfaceOrientationPortraitUpsideDown):
				self.frame = CGRectMake(self.frame.origin.x, 300-self.pos*(self.frame.size.height-10), self.frame.size.width, self.frame.size.height);
				break;
			case (UIInterfaceOrientationLandscapeLeft):
			case (UIInterfaceOrientationLandscapeRight):
				self.frame = CGRectMake(self.frame.origin.x, 180-self.pos*(self.frame.size.height-7), self.frame.size.width, self.frame.size.height);
				break;
			case (11):
				self.frame = CGRectMake(self.frame.origin.x, 180-self.pos*(self.frame.size.height-10), self.frame.size.width, self.frame.size.height);
				break;				
			case (10):
				[self setHidden:YES];
				break;
		}
		[UIView commitAnimations];
	}
	else {
		switch (self.orientation)	{
			case (UIInterfaceOrientationPortrait):
			case (UIInterfaceOrientationPortraitUpsideDown):
				self.frame = startSampleRectP;
				self.frame = CGRectMake(self.frame.origin.x, 300-self.pos*(self.frame.size.height-10), self.frame.size.width, self.frame.size.height);
				break;
			case (UIInterfaceOrientationLandscapeLeft):
			case (UIInterfaceOrientationLandscapeRight):
				self.frame = startSampleRectL;
				self.frame = CGRectMake(self.frame.origin.x, 180-self.pos*(self.frame.size.height-7), self.frame.size.width, self.frame.size.height);
				break;
			case (11):
				self.frame = startSampleRectI;
				self.frame = CGRectMake(self.frame.origin.x, 180-self.pos*(self.frame.size.height-10), self.frame.size.width, self.frame.size.height);
				break;
			case (10):
				self.frame = startSampleRectR;
				self.frame = CGRectMake(self.frame.origin.x, 180-self.pos*(self.frame.size.height-7), self.frame.size.width, self.frame.size.height);
				break;
		}
	}

}	

@end
