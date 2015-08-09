//
//  SnowFlake.m
//  bishibashi
//
//  Created by Eric on 13/12/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "SnowFlake.h"


@implementation SnowFlake

static const float vVelocity = 20;
static const float hVelocity = 5;
static const float starSize = 4;

@synthesize owner = _owner;

@synthesize isStopped = _isStopped;

- (id) initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])	{
		self.isStopped = NO;
	}
	return self;
}
-(void)drawRect:(CGRect)rect	{
	CGContextRef context = UIGraphicsGetCurrentContext();
//	CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
		
	CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
	CGContextFillEllipseInRect(context, CGRectMake(0,0,self.frame.size.width, self.frame.size.height));
	/*
	CGContextMoveToPoint(context, center.x, center.y);
			for(int j = 1; j < 5; ++j)
			{
				CGFloat x = starSize * sinf(j * 4.0 * M_PI / 5.0);
				CGFloat y = starSize * cosf(j * 4.0 * M_PI / 5.0);
				CGContextAddLineToPoint(context, center.x +x , center.y + y);
			}
			// And close the subpath.
			CGContextClosePath(context);
			// Now draw the star & hexagon with the current drawing mode.
			CGContextDrawPath(context, kCGPathFill);
	*/	
}

- (void) fallDown
{
	@synchronized(self.owner)	{
		if (!self.isStopped && [[self.owner snowFlakes] containsObject:self])	{
			[self.owner bringSubviewToFront:self];
			[UIView beginAnimations:@"fallDown" context:nil];
			[UIView setAnimationDuration:1];
			[UIView setAnimationCurve:UIViewAnimationCurveLinear];
			[UIView setAnimationDelegate:self];
			if (arc4random()%2 == 0)
				self.frame = CGRectOffset(self.frame, hVelocity, vVelocity);
			else
				self.frame = CGRectOffset(self.frame, -hVelocity, vVelocity);
			 [UIView commitAnimations];
		}
		else	{
			NSLog(@"in fall down, isStopped or not contain, remove myself from view");
			[self removeFromSuperview];
		}
	}
}	

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	@synchronized(self.owner)	{
		if (self.isStopped || ![[self.owner snowFlakes] containsObject:self])	{
			NSLog(@"in animationDidStop, isStopped or not contain, remove myself from view and array");
			[[self.owner snowFlakes] removeObject:self];
			[self removeFromSuperview];
		}			
			
		else 
			if (self.frame.origin.y <480)
			[self fallDown];
			else {
			[[self.owner snowFlakes] removeObject:self];
			[self removeFromSuperview];
			[self.owner addSnowFlakeWithDelay:1];
			}
	}
}

- (void) dealloc
{
	NSLog(@"snow dealloc");
	[super dealloc];
}	
	
@end
