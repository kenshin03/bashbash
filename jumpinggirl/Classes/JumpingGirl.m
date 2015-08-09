//
//  JumpingGirl.m
//  bishibashi
//
//  Created by Eric on 14/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "JumpingGirl.h"
#define MANIFYING_FACTOR 1.07

@implementation JumpingGirl
@synthesize owner = _owner;
@synthesize color = _color;
@synthesize toLeftImg = _toLeftImg;
@synthesize toRightImg = _toRightImg;
@synthesize toLeftJumpingImg = _toLeftJumpingImg;
@synthesize toRightJumpingImg = _toRightJumpingImg;
@synthesize orientation = _orientation;

static const CGRect startRectP = {{27, 192}, {80, 180}};
static const CGRect startRectL = {{25, 100}, {80, 120}};
static const CGRect startRectR = {{0, 100}, {50, 120}};
static const CGRect startRectI = {{2, 67}, {80, 180}};


- (id)initWithOwner:(id)owner AndOrientation:(UIInterfaceOrientation) orientation AndIsMyself:(BOOL)isMyself	{
	self.orientation = orientation;
	self.owner = owner;
	self.color = kRed;
	if (isMyself)	{
		self.toLeftImg = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"toleftgirl" ofType:@"png"]];
		self.toRightImg = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"torightgirl" ofType:@"png"]];
		self.toLeftJumpingImg = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"toleftcentergirl" ofType:@"png"]];
		self.toRightJumpingImg = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"torightcentergirl" ofType:@"png"]];
	}
	else {
		self.toLeftImg = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"toleftgirl_bw" ofType:@"png"]];
		self.toRightImg = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"torightgirl_bw" ofType:@"png"]];
		self.toLeftJumpingImg = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"toleftcentergirl_bw" ofType:@"png"]];
		self.toRightJumpingImg = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"torightcentergirl_bw" ofType:@"png"]];		
	}

	self = [super initWithImage:self.toRightImg];
	switch (self.orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
			self.frame = startRectP;
			break;
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
			self.frame = startRectL;
			break;
		case (10):
			self.frame = startRectR;
			break;
		case (11):
			self.frame = startRectI;
			break;
	}
	return self;
}


- (void) dealloc
{
	NSLog(@"dealloc jumping girl");
	self.toLeftImg = nil;
	self.toRightImg = nil;
	self.toLeftJumpingImg  = nil;
	self.toRightJumpingImg = nil;
	[super dealloc];
}


- (void) jumpToLeft
{	
	self.image = self.toLeftJumpingImg;
	if (self.color == kBlue)	{
		self.color = kGreen;
	}
	else {
		self.color = kRed;
	}
	[UIView beginAnimations:@"toLeft1" context:[NSNumber numberWithInt:self.color]];
	[UIView setAnimationDuration:0.1];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
	switch (self.orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
			if (self.color == kGreen)
				[self setFrame:CGRectMake(self.frame.origin.x-63, self.frame.origin.y-120, self.frame.size.width/MANIFYING_FACTOR, self.frame.size.height/MANIFYING_FACTOR)];
			else
				[self setFrame:CGRectMake(self.frame.origin.x-33, self.frame.origin.y-120, self.frame.size.width/MANIFYING_FACTOR, self.frame.size.height/MANIFYING_FACTOR)];
			break;
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
			if (self.color == kGreen)
				[self setFrame:CGRectMake(self.frame.origin.x-63, self.frame.origin.y-80, self.frame.size.width/MANIFYING_FACTOR, self.frame.size.height/MANIFYING_FACTOR)];
			else
				[self setFrame:CGRectMake(self.frame.origin.x-33, self.frame.origin.y-80, self.frame.size.width/MANIFYING_FACTOR, self.frame.size.height/MANIFYING_FACTOR)];
			break;
		case (10):
			[self setFrame:CGRectMake(self.frame.origin.x-20, self.frame.origin.y-60, self.frame.size.width/MANIFYING_FACTOR, self.frame.size.height/MANIFYING_FACTOR)];
			break;
		case (11):
			if (self.color == kGreen)
				[self setFrame:CGRectMake(self.frame.origin.x-50, self.frame.origin.y-120, self.frame.size.width/MANIFYING_FACTOR, self.frame.size.height/MANIFYING_FACTOR)];
			else
				[self setFrame:CGRectMake(self.frame.origin.x-26, self.frame.origin.y-120, self.frame.size.width/MANIFYING_FACTOR, self.frame.size.height/MANIFYING_FACTOR)];
			break;
	}
	[UIView commitAnimations];	
}

- (void) jumpToRight
{	
	if (self.color == kRed)	{
		self.color = kGreen;
	}
	else {
		self.color = kBlue;
	}
	self.image = self.toRightJumpingImg;
	[UIView beginAnimations:@"toRight1" context:[NSNumber numberWithInt:self.color]];		
	[UIView setAnimationDuration:0.1];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
	switch (self.orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
			if (self.color == kGreen)
				[self setFrame:CGRectMake(self.frame.origin.x+33, self.frame.origin.y-120, MANIFYING_FACTOR*self.frame.size.width, MANIFYING_FACTOR*self.frame.size.height)];
			else				
				[self setFrame:CGRectMake(self.frame.origin.x+63, self.frame.origin.y-120, MANIFYING_FACTOR*self.frame.size.width, MANIFYING_FACTOR*self.frame.size.height)];
			break;
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
			if (self.color == kGreen)
				[self setFrame:CGRectMake(self.frame.origin.x+33, self.frame.origin.y-80, MANIFYING_FACTOR*self.frame.size.width, MANIFYING_FACTOR*self.frame.size.height)];
			else				
				[self setFrame:CGRectMake(self.frame.origin.x+63, self.frame.origin.y-80, MANIFYING_FACTOR*self.frame.size.width, MANIFYING_FACTOR*self.frame.size.height)];
			break;
		case (10):
			[self setFrame:CGRectMake(self.frame.origin.x+20, self.frame.origin.y-60, MANIFYING_FACTOR*self.frame.size.width, MANIFYING_FACTOR*self.frame.size.height)];
			break;
		case (11):
			if (self.color == kGreen)
				[self setFrame:CGRectMake(self.frame.origin.x+26, self.frame.origin.y-120, MANIFYING_FACTOR*self.frame.size.width, MANIFYING_FACTOR*self.frame.size.height)];
			else				
				[self setFrame:CGRectMake(self.frame.origin.x+50, self.frame.origin.y-120, MANIFYING_FACTOR*self.frame.size.width, MANIFYING_FACTOR*self.frame.size.height)];
			break;
	}
	[UIView commitAnimations];	
}


- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if ([animationID isEqualToString:@"toLeft1"])	{
		[UIView beginAnimations:@"toLeft2" context:nil];
		[UIView setAnimationDuration:0.01];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
		self.image = self.toLeftImg;
		switch (self.orientation)	{
			case (UIInterfaceOrientationPortrait):
			case (UIInterfaceOrientationPortraitUpsideDown):
				if ([(NSNumber*)context intValue] == kGreen)
					[self setFrame:CGRectMake(self.frame.origin.x-63, self.frame.origin.y+185, self.frame.size.width/MANIFYING_FACTOR, self.frame.size.height/MANIFYING_FACTOR)];
				else
					[self setFrame:CGRectMake(self.frame.origin.x-33, self.frame.origin.y+185, self.frame.size.width/MANIFYING_FACTOR, self.frame.size.height/MANIFYING_FACTOR)];
				break;
			case (UIInterfaceOrientationLandscapeLeft):
			case (UIInterfaceOrientationLandscapeRight):
				if ([(NSNumber*)context intValue] == kGreen)
					[self setFrame:CGRectMake(self.frame.origin.x-63, self.frame.origin.y+122, self.frame.size.width/MANIFYING_FACTOR, self.frame.size.height/MANIFYING_FACTOR)];
				else
					[self setFrame:CGRectMake(self.frame.origin.x-33, self.frame.origin.y+122, self.frame.size.width/MANIFYING_FACTOR, self.frame.size.height/MANIFYING_FACTOR)];
				break;
			case (10):
				[self setFrame:CGRectMake(self.frame.origin.x-20, self.frame.origin.y+60, self.frame.size.width/MANIFYING_FACTOR, self.frame.size.height/MANIFYING_FACTOR)];
				break;
			case (11):
				if ([(NSNumber*)context intValue] == kGreen)
					[self setFrame:CGRectMake(self.frame.origin.x-50, self.frame.origin.y+180, self.frame.size.width/MANIFYING_FACTOR, self.frame.size.height/MANIFYING_FACTOR)];
				else
					[self setFrame:CGRectMake(self.frame.origin.x-26, self.frame.origin.y+180, self.frame.size.width/MANIFYING_FACTOR, self.frame.size.height/MANIFYING_FACTOR)];
				break;
		}
		
		[UIView commitAnimations];	
	}
	if ([animationID isEqualToString:@"toRight1"])	{
		[UIView beginAnimations:@"toRight2" context:nil];
		[UIView setAnimationDuration:0.01];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
		self.image = self.toRightImg;
		switch (self.orientation)	{
			case (UIInterfaceOrientationPortrait):
			case (UIInterfaceOrientationPortraitUpsideDown):
				if ([(NSNumber*)context intValue] == kGreen)
					[self setFrame:CGRectMake(self.frame.origin.x+33, self.frame.origin.y+55, MANIFYING_FACTOR*self.frame.size.width, MANIFYING_FACTOR*self.frame.size.height)];
				else				
					[self setFrame:CGRectMake(self.frame.origin.x+63, self.frame.origin.y+55, MANIFYING_FACTOR*self.frame.size.width, MANIFYING_FACTOR*self.frame.size.height)];
				break;				
			case (UIInterfaceOrientationLandscapeLeft):
			case (UIInterfaceOrientationLandscapeRight):
				if ([(NSNumber*)context intValue] == kGreen)
					[self setFrame:CGRectMake(self.frame.origin.x+33, self.frame.origin.y+38, MANIFYING_FACTOR*self.frame.size.width, MANIFYING_FACTOR*self.frame.size.height)];
				else				
					[self setFrame:CGRectMake(self.frame.origin.x+63, self.frame.origin.y+38, MANIFYING_FACTOR*self.frame.size.width, MANIFYING_FACTOR*self.frame.size.height)];
				break;
			case (10):
				[self setFrame:CGRectMake(self.frame.origin.x+20, self.frame.origin.y+60, self.frame.size.width*MANIFYING_FACTOR, self.frame.size.height*MANIFYING_FACTOR)];
				break;
			case (11):
				if ([(NSNumber*)context intValue] == kGreen)
					[self setFrame:CGRectMake(self.frame.origin.x+26, self.frame.origin.y+60, MANIFYING_FACTOR*self.frame.size.width, MANIFYING_FACTOR*self.frame.size.height)];
				else				
					[self setFrame:CGRectMake(self.frame.origin.x+50, self.frame.origin.y+60, MANIFYING_FACTOR*self.frame.size.width, MANIFYING_FACTOR*self.frame.size.height)];
				break;			
		}
		[UIView commitAnimations];	
	}
}	

@end
