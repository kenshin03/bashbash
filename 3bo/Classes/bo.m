//
//  bo.m
//  bishibashi
//
//  Created by Eric on 23/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "bo.h"


@implementation Bo
@synthesize color = _color;
@synthesize pos = _pos;
@synthesize orientation = _orientation;
@synthesize isMyself = _isMysefl;
static int seq=0;

static const CGRect startRectP = {{200, 0}, {56, 45}};
static const CGRect startOpponentRectP = {{260, 0}, {56, 45}};
static const CGRect startRectL = {{200, 0}, {56, 30}};
static const CGRect startRectR = {{100, 0}, {28, 30}};
static const CGRect startRectI = {{170, 0}, {56, 45}};

- (void) dealloc
{
	NSLog(@"dealloc bo");
	[super dealloc];
}

- (id)initWithColor:(ButState)color	AndPos:(int)pos AndOrientation:(UIInterfaceOrientation)orientation AndIsMyself:(BOOL)isMyself	
{
	self.isMyself = isMyself;
	self.orientation = orientation;
	self.color = color;
	self.pos = pos;
	UIImage *tmpImage;
	switch (self.color)	{
		case (kRed):
			if (isMyself)
				tmpImage = [UIImage imageNamed:@"redbo.png"];
			else
				tmpImage = [UIImage imageNamed:@"redbo_bw.png"];
			self = [super initWithImage:tmpImage];
			break;
		case (kBlue):
			if (isMyself)
				tmpImage = [UIImage imageNamed:@"bluebo.png"];
			else
				tmpImage = [UIImage imageNamed:@"bluebo_bw.png"];
			self = [super initWithImage:tmpImage];
			break;
		case (kGreen):
			if (isMyself)
				tmpImage = [UIImage imageNamed:@"greenbo.png"];
			else
				tmpImage = [UIImage imageNamed:@"greenbo_bw.png"];
			self = [super initWithImage:tmpImage];
			break;
	
	}
	if (self.pos <8)	{
		switch (self.orientation)	{
			case (UIInterfaceOrientationPortrait):
			case (UIInterfaceOrientationPortraitUpsideDown):
				if (isMyself)
					self.frame = startRectP;
				else
					self.frame = startOpponentRectP;
				self.frame = CGRectMake(self.frame.origin.x, 290-self.pos*(self.frame.size.height*2/3), self.frame.size.width, self.frame.size.height);
				break;
			case (UIInterfaceOrientationLandscapeLeft):
			case (UIInterfaceOrientationLandscapeRight):
				self.frame = startRectL;
				self.frame = CGRectMake(self.frame.origin.x, 160-self.pos*(self.frame.size.height*2/3), self.frame.size.width, self.frame.size.height);
				break;
			case (10):
				self.frame = startRectR;
				self.frame = CGRectMake(self.frame.origin.x, 200-self.pos*(self.frame.size.height*2/3), self.frame.size.width, self.frame.size.height);
				break;
			case (11):
				self.frame = startRectI;
				self.frame = CGRectMake(self.frame.origin.x, 200-self.pos*(self.frame.size.height*2/3), self.frame.size.width, self.frame.size.height);
				break;
		}
	}
	else
		self.frame = CGRectMake(0,0,0,0);
	seq=0;
	return self;
}



- (void) show
{
	if (self.pos==8)	{
		switch (self.orientation)	{
			case (UIInterfaceOrientationPortrait):
			case (UIInterfaceOrientationPortraitUpsideDown):
				if (self.isMyself)
					self.frame = startRectP;
				else
					self.frame = startOpponentRectP;
				self.frame = CGRectMake(self.frame.origin.x, 290-self.pos*(self.frame.size.height*2/3), self.frame.size.width, self.frame.size.height);
				break;
			case (UIInterfaceOrientationLandscapeLeft):
			case (UIInterfaceOrientationLandscapeRight):
				self.frame = startRectL;
				self.frame = CGRectMake(self.frame.origin.x, 160-self.pos*(self.frame.size.height*2/3), self.frame.size.width, self.frame.size.height);
				break;
			case (10):
				self.frame = startRectR;
				self.frame = CGRectMake(self.frame.origin.x, 200-self.pos*(self.frame.size.height*2/3), self.frame.size.width, self.frame.size.height);
				break;
			case (11):
				self.frame = startRectI;
				self.frame = CGRectMake(self.frame.origin.x, 230-self.pos*(self.frame.size.height*2/3), self.frame.size.width, self.frame.size.height);
				break;
		}
	}		
	self.pos--;
	if (self.pos <8)	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.2];
		switch (self.orientation)	{
			case (UIInterfaceOrientationPortrait):
			case (UIInterfaceOrientationPortraitUpsideDown):
				self.frame = CGRectMake(self.frame.origin.x, 290-self.pos*(self.frame.size.height*2/3), self.frame.size.width, self.frame.size.height);
				break;
			case (UIInterfaceOrientationLandscapeLeft):
			case (UIInterfaceOrientationLandscapeRight):
				self.frame = CGRectMake(self.frame.origin.x, 160-self.pos*(self.frame.size.height*2/3), self.frame.size.width, self.frame.size.height);
				break;
			case (10):
				self.frame = CGRectMake(self.frame.origin.x, 200-self.pos*(self.frame.size.height*2/3), self.frame.size.width, self.frame.size.height);
				break;
			case (11):
				self.frame = CGRectMake(self.frame.origin.x, 200-self.pos*(self.frame.size.height*2/3), self.frame.size.width, self.frame.size.height);
				break;
		}
		[UIView commitAnimations];
	}
}	

- (void) dispose 
{
	seq++;
	switch (self.orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
			self.frame = CGRectMake(self.frame.origin.x, 290-self.pos*(self.frame.size.height*2/3), self.frame.size.width, self.frame.size.height);
			break;
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
			self.frame = CGRectMake(self.frame.origin.x, 160-self.pos*(self.frame.size.height*2/3), self.frame.size.width, self.frame.size.height);
			break;
		case (10):
			self.frame = CGRectMake(self.frame.origin.x, 200-self.pos*(self.frame.size.height*2/3), self.frame.size.width, self.frame.size.height);
			break;
		case (11):
			self.frame = CGRectMake(self.frame.origin.x, 200-self.pos*(self.frame.size.height*2/3), self.frame.size.width, self.frame.size.height);
			break;
	}
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2];
	switch (self.orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
			self.frame = CGRectMake(40+seq*1.5, 290-self.pos*(self.frame.size.height*2/3)-seq*0.2, self.frame.size.width, self.frame.size.height);
			break;
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
			self.frame = CGRectMake(40+seq*1.5, 160-self.pos*(self.frame.size.height*2/3)-seq*0.2, self.frame.size.width, self.frame.size.height);
			break;
		case (10):
			self.frame = CGRectMake(20+seq*1.5, 200-self.pos*(self.frame.size.height*2/3)-seq*0.2, self.frame.size.width, self.frame.size.height);
			break;
		case (11):
			self.frame = CGRectMake(20+seq*1.5, 200-self.pos*(self.frame.size.height*2/3)-seq*0.2, self.frame.size.width, self.frame.size.height);
			break;
	}
	
//	[self removeFromSuperview];
	[UIView commitAnimations];
}	

@end
