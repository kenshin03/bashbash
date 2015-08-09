//
//  GameRecordTVC.m
//  bishibashi
//
//  Created by Eric on 05/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameRecordTVC.h"


@implementation GameRecordTVC

@synthesize mode = _mode;
@synthesize rankNo = _rankNo;
@synthesize sectionNo = _sectionNo;
@synthesize country = _country;
@synthesize terminalView = _terminalView;
- (void)dealloc 
{
	NSLog(@"dealloc GameRecordTVC");
	self.time = nil;
	self.mode = nil;
	self.country = nil;
	self.terminalView = nil;
	[super dealloc];
}


-(void)drawRect:(CGRect)rect
{
	// Since we use the CGContextRef a lot, it is convienient for our demonstration classes to do the real work
	// inside of a method that passes the context as a parameter, rather than having to query the context
	// continuously, or setup that parameter for every subclass.
//	[self drawInContext:UIGraphicsGetCurrentContext()];
}

-(void)drawInContext:(CGContextRef)context
{
	CGContextSaveGState(context);
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGFloat colors[] =
	{
		100.0 / 255.0, 100.0 / 255.0, 100.0 / 255.0, 1.00,
		30.0 / 255.0, 30.0 / 255.0, 30.0 / 255.0, 1.00,
		0.0 / 255.0,  0.0 / 255.0, 0.0 / 255.0, 1.00,
	};
	CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
	CGColorSpaceRelease(rgb);
	CGContextDrawLinearGradient(context, gradient, CGPointMake(0,0), CGPointMake(0,17), 0);
	CGContextDrawLinearGradient(context, gradient, CGPointMake(0,17), CGPointMake(0,44), 0);
	CGGradientRelease(gradient);
	CGContextRestoreGState(context);	
}


- (void) clearViewsOnCell
{
	self.mode.text = nil;
	self.country.image = nil;
	[self.terminalView willDisappear];
}

- (void) randomCellContent
{
	[self initInterface];
	/*
	if (self.rankNo %2 == 0)
		self.contentView.backgroundColor = [UIColor lightGrayColor];
	else
		self.contentView.backgroundColor = [UIColor grayColor];
	*/
	{
		NSMutableArray* stable = [NSMutableArray arrayWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],
								  [NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],
								  [NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],
								  [NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],nil];	
		NSString* str = [[NSString stringWithFormat:@"%d.",self.rankNo] stringByPaddingToLength:NUMCELL withString:@" " startingAtIndex:0];
		NSString* subtitle = [@""  stringByPaddingToLength:NUMSMALLCELL withString:@" " startingAtIndex:0];
		[self.terminalView setText:str AndStable:stable AndCountry:@"" AndScore:0 AndSubtitle:subtitle];
		self.terminalView.sectionNo = self.sectionNo;
		self.terminalView.rankNo = self.rankNo;
	}
}
	
- (void) setCellContent:(GameRecord*) gameRecord
{
	[self initInterface];
	if ([gameRecord.imei isEqualToString:[[UIDevice currentDevice] uniqueIdentifier]])
		self.terminalView.color = [UIColor redColor];
	else
		self.terminalView.color = [UIColor whiteColor];
//		self.contentView.backgroundColor = [UIColor redColor];
	/*
	if (self.rankNo %2 == 0)
		self.contentView.backgroundColor = [UIColor lightGrayColor];
	else
		self.contentView.backgroundColor = [UIColor grayColor];
*/
	NSString* level;
	switch (gameRecord.gameLevel)	{
		case (kEasy):
			level = @"Easy";
			break;
		case (kNormal):
			level = @"Normal";
			break;
		case (kHard):
			level = @"Hard";
			break;
		case (kWorldClass):
			level = @"Master";
			break;
	}
	int numPadding = NUMSMALLCELL - [[NSString timeSince:gameRecord.time WithLevel:1]length];
	NSString* subtitle = [[level stringByPaddingToLength:numPadding withString:@" " startingAtIndex:0] stringByAppendingString:[NSString timeSince:gameRecord.time WithLevel:1]];

	
	if (!gameRecord.isShown)	{
		NSMutableArray* stable = [NSMutableArray arrayWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],
								  [NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],
								  [NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],
								  [NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],nil];	
		NSString* str;
		if (gameRecord.name)
			str = [[NSString stringWithFormat:@"%d.%@",self.rankNo, [gameRecord.name uppercaseString]] stringByPaddingToLength:NUMCELL withString:@" " startingAtIndex:0];
		else
			str = [[NSString stringWithFormat:@"%d.%@",self.rankNo, @"Mr NoBody"] stringByPaddingToLength:NUMCELL withString:@" " startingAtIndex:0];
		[self.terminalView setText:str AndStable:stable AndCountry:gameRecord.country AndScore:gameRecord.score AndSubtitle:subtitle];
		self.terminalView.sectionNo = self.sectionNo;
		self.terminalView.rankNo = self.rankNo;
	}
	else {
		NSMutableArray* stable = [NSMutableArray arrayWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES],
								  [NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES],
								  [NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES],
								  [NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES],nil];	
		NSString* str;
		if (gameRecord.name)
			str = [[NSString stringWithFormat:@"%d.%@",self.rankNo, [gameRecord.name uppercaseString]] stringByPaddingToLength:NUMCELL withString:@" " startingAtIndex:0];
		else
			str = [[NSString stringWithFormat:@"%d.%@",self.rankNo, @"Mr NoBody"] stringByPaddingToLength:NUMCELL withString:@" " startingAtIndex:0];
		[self.terminalView setText:str AndStable:stable  AndCountry:gameRecord.country AndScore:gameRecord.score AndSubtitle:subtitle];
		self.terminalView.sectionNo = self.sectionNo;
		self.terminalView.rankNo = self.rankNo;		
	}

	
}	

- (void) initInterface
{
	self.contentView.backgroundColor = [UIColor blackColor];
	[self clearViewsOnCell];
	
	if (!self.terminalView)	{
		NSMutableArray* stable = [NSMutableArray arrayWithObjects:[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],
								  [NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],
								  [NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],
								  [NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],nil];
		TerminalBoardView* theView = [[TerminalBoardView alloc] initWithFrame:CGRectMake(1, 4, 25*10, 34) AndText:[@"" stringByPaddingToLength:NUMCELL withString:@" " startingAtIndex:0] AndStable:stable AndCountry:@"" AndScore:50 AndSubtitle:[@"" stringByPaddingToLength:NUMSMALLCELL withString:@" " startingAtIndex:0]];
		self.terminalView = theView;
		[theView release];
		[self.contentView addSubview:self.terminalView];
	}
		
}