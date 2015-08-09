//
//  InstructionView.m
//  bishibashi
//
//  Created by Eric on 18/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InstructionView.h"


@implementation InstructionView
@synthesize scenarios = _scenarios;
@synthesize OKView = _OKView;
@synthesize crossView = _crossView;
@synthesize backgroundView = _backgroundView;
@synthesize blueBut = _blueBut;
@synthesize greenBut = _greenBut;
@synthesize redBut = _redBut;
@synthesize handView = _handView;

static const CGRect redButRectP = {{10, 260}, {60, 60}};
static const CGRect greenButRectP = {{90, 260}, {60, 60}};
static const CGRect blueButRectP = {{170, 260}, {60, 60}};


static const CGRect redHandRectP = {{20, 270}, {80, 95}};
static const CGRect greenHandRectP = {{100, 270}, {80, 95}};
static const CGRect blueHandRectP = {{180, 270}, {80, 95}};


static const CGRect OKRectP = {{50, 100}, {60, 70}};
static const CGRect OKRectL = {{100, 130}, {120, 100}};
static const CGRect OKRectR = {{50, 130}, {60, 100}};


- (id) initWithFrame:(CGRect)frameRect;
{
    self = [super initWithFrame:frameRect];
	[self initBackground];
	[self initButtons];
	[self initImages];
	[self initScenarios];
	sharedSoundEffectsManager = [MediaManager sharedInstance];	
    return self;
}

- (void) dealloc	{
	NSLog(@"dealloc InstructionView");
	self.blueBut = nil;
	self.redBut = nil;
	self.greenBut = nil;
	self.scenarios = nil;
	self.OKView = nil;
	self.crossView = nil;
	self.handView = nil;
	self.backgroundView = nil;
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[super dealloc];
}

- (void) initScenarios
{
		NSMutableArray* tmp = [[NSMutableArray alloc] initWithCapacity:20];
		self.scenarios = tmp;
		[tmp release];		
}

- (void) startScenarios
{
}

-(void) initImages
{
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross.png"]];
	self.crossView = tmpView;
	[self.crossView setFrame:OKRectL];
	//	[self addSubview:self.crossView];
	//	[self.crossView setHidden:YES];
	[tmpView release];
	
	tmpView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OK.png"]];
	self.OKView = tmpView;
	[self.OKView setFrame:OKRectL];
	//	[self addSubview:self.OKView];
	//	[self.OKView setHidden:YES];
	[tmpView release];
	
	tmpView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"thumb.png"]];
	self.handView = tmpView;
	[tmpView release];
}	

-(void) initBackground
{
	self.backgroundColor = [UIColor blackColor];
}

-(void) initButtons
{
	UIButton* tmpBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[tmpBut setBackgroundImage:[UIImage imageNamed:@"bluebutton.png"] forState:UIControlStateNormal];
	[tmpBut setFrame:blueButRectP];
	self.blueBut = tmpBut;
	tmpBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[tmpBut setBackgroundImage:[UIImage imageNamed:@"greenbutton.png"] forState:UIControlStateNormal];
	[tmpBut setFrame:greenButRectP];
	self.greenBut = tmpBut;
	tmpBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[tmpBut setBackgroundImage:[UIImage imageNamed:@"redbutton.png"] forState:UIControlStateNormal];
	[tmpBut setFrame:redButRectP];
	self.redBut = tmpBut;
	[self.blueBut addTarget:self action:@selector(blueButClicked) forControlEvents:UIControlEventTouchDown];
	[self.greenBut addTarget:self action:@selector(greenButClicked) forControlEvents:UIControlEventTouchDown];
	[self.redBut addTarget:self action:@selector(redButClicked) forControlEvents:UIControlEventTouchDown];
	[self addSubview:self.blueBut];
	[self addSubview:self.redBut];
	[self addSubview:self.greenBut];
	[self.greenBut setEnabled:NO];
	[self.blueBut setEnabled:NO];
	[self.redBut setEnabled:NO];
}

- (void) redButClicked
{
	[self addSubview:self.handView];
	self.handView.frame = redHandRectP;

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	self.handView.frame = CGRectMake(self.handView.frame.origin.x-5,self.handView.frame.origin.y-5, self.handView.frame.size.width, self.handView.frame.size.height);
	[UIView commitAnimations];
	[self.handView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
}

- (void) blueButClicked
{
	[self addSubview:self.handView];
	self.handView.frame = blueHandRectP;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	self.handView.frame = CGRectMake(self.handView.frame.origin.x-5,self.handView.frame.origin.y-5, self.handView.frame.size.width, self.handView.frame.size.height);
	[UIView commitAnimations];
	[self.handView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
}

- (void) greenButClicked
{
	[self addSubview:self.handView];
	self.handView.frame = greenHandRectP;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	self.handView.frame = CGRectMake(self.handView.frame.origin.x-5,self.handView.frame.origin.y-5, self.handView.frame.size.width, self.handView.frame.size.height);
	[UIView commitAnimations];
	[self.handView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
}
@end
