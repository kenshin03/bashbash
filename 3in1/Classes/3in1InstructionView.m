//
//  3in1InstructionView.m
//  bishibashi
//
//  Created by Eric on 11/06/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "3in1InstructionView.h"


@implementation the3in1InstructionView
@synthesize integratedType = _integratedType;
@synthesize curSeq = _curSeq;
@synthesize seq = _seq;
@synthesize currentRound = _currentRound;
@synthesize rMachine = _rMachine;
@synthesize bMachine = _bMachine;
@synthesize gMachine = _gMachine;

@synthesize positions = _positions;
@synthesize stations = _stations;
@synthesize theRoute = _theRoute;


static const CGRect backgroundRectP = {{20, -10}, {230, 272}};



- (void) dealloc	{
	self.theRoute = nil;
	self.seq = nil;
	self.rMachine = nil;
	self.bMachine = nil;
	self.gMachine = nil;
	
	[super dealloc];
}


- (void) initScenarios
{
	[super initScenarios];
	/* scenario is NSNumber of random number 0-5 */
	for (int i=0; i<4; i++)	{
		NSNumber* scenario = [NSNumber numberWithInt:arc4random()%6];
		[self.scenarios addObject:scenario];
	}
}

- (void) startScenarios
{
	self.currentRound = 0;
	[self startRound];
	int seq = 1;
	for (int i=0; i<4; i++)	{
		seq++;
		int integratedType = [[self.scenarios objectAtIndex:i] intValue];
		NSLog(@"integrated type in start scenario is %d", integratedType);
		switch (integratedType)	{
			case 0:
				[self performSelector:@selector(redButClicked) withObject:nil afterDelay:0.8*seq];
				seq++;
				[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:0.8*seq];
				seq++;
				[self performSelector:@selector(blueButClicked) withObject:nil afterDelay:0.8*seq];
				seq++;
				break;
			case 1:
				[self performSelector:@selector(redButClicked) withObject:nil afterDelay:0.8*seq];
				seq++;
				[self performSelector:@selector(blueButClicked) withObject:nil afterDelay:0.8*seq];
				seq++;
				[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:0.8*seq];
				seq++;
				break;
			case 2:
				[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:0.8*seq];
				seq++;
				[self performSelector:@selector(redButClicked) withObject:nil afterDelay:0.8*seq];
				seq++;
				[self performSelector:@selector(blueButClicked) withObject:nil afterDelay:0.8*seq];
				seq++;
				break;
			case 3:
				[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:0.8*seq];
				seq++;
				[self performSelector:@selector(blueButClicked) withObject:nil afterDelay:0.8*seq];
				seq++;
				[self performSelector:@selector(redButClicked) withObject:nil afterDelay:0.8*seq];
				seq++;
				break;
			case 4:
				[self performSelector:@selector(blueButClicked) withObject:nil afterDelay:0.8*seq];
				seq++;
				[self performSelector:@selector(redButClicked) withObject:nil afterDelay:0.8*seq];
				seq++;
				[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:0.8*seq];
				seq++;
				break;
			case 5:
				[self performSelector:@selector(blueButClicked) withObject:nil afterDelay:0.8*seq];
				seq++;
				[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:0.8*seq];
				seq++;
				[self performSelector:@selector(redButClicked) withObject:nil afterDelay:0.8*seq];
				seq++;
				break;
		}
	}
}

-(void) initBackground
{
	[self setBackgroundColor:[UIColor blackColor]];	
	
	UIImage* tmpImage = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"mtrroute" ofType:@"png"]];
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:tmpImage];
	[tmpView setFrame:backgroundRectP];
	[self addSubview:tmpView];
	self.backgroundView = tmpView;
	[tmpView release];
	
}

- (void) initImages
{
	[super initImages];
	Route* theRoute = [[Route alloc] initWithOrientation:11 
										 AndStationNames:[NSArray arrayWithObjects:@"test1", @"test2", @"test3",@"test4", nil] 
											   AndColors:[NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil]];
	self.theRoute = theRoute;
	[theRoute release];
	[self addSubview:self.theRoute];

}
- (void) initObjects {
	
	self.stations = [NSArray  arrayWithObjects:
					 /* RGY */			 @"沙田", @"九龍塘", @"荔景", @"青衣", 
					 /* RYG */			 @"荃灣西", @"南昌", @"香港", @"銅鑼灣",
					 /* GRY */			 @"深水埗", @"美孚", @"南昌", @"香港",
					 /* GYR */			 @"銅鑼灣", @"香港", @"南昌", @"荃灣西",
					 /* YRG */			 @"九龍", @"南昌", @"美孚", @"深水埗",
					 /* YGR */			 @"九龍", @"香港", @"九龍塘", @"沙田",nil];
	
			float ratio = 0.8;
			CGPoint positions[] = {
				CGPointMake(270*ratio,30*ratio),CGPointMake(270*ratio,80*ratio),CGPointMake(120*ratio,80*ratio),CGPointMake(100*ratio,120*ratio),
				CGPointMake(20*ratio,50*ratio),CGPointMake(150*ratio,90*ratio),CGPointMake(140*ratio,220*ratio),CGPointMake(250*ratio,220*ratio),
				CGPointMake(220*ratio,90*ratio),CGPointMake(150*ratio,50*ratio),CGPointMake(150*ratio,80*ratio),CGPointMake(140*ratio,220*ratio),
				CGPointMake(250*ratio,220*ratio),CGPointMake(140*ratio,220*ratio),CGPointMake(150*ratio,90*ratio),CGPointMake(20*ratio,50*ratio),
				CGPointMake(160*ratio,160*ratio),CGPointMake(150*ratio,90*ratio),CGPointMake(150*ratio,50*ratio),CGPointMake(220*ratio,90*ratio),
				CGPointMake(160*ratio,160*ratio),CGPointMake(140*ratio,220*ratio),CGPointMake(270*ratio,80*ratio),CGPointMake(270*ratio,30*ratio)};
			self.positions = malloc(sizeof(CGPoint)*24);
			memcpy(self.positions, positions, sizeof(CGPoint)*24);
	
	
	
	if (!self.rMachine)	{
		Machine* rMachine = [[Machine alloc] initWithOwner:self AndColor:kRed AndOrientation:11];
		self.rMachine = rMachine;
		[self addSubview:self.rMachine];
		[rMachine release];
	}
	if (!self.gMachine)	{
		Machine* gMachine = [[Machine alloc] initWithOwner:self AndColor:kGreen AndOrientation:11];
		self.gMachine = gMachine;
		[self addSubview:self.gMachine];
		[gMachine release];
	}
	
	
	if (!self.bMachine)	{
		Machine* bMachine = [[Machine alloc] initWithOwner:self AndColor:kBlue AndOrientation:11];
		self.bMachine = bMachine;
		[self addSubview:self.bMachine];
		[bMachine release];
	}
	
	
}
- (void) startRound	{
	if ([self.scenarios count] > self.currentRound)	{
		NSMutableArray* theSeq = [[NSMutableArray alloc] initWithCapacity:3];
		self.seq = theSeq;
		[theSeq release];
		[self initObjects];
		self.curSeq = 0;
		self.integratedType = [[self.scenarios objectAtIndex:self.currentRound++] intValue];
		NSArray* colors;
		NSArray* stationNames;
		NSRange myRange = {self.integratedType*4, 4};
		switch (self.integratedType)	{
			case (0):
				[self.seq addObject:self.rMachine];
				self.rMachine.pos = 0;
				[self.seq addObject:self.gMachine];
				self.gMachine.pos = 1;
				[self.seq addObject:self.bMachine];
				self.bMachine.pos = 2;
				colors = [NSArray arrayWithObjects:[NSNumber numberWithInt:kRed], [NSNumber numberWithInt:kGreen], [NSNumber numberWithInt:kBlue], nil];	
				stationNames = [self.stations subarrayWithRange:myRange];
				CGRect a = {self.positions[self.integratedType*4],self.rMachine.frame.size};
				CGRect b = {self.positions[self.integratedType*4+1],self.gMachine.frame.size};
				CGRect c = {self.positions[self.integratedType*4+2],self.bMachine.frame.size};
				CGRect ab = {self.positions[self.integratedType*4+1],self.rMachine.frame.size};
				CGRect bc = {self.positions[self.integratedType*4+2],self.gMachine.frame.size};
				CGRect cd = {self.positions[self.integratedType*4+3],self.bMachine.frame.size};
				self.rMachine.frame = a;
				self.gMachine.frame = b;
				self.bMachine.frame = c;
				self.rMachine.finalPos = ab;
				self.gMachine.finalPos = bc;
				self.bMachine.finalPos = cd;
				break;
			case (1):
				[self.seq addObject:self.rMachine];
				self.rMachine.pos = 0;
				[self.seq addObject:self.bMachine];
				self.bMachine.pos = 1;
				[self.seq addObject:self.gMachine];
				self.gMachine.pos = 2;
				colors = [NSArray arrayWithObjects:[NSNumber numberWithInt:kRed], [NSNumber numberWithInt:kBlue], [NSNumber numberWithInt:kGreen], nil];
				stationNames = [self.stations subarrayWithRange:myRange];
				CGRect a2 = {self.positions[self.integratedType*4],self.rMachine.frame.size};
				CGRect b2 = {self.positions[self.integratedType*4+1],self.bMachine.frame.size};
				CGRect c2 = {self.positions[self.integratedType*4+2],self.gMachine.frame.size};
				CGRect ab2 = {self.positions[self.integratedType*4+1],self.rMachine.frame.size};
				CGRect bc2 = {self.positions[self.integratedType*4+2],self.bMachine.frame.size};
				CGRect cd2 = {self.positions[self.integratedType*4+3],self.gMachine.frame.size};
				self.rMachine.frame = a2;
				self.bMachine.frame = b2;
				self.gMachine.frame = c2;
				self.rMachine.finalPos = ab2;
				self.bMachine.finalPos = bc2;
				self.gMachine.finalPos = cd2;
				break;
			case (2):
				[self.seq addObject:self.gMachine];
				self.gMachine.pos = 0;
				[self.seq addObject:self.rMachine];
				self.rMachine.pos = 1;
				[self.seq addObject:self.bMachine];
				self.bMachine.pos = 2;
				colors = [NSArray arrayWithObjects:[NSNumber numberWithInt:kGreen], [NSNumber numberWithInt:kRed], [NSNumber numberWithInt:kBlue], nil];
				stationNames = [self.stations subarrayWithRange:myRange];
				CGRect a3 = {self.positions[self.integratedType*4],self.gMachine.frame.size};
				CGRect b3 = {self.positions[self.integratedType*4+1],self.rMachine.frame.size};
				CGRect c3 = {self.positions[self.integratedType*4+2],self.bMachine.frame.size};
				CGRect ab3 = {self.positions[self.integratedType*4+1],self.gMachine.frame.size};
				CGRect bc3 = {self.positions[self.integratedType*4+2],self.rMachine.frame.size};
				CGRect cd3 = {self.positions[self.integratedType*4+3],self.bMachine.frame.size};
				self.gMachine.frame = a3;
				self.rMachine.frame = b3;
				self.bMachine.frame = c3;
				self.gMachine.finalPos = ab3;
				self.rMachine.finalPos = bc3;
				self.bMachine.finalPos = cd3;
				break;
			case (3):
				[self.seq addObject:self.gMachine];
				self.gMachine.pos = 0;
				[self.seq addObject:self.bMachine];
				self.bMachine.pos = 1;
				[self.seq addObject:self.rMachine];
				self.rMachine.pos = 2;
				colors = [NSArray arrayWithObjects:[NSNumber numberWithInt:kGreen], [NSNumber numberWithInt:kBlue], [NSNumber numberWithInt:kRed], nil];
				stationNames = [self.stations subarrayWithRange:myRange];
				CGRect a4 = {self.positions[self.integratedType*4],self.gMachine.frame.size};
				CGRect b4 = {self.positions[self.integratedType*4+1],self.bMachine.frame.size};
				CGRect c4 = {self.positions[self.integratedType*4+2],self.rMachine.frame.size};
				CGRect ab4 = {self.positions[self.integratedType*4+1],self.gMachine.frame.size};
				CGRect bc4 = {self.positions[self.integratedType*4+2],self.bMachine.frame.size};
				CGRect cd4 = {self.positions[self.integratedType*4+3],self.rMachine.frame.size};
				self.gMachine.frame = a4;
				self.bMachine.frame = b4;
				self.rMachine.frame = c4;
				self.gMachine.finalPos = ab4;
				self.bMachine.finalPos = bc4;
				self.rMachine.finalPos = cd4;
				break;
			case (4):
				[self.seq addObject:self.bMachine];
				self.bMachine.pos = 0;
				[self.seq addObject:self.rMachine];
				self.rMachine.pos = 1;
				[self.seq addObject:self.gMachine];
				self.gMachine.pos = 2;
				colors = [NSArray arrayWithObjects:[NSNumber numberWithInt:kBlue], [NSNumber numberWithInt:kRed], [NSNumber numberWithInt:kGreen], nil];
				stationNames = [self.stations subarrayWithRange:myRange];
				CGRect a5 = {self.positions[self.integratedType*4],self.bMachine.frame.size};
				CGRect b5 = {self.positions[self.integratedType*4+1],self.rMachine.frame.size};
				CGRect c5 = {self.positions[self.integratedType*4+2],self.gMachine.frame.size};
				CGRect ab5 = {self.positions[self.integratedType*4+1],self.bMachine.frame.size};
				CGRect bc5 = {self.positions[self.integratedType*4+2],self.rMachine.frame.size};
				CGRect cd5 = {self.positions[self.integratedType*4+3],self.gMachine.frame.size};
				self.bMachine.frame = a5;
				self.rMachine.frame = b5;
				self.gMachine.frame = c5;
				self.bMachine.finalPos = ab5;
				self.rMachine.finalPos = bc5;
				self.gMachine.finalPos = cd5;
				break;
			case (5):
				[self.seq addObject:self.bMachine];
				self.bMachine.pos = 0;
				[self.seq addObject:self.gMachine];
				self.gMachine.pos = 1;
				[self.seq addObject:self.rMachine];
				self.rMachine.pos = 2;
				colors = [NSArray arrayWithObjects:[NSNumber numberWithInt:kBlue], [NSNumber numberWithInt:kGreen], [NSNumber numberWithInt:kRed], nil];
				stationNames = [self.stations subarrayWithRange:myRange];
				CGRect a6 = {self.positions[self.integratedType*4],self.bMachine.frame.size};
				CGRect b6 = {self.positions[self.integratedType*4+1],self.gMachine.frame.size};
				CGRect c6 = {self.positions[self.integratedType*4+2],self.rMachine.frame.size};
				CGRect ab6 = {self.positions[self.integratedType*4+1],self.bMachine.frame.size};
				CGRect bc6 = {self.positions[self.integratedType*4+2],self.gMachine.frame.size};
				CGRect cd6 = {self.positions[self.integratedType*4+3],self.rMachine.frame.size};
				self.bMachine.frame = a6;
				self.gMachine.frame = b6;
				self.rMachine.frame = c6;
				self.bMachine.finalPos = ab6;
				self.gMachine.finalPos = bc6;
				self.rMachine.finalPos = cd6;
				break;
		}
		[self.theRoute updateWithOrientation:11 
							 AndStationNames:stationNames 
								   AndColors:colors];
		
		[self.rMachine show];
		[self.gMachine show];
		[self.bMachine show];
	}
}	


- (void) success {
	[sharedSoundEffectsManager playYeahSound];
	
	[UIView beginAnimations:@"end" context:nil];
	[UIView setAnimationDuration:0.6];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];	
	for (Machine* machine in self.seq)	{
		//		[machine setHidden:YES];
		;
	}
	/*
	 switch (self.orientation)	{
	 case (UIInterfaceOrientationPortrait):
	 case (UIInterfaceOrientationPortraitUpsideDown):
	 [[self.machineImgs objectAtIndex:self.integratedType] setFrame:backgroundRectP];
	 break;
	 case (UIInterfaceOrientationLandscapeLeft):
	 case (UIInterfaceOrientationLandscapeRight):
	 [[self.machineImgs objectAtIndex:self.integratedType] setFrame:backgroundRectL];
	 break;
	 case (10):
	 [[self.machineImgs objectAtIndex:self.integratedType] setFrame:backgroundRectR];
	 break;
	 }
	 */
	[UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	int contextid = [((NSNumber*)context) intValue];
	if ([animationID isEqualToString:@"end"])	{
		[self.crossView removeFromSuperview];
		
		[self startRound];
		
	}
	else if ([animationID isEqualToString:@"integrate1"]){
		[sharedSoundEffectsManager playIntegrateSound];
		if (contextid==2)
			[self success];
	}
	else if ([animationID isEqualToString:@"fail"] && contextid==2 && [finished boolValue]==YES)	{
		[self fail];
	}
	
}



- (void) redButClicked
{
	[super redButClicked];
	Machine* machine = [self.seq objectAtIndex:self.curSeq];
	if (machine.color == kRed)	{
		self.curSeq ++;
		[self bringSubviewToFront:machine];
		[self.theRoute show:self.curSeq-1];
		[machine toIntegrate];
		
	}
}

- (void) blueButClicked
{
	[super blueButClicked];
	Machine* machine = [self.seq objectAtIndex:self.curSeq];
	if (machine.color == kBlue)	{
		self.curSeq ++;
		[self bringSubviewToFront:machine];
		[self.theRoute show:self.curSeq-1];
		[machine toIntegrate];
	}
}

- (void) greenButClicked
{
	[super greenButClicked];
	Machine* machine = [self.seq objectAtIndex:self.curSeq];
	if (machine.color == kGreen)	{
		self.curSeq ++;
		[self bringSubviewToFront:machine];
		[self.theRoute show:self.curSeq-1];
		[machine toIntegrate];
	}
}


@end