//
//  ScoreBox.m
//  bishibashi
//
//  Created by Eric on 05/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "ScoreBox.h"
#import "MediaManager.h"


@implementation ScoreBox
@synthesize score = _score;


-(id) initWithScore:(int) score AndView:(UIView*)view AndFrame:(CGRect)frame
{
	sharedSoundEffectsManager = [MediaManager sharedInstance];	
	self.score = score;
	NSString* filename;
	if (score <=10)	{
		filename = [NSString stringWithFormat:@"+%d.png", score];
	}
	else
		filename = [NSString stringWithFormat:@"+10.png"];
	self = [super initWithImage:[UIImage imageNamed:filename]];
	self.frame = CGRectMake(frame.origin.x, frame.origin.y, 21,14);

	self.alpha = 0;
	[view addSubview:self];
	[UIView beginAnimations:@"showScore" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	self.frame = CGRectMake(self.frame.origin.x-2,self.frame.origin.y-10, self.frame.size.width*2, self.frame.size.height*2);
	self.alpha = 0.8;
	[UIView commitAnimations];
	
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

- (void)hideScoreBox{
	[self removeFromSuperview];
}

	
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
//	if (self.score > 0){
//		[sharedSoundEffectsManager playCoinSound];
//	}
	[self performSelector:@selector(hideScoreBox) withObject:nil afterDelay:0.2];
	
}