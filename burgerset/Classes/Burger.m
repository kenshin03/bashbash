//
//  burger.m
//  bishibashi
//
//  Created by Eric on 10/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "burger.h"


@implementation Burger
@synthesize color = _color;
@synthesize pos = _pos;
@synthesize empty = _empty;
@synthesize orientation = _orientation;

static const CGRect redRectP = {{40, 0}, {50, 50}};
static const CGRect greenRectP = {{140, 0}, {50, 50}};
static const CGRect blueRectP = {{240, 0}, {50, 50}};

static const CGRect redRectPS = {{40, 0}, {50, 80}};
static const CGRect greenRectPS = {{140, 0}, {50, 80}};
static const CGRect blueRectPS = {{240, 0}, {50, 80}};


static const CGRect redRectI = {{25, 0}, {30, 30}};
static const CGRect greenRectI = {{105, 0}, {30, 30}};
static const CGRect blueRectI = {{185, 0}, {30, 30}};

static const CGRect redRectIS = {{25, 0}, {30, 50}};
static const CGRect greenRectIS = {{105, 0}, {30, 50}};
static const CGRect blueRectIS = {{185, 0}, {30, 50}};

- (void) dealloc
{
	NSLog(@"dealloc burger");
	[super dealloc];
}

- (id)initWithColor:(ButState)color	AndPos:(int)pos AndEmpty:(BOOL)isEmpty AndOrientation:(UIInterfaceOrientation)orientation{
	self.orientation = orientation;
	self.color = color;
	self.pos = pos;
	self.empty = isEmpty;
	self.starOffsetY = 0.0;
	self.redColor=1.0;
	self.blueColor=1.0;
	self.greenColor =1.0;
	if (!self.empty)	{
		switch (self.color)	{
			case (kRed):
				self.image = [UIImage imageNamed:@"drink.png"];
				if (orientation==11)
					self = [super initWithFrame:redRectIS AndImageFrame:redRectI WithNumStars:15];
				else
					self = [super initWithFrame:redRectPS AndImageFrame:redRectP WithNumStars:30];
				break;
			case (kBlue):
				self.image = [UIImage imageNamed:@"fried.png"];
				if (orientation==11)
					self = [super initWithFrame:blueRectIS AndImageFrame:blueRectI WithNumStars:15];
				else
					self = [super initWithFrame:blueRectPS AndImageFrame:blueRectP WithNumStars:30];
				break;
			case (kGreen):
				self.image = [UIImage imageNamed:@"burger.png"];
				if (orientation==11)
					self = [super initWithFrame:greenRectIS AndImageFrame:greenRectI WithNumStars:15];
				else
					self = [super initWithFrame:greenRectPS AndImageFrame:greenRectP WithNumStars:30];
				break;
		}
	}
	else {
		self.showStars = NO;
		switch (self.color)	{
			case (kRed):
				self.image = [UIImage imageNamed:@"drink_empty.png"];
				if (orientation==11)
					self = [super initWithFrame:redRectIS AndImageFrame:redRectI WithNumStars:0];
				else
					self = [super initWithFrame:redRectPS AndImageFrame:redRectP WithNumStars:0];
				break;
			case (kBlue):
				self.image = [UIImage imageNamed:@"fried_empty.png"];
				if (orientation==11)
					self = [super initWithFrame:blueRectIS AndImageFrame:blueRectI WithNumStars:0];
				else
					self = [super initWithFrame:blueRectPS AndImageFrame:blueRectP WithNumStars:0];
				break;
			case (kGreen):
				self.image = [UIImage imageNamed:@"burger_empty.png"];
				if (orientation==11)
					self = [super initWithFrame:greenRectIS AndImageFrame:greenRectI WithNumStars:0];
				else
					self = [super initWithFrame:greenRectPS AndImageFrame:greenRectP WithNumStars:0];
				break;
		}
	}
	switch(self.color)	{
		case kRed:
			self.redColor=1.0;
			self.greenColor=0.0;
			self.blueColor=0.0;
			break;
		case kGreen:
			self.redColor=0.0;
			self.greenColor = 1.0;
			self.blueColor=0.0;
			break;
		case kBlue:
			self.redColor=0.75;
			self.greenColor=0.75;
			self.blueColor=0.15;
			break;
	}
	
	return self;
}

   

- (void) show
{
	if (!self.empty)	{
	[self setNeedsDisplay];
	[UIView beginAnimations:@"fall" context:nil];
	[UIView setAnimationDuration:0.3];	
	[UIView setAnimationDelegate:self];
	switch (self.orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
			[self setFrame:CGRectMake(self.imageRect.origin.x, 475-(self.pos+1)*self.imageRect.size.height-100, self.imageRect.size.width,self.imageRect.size.height)];
			break;
		case (11):
			[self setFrame:CGRectMake(self.imageRect.origin.x, 310-(self.pos+1)*self.imageRect.size.height-50, self.imageRect.size.width,self.imageRect.size.height)];
			break;
	}
	[UIView commitAnimations];

	}
	else {
		switch (self.orientation)	{
			case (UIInterfaceOrientationPortrait):
			case (UIInterfaceOrientationPortraitUpsideDown):
				[self setFrame:CGRectMake(self.imageRect.origin.x, 475-(self.pos+1)*self.imageRect.size.height-100, self.imageRect.size.width,self.imageRect.size.height)];
				break;
			case (11):
				[self setFrame:CGRectMake(self.imageRect.origin.x, 310-(self.pos+1)*self.imageRect.size.height-50, self.imageRect.size.width,self.imageRect.size.height)];
				break;
		}
	}										  
}	

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if ([animationID isEqualToString:@"fall"])	{
		self.showStars=NO;
		[self setNeedsDisplay];
	}
}




@end
