//
//  Ball.m
//  bishibashi
//
//  Created by Eric on 07/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Ball.h"
@implementation Ball
@synthesize direction = _direction;
@synthesize speed = _speed;
@synthesize owner = _owner;
//@synthesize image = _image;
@synthesize orientation = _orientation;
static const CGRect startRect1P = {{160, 400}, {30, 70}};
static const CGRect startRect2P = {{160, 310}, {30, 70}};
static const y_displacement1P = -120;
static const y_displacement2P = -90;
static const y_displacement3P = 90;
static const x_displacementP = 30;

static const CGRect startRect1L = {{160, 250}, {25, 25}};
static const CGRect startRect2L = {{160, 185}, {25, 25}};
static const y_displacement1L = -60;
static const y_displacement2L = -40;
static const y_displacement3L = 40;
static const x_displacementL = 30;

static const CGRect startRect1R = {{80, 250}, {15, 15}};
static const CGRect startRect2R = {{80, 180}, {15, 15}};
static const y_displacement1R = -60;
static const y_displacement2R = -40;
static const y_displacement3R = 40;
static const x_displacementR = 15;

static const CGRect startRect1I = {{105, 250}, {25, 25}};
static const CGRect startRect2I = {{105, 185}, {25, 25}};
static const y_displacement1I = -60;
static const y_displacement2I = -40;
static const y_displacement3I = 40;
static const x_displacementI = 20;

- (id)initWithOwner:(id)owner AndSpeed:(float)speed AndColor:(ButState) color AndOrientation:(UIInterfaceOrientation) orientation
{
	if (orientation==11)
		self = [super initWithFrame:startRect2P AndImageFrame:CGRectMake(0,0,25,25) WithNumStars:25];
	else
		self = [super initWithFrame:startRect2P AndImageFrame:CGRectMake(0,0,30,30) WithNumStars:25];
	if (self)	{
		self.orientation = orientation;
		self.owner = owner;
		self.speed = speed;
		self.direction = color;
		self.starOffsetY = 10.0;
		if (self.direction==kRed)	{
			self.redColor=1.0;
			self.greenColor=0.0;
			self.blueColor=0.0;
		}
		else if (self.direction==kGreen)	{
			self.redColor=0.0;
			self.greenColor = 1.0;
			self.blueColor=0.0;
		}
		else if (self.direction==kBlue)	{
			self.redColor=0.75;
			self.greenColor=0.75;
			self.blueColor=0.15;
		}
		switch (self.direction)	{
			case (kRed):
				self.image = [UIImage imageNamed:@"redbean0.png"];
				break;
			case (kBlue):
				self.image = [UIImage imageNamed:@"bluebean0.png"];
				break;
			case (kGreen):
				self.image = [UIImage imageNamed:@"greenbean0.png"];
				break;
		}
		
		}
	return self;
}

- (void) dealloc
{
	NSLog(@"dealloc Ball");
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.01];
	[UIView setAnimationCurve: UIViewAnimationCurveLinear];
	[self removeFromSuperview];
	[UIView commitAnimations];
	[UIView setAnimationsEnabled:YES];
	self.image = nil;
	[super dealloc];
}
/*
-(void)drawRect:(CGRect)rect	{
	CGContextRef context = UIGraphicsGetCurrentContext();

	[self.image drawInRect:CGRectMake(0,0,rect.size.width, rect.size.width)];
	
	CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.width/2);

	for (int i=0; i<15; i++)	{
		// Drawing with a fill color
		if (i%2==1)
			CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
		else{
			if (self.direction==kRed)
				CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
			else if (self.direction==kGreen)
				CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 1.0);
			else if (self.direction==kBlue)
				CGContextSetRGBFillColor(context, 0.75, 0.75, 0.15, 1.0);
		}

		CGContextMoveToPoint(context, center.x +_starPosX[i], center.y + _starPosY[i] + _starSize[i]);
		for(int j = 1; j < 5; ++j)
		{
			CGFloat x = _starSize[i] * sinf(j * 4.0 * M_PI / 5.0);
			CGFloat y = _starSize[i] * cosf(j * 4.0 * M_PI / 5.0);
			CGContextAddLineToPoint(context, center.x + _starPosX[i]+x , center.y + _starPosY[i]+ y);
		}
		// And close the subpath.
		CGContextClosePath(context);
		// Now draw the star & hexagon with the current drawing mode.
		CGContextDrawPath(context, kCGPathFill);
	}

	for (int i=0; i<15; i++)	{
		_starPosX[i] += (float)((arc4random()%10-5.0));
		_starPosY[i] += (float)((arc4random()%30-15.0));
		_starSize[i] *= 0.7;
	}
	// Now draw the star & hexagon with the current drawing mode.
//	CGContextDrawPath(context, kCGPathFill);
}
*/

- (void) show
{
	switch (self.orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
			[self setFrame:startRect1P];
			break;
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
			[self setFrame:startRect1L];
			break;
		case (10):
			[self setFrame:startRect1R];
			break;
		case (11):
			[self setFrame:startRect1I];
			break;
			
	}	

	[UIView beginAnimations:@"show1" context:nil];
	[UIView setAnimationDuration:self.speed];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
	switch (self.orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
			[self setFrame:startRect2P];
			break;
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
			[self setFrame:startRect2L];
			break;
		case (10):
			[self setFrame:startRect2R];
			break;
		case (11):
			[self setFrame:startRect2I];
			break;
	}	
	[UIView commitAnimations];	
	[self setNeedsDisplay];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	[self setNeedsDisplay];
	if ([animationID isEqualToString:@"show1"])	{
		[UIView beginAnimations:@"show2" context:nil];
		[UIView setAnimationDuration:self.speed];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
		switch (self.orientation)	{
			case (UIInterfaceOrientationPortrait):
			case (UIInterfaceOrientationPortraitUpsideDown):
				if (self.direction==kGreen)	{
					[self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y+y_displacement1P, 0.8*self.frame.size.width, 0.8*self.frame.size.height)];
					[self setImageRect:CGRectMake(0,0, 0.8*self.imageRect.size.width, 0.8*self.imageRect.size.height)];
				}
				else if (self.direction==kRed)	{
					[self setImageRect:CGRectMake(0,0,0.8*self.imageRect.size.width, 0.8*self.imageRect.size.height)];
					[self setFrame:CGRectMake(self.frame.origin.x-x_displacementP,self.frame.origin.y+y_displacement1P, 0.8*self.frame.size.width, 0.8*self.frame.size.height)];
				}	
				else if (self.direction==kBlue)	{
					[self setFrame:CGRectMake(self.frame.origin.x+x_displacementP,self.frame.origin.y+y_displacement1P, 0.8*self.frame.size.width, 0.8*self.frame.size.height)];
					[self setImageRect:CGRectMake(0,0, 0.8*self.imageRect.size.width, 0.8*self.imageRect.size.height)];
				}
					break;
			case (UIInterfaceOrientationLandscapeLeft):
			case (UIInterfaceOrientationLandscapeRight):
			case(11):
				if (self.direction==kGreen)	{
					[self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y+y_displacement1L, 0.8*self.frame.size.width, 0.8*self.frame.size.height)];
					[self setImageRect:CGRectMake(0,0, 0.8*self.imageRect.size.width, 0.8*self.imageRect.size.height)];

				}else if (self.direction==kRed)	{
					[self setFrame:CGRectMake(self.frame.origin.x-x_displacementL,self.frame.origin.y+y_displacement1L, 0.8*self.frame.size.width, 0.8*self.frame.size.height)];
					[self setImageRect:CGRectMake(0,0, 0.8*self.imageRect.size.width, 0.8*self.imageRect.size.height)];
				}
				else if (self.direction==kBlue)	{
					[self setFrame:CGRectMake(self.frame.origin.x+x_displacementL,self.frame.origin.y+y_displacement1L, 0.8*self.frame.size.width, 0.8*self.frame.size.height)];
					[self setImageRect:CGRectMake(0,0, 0.8*self.imageRect.size.width, 0.8*self.imageRect.size.height)];
				}
				break;
			case (10):
				if (self.direction==kGreen)
					[self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y+y_displacement1R, 0.8*self.frame.size.width, 0.8*self.frame.size.height)];
				else if (self.direction==kRed)
					[self setFrame:CGRectMake(self.frame.origin.x-x_displacementR,self.frame.origin.y+y_displacement1R, 0.8*self.frame.size.width, 0.8*self.frame.size.height)];
				else if (self.direction==kBlue)
					[self setFrame:CGRectMake(self.frame.origin.x+x_displacementR,self.frame.origin.y+y_displacement1R, 0.8*self.frame.size.width, 0.8*self.frame.size.height)];
				break;
		}		
		[UIView commitAnimations];	
	}
	if ([animationID isEqualToString:@"show2"])	{
		[UIView beginAnimations:@"show3" context:nil];
		[UIView setAnimationDuration:self.speed];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
		switch (self.orientation)	{
			case (UIInterfaceOrientationPortrait):
			case (UIInterfaceOrientationPortraitUpsideDown):
				if (self.direction==kGreen)	{
					[self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y+y_displacement2P, 0.8*self.frame.size.width, 0.8*self.frame.size.height)];
					[self setImageRect:CGRectMake(0,0, 0.8*self.imageRect.size.width, 0.8*self.imageRect.size.height)];
				}
				else if (self.direction==kRed){
					[self setFrame:CGRectMake(self.frame.origin.x-x_displacementP,self.frame.origin.y+y_displacement2P, 0.8*self.frame.size.width, 0.8*self.frame.size.height)];
					[self setImageRect:CGRectMake(0,0, 0.8*self.imageRect.size.width, 0.8*self.imageRect.size.height)];

				}else if (self.direction==kBlue)	{
					[self setFrame:CGRectMake(self.frame.origin.x+x_displacementP,self.frame.origin.y+y_displacement2P, 0.8*self.frame.size.width, 0.8*self.frame.size.height)];
					[self setImageRect:CGRectMake(0,0, 0.8*self.imageRect.size.width, 0.8*self.imageRect.size.height)];

				}break;
			case (UIInterfaceOrientationLandscapeLeft):
			case (UIInterfaceOrientationLandscapeRight):
			case(11):
				if (self.direction==kGreen)
					[self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y+y_displacement2L, 0.8*self.frame.size.width, 0.8*self.frame.size.height)];
				else if (self.direction==kRed)
					[self setFrame:CGRectMake(self.frame.origin.x-x_displacementL,self.frame.origin.y+y_displacement2L, 0.8*self.frame.size.width, 0.8*self.frame.size.height)];
				else if (self.direction==kBlue)
					[self setFrame:CGRectMake(self.frame.origin.x+x_displacementL,self.frame.origin.y+y_displacement2L, 0.8*self.frame.size.width, 0.8*self.frame.size.height)];
				break;
			case (10):
				if (self.direction==kGreen)
					[self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y+y_displacement2R, 0.8*self.frame.size.width, 0.8*self.frame.size.height)];
				else if (self.direction==kRed)
					[self setFrame:CGRectMake(self.frame.origin.x-x_displacementR,self.frame.origin.y+y_displacement2R, 0.8*self.frame.size.width, 0.8*self.frame.size.height)];
				else if (self.direction==kBlue)
					[self setFrame:CGRectMake(self.frame.origin.x+x_displacementR,self.frame.origin.y+y_displacement2R, 0.8*self.frame.size.width, 0.8*self.frame.size.height)];
				break;
		}
		[UIView commitAnimations];	
	}
	if ([animationID isEqualToString:@"show3"])	{
		[UIView beginAnimations:@"show4" context:nil];
		[UIView setAnimationDuration:self.speed];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
		switch (self.orientation)	{
			case (UIInterfaceOrientationPortrait):
			case (UIInterfaceOrientationPortraitUpsideDown):
				if (self.direction==kGreen)	{
					[self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y+y_displacement3P, 0.8*self.frame.size.width, 0.8*self.frame.size.height)];
					[self setImageRect:CGRectMake(0,0,0.8*self.imageRect.size.width,0.8*self.imageRect.size.height)];

				}else if (self.direction==kRed){
					[self setFrame:CGRectMake(self.frame.origin.x-x_displacementP,self.frame.origin.y+y_displacement3P, 0.8*self.frame.size.width, 0.8*self.frame.size.height)];
					[self setImageRect:CGRectMake(0,0, 0.8*self.imageRect.size.width, 0.8*self.imageRect.size.height)];

				}else if (self.direction==kBlue){
					[self setFrame:CGRectMake(self.frame.origin.x+x_displacementP,self.frame.origin.y+y_displacement3P, 0.8*self.frame.size.width, 0.8*self.frame.size.height)];
					[self setImageRect:CGRectMake(0,0, 0.8*self.imageRect.size.width, 0.8*self.imageRect.size.height)];

				}break;
			case (UIInterfaceOrientationLandscapeLeft):
			case (UIInterfaceOrientationLandscapeRight):
			case(11):
				if (self.direction==kGreen)
					[self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y+y_displacement3L, 0.8*self.frame.size.width, 0.8*self.frame.size.height)];
				else if (self.direction==kRed)
					[self setFrame:CGRectMake(self.frame.origin.x-x_displacementL,self.frame.origin.y+y_displacement3L, 0.8*self.frame.size.width, 0.8*self.frame.size.height)];
				else if (self.direction==kBlue)
					[self setFrame:CGRectMake(self.frame.origin.x+x_displacementL,self.frame.origin.y+y_displacement3L, 0.8*self.frame.size.width, 0.8*self.frame.size.height)];
				break;
			case (10):
				if (self.direction==kGreen)
					[self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y+y_displacement3R, 0.8*self.frame.size.width, 0.8*self.frame.size.height)];
				else if (self.direction==kRed)
					[self setFrame:CGRectMake(self.frame.origin.x-x_displacementR,self.frame.origin.y+y_displacement3R, 0.8*self.frame.size.width, 0.8*self.frame.size.height)];
				else if (self.direction==kBlue)
					[self setFrame:CGRectMake(self.frame.origin.x+x_displacementR,self.frame.origin.y+y_displacement3R, 0.8*self.frame.size.width, 0.8*self.frame.size.height)];
				break;
		}		
		[UIView commitAnimations];	
	}
	if ([animationID isEqualToString:@"show4"])	{
		[self removeFromSuperview];
		if ([finished boolValue]) 
			[self.owner removeFromQueue:self];
	}	
	
}



@end
