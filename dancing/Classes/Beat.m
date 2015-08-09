//
//  Beat.m
//  bishibashi
//
//  Created by Eric on 04/07/2010.
//  Copyright 2010 Red Soldier. All rights reserved.
//

#import "Beat.h"


@implementation Beat
@synthesize theBeatType = _theBeatType;
static const CGRect twoBeatRectP = {{0,0}, {30, 30}};
static const CGRect fourBeatRectP = {{0, 0}, {25, 25}};
static const CGRect eightBeatRectP = {{0, 0}, {20, 20}};

-(id) initWithBeatType:(BeatType)theBeatType
{
	switch (theBeatType)	{
		case (k2Beat):
			self = [super initWithImage:[[UIImage imageNamed:@"lightbulb.png"] scaleImage:twoBeatRectP]];
			break;
		case (k4Beat):
			self = [super initWithImage:[[UIImage imageNamed:@"lightbulb.png"] scaleImage:fourBeatRectP]];
			break;		
		case (k8Beat):
			self = [super initWithImage:[[UIImage imageNamed:@"lightbulb.png"] scaleImage:eightBeatRectP]];				
			break;
		case (kFinishBeat):
	//		self = [super initWithImage:[[UIImage imageNamed:@"lightbulb_finish.png"] scaleImage:twoBeatRectP]];				
			break;
	}

	self.theBeatType = theBeatType;
	[self setHidden:YES];
	return self;
}

-(NSTimeInterval) getTime:(float)constant
{
	switch (self.theBeatType)	{
		case (k2Beat):
			return constant * 2.0;
			break;
		case (k4Beat):
			return constant;
			break;
		case (k8Beat):
			return constant/2.0;
			break;
		case (kFinishBeat):
			return 0.1;
			break;
	}
}

- (void) show:(NSNumber*)constant
{
	[[MediaManager sharedInstance] playTapSound];
	NSTimeInterval delay = [self getTime:[constant floatValue]]; 
	[self performSelector:@selector(unHide) withObject:nil afterDelay:delay];
}

- (void) unHide
{
	[self setHidden:NO];
}

- (void) showCorrect
{
	switch (self.theBeatType)	{
		case (k2Beat):
			self.image = [[UIImage imageNamed:@"lightbulb_light.png"] scaleImage:twoBeatRectP];
			break;
		case (k4Beat):
			self.image = [[UIImage imageNamed:@"lightbulb_light.png"] scaleImage:fourBeatRectP];
			break;		
		case (k8Beat):
			self.image = [[UIImage imageNamed:@"lightbulb_light.png"] scaleImage:eightBeatRectP];				
			break;
	}	
}

- (void) showInCorrect
{
	switch (self.theBeatType)	{
		case (k2Beat):
			self.image = [[UIImage imageNamed:@"lightbulb_dim.png"] scaleImage:twoBeatRectP];
			break;
		case (k4Beat):
			self.image = [[UIImage imageNamed:@"lightbulb_dim.png"] scaleImage:fourBeatRectP];
			break;		
		case (k8Beat):
			self.image = [[UIImage imageNamed:@"lightbulb_dim.png"] scaleImage:eightBeatRectP];				
			break;
	}	
}

-(void) dealloc
{
	NSLog(@"dealloc beat");
	[super dealloc];
}

@end
