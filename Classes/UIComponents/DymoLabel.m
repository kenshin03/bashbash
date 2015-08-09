//
//  DymoLabel.m
//  bishibashi
//
//  Created by Eric on 04/11/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "DymoLabel.h"


@implementation DymoLabel
@synthesize color = _color;
@synthesize text = _text;
@synthesize fontSize = _fontSize;

-(id) initWithFrame:(CGRect)frame AndText:(NSString*)text AndColor:(UIColor*)color AndTextFontSize:(float)fontSize
{
	if (self = [super initWithFrame:frame])	{
		self.text = text;
		self.color = color;
		self.fontSize = fontSize;
		self.backgroundColor = color;
		CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
		CGFloat colors[] =
		{
			100.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0, 1.00,
			200.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0, 1.00,
			2550.0 / 255.0,  0.0 / 255.0, 0.0 / 255.0, 1.00,
		};
		CGFloat reversecolors[] =
		{
			255.0 / 255.0,  0.0 / 255.0, 0.0 / 255.0, 1.00,
			200.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0, 1.00,
			100.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0, 1.00,
		};
		gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
		reversegradient = CGGradientCreateWithColorComponents(rgb, reversecolors, NULL, sizeof(reversecolors)/(sizeof(reversecolors[0])*4));
		CGColorSpaceRelease(rgb);
	}
	return self;
}

-(void)drawRect:(CGRect)rect
{
	[self drawInContext:UIGraphicsGetCurrentContext()];
}

-(void)drawInContext:(CGContextRef)context
{
	CGContextSaveGState(context);
	
//	CGContextDrawLinearGradient(context, gradient, CGPointMake(0,0), CGPointMake(0,self.frame.size.height/2), 0);
//	CGContextDrawLinearGradient(context, gradient, CGPointMake(0,0), CGPointMake(0,self.frame.size.height/3), 0);
//	CGContextDrawLinearGradient(context, reversegradient, CGPointMake(0,4*self.frame.size.height/5), CGPointMake(0,self.frame.size.height), 0);
	
		
	CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
	CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
	
	BOOL isEnglish=NO;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"])
		isEnglish = YES;
	// Draw the Text
	for (int i=0; i<[self.text length]; i++)	{
		float yoffset = (float)(arc4random()%8/2.0);
		float xoffset = arc4random()%2;
		[[UIColor colorWithWhite:0.95 alpha:0.8] setFill];
		//[[UIColor lightGrayColor] setFill];
		if (!isEnglish)	{
			[[self.text substringWithRange:NSMakeRange(i,1)] drawAtPoint:CGPointMake(i*1.2*self.fontSize+4+xoffset-0.1*self.fontSize, 2+yoffset-0.1*self.fontSize) withFont:[UIFont systemFontOfSize:1.2*self.fontSize]];
			[[UIColor darkGrayColor] setFill];
			[[self.text substringWithRange:NSMakeRange(i,1)] drawAtPoint:CGPointMake(i*1.2*self.fontSize+3+xoffset, yoffset+1) withFont:[UIFont systemFontOfSize:self.fontSize+2]];
			[[UIColor whiteColor] setFill];
			[[self.text substringWithRange:NSMakeRange(i,1)] drawAtPoint:CGPointMake(i*1.2*self.fontSize+4+xoffset, 2+yoffset) withFont:[UIFont systemFontOfSize:self.fontSize]];
		}
		else {
			[[self.text substringWithRange:NSMakeRange(i,1)] drawAtPoint:CGPointMake(i*0.7*self.fontSize+4+xoffset-0.1*self.fontSize, 2+yoffset-0.1*self.fontSize) withFont:[UIFont systemFontOfSize:1.2*self.fontSize]];
			[[UIColor darkGrayColor] setFill];
			[[self.text substringWithRange:NSMakeRange(i,1)] drawAtPoint:CGPointMake(i*0.7*self.fontSize+3+xoffset, yoffset+1) withFont:[UIFont systemFontOfSize:self.fontSize+2]];
			[[UIColor whiteColor] setFill];
			[[self.text substringWithRange:NSMakeRange(i,1)] drawAtPoint:CGPointMake(i*0.7*self.fontSize+4+xoffset, 2+yoffset) withFont:[UIFont systemFontOfSize:self.fontSize]];
			
		}

	
		int no = arc4random()%4;
		[self.color setFill];
		[self.color setStroke];
		for (int j=0; j<no; j++)	{
			CGContextSetLineWidth(context, 1);
			CGContextBeginPath(context);
			int smallyoffset = (arc4random()%(int)(self.fontSize-5))+5;
			if (!isEnglish)	{
				CGContextMoveToPoint(context, i*1.2*self.fontSize+4+xoffset,2+yoffset+smallyoffset);
				CGContextAddLineToPoint(context, i*1.2*self.fontSize+4+xoffset+self.fontSize, 2+yoffset+smallyoffset);
			}
			else	{
				CGContextMoveToPoint(context, i*0.7*self.fontSize+4+xoffset,2+yoffset+smallyoffset);
				CGContextAddLineToPoint(context, i*0.7*self.fontSize+4+xoffset+self.fontSize, 2+yoffset+smallyoffset);				
			}
			CGContextClosePath(context);
			CGContextDrawPath(context, kCGPathFillStroke);
		}			
	}

	
//	CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
//	CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
	// Draw them with a 2.0 stroke width so they are a bit more visible.
	//CGContextSetLineWidth(context, 4.0);
	//CGContextBeginPath(context);
	//CGContextMoveToPoint(context, 0,self.frame.size.height/2);
	//CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height/2);
	//CGContextClosePath(context);
	//CGContextDrawPath(context, kCGPathFillStroke);

	
	CGContextRestoreGState(context);	
}

- (void) dealloc
{
	self.color = nil;
	self.text = nil;
}

@end
