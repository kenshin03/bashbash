//
//  Route.m
//  bishibashi
//
//  Created by Eric on 30/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Route.h"


@implementation Route
@synthesize startStation = _startStation;
@synthesize startStationNameLabel = _startStationNameLabel;
@synthesize stations = _stations;
@synthesize stationNameLabels = _stationNameLabels;
@synthesize lines = _lines;

static const float yDisplacement1P = 20;
static const float yDisplacement2P = 23;
static const float yDisplacement1L = 13;
static const float yDisplacement2L = 15;
static const float xDisplacement1P = 25;
static const float xDisplacement2P = 50;
static const float xDisplacement1I = 20;
static const float xDisplacement2I = 40;
static const float lineExtP = 10;
static const float lineExtL = 10;
static const float lineHeightP = 14;
static const float lineHeightL = 8;
static const CGRect startStationRectP = {{15, 20}, {25, 25}};
static const CGRect startStationRectL = {{15, 15}, {25, 20}};
static const float fontSizeP = 16.0;
static const float fontSizeL = 10.0;

static const float transit_xP=25;
static const float transit_yP=47;

static const float transit_xL=25;
static const float transit_yL=35;

static const float station_xP=25;
static const float station_yP=25;

static const float station_xL=25;
static const float station_yL=20;


static const CGRect selfRectP = {{20,320},{280,60}};
static const CGRect selfRectL = {{20,195},{280,60}};
static const CGRect selfRectI = {{20,220},{220,60}};

-(void) dealloc
{
	self.lines = nil;
	self.startStationNameLabel;
	self.stations = nil;
	self.stationNameLabels = nil;
	self.startStation = nil;
	[super dealloc];
}

-(void) show:(int) pos
{
	UIView* theView = [self.lines objectAtIndex:pos];
	[UIView beginAnimations:@"line" context:[NSNumber numberWithInt:pos]];
	[UIView setAnimationDuration:0.1];
	[UIView setAnimationDelegate:self];
//	theView.frame = CGRectMake(theView.frame.origin.x,theView.frame.origin.y,theView.frame.size.width, yDisplacement2);
//	[self addSubview:theView];
	
	
	
	[UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if ([animationID isEqual:@"line"])	{
		[UIView beginAnimations:@"showStation" context:context];
		[UIView setAnimationDuration:0.1];
		[UIView setAnimationDelegate:self];
		UIImageView* theView = [self.stations objectAtIndex:[context intValue]];
		theView.transform = (CGAffineTransformMakeScale(2.0, 2.0));
		[UIView commitAnimations];
	}		 
	else if ([animationID isEqual:@"showStation"])	{
		[UIView beginAnimations:@"showStation2" context:context];
		[UIView setAnimationDuration:0.1];
		UIImageView* theView = [self.stations objectAtIndex:[context intValue]];
		theView.transform = (CGAffineTransformMakeScale(1.0,1.0));
		[UIView commitAnimations];
	}		 
	
}

- (void) updateWithOrientation:(UIInterfaceOrientation) orientation AndStationNames:(NSArray*) stationNames AndColors:(NSArray*)colors
{
	float xDisplacement1;
	float xDisplacement2;
	
	switch (orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
			xDisplacement1 = xDisplacement1P;
			xDisplacement2 = xDisplacement2P;
			break;
		case (11):
			xDisplacement1 = xDisplacement1I;
			xDisplacement1 = xDisplacement1I;
			break;
	}
	float offset_x = xDisplacement1+xDisplacement2;
	self.startStationNameLabel.text = [stationNames objectAtIndex:0];
	for (int i=0; i<[colors count]; i++)	{
		[[self.stationNameLabels objectAtIndex:i] setText:[stationNames objectAtIndex:(i+1)]];
		if (i<[colors count]-1)
			[[self.stations objectAtIndex:i] setImage:[UIImage imageNamed:@"transit.png"]];
		else
			[[self.stations objectAtIndex:i] setImage:[UIImage imageNamed:@"station.png"]];
	//	[[self.lines objectAtIndex:i] setFrame:CGRectMake(offset_x,yDisplacement1,xDisplacement2,14)];

		
		switch ([[colors objectAtIndex:i] intValue])	{
			case (kRed):
				[[self.lines objectAtIndex:i] setBackgroundColor:[UIColor redColor]];
				break;
			case (kGreen):
				[[self.lines objectAtIndex:i] setBackgroundColor:[UIColor colorWithRed:0.267 green:0.675 blue:0.4 alpha:1]];
				break;
			case (kBlue):
				[[self.lines objectAtIndex:i] setBackgroundColor:[UIColor orangeColor]];
				break;
		}
		[self bringSubviewToFront:[self.stations objectAtIndex:i]];
		offset_x += (xDisplacement1+xDisplacement2);
	}
	[self bringSubviewToFront:self.startStation];
}
				 
														
- (id) initWithOrientation:(UIInterfaceOrientation) orientation AndStationNames:(NSArray*) stationNames AndColors:(NSArray*)colors
{
	CGRect selfRect;
	CGRect startStationRect;
	float fontSize;
	float yDisplacement1;
	float yDisplacement2;
	float lineExt;
	float lineHeight;
	float transit_x;
	float transit_y;
	float station_x;
	float station_y;
	float xDisplacement1;
	float xDisplacement2;
	switch (orientation)	{
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
			startStationRect = startStationRectL;
			selfRect = selfRectL;
			fontSize = fontSizeL;
			yDisplacement1 = yDisplacement1L;
			yDisplacement2 = yDisplacement2L;
			lineExt = lineExtL;
			lineHeight = lineHeightL;
			transit_x = transit_xL;
			transit_y = transit_yL;
			station_x = station_xL;
			station_y = station_yL;
			xDisplacement1 = xDisplacement1P;
			xDisplacement2 = xDisplacement2P;
			break;
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
			startStationRect = startStationRectP;
			selfRect = selfRectP;
			fontSize = fontSizeP;
			yDisplacement1 = yDisplacement1P;
			yDisplacement2 = yDisplacement2P;
			lineExt = lineExtP;
			lineHeight = lineHeightP;
			transit_x = transit_xP;
			transit_y = transit_yP;
			station_x = station_xP;
			station_y = station_yP;
			xDisplacement1 = xDisplacement1P;
			xDisplacement2 = xDisplacement2P;
			break;
		case 11:
			startStationRect = startStationRectL;
			selfRect = selfRectI;
			fontSize = fontSizeL;
			yDisplacement1 = yDisplacement1L;
			yDisplacement2 = yDisplacement2L;
			lineExt = lineExtL;
			lineHeight = lineHeightL;
			transit_x = transit_xL;
			transit_y = transit_yL;
			station_x = station_xL;
			station_y = station_yL;
			xDisplacement1 = xDisplacement1I;
			xDisplacement2 = xDisplacement2I;
			break;
			
	}			
	if (self = [super initWithFrame:selfRect])	{
		if (!self.startStation)	{
			UIImageView* theView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"station.png"]];
			self.startStation = theView;
			[theView release];
			self.startStation.frame = startStationRect;
			[self addSubview:self.startStation];
			UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(15-40/2, -yDisplacement1, 60,20)];
			self.startStationNameLabel = label;
			[label release];
			self.startStationNameLabel.text = [stationNames objectAtIndex:0];
			self.startStationNameLabel.font = [UIFont systemFontOfSize:fontSize];
			self.startStationNameLabel.textColor = [UIColor blackColor];
			self.startStationNameLabel.numberOfLines=1;
			self.startStationNameLabel.backgroundColor = [UIColor clearColor];
			self.startStationNameLabel.textAlignment = UITextAlignmentCenter;
			[self addSubview:self.startStationNameLabel];
		}

		self.lines = [NSMutableArray arrayWithCapacity:3];
		
		self.stations = [NSMutableArray arrayWithCapacity:3];
		
		self.stationNameLabels = [NSMutableArray arrayWithCapacity:3];
		
		float offset_x = 15+xDisplacement1;
		for (int i=0; i<[colors count]; i++)	{
			UIView* theView = [[UIView alloc] initWithFrame:CGRectMake(offset_x-lineExt,yDisplacement2,xDisplacement2+2*lineExt,lineHeight)];
			switch ([[colors objectAtIndex:i] intValue])	{
				case (kRed): 
					theView.backgroundColor = [UIColor redColor];
					break;
				case (kGreen):
					theView.backgroundColor = [UIColor colorWithRed:0.267 green:0.675 blue:0.4 alpha:1];
					break;
				case (kBlue):
					theView.backgroundColor = [UIColor orangeColor];
					break;
			}
			[self addSubview:theView];
			[self.lines addObject:theView];
			[theView release];
		
			UIImageView* theStation;
			if (i<[colors count]-1)	{
				theStation = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"transit.png"]];
				theStation.frame = CGRectMake(offset_x+xDisplacement2, 0, transit_x, transit_y);
			}
			else	{
				theStation = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"station.png"]];
				theStation.frame = CGRectMake(offset_x+xDisplacement2, yDisplacement1, station_x, station_y);
			}
			[self.stations addObject:theStation];
			[self addSubview:theStation];
			[theStation release];
			
			
			UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(offset_x+xDisplacement2-40/2, -yDisplacement1, 60,20)];
			label.text = [stationNames objectAtIndex:i+1];
			label.font = [UIFont systemFontOfSize:fontSize];
			label.textColor = [UIColor blackColor];
			label.backgroundColor = [UIColor clearColor];
			label.numberOfLines =1;
			label.textAlignment = UITextAlignmentCenter;
			[self.stationNameLabels addObject:label];
			[self addSubview:label];
			[label release];
			
			offset_x += (xDisplacement2 + xDisplacement1);
		}
	}
	return self;
}


@end
