//
//  VersusResultView.m
//  bishibashi
//
//  Created by ktang on 9/28/10.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//peer

#import "VersusResultView.h"



@implementation VersusResultView
@synthesize koImageView, youWinImageView, youLoseImageView;




- (void) showKOMessage:(BOOL)didIWin{
	
	sharedSoundEffectsManager = [MediaManager sharedInstance];	
	[sharedSoundEffectsManager playKoSound];
	
	self.koImageView.backgroundColor = [UIColor clearColor];
	self.koImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ko" ofType:@"png"]]];
	self.koImageView.frame = CGRectMake(60, 160, 247, 78);
	self.koImageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
	self.koImageView.alpha = 0;
	[self addSubview:self.koImageView];
	
	[UIView beginAnimations:@"showKOView" context:nil];
	[UIView setAnimationDuration:0.5]; 
	
	self.koImageView.alpha = 1;
	self.koImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
	
	[UIView setAnimationDelay: UIViewAnimationCurveEaseIn];
	[UIView setAnimationDelay: UIViewAnimationCurveEaseOut];
	[UIView commitAnimations];
	if (didIWin == YES){
		[self performSelector:@selector(showYouWinMessage) withObject:nil afterDelay:1.5];
	}else{
		[self performSelector:@selector(showYouLoseMessage) withObject:nil afterDelay:1.5];
	}
}

- (void) showYouWinMessage{
	[self.koImageView removeFromSuperview];
	sharedSoundEffectsManager = [MediaManager sharedInstance];	
	[sharedSoundEffectsManager playYouWinSound];
	
	
	self.youWinImageView.backgroundColor = [UIColor clearColor];
	self.youWinImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"youwin" ofType:@"png"]]];
	self.youWinImageView.frame = CGRectMake(40, 160, 247, 78);
	self.youWinImageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
	self.youWinImageView.alpha = 0;
	[self addSubview:self.youWinImageView];
	
	[UIView beginAnimations:@"youWinImageView" context:nil];
	[UIView setAnimationDuration:0.5]; 
	
	self.youWinImageView.alpha = 1;
	self.youWinImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
	
	[UIView setAnimationDelay: UIViewAnimationCurveEaseIn];
	[UIView setAnimationDelay: UIViewAnimationCurveEaseOut];
	[UIView commitAnimations];
	
	
	
}


- (void) showYouLoseMessage{
	[self.koImageView removeFromSuperview];
	
	
	sharedSoundEffectsManager = [MediaManager sharedInstance];	
	[sharedSoundEffectsManager playYouLoseSound];
	
	self.youWinImageView.backgroundColor = [UIColor clearColor];
	self.youWinImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"youlose" ofType:@"png"]]];
	self.youWinImageView.frame = CGRectMake(40, 160, 247, 78);
	self.youWinImageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
	self.youWinImageView.alpha = 0;
	[self addSubview:self.youWinImageView];
	
	[UIView beginAnimations:@"youWinImageView" context:nil];
	[UIView setAnimationDuration:0.5]; 
	
	self.youWinImageView.alpha = 1;
	self.youWinImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
	
	[UIView setAnimationDelay: UIViewAnimationCurveEaseIn];
	[UIView setAnimationDelay: UIViewAnimationCurveEaseOut];
	[UIView commitAnimations];
	
}



-(void) dealloc
{
	NSLog(@"dealloc VersusTransitionView");
	[super dealloc];
	[self.koImageView release];
	[self.youWinImageView release];
}


@end
