//
//  JumpingGirlInstructionView.m
//  bishibashi
//
//  Created by Eric on 19/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "JumpingGirlInstructionView.h"


@implementation JumpingGirlInstructionView
@synthesize theGirl = _theGirl;
@synthesize seq = _seq;

static const CGRect backgroundRectP = {{0, 0}, {240, 260}};
static const CGRect backgroundRectL = {{0, 0}, {240, 260}};
static const CGRect backgroundRectR = {{30, 20}, {100, 240}};

-(void) initBackground
{
	[self setBackgroundColor:[UIColor blackColor]];	
	UIImage* tmpImage = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"jumpinggirlbackground" ofType:@"png"]];
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:tmpImage];
	[tmpView setFrame:backgroundRectP];
	self.backgroundView = tmpView;
	[self addSubview:tmpView];
	[tmpView release];
	
	if (self.theGirl)
		[self.theGirl removeFromSuperview];
	JumpingGirl* theGirl = [[JumpingGirl alloc] initWithOwner:self AndOrientation:11 AndIsMyself:YES];
	self.theGirl = theGirl;
	[theGirl release];
	self.theGirl.color = kRed;
	[self addSubview:self.theGirl];	
	self.seq = 1;
	
}

- (void) dealloc	{
	self.theGirl = nil;
	[super dealloc];
}

- (void) startScenarios 
{
	[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:1];
	[self performSelector:@selector(blueButClicked) withObject:nil afterDelay:2];
	[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:3];
	[self performSelector:@selector(redButClicked) withObject:nil afterDelay:4];
	[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:5];
	[self performSelector:@selector(blueButClicked) withObject:nil afterDelay:6];
	[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:7];
	[self performSelector:@selector(redButClicked) withObject:nil afterDelay:8];
	[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:9];
	[self performSelector:@selector(blueButClicked) withObject:nil afterDelay:10];
	[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:11];
}


- (void) redButClicked
{
	[super redButClicked];
	if (self.seq==4)	{
		[sharedSoundEffectsManager playDripSound];
		[self.theGirl jumpToLeft];
		self.seq = 1;
	}
}

- (void) blueButClicked
{
	[super blueButClicked];
	if (self.seq==2)	{
		[sharedSoundEffectsManager playDripSound];
		[self.theGirl jumpToRight];
		self.seq = 3;
	}
}

- (void) greenButClicked
{
	[super greenButClicked];
	if (self.seq==1)	{
		[sharedSoundEffectsManager playDripSound];
		[self.theGirl jumpToRight];
		self.seq=2;
	}
	else if (self.seq==3)	{
		[sharedSoundEffectsManager playDripSound];
		[self.theGirl jumpToLeft];
		self.seq=4;
	}
}

@end
