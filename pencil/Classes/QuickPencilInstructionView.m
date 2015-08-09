//
//  QuickPencilView.m
//  bishibashi
//
//  Created by Eric on 14/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "QuickPencilInstructionView.h"


@implementation QuickPencilInstructionView

@synthesize localPencilHoldingHand = _localPencilHoldingHand;
@synthesize localPencilLead = _localPencilLead;
@synthesize hits = _hits;
@synthesize duration = _duration;

static const CGRect backgroundRectP = {{15, 80}, {290, 330}};


- (void) dealloc	{
	self.localPencilHoldingHand = nil;
	self.localPencilLead = nil;

	[super dealloc];
}

-(void) initButtons
{
	[super initButtons];
}

- (void) fail
{
	[self showPlayAgain];

}

- (void) startScenarios 
{
	[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:1];
	[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:1.2];
	[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:2.4];
	[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:3.5];
	[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:4];
	[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:4.5];
	[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:5];
	[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:5.2];
	[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:5.5];
	[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:6];
	[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:6.2];
	[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:7];
	[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:7.4];
	[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:7.6];
	[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:7.8];
	[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:8];
	[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:8.4];
	[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:9];
	[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:10];
	
}



- (void) hidePlayAgain
{
	[super hidePlayAgain];
}

-(void) initBackground
{
	[self setBackgroundColor:[UIColor blackColor]];		
	UIImage* tmpImage = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"pencil_background" ofType:@"png"]];
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:tmpImage];
//	[tmpView setFrame:CGRectMake(0, 0, 291, 373)];
	[tmpView setFrame:CGRectMake(-10, 10, 280, 230)];
	self.backgroundView = tmpView;
	[self addSubview:self.backgroundView];
	[self sendSubviewToBack:self.backgroundView];
	[tmpView release];
	[self initObjects];
	
}


- (void) initObjects {
	if (self.localPencilHoldingHand){
		[self.localPencilHoldingHand removeFromSuperview];
	}
	if (self.localPencilLead){
		[self.localPencilLead removeFromSuperview];
	}
	QuickPencil* localPencilHoldingHand = [[QuickPencil alloc] initWithOwner:self isMyself:YES];
	[localPencilHoldingHand setFrame:CGRectMake(80, -82, 215, 378)];
	self.localPencilHoldingHand = localPencilHoldingHand;
	[localPencilHoldingHand release];

	
	UIImageView* localPencilLeadView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pencil_lead" ofType:@"png"]]];
	localPencilLeadView.frame = CGRectMake(98, 70, 95, 97);
	self.localPencilLead = localPencilLeadView;
	[localPencilLeadView release];
	
//
	
	[self addSubview:self.localPencilLead];
	[self addSubview:self.localPencilHoldingHand];
	
}




-(void)moveOutPencilLead{
	[UIView beginAnimations:@"move out pencil lead" context:nil];
	[UIView setAnimationDuration:0.2]; 
	[UIView setAnimationDelegate:self];
	CGRect frame = self.localPencilLead.frame;
	frame.origin = CGPointMake(self.localPencilLead.frame.origin.x-8, self.localPencilLead.frame.origin.y+8);
	
	self.localPencilLead.frame = frame;
	[UIView commitAnimations];		
}

-(void)dropPencilLead{
	[sharedSoundEffectsManager playPencilLeadFallSound];
	[UIView beginAnimations:@"drop pencil lead" context:nil];
	[UIView setAnimationDuration:0.1]; 
	[UIView setAnimationDelegate:self];
	CGRect frame = self.localPencilLead.frame;
	frame.origin = CGPointMake(self.localPencilLead.frame.origin.x, self.localPencilLead.frame.origin.y+100);
	self.localPencilLead.alpha = 0;
	self.localPencilLead.frame = frame;
	[UIView commitAnimations];
	
}


- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if ([animationID isEqualToString:@"drop pencil lead"])	{
		// reset
		[self.localPencilLead removeFromSuperview];
		self.localPencilLead.frame = CGRectMake(98, 70, 95, 97);
		[self addSubview:self.localPencilLead];
		[self insertSubview:self.localPencilLead belowSubview:self.localPencilHoldingHand];
		self.localPencilLead.alpha = 1;
	}
}		


- (void) redButClicked
{
	[super redButClicked];
	[sharedSoundEffectsManager playPencilPressSound];
	
	self.hits++;
	
		[self.localPencilHoldingHand buttonClicked];
		[self moveOutPencilLead];
		if ((self.hits%10 == 0) && (self.hits != 1)){
			[self dropPencilLead];
		}
}



- (void) greenButClicked
{
	[super greenButClicked];
	[sharedSoundEffectsManager playPencilPressSound];
	
	self.hits++;
	
		[self.localPencilHoldingHand buttonClicked];
		[self moveOutPencilLead];
		if ((self.hits%10 == 0) && (self.hits != 1)){
			[self dropPencilLead];
		}
}
-(NSString*) getStat
{
	return nil;
}

-(UIImage*) getStatPic
{
	return [NSArray array];
}
@end