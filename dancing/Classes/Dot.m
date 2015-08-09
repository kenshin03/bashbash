//
//  dot.m
//  bishibashi
//
//  Created by Eric on 08/07/2010.
//  Copyright 2010 Red Soldier. All rights reserved.
//

#import "Dot.h"


@implementation Dot
@synthesize x1 = _x1;
@synthesize x2 = _x2;
@synthesize duration = _duration;
static const height = 28;
static const size=12;

- (id) init	
{
	if (self=[super initWithImage:[UIImage imageNamed:@"redbean0.png"]])	{
		self.frame = CGRectMake(0,0,size,size);
	}
	return self;
}

- (void) jumpWithContext:(NSArray*)arr
{
	self.x1 = [[arr objectAtIndex:0] floatValue ];
	self.x2 = [[arr objectAtIndex:1] floatValue ];
	self.duration = [[arr objectAtIndex:2] floatValue ];;
	
	self.frame = CGRectMake(self.x1, self.frame.origin.y, size,size);
	[UIView beginAnimations:@"jump0" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:self.duration/4];
	[UIView setAnimationDelegate:self];
	self.frame = CGRectMake(self.frame.origin.x+(self.x2-self.x1)/4, self.frame.origin.y-height*2/3, self.frame.size.width, self.frame.size.height);
	[UIView commitAnimations];
}

- (void) hide
{
	[self setHidden:YES];
}

- (void) unHide
{
	[self setHidden:NO];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if ([animationID isEqualToString:@"jump0"])	{
		[UIView beginAnimations:@"jump1" context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationDuration:self.duration/4];
		[UIView setAnimationDelegate:self];
		self.frame = CGRectMake(self.frame.origin.x+(self.x2-self.x1)/4, self.frame.origin.y-height/3, self.frame.size.width, self.frame.size.height);
		[UIView commitAnimations];
	}		
	else if ([animationID isEqualToString:@"jump1"])	{
		[UIView beginAnimations:@"jump2" context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		[UIView setAnimationDuration:self.duration/4];
		[UIView setAnimationDelegate:self];
		self.frame = CGRectMake(self.frame.origin.x+(self.x2-self.x1)/4, self.frame.origin.y+height/3, self.frame.size.width, self.frame.size.height);
		[UIView commitAnimations];
	}		
	else if ([animationID isEqualToString:@"jump2"])	{
		[UIView beginAnimations:@"jump3" context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		[UIView setAnimationDuration:self.duration/4];
		[UIView setAnimationDelegate:self];
		self.frame = CGRectMake(self.frame.origin.x+(self.x2-self.x1)/4, self.frame.origin.y+height*2/3, self.frame.size.width, self.frame.size.height);
		[UIView commitAnimations];
	}		
}

-(void) dealloc
{
	NSLog(@"dealloc Dot");
	[super dealloc];
}
	
@end
