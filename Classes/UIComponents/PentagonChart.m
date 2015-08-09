//
//  PentagonChart.m
//  bishibashi
//
//  Created by Eric on 22/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PentagonChart.h"


@implementation PentagonChart
@synthesize center  = _center;
@synthesize scores = _scores;
@synthesize fulllength = _fulllength;
@synthesize scoreLabels = _scoreLabels;
@synthesize scoreStrings = _scoreStrings;
@synthesize theTimer = _theTimer;
@synthesize showRank = _showRank;

-(id) initWithFrame:(CGRect)frame AndScores:(NSArray*)scores AndTotalScores:(NSArray*)totalscores AndScoreLabels:(NSArray*)scoreLabels AndShowRank:(BOOL)showRank
{
	if (self = [super initWithFrame:frame])	{
		self.showRank = showRank;
		self.backgroundColor = [UIColor clearColor];
		self.opaque = YES;
		self.clearsContextBeforeDrawing = YES;	

		_step = 0;
		self.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
		if (self.frame.size.width > self.frame.size.height)
			self.fulllength = self.frame.size.width/3;
		else {
			self.fulllength = self.frame.size.height/3;
		}
		self.scores = [NSMutableArray arrayWithCapacity:5];
		for (int i=0; i<[scores count]; i++)	{
			float score;
			if (fabs([[totalscores objectAtIndex:i] floatValue])<0.00001)
				score = 0.0;
			else
				score = [[scores objectAtIndex:i] floatValue] / [[totalscores objectAtIndex:i] floatValue];
			[self.scores addObject:[NSNumber numberWithFloat:score]];
		}
		self.scoreStrings = [NSArray arrayWithArray:scoreLabels];
		self.scoreLabels = [NSMutableArray arrayWithCapacity:5];
		for (int i=0; i<[self.scores count]; i++)	{
//		for (NSNumber* number in self.scores)	{
			float score = [[self.scores objectAtIndex:i] floatValue];
			if (score>=80)
				[self.scoreLabels addObject:@"S"];
			else if (score >=70)
				[self.scoreLabels addObject:@"A"];
			else if (score >=60)
				[self.scoreLabels addObject:@"B"];
			else if (score >=50)
				[self.scoreLabels addObject:@"C"];
			else if (score >=40)
				[self.scoreLabels addObject:@"D"];
			else if (score >=30)
				[self.scoreLabels addObject:@"E"];
			else
				[self.scoreLabels addObject:@"F"];
			
			// for making minimal values to be shown on the pentagon chart
			if (score<20)
				[self.scores replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:20.0]];
		}
			
	}
	self.theTimer= [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
	/*
	NSArray *familyNames = [UIFont familyNames];
	for( NSString *familyName in familyNames ){
		NSLog( @"Family: %s \n", [familyName UTF8String] );
		NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
		for( NSString *fontName in fontNames ){
			NSLog( @"\tFont: %s \n", [fontName UTF8String] );
		}
	}
	*/
	return self;
}

-(void) dealloc
{
	NSLog(@"dealloc PentagoChart");
	[self.theTimer invalidate];
	self.theTimer = nil;
	self.scoreLabels = nil;
	self.scoreStrings = nil;
	self.scores = nil;
	[super dealloc];
}
- (void)timerFireMethod:(NSTimer*)theTimer
{
	if (_step <=1)	{
		_step += 0.1;
		[self setNeedsDisplay];
	}
	else
		[self.theTimer invalidate];
}

- (void)drawRect:(CGRect)rect
{
	[self drawInContext:UIGraphicsGetCurrentContext()];
}

-(void)drawInContext:(CGContextRef)context
{
	// Drawing with a white stroke color
	CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
	// Drawing with a blue fill color
	CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
	// Draw them with a 2.0 stroke width so they are a bit more visible.
	CGContextSetLineWidth(context, 2.0);

	CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
	CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
	CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
	CGContextSetTextDrawingMode(context, kCGTextFill);

	// Draw the panel label
	UIFont* theFont = [UIFont fontWithName:@"STHeitiTC-Light" size:13];
	for(int i = 0; i < 5; ++i)
	{
		CGContextMoveToPoint(context, self.center.x, self.center.y);
		CGFloat x = self.fulllength * sinf(i * 2.0 * M_PI / 5.0);
		CGFloat y = self.fulllength * cosf(i * 2.0 * M_PI / 5.0);
		CGContextAddLineToPoint(context, self.center.x - x, self.center.y - y);
		CGPoint textPos;

		int strLen = [[self.scoreStrings objectAtIndex:i] length];
		switch (i)	{
			case (0):
				textPos = CGPointMake(self.center.x - 1.05*x-13*strLen/3, self.center.y - 1.05*y-13);
				break;
			case (1):
				textPos = CGPointMake(self.center.x - 1.05*x-28, self.center.y - 1.05*y-20);
				break;
			case (2):
				textPos = CGPointMake(self.center.x - 1.05*x-13*strLen/3, self.center.y - 1.05*y);
				break;
			case (3):
				textPos = CGPointMake(self.center.x - 1.05*x-13*strLen/3, self.center.y - 1.05*y);
				break;
			case (4):
				textPos = CGPointMake(self.center.x - 1.05*x-5, self.center.y - 1.05*y-20);
				break;
		}
		
		[[self.scoreStrings objectAtIndex:i] drawAtPoint:textPos withFont:theFont];
	}
	
	// Draw the panel
	// Drawing with a white stroke color
	CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
	// Drawing with a blue fill color
	CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
	CGContextMoveToPoint(context, self.center.x, self.center.y - self.fulllength);
	for(int i = 1; i < 5; ++i)
	{
		CGFloat x = self.fulllength * sinf(i * 2.0 * M_PI / 5.0);
		CGFloat y = self.fulllength * cosf(i * 2.0 * M_PI / 5.0);
		CGContextAddLineToPoint(context, self.center.x - x, self.center.y - y);
	}
	// And close the subpath.
	CGContextClosePath(context);
	// Now draw the star & hexagon with the current drawing mode.
	CGContextDrawPath(context, kCGPathFillStroke);
	
	// Draw the scoring area
	CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
	CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 0.3);
	CGContextSetTextDrawingMode(context, kCGTextFillStroke);
	CGContextMoveToPoint(context, self.center.x, self.center.y - [[self.scores objectAtIndex:0] floatValue]/100*self.fulllength);
	theFont = [UIFont fontWithName:@"Helvetica" size:13];
	for(int i = 0; i < 5; ++i)
	{
		CGFloat x = [[self.scores objectAtIndex:i] floatValue]/100*self.fulllength * sinf(i * 2.0 * M_PI / 5.0)*_step;
		CGFloat y = [[self.scores objectAtIndex:i] floatValue]/100*self.fulllength * cosf(i * 2.0 * M_PI / 5.0)*_step;
		CGContextAddLineToPoint(context, self.center.x - x, self.center.y - y);
		CGFloat newx, newy;
		if (x>0)
			newx=self.center.x-x-16;
		else if (x==0)
			newx = self.center.x-x-8;
		else
			newx = self.center.x-x;
		if (y>0)
			newy=self.center.y-y-16;
		else if (y==0)
			newy=self.center.y-y-8;
		else 
			newy=self.center.y-y;
	
		if (self.showRank)
			[[self.scoreLabels objectAtIndex:i] drawAtPoint:CGPointMake(newx, newy) withFont:theFont];
	}
	CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 0.3);
	// And close the subpath.
	CGContextClosePath(context);	
	// Now draw the star & hexagon with the current drawing mode.
	CGContextDrawPath(context, kCGPathFill);

	
}

@end