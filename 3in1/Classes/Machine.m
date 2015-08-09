//
//  machine.m
//  bishibashi
//
//  Created by Eric on 08/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Machine.h"


@implementation Machine
@synthesize owner = _owner;
@synthesize color = _color;
@synthesize pos = _pos;
@synthesize finalPos = _finalPos;
@synthesize integrated = _integrated;
@synthesize orientation = _orientation;


static const CGRect startRectP = {{200, 0}, {70, 70}};
static const CGRect startRectL = {{140, 0}, {80, 60}};
static const CGRect startRectR = {{55, 0}, {55, 60}};


- (id)initWithOwner:(id)owner AndColor:(ButState)color	AndOrientation:(UIInterfaceOrientation) orientation{
	self.orientation = orientation;
	self.color = color;
	self.integrated = NO;
	self.owner = owner;
	
	UIImage *tmpImage;
	switch (self.color)	{
		case (kRed):
			tmpImage = [UIImage imageNamed:@"eastrail.png"];
			break;
		case (kBlue):
			tmpImage = [UIImage imageNamed:@"disney.png"];
			break;
		case (kGreen):
			tmpImage = [UIImage imageNamed:@"mtr.png"];
			break;
	}
	self = [super initWithImage:tmpImage];
	//[tmpImage release];
	return self;
}


- (void) dealloc
{
	NSLog(@"dealloc machine");
	[super dealloc];
}

- (void) toIntegrate
{
	self.integrated=YES;
	[UIView beginAnimations:@"integrate1" context:[NSNumber numberWithInt:self.pos]];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self.owner]; 
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
	switch (self.pos)	{
		case (0):
			switch (self.orientation)	{
				case (UIInterfaceOrientationPortrait):
				case (UIInterfaceOrientationPortraitUpsideDown):
					[self setFrame:self.finalPos];
					break;
				case (UIInterfaceOrientationLandscapeLeft):
				case (UIInterfaceOrientationLandscapeRight):
					[self setFrame:self.finalPos];
					break;
				case (10):
				case (11):
					[self setFrame:self.finalPos];
					break;

			}	
			break;
		case (1):
			switch (self.orientation)	{
				case (UIInterfaceOrientationPortrait):
				case (UIInterfaceOrientationPortraitUpsideDown):
					[self setFrame:self.finalPos];
					break;
				case (UIInterfaceOrientationLandscapeLeft):
				case (UIInterfaceOrientationLandscapeRight):
					[self setFrame:self.finalPos];
					break;
				case (10):
				case (11):
					[self setFrame:self.finalPos];
					break;

			}	
			break;
		case (2):
			switch (self.orientation)	{
				case (UIInterfaceOrientationPortrait):
				case (UIInterfaceOrientationPortraitUpsideDown):
					[self setFrame:self.finalPos];
					break;
				case (UIInterfaceOrientationLandscapeLeft):
				case (UIInterfaceOrientationLandscapeRight):
					[self setFrame:self.finalPos];
					break;
				case (10):
				case (11):
					[self setFrame:self.finalPos];
					break;

			}	
			break;
	}
	[UIView commitAnimations];	
}
	
- (void) show
{
	self.integrated=NO;
	[self setHidden:NO];
	switch (self.orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
	//		self.frame = startRectP;
	//		[self setFrame:CGRectMake(self.frame.origin.x, 45+(self.pos)*self.frame.size.height, self.frame.size.width, self.frame.size.height)];
			break;
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
	//		self.frame = startRectL;
	//		[self setFrame:CGRectMake(self.frame.origin.x, 45+(self.pos)*self.frame.size.height, self.frame.size.width, self.frame.size.height)];
			break;
		case (10):
	//		self.frame = startRectR;
	//		[self setFrame:CGRectMake(self.frame.origin.x, 45+(self.pos)*self.frame.size.height, self.frame.size.width, self.frame.size.height)];
			break;
	}	
	

	[UIView beginAnimations:@"osciliate" context:[NSNumber numberWithInt:self.pos]];
	[UIView setAnimationDuration:0.15];
	[UIView setAnimationDelegate:self.owner]; 
	[UIView setAnimationRepeatAutoreverses:YES];
	[UIView setAnimationRepeatCount:40];
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
	switch (self.orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
	//		[self setFrame:CGRectMake(startRectP.origin.x+arc4random()%8-4, 45+(self.pos)*self.frame.size.height+arc4random()%10-5, self.frame.size.width, self.frame.size.height)];
			break;
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
	//		[self setFrame:CGRectMake(startRectL.origin.x+arc4random()%8-4, 45+(self.pos)*self.frame.size.height+arc4random()%10-5, self.frame.size.width, self.frame.size.height)];
			break;
		case (10):
	//		[self setFrame:CGRectMake(startRectR.origin.x+arc4random()%4-2, 45+(self.pos)*self.frame.size.height+arc4random()%5-2.5, self.frame.size.width, self.frame.size.height)];
			break;
	}	


	[UIView commitAnimations];	
}

@end
