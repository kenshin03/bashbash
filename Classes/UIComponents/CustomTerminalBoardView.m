//
//  CustomTerminalBoard.m
//  bishibashi
//
//  Created by Eric on 19/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CustomTerminalBoardView.h"


@implementation CustomTerminalBoardView
@synthesize text = _text;
@synthesize temptext = _temptext;
@synthesize seq = _seq;
@synthesize blank = _blank;
@synthesize color = _color;

@synthesize timerqueue = _timerqueue;


-(id)initWithFrame:(CGRect)frame AndText:(NSString*)text AndColor:(UIColor*)color AndFixed:(BOOL)isfixed
{
	frame.size.width = CUSTOMNUMCELL * CUSTOMCELLWIDTH;
	frame.size.height = CUSTOMCELLHEIGHT;
	self = [super initWithFrame:frame];
	if(self != nil)
	{
		self.color = color;
		CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
		CGFloat colors[] =
		{
			100.0 / 255.0, 100.0 / 255.0, 100.0 / 255.0, 1.00,
			30.0 / 255.0, 30.0 / 255.0, 30.0 / 255.0, 1.00,
			0.0 / 255.0,  0.0 / 255.0, 0.0 / 255.0, 1.00,
		};
		gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
		CGColorSpaceRelease(rgb);
		self.seq = 0;
		int prefixPadding = (int)((CUSTOMNUMCELL - [text length])/2);
		int suffixPadding = CUSTOMNUMCELL - [text length] - prefixPadding;
		self.text = [[[@"" stringByPaddingToLength:prefixPadding withString:@" " startingAtIndex:0] stringByAppendingString:text] stringByPaddingToLength:CUSTOMNUMCELL withString:@" " startingAtIndex:0];
		if (isfixed)
			self.temptext = [[[@"" stringByPaddingToLength:prefixPadding withString:@" " startingAtIndex:0] stringByAppendingString:text] stringByPaddingToLength:CUSTOMNUMCELL withString:@" " startingAtIndex:0];
		else
			self.temptext = [NSMutableString stringWithCapacity:[self.text length]];
		
		
		UIImageView* boarder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"terminal_all_custom.png"]];
		boarder.frame = CGRectMake(0, 0, CUSTOMNUMCELL*CUSTOMCELLWIDTH, CUSTOMCELLHEIGHT);
		boarder.backgroundColor = [UIColor clearColor];
		[self addSubview:boarder];
		[boarder release];
		
		
		UIView* blank = [[UIView alloc] initWithFrame:CGRectMake(0, CUSTOMCELLHEIGHT/2, self.frame.size.width, CUSTOMCELLHEIGHT/4)];
		self.blank =blank;
		blank.backgroundColor = [UIColor whiteColor];
		blank.alpha = 0.3;
		[self addSubview:blank];
		[self.blank setHidden:YES];
		[blank release];
		
		self.backgroundColor = [UIColor blackColor];
		self.opaque = YES;
		self.clearsContextBeforeDrawing = YES;
	}
	return self;
}


-(void) willDisappear
{
	@synchronized(self.timerqueue){[self.timerqueue removeTerminalView:self];}
}

-(void)dealloc
{
	NSLog(@"dealloc TerminalBoardView");
	@synchronized(self.timerqueue){[self.timerqueue removeTerminalView:self];}
	CGGradientRelease(gradient);
	self.text = nil;
	self.temptext = nil;
	self.blank = nil;
	self.color = nil;
	[super dealloc];
}


-(void)drawRect:(CGRect)rect
{
	[self drawInContext:UIGraphicsGetCurrentContext()];
}

-(void)drawInContext:(CGContextRef)context
{
	CGContextSaveGState(context);
	
	CGContextDrawLinearGradient(context, gradient, CGPointMake(0,0), CGPointMake(0,self.frame.size.height), 0);
	
	[self.color setFill];
	// Draw the Text
	for (int i=0; i<[self.temptext length]; i++)	{
		[[self.temptext substringWithRange:NSMakeRange(i,1)] drawAtPoint:CGPointMake(i*CUSTOMCELLWIDTH+2, 2) withFont:[UIFont systemFontOfSize:CUSTOMCELLWIDTH-4]];
	}
	
	CGContextRestoreGState(context);	
}


- (void) updateView
{
	if (self.seq<5)	{
		if (arc4random()%3==0)	{
			[self.blank setHidden:NO];
		}
		else	{
			[self.blank setHidden:YES];
		}
		self.temptext = [NSMutableString stringWithCapacity:[self.text length]];
		for (int i=0; i<[self.text length]; i++)	{
			unichar theChar[1];
			theChar[0] = [self.text characterAtIndex:i]+self.seq;
			[self.temptext appendString:[NSString stringWithCharacters:theChar length:1]];
			[self setNeedsDisplay];
		}
		
		self.seq++;
	}
	else	{
		for (int i=0; i<[self.text length]; i++)	{
			self.temptext = self.text;
			[self setNeedsDisplay];
		}
		[self.blank setHidden:YES];
		self.seq++;
	}
}

@end
