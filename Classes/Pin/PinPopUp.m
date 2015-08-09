//
//  PinPopUp.m
//  bishibashi
//
//  Created by Eric on 01/09/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "PinPopUp.h"


@implementation PinPopUp
@synthesize pin = _pin;
@synthesize pinbg = _pinbg;
@synthesize text = _text;

- (id)initWithFrame:(CGRect)frame AndPin:(Pin*)pinData{
    if ((self = [super initWithFrame:frame])) {
		self.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pinpopup" ofType:@"png"]];
		UIImageView* pinbg = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pinblackbg" ofType:@"png"]]];
		self.pinbg = pinbg;
		[pinbg release];
		self.pinbg.frame = CGRectMake(5, 5, 33,33);
		
		UIImageView* pin;
		if (pinData.pinLevel==kIntermediate)
			pin = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[[Constants sharedInstance] gameGreyPinsArray] objectAtIndex:pinData.game]]];
		else if (pinData.pinLevel = kMaster)
			pin = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[[Constants sharedInstance] gamePinsArray] objectAtIndex:pinData.game]]];
			
		self.pin = pin;
		[pin release];
		self.pin.frame = CGRectMake(6, 6, 31,31);
		
		UILabel* text = [[UILabel alloc] initWithFrame:CGRectMake(43, 0, 107, 40)];
		text.backgroundColor = [UIColor clearColor];
		text.font = [UIFont systemFontOfSize:11];
		text.numberOfLines = 2;
		text.textColor = [UIColor whiteColor];
		if (pinData.pinLevel==kIntermediate)
			text.text = [NSString stringWithFormat:@"%@<%@>%@", NSLocalizedString(@"取得",nil), 
																NSLocalizedString([[[Constants sharedInstance] getGameNamesDictionary] objectForKey:[NSNumber numberWithInt:pinData.game]],nil), 
						 NSLocalizedString(@"初心者襟章", nil)];
		else if (pinData.pinLevel == kMaster)
			text.text = [NSString stringWithFormat:@"%@<%@>%@", NSLocalizedString(@"取得",nil), 
						 NSLocalizedString([[[Constants sharedInstance] getGameNamesDictionary] objectForKey:[NSNumber numberWithInt:pinData.game]],nil), 
						 NSLocalizedString(@"大師級襟章", nil)];
		self.text = text;
		[text release];
		[self addSubview:self.pinbg];
		[self addSubview:self.pin];
		[self addSubview:self.text];
		
		self.alpha = 0;
    }
    return self;
}

- (void) show
{
	[[MediaManager sharedInstance] playStarSound];
	[UIView beginAnimations:@"show2" context:nil];
	[UIView setAnimationDuration:1.5];
	[UIView setAnimationDelegate:self];
	self.frame = CGRectOffset(self.frame, 0, -10);
	self.alpha = 0.8;
	[UIView commitAnimations];
}

-(void) dismiss
{
	[UIView beginAnimations:@"dismiss" context:nil];
	[UIView setAnimationDuration:1];
	[UIView setAnimationDelegate:self];
	self.alpha = 0.0;
	[UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if ([animationID isEqualToString:@"show"])	{
		[UIView beginAnimations:@"dismiss" context:nil];
		[UIView setAnimationDuration:2];
		[UIView setAnimationDelegate:self];
		self.alpha = 0.0;
		[UIView commitAnimations];
	}
	else if ([animationID isEqualToString:@"dismiss"])	{
		[self removeFromSuperview];
	}
}
	

- (void)dealloc {
	self.pin = nil;
	self.pinbg = nil;
	self.text = nil;
    [super dealloc];
}


@end
