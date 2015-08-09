//
//  CreditView.m
//  bishibashi
//
//  Created by Eric on 06/06/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CreditView.h"


@implementation CreditView
@synthesize aiView = _aiView;
@synthesize webView = _webView;
@synthesize infoBut = _infoBut;
@synthesize owner = _owner;
@synthesize orientation = _orientation;
@synthesize isFromTransition = _isFromTransition;
static const CGRect selfRectP = {{0, 0}, {320, 480}};
static const CGRect selfRectL = {{0, 0}, {480, 320}};
static const CGRect infoRectP = {{280,440}, {30, 30}};
static const CGRect infoRectL = {{440, 280}, {30, 30}};
static const CGRect aiRectP = {{110,160},{100,100}};
static const CGRect aiRectL = {{160,110},{100,100}};

			


-(id) initWithOrientation:(UIInterfaceOrientation) orientation AndOwner:(id)owner
{

	
	self.isFromTransition = NO;
	self.owner = owner;
	self.orientation = orientation;
	CGRect theRect; 
	CGRect infoRect;
	CGRect aiRect;
	switch (orientation)	{
		case UIInterfaceOrientationLandscapeLeft:
		case UIInterfaceOrientationLandscapeRight:
			theRect= selfRectL;
			infoRect = infoRectL;
			aiRect = aiRectL;
			break;
		case UIInterfaceOrientationPortrait:
		case UIInterfaceOrientationPortraitUpsideDown:
			theRect = selfRectP;
			infoRect = infoRectP;
			aiRect = aiRectP;
			break;
	}
	if (self = [super initWithFrame:theRect])	{
		self.backgroundColor = [UIColor blackColor];
		UIActivityIndicatorView* aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		aiView.hidesWhenStopped=YES;
		aiView.frame = aiRect;
		[self addSubview:aiView];
		self.aiView = aiView;
		[aiView release];
		
		UIWebView* webView = [[UIWebView alloc] initWithFrame:theRect];
		self.webView = webView;
		[webView release];
		[self addSubview:self.webView];
		self.webView.backgroundColor = [UIColor blackColor];
		self.webView.scalesPageToFit = YES;
		self.webView.delegate = self;
		[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.red-soldier.com/"]]];

		self.infoBut = [UIButton buttonWithType:UIButtonTypeInfoLight];
		self.infoBut.frame = infoRect;
		[self addSubview:self.infoBut];
		[self.infoBut addTarget:self action:@selector(switchToGameView) forControlEvents:UIControlEventTouchDown];
	}
	return self;
}				

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[self bringSubviewToFront:self.aiView];
	[self.aiView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self bringSubviewToFront:self.aiView];
	[self.aiView stopAnimating];
}

-(void) dealloc
{
	NSLog(@"dealloc creditview");
	self.webView = nil;
	self.aiView = nil;
	self.infoBut = nil;
	[super dealloc];
}
				
-(void) switchToGameView
{
	UIView* returnView;
	if (self.isFromTransition)
		returnView = [self.owner transitionView];
	else
		returnView = [self.owner theMainView];
	[UIView beginAnimations:@"flipToGameView" context:nil];
	[UIView setAnimationDuration:1];
	UIWindow* window = [[self.owner view] superview];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:window cache:YES];
	[window addSubview:returnView];
	[[self.owner view] removeFromSuperview];
	[self.owner setView:returnView];

	//	self.isShowingGameView = YES;
	[UIView commitAnimations];
}

@end
