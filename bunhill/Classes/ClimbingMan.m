//
//  ClimbingMan.m
//  bishibashi
//
//  Created by Eric on 03/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "ClimbingMan.h"


@implementation ClimbingMan
@synthesize pos = _pos;
@synthesize orientation = _orientation;
@synthesize arm = _arm;
@synthesize isComputer  = _isComputer;
@synthesize component = _component;
static const CGRect manRect1P = {{25, 265}, {80, 140}};
static const CGRect manRect2P = {{35, 235}, {80, 140}};
static const CGRect manRect3P = {{45, 205}, {80, 140}};
static const CGRect manRect4P = {{55, 175}, {80, 140}};
static const CGRect manRect5P = {{65, 145}, {80, 140}};
static const CGRect manRect6P = {{75, 115}, {80, 140}};

static const CGRect manFlippedRect1P = {{205, 265}, {80, 140}};
static const CGRect manFlippedRect2P = {{195, 235}, {80, 140}};
static const CGRect manFlippedRect3P = {{185, 205}, {80, 140}};
static const CGRect manFlippedRect4P = {{175, 175}, {80, 140}};
static const CGRect manFlippedRect5P = {{165, 145}, {80, 140}};
static const CGRect manFlippedRect6P = {{155, 115}, {80, 140}};

static const CGRect manRect1I = {{25, 130}, {60, 120}};
static const CGRect manRect2I = {{30, 110}, {60, 120}};
static const CGRect manRect3I = {{35, 90}, {60, 120}};
static const CGRect manRect4I = {{40, 70}, {60, 120}};
static const CGRect manRect5I = {{45, 50}, {60, 120}};
static const CGRect manRect6I = {{50, 30}, {60, 120}};


static const CGRect armRect = {{23, 15}, {50, 38}};
static const CGRect armRectI = {{17, 11}, {35, 28}};
static const CGRect armFlippedRect = {{16, 15}, {50, 38}};

static const CGRect componentRect = {{50,25},{80,18}};


- (void) dealloc
{
	NSLog(@"dealloc ClimbingMan");
	self.arm = nil;
	self.component = nil;
	[super dealloc];
}

- (id)initWithOrientation:(UIInterfaceOrientation) orientation
{
	self.orientation = orientation;
	UIImage* tmpImage = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"climbingman" ofType:@"png"]];
	self = [super initWithImage:tmpImage];
	self.pos = 0;	
	
	UIImageView* arm = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"arm" ofType:@"png"]]];
	self.arm = arm;
	[arm release];
	
	if (orientation==UIInterfaceOrientationPortrait)	{
		self.frame = manRect1P;
		self.arm.frame = armRect;
	}
	else if (orientation==11)	{
		self.frame = manRect1I;
		self.arm.frame = armRectI;
	}
	[self addSubview:self.arm];
	[self.arm.layer setAnchorPoint:CGPointMake(0.2,0.3)];
	self.isComputer = NO;
	
	return self;
}

-(void) setComputer
{
	self.isComputer = YES;
	self.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"climbingmanflipped" ofType:@"png"]];
	self.frame = manFlippedRect1P;
	
	self.arm.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"armflipped" ofType:@"png"]];
	self.arm.frame = armFlippedRect;
	
	[self.arm.layer setAnchorPoint:CGPointMake(0.8,0.3)];
	
	UILabel* component = [[UILabel alloc] initWithFrame:componentRect];
	component.backgroundColor = [UIColor clearColor];
	component.text = NSLocalizedString(@"←對手",nil);
	component.textColor= [UIColor whiteColor];
	component.font = [UIFont boldSystemFontOfSize:14];
	[self addSubview:component];
	self.component = component;
	[component release];
}

-(void) resetPos
{
	self.pos = 0;
	if (self.isComputer)
		self.frame = manFlippedRect1P;
	else
		self.frame = manRect1P;
}

- (void) moveRight
{
	if (self.pos<5)	{
		if (!self.isComputer)
			[[MediaManager sharedInstance] playDripSound];
		[UIView beginAnimations:@"moveRight" context:nil];
		[UIView setAnimationDuration:0.3];
		self.pos ++;
		if (self.orientation==11)	{
			switch (self.pos)	{
				case (1):
					self.frame = manRect2I;
					break;
				case (2):
					self.frame = manRect3I;
					break;
				case (3):
					self.frame = manRect4I;
					break;
				case (4):
					self.frame = manRect5I;
					break;
				case (5):
					self.frame = manRect6I;
					break;
			}
		}
		
		else 
		if (self.isComputer)	{
			switch (self.pos)	{
				case (1):
					self.frame = manFlippedRect2P;
					break;
				case (2):
					self.frame = manFlippedRect3P;
					break;
				case (3):
					self.frame = manFlippedRect4P;
					break;
				case (4):
					self.frame = manFlippedRect5P;
					break;
				case (5):
					self.frame = manFlippedRect6P;
					break;
			}
		}
		else{
			switch (self.pos)	{
				case (1):
					self.frame = manRect2P;
					break;
				case (2):
					self.frame = manRect3P;
					break;
				case (3):
					self.frame = manRect4P;
					break;
				case (4):
					self.frame = manRect5P;
					break;
				case (5):
					self.frame = manRect6P;
					break;
			}
		}
		[UIView commitAnimations];
	}
}

- (void) moveLeft
{
	if (self.pos>0)	{
		if (!self.isComputer)
			[[MediaManager sharedInstance] playDripSound];
		[UIView beginAnimations:@"moveLeft" context:nil];
		[UIView setAnimationDuration:0.3];
		self.pos --;
		if (self.orientation==11)	{
			switch (self.pos)	{
				case (0):
					self.frame = manRect1I;
					break;
				case (1):
					self.frame = manRect2I;
					break;
				case (2):
					self.frame = manRect3I;
					break;
				case (3):
					self.frame = manRect4I;
					break;
				case (4):
					self.frame = manRect5I;
					break;
			}
		}
		else
		if (self.isComputer)	{
			switch (self.pos)	{
				case (0):
					self.frame = manFlippedRect1P;
					break;
				case (1):
					self.frame = manFlippedRect2P;
					break;
				case (2):
					self.frame = manFlippedRect3P;
					break;
				case (3):
					self.frame = manFlippedRect4P;
					break;
				case (4):
					self.frame = manFlippedRect5P;
					break;
			}
		}
		else{
			switch (self.pos)	{
				case (0):
					self.frame = manRect1P;
					break;
				case (1):
					self.frame = manRect2P;
					break;
				case (2):
					self.frame = manRect3P;
					break;
				case (3):
					self.frame = manRect4P;
					break;
				case (4):
					self.frame = manRect5P;
					break;
			}
		}
		
		[UIView commitAnimations];
	}
}

-(void) moveArm
{
	if (self.isComputer)	{
		[UIView beginAnimations:@"moveArm" context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.3];
		self.arm.transform = CGAffineTransformMakeRotation(radians(180));
		[UIView commitAnimations];
		
	}
	else{
		[UIView beginAnimations:@"moveArm" context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.3];
		self.arm.transform = CGAffineTransformMakeRotation(radians(180));
		[UIView commitAnimations];
	}
}

 - (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if ([animationID isEqualToString:@"moveArm"])	{
			[UIView beginAnimations:@"moveArmBack" context:nil];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDuration:0.3];
			self.arm.transform = CGAffineTransformMakeRotation(0);
			[UIView commitAnimations];
	}		
}
@end
