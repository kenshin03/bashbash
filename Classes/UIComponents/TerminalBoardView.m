/*
     File: QuartzRendering.m
 Abstract: Demonstrates using Quartz for drawing gradients (QuartzGradientView) and patterns (QuartzPatternView).
  Version: 2.3
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
*/

#import "TerminalBoardView.h"



@implementation TerminalBoardView

@synthesize text = _text;
@synthesize subtitle = _subtitle;
@synthesize temptext = _temptext;
@synthesize tempsubtitle = _tempsubtitle;
@synthesize seq = _seq;
@synthesize blank = _blank;
@synthesize subtitleblank = _subtitleblank;
@synthesize color = _color;
@synthesize timerqueue = _timerqueue;

@synthesize stable = _stable;
@synthesize isFinal = _isFinal;
@synthesize sectionNo = _sectionNo;
@synthesize rankNo = _rankNo;
@synthesize score = _score;

@synthesize nationalFlagManager = _nationalFlagManager;
@synthesize theFlag = _theFlag;

@synthesize country = _country;

- (BOOL)isEqual:(id)anObject
{
	if ([anObject isKindOfClass:[TerminalBoardView class]] && self.sectionNo == [anObject sectionNo] && self.rankNo == [anObject rankNo])
		return YES;
	else
		return NO;
}

- (NSUInteger)hash
{
	return 100*self.sectionNo + self.rankNo;
}


-(id)initWithFrame:(CGRect)frame AndText:(NSString*)text AndStable:(NSMutableArray*)stable AndCountry:(NSString*)country AndScore:(int)score AndSubtitle:(NSString*)subtitle
{
	frame.size.width = ([text length]+3) * CELLWIDTH + FLAGWIDTH;
	frame.size.height = CELLHEIGHT+SMALLCELLHEIGHT;
	self = [super initWithFrame:frame];
	if(self != nil)
	{
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
		self.text = text;
		self.subtitle= subtitle;
		self.temptext = text;
		self.tempsubtitle = subtitle;
		self.country = [country capitalizedString];
		self.stable = stable;

		self.nationalFlagManager = [NationalFlagView sharedInstance];
		
		UIImageView* boarder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"terminal_all_small.png"]];
		boarder.frame = CGRectMake(0, 0, 320, SMALLCELLHEIGHT);
		boarder.backgroundColor = [UIColor clearColor];
		[self addSubview:boarder];
		[boarder release];



		// Draw the Flag
		UIImageView* flag = [[UIImageView alloc] initWithFrame:CGRectMake([text length]*CELLWIDTH+2,SMALLCELLHEIGHT+2, FLAGWIDTH-6, FLAGHEIGHT-4)];
		self.theFlag = flag;
		[flag release];
		[self addSubview:self.theFlag];
		self.score = score;
		
		boarder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"terminal_all.png"]];
		boarder.frame = CGRectMake(0, SMALLCELLHEIGHT, 317, CELLHEIGHT);
		boarder.backgroundColor = [UIColor clearColor];
		[self addSubview:boarder];
		[boarder release];
		
		UIView* blank = [[UIView alloc] initWithFrame:CGRectMake(0, SMALLCELLHEIGHT+CELLHEIGHT/2, self.frame.size.width, CELLHEIGHT/4)];
		self.blank =blank;
		blank.backgroundColor = [UIColor whiteColor];
		blank.alpha = 0.3;
		[self addSubview:blank];
		[self.blank setHidden:YES];
		[blank release];

		blank = [[UIView alloc] initWithFrame:CGRectMake(0, SMALLCELLHEIGHT/2, self.frame.size.width, SMALLCELLHEIGHT/4)];
		self.subtitleblank =blank;
		blank.backgroundColor = [UIColor whiteColor];
		blank.alpha = 0.3;
		[self addSubview:blank];
		[self.subtitleblank setHidden:YES];
		[blank release];		

		self.backgroundColor = [UIColor blackColor];
		self.opaque = YES;
		self.clearsContextBeforeDrawing = YES;
		
		self.isFinal = NO;
	}
	return self;
}

-(void) setText:(NSString*)text AndStable:(NSMutableArray*)stable AndCountry:(NSString*)country AndScore:(int)score AndSubtitle:(NSString*)subtitle
{
	self.text = text;
	self.temptext = text;
	self.subtitle = subtitle;
	self.tempsubtitle = subtitle;
	self.country = [country capitalizedString];
	self.stable = stable;
	self.seq = 0;
	[self setNeedsDisplay];
	self.theFlag.image = [self.nationalFlagManager getNationalFlagByCountry:country];
	self.score = score;

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
	self.color = nil;
	self.temptext = nil;
	self.tempsubtitle = nil;
	self.text = nil;
	self.blank = nil;
	self.stable = nil;
	self.country=nil;
	self.theFlag = nil;
	self.subtitle=nil;
	self.subtitleblank = nil;
	[super dealloc];
}


-(void)drawRect:(CGRect)rect
{
	[self drawInContext:UIGraphicsGetCurrentContext()];
}

-(void)drawInContext:(CGContextRef)context
{
	CGContextSaveGState(context);
	
	CGContextDrawLinearGradient(context, gradient, CGPointMake(0,0), CGPointMake(0,SMALLCELLHEIGHT), 0);
	CGContextDrawLinearGradient(context, gradient, CGPointMake(0,SMALLCELLHEIGHT), CGPointMake(0,CELLHEIGHT+SMALLCELLHEIGHT), 0);

	[[UIColor lightGrayColor] setFill];	
	// Draw the subtitle
	for (int i=0; i<[self.tempsubtitle length]; i++)	{
		[[self.tempsubtitle substringWithRange:NSMakeRange(i,1)] drawAtPoint:CGPointMake(i*20+4, 0) withFont:[UIFont systemFontOfSize:12]];
	}


	if (self.color!=nil && self.isFinal)		
		[self.color setFill];
	else		
		[[UIColor whiteColor] setFill];
	// Draw the Text
	for (int i=0; i<[self.temptext length]; i++)	{
		[[self.temptext substringWithRange:NSMakeRange(i,1)] drawAtPoint:CGPointMake(i*CELLWIDTH+2, SMALLCELLHEIGHT+2) withFont:[UIFont systemFontOfSize:CELLWIDTH-3]];
	}

	[[UIColor orangeColor] setFill];
	[[[NSString stringWithFormat:@"%03d", self.score] substringWithRange:NSMakeRange(0,1)] drawAtPoint:CGPointMake([self.text length]*CELLWIDTH+FLAGWIDTH+4, SMALLCELLHEIGHT+2) withFont:[UIFont systemFontOfSize:CELLWIDTH-2]];
	[[[NSString stringWithFormat:@"%03d", self.score] substringWithRange:NSMakeRange(1,1)] drawAtPoint:CGPointMake(([self.text length]+1)*CELLWIDTH+FLAGWIDTH+4, SMALLCELLHEIGHT+2) withFont:[UIFont systemFontOfSize:CELLWIDTH-2]];
	[[[NSString stringWithFormat:@"%03d", self.score] substringWithRange:NSMakeRange(2,1)] drawAtPoint:CGPointMake(([self.text length]+2)*CELLWIDTH+FLAGWIDTH+4, SMALLCELLHEIGHT+2) withFont:[UIFont systemFontOfSize:CELLWIDTH-2]];


	CGContextRestoreGState(context);	
}


- (void) updateView
{
	if (self.seq<5)	{
		if (arc4random()%3==0)	{
			[self.subtitleblank setHidden:NO];
			[self.blank setHidden:NO];
		}
		else	{
			[self.subtitleblank setHidden:YES];
			[self.blank setHidden:YES];
		}
		self.temptext = [NSMutableString stringWithCapacity:[self.text length]];
		for (int i=0; i<[self.text length]; i++)	{
			unichar theChar[1];
			theChar[0] = [self.text characterAtIndex:i]+self.seq;
			[self.temptext appendString:[NSString stringWithCharacters:theChar length:1]];
		}
		
		self.tempsubtitle = [NSMutableString stringWithCapacity:[self.subtitle length]];
		for (int i=0; i<[self.subtitle length]; i++)	{
			unichar theChar[1];
			theChar[0] = [self.subtitle characterAtIndex:i]+self.seq;
			[self.tempsubtitle appendString:[NSString stringWithCharacters:theChar length:1]];
		}
		[self setNeedsDisplay];
		
		self.theFlag.image = [[self.nationalFlagManager getAllNationalFlags] objectAtIndex:(arc4random()%[[self.nationalFlagManager getAllNationalFlags]count])];
		
		self.seq++;
	}
	else	{
		self.isFinal = YES;
		self.temptext = self.text;
		self.tempsubtitle = self.subtitle;
		[self setNeedsDisplay];
		self.theFlag.image = [self.nationalFlagManager getNationalFlagByCountry:self.country];
		
		[self.subtitleblank setHidden:YES];
		[self.blank setHidden:YES];
		self.seq++;
	}
}
	
@end
