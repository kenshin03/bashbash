//
//  BunHillInstructionView.m
//  bishibashi
//
//  Created by Eric on 08/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "BunHillInstructionView.h"


@implementation BunHillInstructionView
@synthesize theClimbingMan = _theClimbingMan;
@synthesize seq = _seq;
@synthesize queues = _queues;

static const CGRect backgroundRectP = {{0, 0}, {240, 260}};

-(void) initBackground
{
	[self setBackgroundColor:[UIColor blackColor]];	
	UIImage* tmpImage = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"bunhillbackground" ofType:@"png"]];
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:tmpImage];
	[tmpView setFrame:backgroundRectP];
	self.backgroundView = tmpView;
	[self addSubview:tmpView];
	[tmpView release];

	if (!self.theClimbingMan)	{
		ClimbingMan* theClimbingMan = [[ClimbingMan alloc] initWithOrientation:11];
		self.theClimbingMan = theClimbingMan;
		[theClimbingMan release];
		[self addSubview:self.theClimbingMan];
	}
	
	self.seq = 1;
	
}

- (void) dealloc	{
	NSLog(@"dealloc BunHill InstructionView");
	self.theClimbingMan = nil;
	self.queues = nil;
	[super dealloc];
}



- (void) startScenarios 
{
	self.queues = [NSArray arrayWithObjects:[NSMutableArray arrayWithCapacity:10],
				   [NSMutableArray arrayWithCapacity:10],
				   [NSMutableArray arrayWithCapacity:10],
				   [NSMutableArray arrayWithCapacity:10],
				   [NSMutableArray arrayWithCapacity:10],
				   [NSMutableArray arrayWithCapacity:10],
				   [NSMutableArray arrayWithCapacity:10],
				   nil];
	
	for (int i=0; i<6; i++)	{
		for (int j=0; j<3; j++)	{
			Bun* aBun = [[Bun alloc] initWithOwner:self andOrientation:11 AndPos:i AndCol:[[self.queues objectAtIndex:i] count]  AndSpecial:NO AndDifficultLevel:kNormal];
			[[self.queues objectAtIndex:i] addObject:aBun];
			[aBun show];
			[self addSubview:aBun];
			[aBun release];
		}
	}

	for (int i=0; i<6; i++)	
		[self performSelector:@selector(blueButClicked) withObject:nil afterDelay:0.3*i];

	for (int k=0; k<6; k++)	{
		for (int j=0; j<3; j++)	
			[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:0.3*6 + 0.3*4*k + 0.3*j];			
		[self performSelector:@selector(redButClicked) withObject:nil afterDelay:0.3*6 + 0.3*4*k + 0.3*3];
	}
		
}

- (void) collectBun:(int) pos FromUser:(BOOL)fromUser
{
	if ([[self.queues objectAtIndex:pos]count]>0)	{
		Bun* aBun =[[self.queues objectAtIndex:pos] objectAtIndex:0];
		if (fromUser)	{
			[[MediaManager sharedInstance] playMouthPopSound];
		}
		[aBun collectedFromUser:fromUser];
		[[self.queues objectAtIndex:pos]removeObjectAtIndex:0];
		for (Bun* aBun in [self.queues objectAtIndex:pos])	{
			aBun.column --;
			[aBun show];
		}
	}
}

- (void) redButClicked
{
	[super redButClicked];
	[self.theClimbingMan moveLeft];
}

- (void) blueButClicked
{
	[super blueButClicked];
	[self.theClimbingMan moveRight];	
}

- (void) greenButClicked
{
	[super greenButClicked];
	[self.theClimbingMan moveArm];
	[self collectBun:self.theClimbingMan.pos FromUser:YES];
}

@end
