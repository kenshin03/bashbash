//
//  UIViewWithStars.m
//  bishibashi
//
//  Created by Eric on 14/10/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "UIViewWithStars.h"


@implementation UIViewWithStars
@synthesize image = _image;
@synthesize imageRect = _imageRect;
@synthesize redColor = _redColor;
@synthesize greenColor = _greenColor;
@synthesize blueColor = _blueColor;
@synthesize starOffsetY = _starOffsetY;
@synthesize showStars = _showStars;
@synthesize numStars = _numStars;

-(void) dealloc
{
	self.image = nil;
	[super dealloc];
}

-(id) initWithFrame:(CGRect)frame
{
	return [self initWithFrame:frame AndImageFrame:frame];
}

-(id) initWithFrame:(CGRect)frame AndImageFrame:(CGRect)imageRect
{
	return [self initWithFrame:frame AndImageFrame:imageRect WithNumStars:15];
}

-(id) initWithFrame:(CGRect)frame AndImageFrame:(CGRect)imageRect WithNumStars:(int)numStars
{
	if (self = [super initWithFrame:frame])	{
		self.backgroundColor = [UIColor clearColor];
		self.opaque = YES;
		self.clearsContextBeforeDrawing = YES;	
		
		self.showStars = YES;
		self.numStars = numStars;
		self.imageRect = imageRect;
		_starPosX = (float*) malloc(sizeof(float)*self.numStars);
		_starPosY = (float*) malloc(sizeof(float)*self.numStars);
		_starSize = (float*) malloc(sizeof(float)*self.numStars);
		for (int i=0; i<self.numStars; i++)	{
			int width = (float)(self.imageRect.size.width);
			int height = (float)(self.imageRect.size.height);
			_starPosX[i] = (float)(arc4random()%(width/2) - (width/4));
			_starPosY[i] = _starOffsetY+(float)(arc4random()%(height));
			_starSize[i] = 4.0+(float)(arc4random()%5);
		}
		
	}
	return self;
}


-(void)drawRect:(CGRect)rect	{
	[self.image drawInRect:CGRectMake(0,0,self.imageRect.size.width, self.imageRect.size.height)];

	if (self.showStars)	{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGPoint center = CGPointMake(self.imageRect.size.width/2, self.imageRect.size.height/2);
	
	for (int i=0; i<self.numStars; i++)	{
		// Drawing with a fill color
		if (i%2==1)
			CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
		else{
			CGContextSetRGBFillColor(context, self.redColor, self.greenColor, self.blueColor, 1.0);
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
	
	for (int i=0; i<self.numStars; i++)	{
		_starPosX[i] += (float)((arc4random()%10-5.0));
		_starPosY[i] += (float)((arc4random()%30-15.0));
		_starSize[i] *= 0.7;
	}
	
	}
}


@end
