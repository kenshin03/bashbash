    //
//  CreditsViewController.m
//  bishibashi
//
//  Created by Kenny Tang on 5/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CreditsViewController.h"
#import "Constants.h"


@implementation CreditsViewController

@synthesize selectedGame = _selectedGame;
@synthesize owner = _owner;
@synthesize isFromTransition = _isFromTransition;

static const CGRect gameCreditViewRect = {{20, 140}, {250, 2000}};

- (id)initWithGameType:(NSInteger)gameType {
	
	self.selectedGame = gameType;
	
	// main view start
	mainView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 480)];
	mainView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"credits_view_background.jpg"]];	
	
	UIImageView* logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NSLocalizedString(@"logo",nil) ofType:@"png"]]];
	logoImageView.frame = CGRectMake(10, 15, 287, 98);
	[mainView addSubview:logoImageView];
	
	UIScrollView* buttonsScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(20, 110, 290, 270)];
	[buttonsScrollView setBackgroundColor:[UIColor whiteColor]];
	[buttonsScrollView setContentSize:CGSizeMake(290, 2000)];
	buttonsScrollView.showsVerticalScrollIndicator = NO;
	[buttonsScrollView setAlpha:0.8];
	buttonsScrollView.multipleTouchEnabled = YES;

	
	
	UIFont *normalSizedLabelFont = [UIFont fontWithName:@"Arial" size:15];
	UIFont *smallFont = [UIFont fontWithName:@"Arial" size:12];

	UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 230, 60)];
	if ([[[Constants sharedInstance] APPVERSION] isEqualToString:@"version1"])
		versionLabel.text = @"拍拍機 BashBash! Lite\n Version 1.4    \n    2010 Red Soldier Productions";
	else if ([[[Constants sharedInstance] APPVERSION] isEqualToString:@"version2"])
		versionLabel.text = @"拍拍機 BashBash!\n Version 1.4    \n    2010 Red Soldier Productions";
	
	versionLabel.numberOfLines = 3;
	versionLabel.font = normalSizedLabelFont;
	versionLabel.textAlignment = UITextAlignmentCenter;
	versionLabel.textColor = [UIColor blackColor];
	versionLabel.backgroundColor = [UIColor clearColor];
	[buttonsScrollView addSubview:versionLabel];
	
	
	UILabel *rightsLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 80, 150, 40)];
	rightsLabel.text = @"All Rights Reserved.\n		www.red-solider.com";
	rightsLabel.numberOfLines = 2;
	rightsLabel.font = normalSizedLabelFont;
	rightsLabel.textAlignment = UITextAlignmentCenter;
	rightsLabel.textColor = [UIColor blackColor];
	rightsLabel.backgroundColor = [UIColor clearColor];
	[buttonsScrollView addSubview:rightsLabel];
	
	
	if (gameType == kcreditsview){
		
		[buttonsScrollView setContentSize:CGSizeMake(290, 450)];
		UIButton *titleLogoButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[titleLogoButton setFrame: CGRectMake(20, 130, 260, 57)];
		UIImage *logoImage = [UIImage imageNamed:@"red_soldier_credits_view.png"];
		[titleLogoButton setBackgroundImage:logoImage forState:UIControlStateNormal];
		[titleLogoButton setBackgroundImage:logoImage forState:UIControlStateHighlighted];
		[titleLogoButton addTarget:self action:@selector(titleLogoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
		[buttonsScrollView addSubview:titleLogoButton];
		
		UILabel *photoCreditsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 250, 40)];
		photoCreditsLabel.text = @"Creative Commons Images Credits:";
		photoCreditsLabel.numberOfLines = 2;
		photoCreditsLabel.font = normalSizedLabelFont;
		photoCreditsLabel.textAlignment = UITextAlignmentCenter;
		photoCreditsLabel.textColor = [UIColor blackColor];
		photoCreditsLabel.backgroundColor = [UIColor clearColor];
		[buttonsScrollView addSubview:photoCreditsLabel];
		[photoCreditsLabel release];
		
		UITextView *photoCreditsTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 240, 250, 70)];
		photoCreditsTextView.editable = NO;
		photoCreditsTextView.textAlignment = UITextAlignmentLeft;
		photoCreditsTextView.font = smallFont;
		photoCreditsTextView.textColor = [UIColor blackColor];
		photoCreditsTextView.text = @"limaoscarjuliet, rogerhee, C. Y. Chow, dydcheung, chacrebleu, bensonkua, Honta, ●○※Yung.Hao※○● on Flickr.com";
		[buttonsScrollView addSubview:photoCreditsTextView];
		[photoCreditsTextView release];
		
		
		UILabel *soundCreditsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 320, 250, 40)];
		soundCreditsLabel.text = @"Sound Effects under Creative Commons Sampling Plus 1.0 License";
		soundCreditsLabel.numberOfLines = 2;
		soundCreditsLabel.font = [UIFont fontWithName:@"Arial" size:13];
		soundCreditsLabel.textAlignment = UITextAlignmentCenter;
		soundCreditsLabel.textColor = [UIColor blackColor];
		soundCreditsLabel.backgroundColor = [UIColor clearColor];
		[buttonsScrollView addSubview:soundCreditsLabel];
		[soundCreditsLabel release];
		
		UITextView *soundCreditsTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 360, 250, 70)];
		soundCreditsTextView.editable = NO;
		soundCreditsTextView.textAlignment = UITextAlignmentLeft;
		soundCreditsTextView.font = smallFont;
		soundCreditsTextView.textColor = [UIColor blackColor];
		soundCreditsTextView.text = @"19446_totya_yeah.mp3, 33369_HerbertBoland_MouthPop.wav, 523_jenc_latch1.wav on thefreesoundproject";
		[buttonsScrollView addSubview:soundCreditsTextView];
		[soundCreditsTextView release];
		[mainView addSubview:buttonsScrollView];
		
	}else if (gameType == keatbeans){
		
		UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(20, 140, 250, 400)];
		if 	([[[Constants sharedInstance] language] isEqualToString:@"en"])
			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.corgitoergosum.net/bashbash/?p=100"]]];
		else
			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.corgitoergosum.net/bashbash/?p=4"]]];
		webView.scalesPageToFit=YES;
		[buttonsScrollView addSubview:webView];
		[mainView addSubview:buttonsScrollView];
		
	}else if (gameType == k3in1){
		
		UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(20, 140, 250, 400)];
		if 	([[[Constants sharedInstance] language] isEqualToString:@"en"])
			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.corgitoergosum.net/bashbash/?p=103"]]];
		else
			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.corgitoergosum.net/bashbash/?p=7"]]];
		webView.scalesPageToFit=YES;
		[buttonsScrollView addSubview:webView];
		[mainView addSubview:buttonsScrollView];
		
	}else if (gameType == kburgerset){
		
		UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(20, 140, 250, 400)];
		if 	([[[Constants sharedInstance] language] isEqualToString:@"en"])
			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.corgitoergosum.net/bashbash/?p=97"]]];
		else
			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.corgitoergosum.net/bashbash/?p=9"]]];
		webView.scalesPageToFit=YES;
		[buttonsScrollView addSubview:webView];
		[mainView addSubview:buttonsScrollView];
		
	}else if (gameType == kufo){
		
		UIWebView* webView = [[UIWebView alloc] initWithFrame:gameCreditViewRect];
		if 	([[[Constants sharedInstance] language] isEqualToString:@"en"])
			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.corgitoergosum.net/bashbash/?p=95"]]];
		else 
			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.corgitoergosum.net/bashbash/?p=11"]]];
		webView.scalesPageToFit=YES;
		[buttonsScrollView addSubview:webView];
		[mainView addSubview:buttonsScrollView];
		
	}else if (gameType == kalarmclock){
		
		UIWebView* webView = [[UIWebView alloc] initWithFrame:gameCreditViewRect];
		if 	([[[Constants sharedInstance] language] isEqualToString:@"en"])
			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.corgitoergosum.net/bashbash/?p=92"]]];
		else
			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.corgitoergosum.net/bashbash/?p=13"]]];
		webView.scalesPageToFit=YES;
		[buttonsScrollView addSubview:webView];
		[mainView addSubview:buttonsScrollView];
		
	}else if (gameType == kjumpinggirl){
		
		UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(20, 140, 250, 400)];
		if 	([[[Constants sharedInstance] language] isEqualToString:@"en"])
			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.corgitoergosum.net/bashbash/?p=90"]]];
		else
			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.corgitoergosum.net/bashbash/?p=15"]]];
		webView.scalesPageToFit=YES;
		[buttonsScrollView addSubview:webView];
		[mainView addSubview:buttonsScrollView];
		
	}else if (gameType == kburgerseq){
		
		UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(20, 140, 250, 400)];
		if 	([[[Constants sharedInstance] language] isEqualToString:@"en"])
		[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.corgitoergosum.net/bashbash/?p=88"]]];
		else
			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.corgitoergosum.net/bashbash/?p=17"]]];
		webView.scalesPageToFit=YES;
		[buttonsScrollView addSubview:webView];
		[mainView addSubview:buttonsScrollView];
		
	}else if (gameType == k3bo){
		
		UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(20, 140, 250, 400)];
		if 	([[[Constants sharedInstance] language] isEqualToString:@"en"])
			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.corgitoergosum.net/bashbash/?p=86"]]];
		else 
			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.corgitoergosum.net/bashbash/?p=20"]]];
		webView.scalesPageToFit=YES;
		[buttonsScrollView addSubview:webView];
		[mainView addSubview:buttonsScrollView];
		
		
	}else if (gameType == ksmallnumber){
		
		UIWebView* webView = [[UIWebView alloc] initWithFrame:gameCreditViewRect];
		if 	([[[Constants sharedInstance] language] isEqualToString:@"en"])
			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.corgitoergosum.net/bashbash/?p=84"]]];
		else
			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.corgitoergosum.net/bashbash/?p=22"]]];
		webView.scalesPageToFit=YES;
		[buttonsScrollView addSubview:webView];
		[mainView addSubview:buttonsScrollView];
		
	}else if (gameType == kbignumber){
		
		UIWebView* webView = [[UIWebView alloc] initWithFrame:gameCreditViewRect];
		if 	([[[Constants sharedInstance] language] isEqualToString:@"en"])
			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.corgitoergosum.net/bashbash/?p=82"]]];
		else
			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.corgitoergosum.net/bashbash/?p=24"]]];
		webView.scalesPageToFit=YES;
		[buttonsScrollView addSubview:webView];
		[mainView addSubview:buttonsScrollView];
	}else if (gameType == kdancing){
	
		UIWebView* webView = [[UIWebView alloc] initWithFrame:gameCreditViewRect];
		if 	([[[Constants sharedInstance] language] isEqualToString:@"en"])
			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.corgitoergosum.net/bashbash/?p=80"]]];
		else
			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.corgitoergosum.net/bashbash/?p=73"]]];
		webView.scalesPageToFit=YES;
		[buttonsScrollView addSubview:webView];
		[mainView addSubview:buttonsScrollView];
	}else if (gameType == kbunhill){
		
		UIWebView* webView = [[UIWebView alloc] initWithFrame:gameCreditViewRect];
		if 	([[[Constants sharedInstance] language] isEqualToString:@"en"])
			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.corgitoergosum.net/bashbash/?p=125"]]];
		else
			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.corgitoergosum.net/bashbash/?p=123"]]];
		webView.scalesPageToFit=YES;
		[buttonsScrollView addSubview:webView];
		[mainView addSubview:buttonsScrollView];
	}
	
	UIImage *buttonBackgroundImage = [[UIImage imageNamed:@"streetsign_button_background.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
	UIImage *buttonBackgroundImageDown = [[UIImage imageNamed:@"streetsign_button_background_inverted.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
	UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[cancelButton setFrame: CGRectMake(45, 380, 232, 80)];
	UILabel *englishCancelTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 13, 80, 20)];
	[englishCancelTextLabel setText:@"Back"];
	englishCancelTextLabel.contentMode = UIViewContentModeCenter;
	englishCancelTextLabel.font = [UIFont systemFontOfSize:13];
	[englishCancelTextLabel setBackgroundColor:[UIColor clearColor]];
	[cancelButton addSubview:englishCancelTextLabel];
	[englishCancelTextLabel release];
	UILabel *chineseCancelTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 38, 70, 20)];
	[chineseCancelTextLabel setText:@"返回"];
	[chineseCancelTextLabel setBackgroundColor:[UIColor clearColor]];
	[cancelButton addSubview:chineseCancelTextLabel];
	[chineseCancelTextLabel release];
	[cancelButton setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
	[cancelButton setBackgroundImage:buttonBackgroundImageDown forState:UIControlStateHighlighted];
	[cancelButton addTarget:self action:@selector(cancelCreditsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[mainView addSubview:cancelButton];
	
//	[buttonsScrollView setContentOffset:CGPointMake(0, 300) animated:YES];
	
	scrollIndex = 100;
	
	[self.view addSubview: mainView];
	return self;
}	



- (void) titleLogoButtonClicked:(id)sender{
	NSURL *url = [[NSURL alloc] initWithString:@"http://www.red-soldier.com"];
	[[UIApplication sharedApplication]openURL:url];
	[url release];
	
}



- (void)cancelCreditsButtonClicked:(id)sender{
	
	if (self.selectedGame == kcreditsview){
		[[self parentViewController] dismissModalViewControllerAnimated:YES];
	}else{
		UIView* returnView;
		if (self.isFromTransition){
			returnView = [self.owner transitionView];
		}else{
			returnView = [self.owner theMainView];
		}
		
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
	
}


//- (void) scrollDownButtonsScrollView: (NSTimer*) theTimer {
- (void) scrollDownButtonsScrollView{
	CGPoint scrollPoint = buttonsScrollView.contentOffset;
	/*
	scrollPoint.y= scrollPoint.y+10;
	[buttonsScrollView setContentOffset:scrollPoint animated:YES];
	 */
//	scrollIndex
	scrollIndex = scrollIndex+100;
	if (scrollIndex < 900){
		[buttonsScrollView setContentOffset:CGPointMake(0, scrollIndex) animated:YES];
		[self scrollDownButtonsScrollView];
	}
//	[buttonsScrollView setContentOffset:CGPointMake(0, 400) animated:YES];
	
}

- (void) resetButtonsScrollView{
	[buttonsScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}


-(void)viewDidAppear:(BOOL)animated
{
//	[self scrollDownButtonsScrollView];
}

- (void)viewDidLoad 
{
	[buttonsScrollView setContentSize:CGSizeMake(290, 600)];
//	[self resetButtonsScrollView];
//	[self scrollDownButtonsScrollView];
//	[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(scrollDownButtonsScrollView:) userInfo:nil repeats:YES];

	
    [super viewDidLoad];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[buttonsScrollView release];
}


@end
