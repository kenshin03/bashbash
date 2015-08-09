//
//  Dice.m
//  bishibashi
//
//  Created by Eric on 25/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Dice.h"


@implementation Dice
@synthesize color = _color;
@synthesize val = _val;
@synthesize orientation = _orientation;

static const CGRect startRectP = {{20, 290}, {80, 80}};
static const CGRect startRectL = {{20, 140}, {80, 80}};
static const CGRect startRectR = {{10, 140}, {40, 40}};
static const CGRect startRectI = {{10, 200}, {60, 60}};

- (void) dealloc
{
	NSLog(@"dealloc dice");
	[super dealloc];
}

- (id)initWithColor:(ButState)color	AndVal:(int)val{
	self.orientation = UIInterfaceOrientationPortrait;
	UIImage *tmpImage;
	NSString* str = [[NSString alloc] initWithFormat:@"move%d.png", arc4random()%6+1];
	UIImage* theImage = [UIImage imageNamed:str];
	[str release];
	self = [super initWithImage:theImage];
	self.color = color;
	self.val = val;
	self.frame = startRectP;
	self.frame = CGRectMake(100*self.color+self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
	return self;
}

- (void) changeOrientationTo:(UIInterfaceOrientation) orientation
{
	self.orientation = orientation;
	switch (self.orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
			self.frame = startRectP;
			self.frame = CGRectMake(100*self.color+self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
			break;
		case (11):
			self.frame = startRectI;
			self.frame = CGRectMake(80*self.color+self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
			break;
	}
}


- (void) show
{
	[UIView beginAnimations:@"show1" context:nil];
	[UIView setAnimationDuration:0.15];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
	[self setHidden:NO];
	NSString* str;
	if (arc4random()%2==0)
		str = [[NSString alloc] initWithFormat:@"%d.png", arc4random()%6+1];
	else
		str = [[NSString alloc] initWithFormat:@"move%d.png", arc4random()%6+1];
	self.image = [UIImage imageNamed:str];
	[str release];
	[self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y-20,self.frame.size.width, self.frame.size.height)];
	[UIView commitAnimations];	
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if ([animationID isEqualToString:@"show1"])	{
		[UIView beginAnimations:@"show2" context:nil];
		[UIView setAnimationDuration:0.15];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
		NSString* str;
		if (arc4random()%2==0)
			str = [[NSString alloc] initWithFormat:@"%d.png", arc4random()%6+1];
		else
			str = [[NSString alloc] initWithFormat:@"move%d.png", arc4random()%6+1];
		self.image = [UIImage imageNamed:str];
		[str release];
		[self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y-20,self.frame.size.width, self.frame.size.height)];
		[UIView commitAnimations];	
	}
	if ([animationID isEqualToString:@"show2"])	{
		[UIView beginAnimations:@"show3" context:nil];
		[UIView setAnimationDuration:0.15];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
		NSString* str;
		if (arc4random()%2==0)
			str = [[NSString alloc] initWithFormat:@"%d.png", arc4random()%6+1];
		else
			str = [[NSString alloc] initWithFormat:@"move%d.png", arc4random()%6+1];
		self.image = [UIImage imageNamed:str];
		[str release];
		[self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y-20,self.frame.size.width, self.frame.size.height)];
		[UIView commitAnimations];	
	}
	if ([animationID isEqualToString:@"show3"])	{
		[UIView beginAnimations:@"show4" context:nil];
		[UIView setAnimationDuration:0.15];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
		NSString* str;
		if (arc4random()%2==0)
			str = [[NSString alloc] initWithFormat:@"%d.png", arc4random()%6+1];
		else
			str = [[NSString alloc] initWithFormat:@"move%d.png", arc4random()%6+1];
		self.image = [UIImage imageNamed:str];
		[str release];
		[self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y-20, self.frame.size.width, self.frame.size.height)];
		[UIView commitAnimations];	
	}
	if ([animationID isEqualToString:@"show4"])	{
		[UIView beginAnimations:@"show5" context:nil];
		[UIView setAnimationDuration:0.15];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
		NSString* str;
		if (arc4random()%2==0)
			str = [[NSString alloc] initWithFormat:@"%d.png", arc4random()%6+1];
		else
			str = [[NSString alloc] initWithFormat:@"move%d.png", arc4random()%6+1];
		self.image = [UIImage imageNamed:str];
		[str release];
		[self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y-20, self.frame.size.width, self.frame.size.height)];
		[UIView commitAnimations];	
	}	
	if ([animationID isEqualToString:@"show5"])	{
		[UIView beginAnimations:@"show6" context:nil];
		[UIView setAnimationDuration:0.15];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
		[self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y+20, self.frame.size.width, self.frame.size.height)];
		NSString* str;
		if (arc4random()%2==0)
			str = [[NSString alloc] initWithFormat:@"%d.png", arc4random()%6+1];
		else
			str = [[NSString alloc] initWithFormat:@"move%d.png", arc4random()%6+1];
		self.image = [UIImage imageNamed:str];
		[str release];
		[UIView commitAnimations];	
	}	
	if ([animationID isEqualToString:@"show6"])	{
		[UIView beginAnimations:@"show7" context:nil];
		[UIView setAnimationDuration:0.15];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
		[self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y+20, self.frame.size.width, self.frame.size.height)];
		NSString* str;
		if (arc4random()%2==0)
			str = [[NSString alloc] initWithFormat:@"%d.png", arc4random()%6+1];
		else
			str = [[NSString alloc] initWithFormat:@"move%d.png", arc4random()%6+1];
		self.image = [UIImage imageNamed:str];
		[str release];
		[UIView commitAnimations];	
	}	
	if ([animationID isEqualToString:@"show7"])	{
		[UIView beginAnimations:@"show8" context:nil];
		[UIView setAnimationDuration:0.15];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
		[self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y+20, self.frame.size.width, self.frame.size.height)];
		NSString* str;
		if (arc4random()%2==0)
			str = [[NSString alloc] initWithFormat:@"%d.png", arc4random()%6+1];
		else
			str = [[NSString alloc] initWithFormat:@"move%d.png", arc4random()%6+1];
		self.image = [UIImage imageNamed:str];
		[str release];
		[UIView commitAnimations];	
	}	
	if ([animationID isEqualToString:@"show8"])	{
		[UIView beginAnimations:@"show9" context:nil];
		[UIView setAnimationDuration:0.15];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
		[self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y+20, self.frame.size.width, self.frame.size.height)];
		NSString* str;
		if (arc4random()%2==0)
			str = [[NSString alloc] initWithFormat:@"%d.png", arc4random()%6+1];
		else
			str = [[NSString alloc] initWithFormat:@"move%d.png", arc4random()%6+1];
		self.image = [UIImage imageNamed:str];
		[str release];
		[UIView commitAnimations];	
	}	
	if ([animationID isEqualToString:@"show9"])	{
		[UIView beginAnimations:@"show10" context:nil];
		[UIView setAnimationDuration:0.15];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
		[self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y+20, self.frame.size.width, self.frame.size.height)];
		NSString* str = [[NSString alloc] initWithFormat:@"%d.png", self.val];
		self.image = [UIImage imageNamed:str];
		[str release];
		[UIView commitAnimations];	
	}	
	
}
