//
//  SnowFlakeView.m
//  bishibashi
//
//  Created by Eric on 13/12/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "SnowFlakeView.h"


@implementation SnowFlakeView
@synthesize snowFlakes = _snowFlakes;

-(id) initWithFrame:(CGRect)frame	{
	self = [super initWithFrame:frame];
	self.snowFlakes = [NSMutableArray arrayWithCapacity:30];
//	self.frame = CGRectMake(0,0,320,480);
//	self.backgroundColor = [UIColor clearColor];
//	[self initSnowFlakes];
	return self;
}

-(void) initSnowFlakes
{
	if (!self.snowFlakes)
		self.snowFlakes = [NSMutableArray arrayWithCapacity:30];
	for (int i=0; i<30; i++)	{
		[self addSnowFlakeWithDelay:i];
	}
}

-(void) addSnowFlakeWithDelay:(int)delay	{
	int x = arc4random()%320;
	SnowFlake* theFlake = [[SnowFlake alloc] initWithFrame:CGRectMake(x, -5, 5,5)];
	theFlake.owner = self;
	theFlake.backgroundColor = [UIColor clearColor];
	[self addSubview:theFlake];
	[theFlake performSelector:@selector(fallDown) withObject:nil afterDelay:delay];
	[self.snowFlakes addObject:theFlake];
	[theFlake release];	
}


- (void) dealloc {
	@synchronized(self)	{
	for (SnowFlake* theSnowFlake in self.snowFlakes)	{
		theSnowFlake.isStopped = YES;
		NSLog(@"snow count1 is %d", [theSnowFlake retainCount]);
		[NSObject cancelPreviousPerformRequestsWithTarget:theSnowFlake];
		NSLog(@"snow count2 is %d", [theSnowFlake retainCount]);
		[theSnowFlake removeFromSuperview];
	}
	self.snowFlakes = nil;
	[super dealloc];
	}	
}

- (void) removeAllSnowFlakes
{
	@synchronized(self)	{
	for (SnowFlake* theSnowFlake in self.snowFlakes)	{
		theSnowFlake.isStopped = YES;
		NSLog(@"snow count1 is %d", [theSnowFlake retainCount]);
		[NSObject cancelPreviousPerformRequestsWithTarget:theSnowFlake];
		NSLog(@"snow count2 is %d", [theSnowFlake retainCount]);
		[theSnowFlake removeFromSuperview];
	}
	self.snowFlakes = nil;
	}
}

@end
