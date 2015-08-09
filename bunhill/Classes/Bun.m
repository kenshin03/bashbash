//
//  Bun.m
//  bishibashi
//
//  Created by Eric on 03/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "Bun.h"


@implementation Bun
@synthesize orientation = _orientation;
@synthesize pos = _pos;
@synthesize owner = _owner;
@synthesize column = _column;
@synthesize score = _score;
@synthesize isSpecial = _isSpecial;
static const CGRect bunRect1P = {{100, 295}, {20, 20}};
static const CGRect bunRect2P = {{110, 265}, {20, 20}};
static const CGRect bunRect3P = {{120, 235}, {20, 20}};
static const CGRect bunRect4P = {{130, 205}, {20, 20}};
static const CGRect bunRect5P = {{140, 175}, {20, 20}};
static const CGRect bunRect6P = {{150, 145}, {20, 20}};

static const CGRect bunRect1I = {{80, 165}, {15, 15}};
static const CGRect bunRect2I = {{85, 145}, {15, 15}};
static const CGRect bunRect3I = {{90, 125}, {15, 15}};
static const CGRect bunRect4I = {{95, 105}, {15, 15}};
static const CGRect bunRect5I = {{100, 85}, {15, 15}};
static const CGRect bunRect6I = {{105, 65}, {15, 15}};


- (void) dealloc
{
	NSLog(@"dealloc Bun");
	[super dealloc];
}

- (id)initWithOwner:(id)owner andOrientation:(UIInterfaceOrientation) orientation AndPos:(int)pos AndCol:(int)column AndSpecial:(BOOL)special AndDifficultLevel:(GameLevel)level
{
	self.owner = owner;
	self.orientation = orientation;
	self.pos = pos;
	self.column = column;
	if (special)
		self = [super initWithImage:[UIImage imageNamed:@"bunred.png"]];
	else
		self = [super initWithImage:[UIImage imageNamed:@"bun.png"]];
	self.isSpecial = special;
	self.score = pos+1;
	if (special)
		self.score *= 2;
	if (level==kNormal)
		self.score = ceil((double)self.score*4/6);
	else if (level==kEasy)
		self.score = ceil((double)self.score*3/6);
	
	if (self.score>10)
		self.score=10;
	return self;
}

- (void) collectedFromUser:(BOOL)isLeft
{
	[UIView beginAnimations:@"collect0" context:[NSNumber numberWithBool:isLeft]];
	[UIView setAnimationDelay:0.1];
	[UIView setAnimationDelegate:self];
	if (isLeft)
		self.frame = CGRectOffset(self.frame, -25, -25);
	else
		self.frame = CGRectOffset(self.frame, 25, -25);
	[UIView commitAnimations];
}

- (void) show
{	if (self.orientation == 11)	{
	switch (self.pos)	{
		case (0):
			self.frame = bunRect1I;
			break;
		case (1):
			self.frame = bunRect2I;
			break;
		case (2):
			self.frame = bunRect3I;
			break;
		case (3):
			self.frame = bunRect4I;
			break;
		case (4):
			self.frame = bunRect5I;
			break;
		case (5):
			self.frame = bunRect6I;
			break;
	}	
	}
	else if (self.orientation = UIInterfaceOrientationPortrait)	{
		switch (self.pos)	{
			case (0):
				self.frame = bunRect1P;
				break;
			case (1):
				self.frame = bunRect2P;
				break;
			case (2):
				self.frame = bunRect3P;
				break;
			case (3):
				self.frame = bunRect4P;
				break;
			case (4):
				self.frame = bunRect5P;
				break;
			case (5):
				self.frame = bunRect6P;
				break;
		}
	}
	self.frame = CGRectOffset(self.frame, self.column*5, 0);
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if ([animationID isEqualToString:@"collect0"])	{
		[UIView beginAnimations:@"collect1" context:context];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.1];
		if ([context boolValue])
			self.frame = CGRectOffset(self.frame, -25, 25);
		else
			self.frame = CGRectOffset(self.frame, 25, 25);
		[UIView commitAnimations];
	}		
	if ([animationID isEqualToString:@"collect1"])	{
		[self removeFromSuperview];
	}
}
@end
