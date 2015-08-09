    //
//  TitleMenuViewController.m
//  bishibashi
//
//  Created by kenny on 26/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TitleMenuViewController.h"
#import "CreditsViewController.h"
#import "MediaManager.h"


@implementation TitleMenuViewController
@synthesize msgBoard = _msgBoard;
@synthesize billBoard = _billBoard;
@synthesize multiPlayerBillBoard = _multiPlayerBillBoard;

@synthesize mapBut = _mapBut;
@synthesize youtubeBut = _youtubeBut;
@synthesize soundBut = _soundBut;
@synthesize fbBut = _fbBut;
@synthesize stampBut = _stampBut;

@synthesize blueBut = _blueBut;
@synthesize greenBut = _greenBut;
@synthesize redBut = _redBut;
@synthesize backBut = _backBut;
@synthesize multiPlayerBackBut = _multiPlayerBackBut;
@synthesize owner = _owner;
@synthesize isFreeGame = _isFreeGame;
@synthesize isLite = _isLite;
@synthesize difficultiesLevel = _difficultiesLevel;
@synthesize selectedGame = _selectedGame;
@synthesize logoImageView = _logoImageView;
@synthesize onePlayerButtonsPaneView=_onePlayerButtonsPaneView;
@synthesize newBottomPanel=_newBottomPanel;
@synthesize currentMenu=_currentMenu;
@synthesize extraButtonsPaneView=_extraButtonsPaneView;
@synthesize levelSelectPaneView=_levelSelectPaneView;
@synthesize multiPlayersLevelSelectPaneView=_multiPlayersLevelSelectPaneView;
@synthesize multiPlayersLevelSelectScrollView=_multiPlayersLevelSelectScrollView;
@synthesize sharedSoundEffectsManager = _sharedSoundEffectsManager;
@synthesize onePlayerButtonsDifficultiesSelectView= _onePlayerButtonsDifficultiesSelectView;
@synthesize multiPlayersButtonsDifficultiesSelectView= _multiPlayersButtonsDifficultiesSelectView;
@synthesize multiPlayersLevelSelectPageControl= _multiPlayersLevelSelectPageControl;
@synthesize multiPlayersButtonsPaneView = _multiPlayersButtonsPaneView;
@synthesize socialPanel = _socialPanel;

@synthesize masterLevelSelectButton = _masterLevelSelectButton;


@synthesize waitingForClientsAlertView = _waitingForClientsAlertView;



static const CGRect socialPanelRect = {{15, 115}, {290, 30}};
static const CGRect dottedLineRect = {{15, 145}, {290, 5}};

static const CGRect stampRect = {{15, 35}, {70, 70}};
static const CGRect logoRect = {{95, 35}, {200, 70}};
static const CGRect msgBoardRect = {{30-320,150},{320,250}};

static const CGRect soundButRect = {{290,5},{25,25}};
static const CGRect globeButRect = {{255,5},{25,25}};
static const CGRect videoButRect = {{220,5},{25,25}};
static const CGRect fbButRect = {{185,5},{25,25}};

#pragma mark -
#pragma mark UIScrollViewDelegate Related Methods

- (void)scrollViewDidScroll:(UIScrollView *)sender {
	
	// Switch the indicator when more than 50% of the previous/next page is visible
	CGFloat pageWidth = sender.frame.size.width;
	int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	self.multiPlayersLevelSelectPageControl.currentPage = page;
}



- (void) initInterface
{
	NSString* username = [LocalStorageManager objectForKey:USER_NAME];
	if ([username isEqualToString:@"Ka Ka"] || [username isEqualToString:@"Kenny"] || [username isEqualToString:@"RedSoldier"]|| [username isEqualToString:@"Adelene"]|| [username isEqualToString:@"Heidy"])
		[[Constants sharedInstance] setAPPVERSION:@"version2" ];
	
	if ((self.currentMenu==start_screen) && (!self.logoImageView))
		[self initTitleLogo];
	//	[self initBackgroundWithLogo:YES];
//	else
//		[self initBackgroundWithLogo:NO];
	switch (self.currentMenu)	{
		case (one_player_difficulty_menu):
			[self.view addSubview:self.onePlayerButtonsPaneView];
			[self.view addSubview:self.onePlayerButtonsDifficultiesSelectView];
			break;
		case (one_player_level_select_menu):
			[self.view addSubview:self.onePlayerButtonsDifficultiesSelectView];
			[self.view addSubview:self.levelSelectPaneView];
			break;
		case (multi_players_menu):
			[self.view addSubview:self.multiPlayersButtonsPaneView];
			break;
		case (localmp_mode_select_menu):
			[self pushOutOnePlayerButtonsPane];
			break;
		case (gc_mode_select_menu):
			[self pushOutOnePlayerButtonsPane];			
			break;
		case (extra_menu):
			[self.view addSubview:self.extraButtonsPaneView];
			break;
	}
	
	[self.view initSnowFlakes];
	
}
	


- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
	[self.sharedSoundEffectsManager playTitleScreenBGM];
	NSLog(@"start billboard timer");
	[self.billBoard reload];
	[self.billBoard startTimer];
	if (self.stampBut)	{
		Pin* pinData = [[LocalStorageManager customObjectForKey:PIN] lastObject];
		if (pinData.pinLevel==kBeginner)	{
			[self.stampBut setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"question" ofType:@"png"]] forState:UIControlStateNormal];
		}
		else if (pinData.pinLevel==kMaster)	{
			[self.stampBut setBackgroundImage:[UIImage imageWithContentsOfFile:[[[Constants sharedInstance] gamePinsArray] objectAtIndex:pinData.game]] forState:UIControlStateNormal];
		}
		else if (pinData.pinLevel==kIntermediate)	{
			[self.stampBut setBackgroundImage:[UIImage imageWithContentsOfFile:[[[Constants sharedInstance] gameGreyPinsArray] objectAtIndex:pinData.game]] forState:UIControlStateNormal];
		}
	}
	
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self initInterface];

	[self.view addSubview:self.logoImageView];
	
}

- (void)viewWillDisappear:(BOOL)animated{
	NSLog(@"viewWillDisappear called");
	[self.navigationController setNavigationBarHidden:YES animated:animated];
	[super viewWillDisappear:animated];
	[self.sharedSoundEffectsManager stopTitleScreenBGM];
	NSLog(@"stop billboard timer");
	[[self.billBoard theTimer] invalidate];


}

- (void)loadView {
	NSLog(@"loadView called");
    [ super loadView ];
	[[UIDevice currentDevice] setOrientation:UIInterfaceOrientationPortrait];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
	NSLog(@"viewDidLoad called");
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	[super viewDidLoad];

}

- (void) viewDidDisappear:(BOOL) animated {
	[self.view removeAllSnowFlakes];
	[super viewDidDisappear:animated];
}

- (void) reInit	{
	if (!self.onePlayerButtonsPaneView)
		[self initOnePlayerMenu];
	if (!self.onePlayerButtonsDifficultiesSelectView)
		[self initOnePlayerDifficultiesSelectView];
	if (!self.multiPlayersButtonsPaneView)
		[self initMultiPlayersMenu];
	if (!self.multiPlayersButtonsDifficultiesSelectView)
		[self initMultiPlayersDifficultiesSelectView];
	if (!self.extraButtonsPaneView)
		[self initExtraMenu];
	if (!self.billBoard)
		[self initBillBoard];
	if (!self.levelSelectPaneView)
		[self initLevelSelectMenu];
	if (!self.multiPlayersLevelSelectPaneView)
		[self initMultiPlayersLevelSelectMenu];
	if (!self.newBottomPanel)
		[self initButtons];
	if (!self.logoImageView)
		[self initTitleLogo];
	
	NSArray* selectorNames = [self.msgBoard.arrowControl actionsForTarget:self.msgBoard forControlEvent:UIControlEventTouchUpInside];
	for (NSString* selectorName in selectorNames)	{
		if ([selectorName isEqualToString:@"show"])
			[self.msgBoard show];
	}
	
}

- (id)init {
	
	self = [ super init ];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	[self.navigationController setNavigationBarHidden:YES animated:NO];

	CGRect windowBounds = [[UIScreen mainScreen] applicationFrame];
	SnowFlakeView* theSnowFlakeView = [[SnowFlakeView alloc] initWithFrame:windowBounds];
	self.view = theSnowFlakeView;
	[theSnowFlakeView release];
	//[self.view addSubview:self.snowFlakeView];
	//UIView* view = [[UIView alloc] initWithFrame: windowBounds];
	//self.view = view;
	//[view release];
	[self.view setBackgroundColor:[UIColor blackColor]];
	self.currentMenu = start_screen;
	
	[self initOnePlayerMenu];
	[self initOnePlayerDifficultiesSelectView];
	[self initMultiPlayersMenu];
	[self initExtraMenu];
	[self initBillBoard];
	[self initLevelSelectMenu];
	
	self.isFreeGame = NO;
	self.sharedSoundEffectsManager = [MediaManager sharedInstance];
		
	return self;
}

-(void) initMsgBoard
{
	if (!self.msgBoard)	{
		MsgBoard* theMsgBoard = [[MsgBoard alloc] initWithFrame:msgBoardRect AndStartColor:1.0 AndEndColor:0.1 AndOwner:self];
		self.msgBoard = theMsgBoard;
		[theMsgBoard release];
		[self.view addSubview:self.msgBoard];
	}
}


- (void)initTitleLogo
{ 
	UIImageView* logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NSLocalizedString(@"logo",nil) ofType:@"png"]]];
	self.logoImageView = logoImageView;
	[logoImageView release];
	self.logoImageView.frame = logoRect;
	[self.view addSubview:self.logoImageView];

	UIButton* stampCollectionBut = [UIButton buttonWithType:UIButtonTypeCustom];
	self.stampBut = stampCollectionBut;
	stampCollectionBut.frame = stampRect;	
	Pin* pinData = [[LocalStorageManager customObjectForKey:PIN] lastObject];
	if (pinData.pinLevel==kBeginner)	{
		[stampCollectionBut setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"question" ofType:@"png"]] forState:UIControlStateNormal];
	}
	else if (pinData.pinLevel==kMaster)	{
		[stampCollectionBut setBackgroundImage:[UIImage imageWithContentsOfFile:[[[Constants sharedInstance] gamePinsArray] objectAtIndex:pinData.game]] forState:UIControlStateNormal];
	}
	else if (pinData.pinLevel==kIntermediate)	{
		[stampCollectionBut setBackgroundImage:[UIImage imageWithContentsOfFile:[[[Constants sharedInstance] gameGreyPinsArray] objectAtIndex:pinData.game]] forState:UIControlStateNormal];
	}
	
	[self.view addSubview:stampCollectionBut];
	[stampCollectionBut addTarget:self action:@selector(stampCollectionButClicked) forControlEvents:UIControlEventTouchUpInside];
	
	
	[self initMsgBoard];
	[self initButtons];

	NSArray* selectorNames = [self.msgBoard.arrowControl actionsForTarget:self.msgBoard forControlEvent:UIControlEventTouchUpInside];
	for (NSString* selectorName in selectorNames)	{
		if ([selectorName isEqualToString:@"show"])
			[self.msgBoard show];
	}
	
}

- (void)initMultiPlayersMenu {

	UIView* multiPlayersButtonsPaneView = [[UIView alloc]initWithFrame:CGRectMake(330, 160, 300, 280)];
	self.multiPlayersButtonsPaneView = multiPlayersButtonsPaneView;
	[multiPlayersButtonsPaneView release];
	UIImage *redButtonBackgroundImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"red_street_sign" ofType:@"png"]];
	UIImage *greenButtonBackgroundImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"green_street_sign" ofType:@"png"]];
	UIImage *yellowButtonBackgroundImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"yellow_street_sign" ofType:@"png"]];
		
	UIButton *multiPlayersCreateGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[multiPlayersCreateGameButton setFrame: CGRectMake(65, 5, 200, 60)];
	
	UILabel *chineseArcadeTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 140, 40)];
	[chineseArcadeTextLabel setText:NSLocalizedString(@"開始 Wifi /\n藍芽 對戰", nil)];
	[chineseArcadeTextLabel setBackgroundColor:[UIColor clearColor]];
	chineseArcadeTextLabel.contentMode = UIViewContentModeCenter;
	chineseArcadeTextLabel.textAlignment = UITextAlignmentCenter;
	chineseArcadeTextLabel.font = [UIFont systemFontOfSize:16];
	chineseArcadeTextLabel.numberOfLines=2;
	[multiPlayersCreateGameButton addSubview:chineseArcadeTextLabel];
	[chineseArcadeTextLabel release];
	[multiPlayersCreateGameButton setBackgroundImage:redButtonBackgroundImage forState:UIControlStateNormal];
	[multiPlayersCreateGameButton addTarget:self action:@selector(createVSModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.multiPlayersButtonsPaneView addSubview:multiPlayersCreateGameButton];
#ifdef LITE_VERSION
	[multiPlayersCreateGameButton removeTarget:self action:@selector(createVSModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];		
	[multiPlayersCreateGameButton addTarget:self action:@selector(liteCreateVSModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
#endif
	
	
	UIButton *multiPlayersJoinGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[multiPlayersJoinGameButton setFrame: CGRectMake(65, 95, 200, 60)];
	UILabel *chineseLevelSelectTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 140, 40)];
	[chineseLevelSelectTextLabel setText:NSLocalizedString(@"加入 Wifi /\n藍芽 對戰",nil)];
	[chineseLevelSelectTextLabel setBackgroundColor:[UIColor clearColor]];
	chineseLevelSelectTextLabel.contentMode = UIViewContentModeCenter;
	chineseLevelSelectTextLabel.textAlignment = UITextAlignmentCenter;
	chineseLevelSelectTextLabel.font = [UIFont systemFontOfSize:16];
	chineseLevelSelectTextLabel.numberOfLines=2;
	[multiPlayersJoinGameButton addSubview:chineseLevelSelectTextLabel];
	[chineseLevelSelectTextLabel release];
	
	[multiPlayersJoinGameButton setBackgroundImage:greenButtonBackgroundImage forState:UIControlStateNormal];
	[multiPlayersJoinGameButton addTarget:self action:@selector(multiPlayersJoinGameButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.multiPlayersButtonsPaneView addSubview:multiPlayersJoinGameButton];
#ifdef LITE_VERSION
	[multiPlayersJoinGameButton removeTarget:self action:@selector(multiPlayersJoinGameButtonClicked) forControlEvents:UIControlEventTouchUpInside];		
	[multiPlayersJoinGameButton addTarget:self action:@selector(liteMultiPlayersJoinGameButtonClicked) forControlEvents:UIControlEventTouchUpInside];
#endif
	
	UIButton *multiPlayersGCButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[multiPlayersGCButton setFrame: CGRectMake(65, 185, 200, 60)];
	UILabel *chineseGCTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 140, 40)];
	chineseGCTextLabel.contentMode = UIViewContentModeCenter;
	chineseGCTextLabel.textAlignment = UITextAlignmentCenter;
	chineseGCTextLabel.font = [UIFont systemFontOfSize:16];
	chineseGCTextLabel.numberOfLines = 2;
	[chineseGCTextLabel setText:NSLocalizedString(@"GameCenter\n對戰", nil)];
	[chineseGCTextLabel setBackgroundColor:[UIColor clearColor]];
	[multiPlayersGCButton addSubview:chineseGCTextLabel];
	[chineseGCTextLabel release];

	UIImageView* gcBut = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"gamecenter_icon" ofType:@"png"]]];
	gcBut.frame = CGRectMake(155, 15, 30, 30);
	[multiPlayersGCButton addSubview:gcBut];
	if ([[Constants sharedInstance] gameCenterEnabled])		
		[multiPlayersGCButton setEnabled:NO];

	[multiPlayersGCButton setBackgroundImage:yellowButtonBackgroundImage forState:UIControlStateNormal];
	[multiPlayersGCButton addTarget:self action:@selector(inviteFdButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.multiPlayersButtonsPaneView addSubview:multiPlayersGCButton];
#ifdef LITE_VERSION
	[multiPlayersGCButton removeTarget:self action:@selector(inviteFdButtonClicked) forControlEvents:UIControlEventTouchUpInside];		
	[multiPlayersGCButton addTarget:self action:@selector(liteInviteFdButtonClicked) forControlEvents:UIControlEventTouchUpInside];
#endif

	
	UIButton* backBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[backBut setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"back" ofType:@"png"]] forState:UIControlStateNormal];
	backBut.frame = CGRectMake(10, 265, 33,33);
	[backBut addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	backBut.enabled = YES;
	[self.multiPlayersButtonsPaneView addSubview:backBut];
	
	
	[self.view addSubview:self.multiPlayersButtonsPaneView];
	
}

- (void)multiPlayersJoinGameButtonClicked{
	[self.sharedSoundEffectsManager playUFOFlyPassSound];
	
	MultiPlayersJoinGameViewController* joinGameView = [[MultiPlayersJoinGameViewController alloc]init];
	[self.navigationController pushViewController:joinGameView animated:YES];	
	[joinGameView release];
}


- (void)initMultiPlayersLevelSelectMenu{
	
	CGRect viewFrame = CGRectMake(330, 120, 300, 440);
	UIView* multiPlayersLevelSelectPaneView = [[UIView alloc]initWithFrame:viewFrame];
	self.multiPlayersLevelSelectPaneView = multiPlayersLevelSelectPaneView;
	[multiPlayersLevelSelectPaneView release];
	
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setFrame: CGRectMake(40, 270, 232, 80)];
	
	UILabel *englishBackTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 13, 40, 20)];
	[englishBackTextLabel setText:@"Back"];
	englishBackTextLabel.contentMode = UIViewContentModeCenter;
	englishBackTextLabel.font = [UIFont systemFontOfSize:13];
	englishBackTextLabel.backgroundColor = [UIColor clearColor];
	[backButton addSubview:englishBackTextLabel];
	[englishBackTextLabel release];
	
	UIImage *buttonBackgroundImage = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"streetsign_button_background" ofType:@"png"]] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
	UIImage *buttonBackgroundImageDown = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"streetsign_button_background_inverted" ofType:@"png"]] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
	
	UILabel *chineseBackTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 38, 40, 20)];
	[chineseBackTextLabel setText:@"返回"];
	chineseBackTextLabel.backgroundColor = [UIColor clearColor];
	[backButton addSubview:chineseBackTextLabel];
	[chineseBackTextLabel release];
	[backButton setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
	[backButton setBackgroundImage:buttonBackgroundImageDown forState:UIControlStateHighlighted];
	[backButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	backButton.enabled = YES;
	self.multiPlayerBackBut = backButton;
	[self.multiPlayersLevelSelectPaneView  addSubview:backButton];
	
	[self.multiPlayersLevelSelectPaneView addSubview:self.multiPlayersLevelSelectScrollView];
	[self.multiPlayersLevelSelectPaneView addSubview:self.multiPlayersLevelSelectPageControl];
	[self.multiPlayersLevelSelectPaneView sendSubviewToBack:self.multiPlayersLevelSelectScrollView];
	[self.view addSubview:self.multiPlayersLevelSelectPaneView];
	
}

- (void) initBillBoard{
	BillBoard* board = [[BillBoard alloc] initWithPosterSize:CGSizeMake(160,200) andPosters:[[Constants sharedInstance] gameScreensArray] andOwner:self andGameLevel:self.difficultiesLevel];
	self.billBoard = board;
	[board release];
}

- (void)initLevelSelectMenu{
	
	CGRect viewFrame = CGRectMake(330, 150, 320, 440);
	UIView* levelSelectPaneView = [[UIView alloc]initWithFrame:viewFrame];
	self.levelSelectPaneView = levelSelectPaneView;
	[levelSelectPaneView release];
	
	
/*
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setFrame: CGRectMake(40, 270, 232, 80)];
	
	UILabel *englishBackTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 13, 40, 20)];
	[englishBackTextLabel setText:@"Back"];
	[englishBackTextLabel setBackgroundColor:[UIColor clearColor]];
	englishBackTextLabel.contentMode = UIViewContentModeCenter;
	englishBackTextLabel.font = [UIFont systemFontOfSize:13];
	[backButton addSubview:englishBackTextLabel];
	[englishBackTextLabel release];
	
	UIImage *buttonBackgroundImage = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"streetsign_button_background" ofType:@"png"]] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
	UIImage *buttonBackgroundImageDown = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"streetsign_button_background_inverted" ofType:@"png"]] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
	
	UILabel *chineseBackTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 38, 40, 20)];
	[chineseBackTextLabel setText:@"返回"];
	[chineseBackTextLabel setBackgroundColor:[UIColor clearColor]];
	[backButton addSubview:chineseBackTextLabel];
	[chineseBackTextLabel release];
	[backButton setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
	[backButton setBackgroundImage:buttonBackgroundImageDown forState:UIControlStateHighlighted];
	[backButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	backButton.enabled = YES;
	self.backBut = backButton;
	[self.levelSelectPaneView  addSubview:backButton];
*/	
	[self.view addSubview:self.levelSelectPaneView];
	

}

- (void)initExtraMenu {
	
	UIView* extraButtonsPaneView = [[UIView alloc]initWithFrame:CGRectMake(330, 130, 300, 400)];
	self.extraButtonsPaneView = extraButtonsPaneView;
	[extraButtonsPaneView release];
	
	UIImage *redButtonBackgroundImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"red_street_sign" ofType:@"png"]];
	UIImage *greenButtonBackgroundImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"green_street_sign" ofType:@"png"]];
	UIImage *yellowButtonBackgroundImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"yellow_street_sign" ofType:@"png"]];
	UIImage *blueButtonBackgroundImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"blue_street_sign" ofType:@"png"]];
	
	UIButton *recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[recordButton setFrame: CGRectMake(65, 40, 200, 60)];
	UILabel *chineseArcadeTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 140, 40)];
	[chineseArcadeTextLabel setText:NSLocalizedString(@"最高記錄", nil)];
	[chineseArcadeTextLabel setBackgroundColor:[UIColor clearColor]];
	chineseArcadeTextLabel.contentMode = UIViewContentModeCenter;
	chineseArcadeTextLabel.textAlignment = UITextAlignmentCenter;
	chineseArcadeTextLabel.font = [UIFont systemFontOfSize:16];
	chineseArcadeTextLabel.numberOfLines = 2;
	[recordButton addSubview:chineseArcadeTextLabel];
	[chineseArcadeTextLabel release];
	[recordButton setBackgroundImage:redButtonBackgroundImage forState:UIControlStateNormal];
	[recordButton addTarget:self action:@selector(recordButClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.extraButtonsPaneView addSubview:recordButton];

	UIButton *gcRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[gcRecordButton setFrame: CGRectMake(65, 120, 200, 60)];
	UILabel *chineseLevelSelectTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 140, 40)];
	[chineseLevelSelectTextLabel setText:NSLocalizedString(@"GameCenter\n龍虎榜",nil)];
	chineseLevelSelectTextLabel.numberOfLines=2;
	[chineseLevelSelectTextLabel setBackgroundColor:[UIColor clearColor]];
	chineseLevelSelectTextLabel.contentMode = UIViewContentModeCenter;
	chineseLevelSelectTextLabel.textAlignment = UITextAlignmentCenter;
	chineseLevelSelectTextLabel.font = [UIFont systemFontOfSize:16];
	[gcRecordButton addSubview:chineseLevelSelectTextLabel];
	[chineseLevelSelectTextLabel release];
	UIImageView* gcBut = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"gamecenter_icon" ofType:@"png"]]];
	gcBut.frame = CGRectMake(155, 15, 30, 30);
	[gcRecordButton addSubview:gcBut];
	
	if ([[Constants sharedInstance] gameCenterEnabled])		
		[gcRecordButton setEnabled:NO];
		
	[gcRecordButton setBackgroundImage:greenButtonBackgroundImage forState:UIControlStateNormal];
	[gcRecordButton addTarget:self action:@selector(gcIconClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.extraButtonsPaneView addSubview:gcRecordButton];

	
	UIButton *configButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[configButton setFrame: CGRectMake(65, 200, 200, 60)];
	chineseLevelSelectTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 140, 40)];
	[chineseLevelSelectTextLabel setText:NSLocalizedString(@"設定",nil)];
	chineseLevelSelectTextLabel.numberOfLines=2;
	[chineseLevelSelectTextLabel setBackgroundColor:[UIColor clearColor]];
	chineseLevelSelectTextLabel.contentMode = UIViewContentModeCenter;
	chineseLevelSelectTextLabel.textAlignment = UITextAlignmentCenter;
	chineseLevelSelectTextLabel.font = [UIFont systemFontOfSize:16];
	[configButton addSubview:chineseLevelSelectTextLabel];
	[chineseLevelSelectTextLabel release];
	
	[configButton setBackgroundImage:yellowButtonBackgroundImage forState:UIControlStateNormal];
	[configButton addTarget:self action:@selector(configButClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.extraButtonsPaneView addSubview:configButton];
	
	UIButton *creditsButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[creditsButton setFrame: CGRectMake(65, 280, 200, 60)];
	UILabel *chineseGCTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 140, 40)];
	chineseGCTextLabel.contentMode = UIViewContentModeCenter;
	chineseGCTextLabel.textAlignment = UITextAlignmentCenter;
	chineseGCTextLabel.font = [UIFont systemFontOfSize:16];
	chineseGCTextLabel.numberOfLines=2;
	[chineseGCTextLabel setText:NSLocalizedString(@"關於", nil)];
	[chineseGCTextLabel setBackgroundColor:[UIColor clearColor]];
	[creditsButton addSubview:chineseGCTextLabel];
	[chineseGCTextLabel release];
	
	[creditsButton setBackgroundImage:blueButtonBackgroundImage forState:UIControlStateNormal];
	[creditsButton addTarget:self action:@selector(creditsButClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.extraButtonsPaneView addSubview:creditsButton];
	
	UIButton* backBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[backBut setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"back" ofType:@"png"]] forState:UIControlStateNormal];
	backBut.frame = CGRectMake(10, 300, 33,33);
	[backBut addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	backBut.enabled = YES;
	[self.extraButtonsPaneView addSubview:backBut];
		
	[self.view addSubview:self.extraButtonsPaneView];
}

- (void)initOnePlayerMenu {
	
	UIView* onePlayerButtonsPaneView = [[UIView alloc]initWithFrame:CGRectMake(330, 160, 300, 320)];
	self.onePlayerButtonsPaneView = onePlayerButtonsPaneView;
	[onePlayerButtonsPaneView release];
	UIImage *redButtonBackgroundImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"red_street_sign" ofType:@"png"]];
	UIImage *greenButtonBackgroundImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"green_street_sign" ofType:@"png"]];
	UIImage *yellowButtonBackgroundImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"yellow_street_sign" ofType:@"png"]];
	
	UIButton *onePlayerArcadeGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[onePlayerArcadeGameButton setFrame: CGRectMake(65, 5, 200, 60)];
	UILabel *chineseArcadeTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 140, 40)];
	[chineseArcadeTextLabel setText:NSLocalizedString(@"街機模式", nil)];
	[chineseArcadeTextLabel setBackgroundColor:[UIColor clearColor]];
	chineseArcadeTextLabel.contentMode = UIViewContentModeCenter;
	chineseArcadeTextLabel.textAlignment = UITextAlignmentCenter;
	chineseArcadeTextLabel.font = [UIFont systemFontOfSize:16];
	chineseArcadeTextLabel.numberOfLines=2;
	[onePlayerArcadeGameButton addSubview:chineseArcadeTextLabel];
	[chineseArcadeTextLabel release];
	[onePlayerArcadeGameButton setBackgroundImage:redButtonBackgroundImage forState:UIControlStateNormal];
	[onePlayerArcadeGameButton addTarget:self action:@selector(arcadeGameButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.onePlayerButtonsPaneView addSubview:onePlayerArcadeGameButton];
	
	UIButton *onePlayerArcadeLiteGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[onePlayerArcadeLiteGameButton setFrame: CGRectMake(65, 95, 200, 60)];
	UILabel *chineseLevelSelectTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 140, 40)];
	[chineseLevelSelectTextLabel setText:@"Random 5"];
	[chineseLevelSelectTextLabel setBackgroundColor:[UIColor clearColor]];
	chineseLevelSelectTextLabel.contentMode = UIViewContentModeCenter;
	chineseLevelSelectTextLabel.textAlignment = UITextAlignmentCenter;
	chineseLevelSelectTextLabel.font = [UIFont systemFontOfSize:16];
	chineseLevelSelectTextLabel.numberOfLines=2;
	[onePlayerArcadeLiteGameButton addSubview:chineseLevelSelectTextLabel];
	[chineseLevelSelectTextLabel release];
	
	[onePlayerArcadeLiteGameButton setBackgroundImage:greenButtonBackgroundImage forState:UIControlStateNormal];
	[onePlayerArcadeLiteGameButton addTarget:self action:@selector(arcadeGameLiteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.onePlayerButtonsPaneView addSubview:onePlayerArcadeLiteGameButton];
	
#ifdef LITE_VERSION
	[onePlayerArcadeLiteGameButton removeFromSuperview];
#endif	
	
	UIButton *onePlayerLevelSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[onePlayerLevelSelectButton setFrame: CGRectMake(65, 185, 200, 60)];
	UILabel *chineseGCTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 140, 40)];
	chineseGCTextLabel.contentMode = UIViewContentModeCenter;
	chineseGCTextLabel.textAlignment = UITextAlignmentCenter;
	chineseGCTextLabel.font = [UIFont systemFontOfSize:16];
	chineseGCTextLabel.numberOfLines=2;
	[chineseGCTextLabel setText:NSLocalizedString(@"自由選關", nil)];
	[chineseGCTextLabel setBackgroundColor:[UIColor clearColor]];
	[onePlayerLevelSelectButton addSubview:chineseGCTextLabel];
	[chineseGCTextLabel release];
	
	[onePlayerLevelSelectButton setBackgroundImage:yellowButtonBackgroundImage forState:UIControlStateNormal];
	[onePlayerLevelSelectButton addTarget:self action:@selector(freeGameButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.onePlayerButtonsPaneView addSubview:onePlayerLevelSelectButton];
	
	UIButton* backBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[backBut setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"back" ofType:@"png"]] forState:UIControlStateNormal];
	backBut.frame = CGRectMake(10, 265, 33,33);
	[backBut addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	backBut.enabled = YES;
	[self.onePlayerButtonsPaneView addSubview:backBut];
	
	
	[self.view addSubview:self.multiPlayersButtonsPaneView];
	
}


-(void)pushInLevelSelectPane{
	
	[self.sharedSoundEffectsManager playUFOFlyPassSound];
	
	UIView* backBoard = [[UIView alloc] initWithFrame:CGRectMake(0,200,320,200)];
	backBoard.backgroundColor = [UIColor blackColor];
	[self.levelSelectPaneView addSubview:backBoard];
	[backBoard release];
	
	self.billBoard.theInner.gameLevel = self.difficultiesLevel;
	[self.levelSelectPaneView addSubview:self.billBoard.scrollView];
	[self.levelSelectPaneView addSubview:self.billBoard];
	[self.levelSelectPaneView bringSubviewToFront:self.backBut];

	[self.billBoard reload];
	NSLog(@"pushInLevelSelectPane");
	[UIView beginAnimations:@"push in Levels" context:nil];
	[UIView setAnimationDuration:0.5]; 
	CGRect frame = self.levelSelectPaneView.frame;
	frame.origin = CGPointMake(self.levelSelectPaneView.frame.origin.x-330, self.levelSelectPaneView.frame.origin.y);
	self.levelSelectPaneView.frame = frame;
	[self.view addSubview:self.levelSelectPaneView];
	[UIView commitAnimations];
	[self.billBoard startTimer];
	
	UIButton* backBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[backBut setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"back" ofType:@"png"]] forState:UIControlStateNormal];
	backBut.frame = CGRectMake(10, 275, 33,33);
	[backBut addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	backBut.enabled = YES;
	[self.levelSelectPaneView addSubview:backBut];
	
}


-(void)pushOutLevelSelectPane{
	[UIView beginAnimations:@"push out Levels" context:nil];
	[UIView setAnimationDuration:0.5]; 
	[UIView setAnimationDelegate:self];
	CGRect frame = self.levelSelectPaneView.frame;
	frame.origin = CGPointMake(self.levelSelectPaneView.frame.origin.x+330, self.levelSelectPaneView.frame.origin.y);
	self.levelSelectPaneView.frame = frame;
	[UIView commitAnimations];		
}

-(void)pushInOnePlayerDifficultysSelectPane{
	[self.sharedSoundEffectsManager playUFOFlyPassSound];
	[UIView beginAnimations:@"push in difficulties" context:nil];
	[UIView setAnimationDuration:0.5]; 
	
	if (self.isFreeGame)
		[self.onePlayerButtonsDifficultiesSelectView addSubview:self.masterLevelSelectButton]; 
	else
		[self.masterLevelSelectButton removeFromSuperview];
	CGRect frame = self.onePlayerButtonsDifficultiesSelectView.frame;
	frame.origin = CGPointMake(self.onePlayerButtonsDifficultiesSelectView.frame.origin.x-325, self.onePlayerButtonsDifficultiesSelectView.frame.origin.y);
	self.onePlayerButtonsDifficultiesSelectView.frame = frame;
	[self.view addSubview:self.onePlayerButtonsDifficultiesSelectView];		
	
	[UIView commitAnimations];
}

-(void)pushOutOnePlayerDifficultysSelectPane{
	[UIView beginAnimations:@"push out difficulties" context:nil];
	[UIView setAnimationDuration:0.5]; 
	CGRect frame = self.onePlayerButtonsDifficultiesSelectView.frame;
	frame.origin = CGPointMake(self.onePlayerButtonsDifficultiesSelectView.frame.origin.x+325, self.onePlayerButtonsDifficultiesSelectView.frame.origin.y);
	self.onePlayerButtonsDifficultiesSelectView.frame = frame;
	[self.view addSubview:self.onePlayerButtonsDifficultiesSelectView];		
	[UIView commitAnimations];		
	
}




-(void)pushInMultiPlayersDifficultysSelectPane{
	[self.sharedSoundEffectsManager playUFOFlyPassSound];
	[UIView beginAnimations:@"push in difficulties" context:nil];
	[UIView setAnimationDuration:0.5]; 
	
	CGRect frame = self.multiPlayersButtonsDifficultiesSelectView.frame;
	frame.origin = CGPointMake(self.multiPlayersButtonsDifficultiesSelectView.frame.origin.x-325, self.multiPlayersButtonsDifficultiesSelectView.frame.origin.y);
	self.multiPlayersButtonsDifficultiesSelectView.frame = frame;
	[self.view addSubview:self.multiPlayersButtonsDifficultiesSelectView];		
	[UIView commitAnimations];
}

-(void)pushOutMultiPlayersDifficultysSelectPane{
	[UIView beginAnimations:@"push out difficulties" context:nil];
	[UIView setAnimationDuration:0.5];
	CGRect frame = self.multiPlayersButtonsDifficultiesSelectView.frame;
	frame.origin = CGPointMake(self.multiPlayersButtonsDifficultiesSelectView.frame.origin.x+325, self.multiPlayersButtonsDifficultiesSelectView.frame.origin.y);
	self.multiPlayersButtonsDifficultiesSelectView.frame = frame;
	[self.view addSubview:self.multiPlayersButtonsDifficultiesSelectView];		
	[UIView commitAnimations];		
	
}

-(void)pushInMultiPlayersButtonsPane{
	[self.sharedSoundEffectsManager playUFOFlyPassSound];
	[UIView beginAnimations:@"push in buttons" context:nil];
	[UIView setAnimationDuration:0.5]; 
	
	CGRect frame = self.multiPlayersButtonsPaneView.frame;
	
	frame.origin = CGPointMake(self.multiPlayersButtonsPaneView.frame.origin.x-325, self.multiPlayersButtonsPaneView.frame.origin.y);
	self.multiPlayersButtonsPaneView.frame = frame;
	[self.view addSubview:self.multiPlayersButtonsPaneView];		
	
	[UIView commitAnimations];
}

-(void)pushOutMultiPlayersButtonsPane{
	[UIView beginAnimations:@"push out one player buttons" context:nil];
	[UIView setAnimationDuration:0.5]; 
	CGRect frame = self.multiPlayersButtonsPaneView.frame;
	
	frame.origin = CGPointMake(self.multiPlayersButtonsPaneView.frame.origin.x+325, self.multiPlayersButtonsPaneView.frame.origin.y);
	self.multiPlayersButtonsPaneView.frame = frame;
	[self.view addSubview:self.multiPlayersButtonsPaneView];		
	[UIView commitAnimations];		
	
}

-(void)pushInExtraButtonsPane{
	[self.sharedSoundEffectsManager playUFOFlyPassSound];
	[UIView beginAnimations:@"push in buttons" context:nil];
	[UIView setAnimationDuration:0.5]; 
	
	CGRect frame = self.extraButtonsPaneView.frame;
	frame.origin = CGPointMake(self.extraButtonsPaneView.frame.origin.x-325, self.extraButtonsPaneView.frame.origin.y);
	
	self.extraButtonsPaneView.frame = frame;
	[self.view addSubview:self.extraButtonsPaneView];		
	
	[UIView commitAnimations];
}

-(void)pushOutExtraButtonsPane{
	[UIView beginAnimations:@"push out extra buttons" context:nil];
	[UIView setAnimationDuration:0.5]; 
	CGRect frame = self.extraButtonsPaneView.frame;
	
	frame.origin = CGPointMake(self.extraButtonsPaneView.frame.origin.x+325, self.extraButtonsPaneView.frame.origin.y);
	self.extraButtonsPaneView.frame = frame;
	[self.view addSubview:self.extraButtonsPaneView];		
	[UIView commitAnimations];		
	
}


-(void)pushInOnePlayerButtonsPane{
	[self.sharedSoundEffectsManager playUFOFlyPassSound];
	[UIView beginAnimations:@"push in buttons" context:nil];
	[UIView setAnimationDuration:0.5]; 
	
	CGRect frame = self.onePlayerButtonsPaneView.frame;
	
	frame.origin = CGPointMake(self.onePlayerButtonsPaneView.frame.origin.x-325, self.onePlayerButtonsPaneView.frame.origin.y);
	
	self.onePlayerButtonsPaneView.frame = frame;
	[self.view addSubview:self.onePlayerButtonsPaneView];		

	[UIView commitAnimations];
}

-(void)pushOutOnePlayerButtonsPane{
	[UIView beginAnimations:@"push out one player buttons" context:nil];
	[UIView setAnimationDuration:0.5]; 
	CGRect frame = self.onePlayerButtonsPaneView.frame;
	
	frame.origin = CGPointMake(self.onePlayerButtonsPaneView.frame.origin.x+325, self.onePlayerButtonsPaneView.frame.origin.y);
	self.onePlayerButtonsPaneView.frame = frame;
	[self.view addSubview:self.onePlayerButtonsPaneView];		
	[UIView commitAnimations];		
	
}






- (void)arcadeGameButtonClicked{
	self.isFreeGame = NO;
	self.isLite = NO;
	[self.sharedSoundEffectsManager playUFOFlyPassSound];
	if (self.currentMenu == one_player_menu)	{
		[self pushInOnePlayerButtonsPane];
		[self pushInOnePlayerDifficultysSelectPane];
		self.currentMenu = one_player_difficulty_menu;
	}
	else if (self.currentMenu == localmp_mode_select_menu)	{
		[self pushInOnePlayerButtonsPane];
		[self localMPLevelSelectButtonClicked:karcade];
//		self.currentMenu = localmp_level_select_menu;
	}
	else if (self.currentMenu == gc_mode_select_menu)	{
		[self pushInOnePlayerButtonsPane];
		[self gcLevelSelectButtonClicked:karcade];
//		self.currentMenu = gc_level_select_menu;
	}
}

- (void)arcadeGameLiteButtonClicked{
	self.isFreeGame = NO;
	self.isLite = YES;
	[self.sharedSoundEffectsManager playUFOFlyPassSound];
	if (self.currentMenu == one_player_menu)	{
		[self pushInOnePlayerButtonsPane];
		[self pushInOnePlayerDifficultysSelectPane];
		self.currentMenu = one_player_difficulty_menu;
	}
	else if (self.currentMenu == localmp_mode_select_menu)	{
		[self pushInOnePlayerButtonsPane];
		[self localMPLevelSelectButtonClicked:karcadelite];
//		self.currentMenu = localmp_level_select_menu;
	}
	else if (self.currentMenu == gc_mode_select_menu)	{
		[self pushInOnePlayerButtonsPane];
		[self gcLevelSelectButtonClicked:karcadelite];
//		self.currentMenu = gc_level_select_menu;
	}
}

- (void)freeGameButtonClicked{
	self.isFreeGame = YES;
	[self.sharedSoundEffectsManager playUFOFlyPassSound];
	if (self.currentMenu == one_player_menu)	{
		[self pushInOnePlayerButtonsPane];
		[self pushInOnePlayerDifficultysSelectPane];
		self.currentMenu = one_player_difficulty_menu;
	}
	else if (self.currentMenu == localmp_mode_select_menu)	{
		[self pushInOnePlayerButtonsPane];
		[self pushInLevelSelectPane];
		self.currentMenu = localmp_level_select_menu;
	}
	else if (self.currentMenu == gc_mode_select_menu)	{
		[self pushInOnePlayerButtonsPane];
		[self pushInLevelSelectPane];
		self.currentMenu = gc_level_select_menu;
	}
}

-(void)backButtonClicked{
	[self.sharedSoundEffectsManager playUFOFlyPassSound];

	if (self.currentMenu == one_player_level_select_menu){
		// back to difficulties menu
		[self pushOutOnePlayerDifficultysSelectPane];
		[self pushOutLevelSelectPane];
		self.currentMenu = one_player_difficulty_menu;
		
	}else if (self.currentMenu == one_player_difficulty_menu){
		// back to one player menu
		[self pushOutOnePlayerDifficultysSelectPane];
		[self pushOutOnePlayerButtonsPane];
		self.currentMenu = one_player_menu;
		
	}else if (self.currentMenu == one_player_menu){
		// back to start screen
		[self pushOutOnePlayerButtonsPane];
		[self unHideBottomButtons];
		self.currentMenu = start_screen;
		
	}else if (self.currentMenu == multi_players_menu){
		// back to start screen
		[self pushOutMultiPlayersButtonsPane];
		[self unHideBottomButtons];
		self.currentMenu = start_screen;
		
	}
	else if (self.currentMenu == localmp_mode_select_menu){
		// back to multi-player menu screen
		[self pushOutOnePlayerButtonsPane];
		[self pushOutMultiPlayersButtonsPane];
		self.currentMenu = multi_players_menu;
		
	}else if (self.currentMenu == localmp_level_select_menu){
		// back to difficulties menu
		[self pushOutLevelSelectPane];
		[self pushOutOnePlayerButtonsPane];
		self.currentMenu = localmp_mode_select_menu;
		
	}else if (self.currentMenu == extra_menu){
		[self pushOutExtraButtonsPane];
		[self unHideBottomButtons];
		self.currentMenu = start_screen;
		
	}
	else if (self.currentMenu == gc_mode_select_menu){
		// back to multi-player menu screen
		[self pushOutOnePlayerButtonsPane];
		[self pushOutMultiPlayersButtonsPane];
		self.currentMenu = multi_players_menu;
		
	} else if (self.currentMenu == gc_level_select_menu)	{
		// back to difficulties menu
		[self pushOutLevelSelectPane];
		[self pushOutOnePlayerButtonsPane];
		self.currentMenu = gc_mode_select_menu;
	} 	 
}


- (void)initOnePlayerDifficultiesSelectView{
	
	UIView* onePlayerButtonsDifficultiesSelectView = [[UIView alloc]initWithFrame:CGRectMake(330, 130, 300, 450)];
	self.onePlayerButtonsDifficultiesSelectView = onePlayerButtonsDifficultiesSelectView;
	[onePlayerButtonsDifficultiesSelectView release];
	
	UIImage *redButtonBackgroundImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"red_street_sign" ofType:@"png"]];
	UIImage *greenButtonBackgroundImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"green_street_sign" ofType:@"png"]];
	UIImage *yellowButtonBackgroundImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"yellow_street_sign" ofType:@"png"]];
	UIImage *blueButtonBackgroundImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"blue_street_sign" ofType:@"png"]];
	
	UIButton *easyLevelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[easyLevelButton setFrame: CGRectMake(65, 40, 200, 60)];
	
	UILabel *chineseArcadeTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 140, 40)];
	[chineseArcadeTextLabel setText:NSLocalizedString(@"好易", nil)];
	[chineseArcadeTextLabel setBackgroundColor:[UIColor clearColor]];
	chineseArcadeTextLabel.contentMode = UIViewContentModeCenter;
	chineseArcadeTextLabel.textAlignment = UITextAlignmentCenter;
	chineseArcadeTextLabel.font = [UIFont systemFontOfSize:16];
	chineseArcadeTextLabel.numberOfLines=2;
	[easyLevelButton addSubview:chineseArcadeTextLabel];
	[chineseArcadeTextLabel release];
	[easyLevelButton setBackgroundImage:redButtonBackgroundImage forState:UIControlStateNormal];
	[easyLevelButton addTarget:self action:@selector(onePlayerEasyLevelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.onePlayerButtonsDifficultiesSelectView addSubview:easyLevelButton];
	
	UIButton *normalLevelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[normalLevelButton setFrame: CGRectMake(65, 120, 200, 60)];
	UILabel *chineseLevelSelectTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 140, 40)];
	[chineseLevelSelectTextLabel setText:NSLocalizedString(@"正常",nil)];
	chineseLevelSelectTextLabel.numberOfLines=2;
	[chineseLevelSelectTextLabel setBackgroundColor:[UIColor clearColor]];
	chineseLevelSelectTextLabel.contentMode = UIViewContentModeCenter;
	chineseLevelSelectTextLabel.textAlignment = UITextAlignmentCenter;
	chineseLevelSelectTextLabel.font = [UIFont systemFontOfSize:16];
	chineseLevelSelectTextLabel.numberOfLines=2;
	[normalLevelButton addSubview:chineseLevelSelectTextLabel];
	[chineseLevelSelectTextLabel release];
	
	[normalLevelButton setBackgroundImage:greenButtonBackgroundImage forState:UIControlStateNormal];
	[normalLevelButton addTarget:self action:@selector(onePlayerNormalLevelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.onePlayerButtonsDifficultiesSelectView addSubview:normalLevelButton];
	
	
	UIButton *hardLevelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[hardLevelButton setFrame: CGRectMake(65, 200, 200, 60)];
	chineseLevelSelectTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 140, 40)];
	[chineseLevelSelectTextLabel setText:NSLocalizedString(@"難爆",nil)];
	[chineseLevelSelectTextLabel setBackgroundColor:[UIColor clearColor]];
	chineseLevelSelectTextLabel.contentMode = UIViewContentModeCenter;
	chineseLevelSelectTextLabel.textAlignment = UITextAlignmentCenter;
	chineseLevelSelectTextLabel.font = [UIFont systemFontOfSize:16];
	chineseLevelSelectTextLabel.numberOfLines=2;
	[hardLevelButton addSubview:chineseLevelSelectTextLabel];
	[chineseLevelSelectTextLabel release];
	
	[hardLevelButton setBackgroundImage:yellowButtonBackgroundImage forState:UIControlStateNormal];
	[hardLevelButton addTarget:self action:@selector(onePlayerHardLevelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.onePlayerButtonsDifficultiesSelectView addSubview:hardLevelButton];
	
	UIButton *worldClassLevelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[worldClassLevelButton setFrame: CGRectMake(65, 280, 200, 60)];
	UILabel *chineseGCTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 140, 40)];
	chineseGCTextLabel.contentMode = UIViewContentModeCenter;
	chineseGCTextLabel.textAlignment = UITextAlignmentCenter;
	chineseGCTextLabel.font = [UIFont systemFontOfSize:16];
	chineseGCTextLabel.numberOfLines=2;
	[chineseGCTextLabel setText:NSLocalizedString(@"大師", nil)];
	[chineseGCTextLabel setBackgroundColor:[UIColor clearColor]];
	[worldClassLevelButton addSubview:chineseGCTextLabel];
	[chineseGCTextLabel release];
	
	[worldClassLevelButton setBackgroundImage:blueButtonBackgroundImage forState:UIControlStateNormal];
	[worldClassLevelButton addTarget:self action:@selector(onePlayersWorldClassLevelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	self.masterLevelSelectButton = worldClassLevelButton;
	[self.onePlayerButtonsDifficultiesSelectView addSubview:worldClassLevelButton];
	UIButton* backBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[backBut setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"back" ofType:@"png"]] forState:UIControlStateNormal];
	backBut.frame = CGRectMake(10, 300, 33,33);
	[backBut addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	backBut.enabled = YES;
	[self.onePlayerButtonsDifficultiesSelectView addSubview:backBut];
	
	[self.view addSubview:self.onePlayerButtonsDifficultiesSelectView];

}


-(void)onePlayerGameSelectButtonClicked:(Game)theGame{
	[self onePlayerLevelSelectButtonClicked:theGame];
}
	
	

-(void)onePlayerLevelSelectButtonClicked:(NSInteger)inSelectedGame{
	self.selectedGame = inSelectedGame;
	[self onePlayerButtonClicked];
}


- (void)multiPlayersButtonClicked{
	[self.sharedSoundEffectsManager playUFOFlyPassSound];
	[self startPicker];
	
}

-(void) leaderBoardButtonClicked{
	NSString* prefix = @"bashbash.";
#ifdef LITE_VERSION
	prefix = @"bashbashlite.";
#endif
	
	if ([[Constants sharedInstance] gameCenterEnabled]) {
		GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
		leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
		
		leaderboardController.category = [NSString stringWithFormat:@"%@arcade", prefix];
		
		if (leaderboardController != nil)
		{
			leaderboardController.leaderboardDelegate = self;
			[self presentModalViewController: leaderboardController animated: YES];
		}
		[leaderboardController release];
		
	}
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void) autoMatchButtonClicked
{
	GKMatchRequest *matchRequest = [[GKMatchRequest alloc] init]; 
	matchRequest.minPlayers = 2; 
	matchRequest.maxPlayers = 2; 
	matchRequest.playerGroup = kjumpinggirl;
	
	GKMatchmaker *matchmaker = [GKMatchmaker sharedMatchmaker];
	[matchmaker findMatchForRequest:matchRequest withCompletionHandler:^(GKMatch *match, NSError *error) {
		if (error) {
			// Handle error
		} else {
		}
	}];
}
-(void) createVSModeButtonClicked
{
	self.currentMenu = localmp_mode_select_menu;
//	self.currentMenu = localmp_level_select_menu;
	self.difficultiesLevel = kHard;
	[self pushInOnePlayerButtonsPane];
	//	[self pushInLevelSelectPane];
	[self pushInMultiPlayersButtonsPane];
}	
-(void) inviteFdButtonClicked
{
	self.currentMenu = gc_mode_select_menu;
//	self.currentMenu = gc_level_select_menu;
	self.difficultiesLevel = kHard;
	[self pushInOnePlayerButtonsPane];
//	[self pushInLevelSelectPane];
//	[self pushInOnePlayerDifficultysSelectPane];
//	[self pushInGameCenterPane];
	[self pushInMultiPlayersButtonsPane];
	
}


-(void) liteInviteFdButtonClicked
{
	// open an alert with just an OK button
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"BashBashVS完整版\n有11個遊戲，街機及Random5模式\n可作線上對戰",nil) 
													message:NSLocalizedString(@"透過iTune 購買拍拍機BashBashVS完整版？",nil)
												   delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"購買!",nil), NSLocalizedString(@"先試搶包山",nil),nil];
	alert.tag = 3;
	[alert show];	
	[alert release];
	
}

- (void) liteCreateVSModeButtonClicked
{
	// open an alert with just an OK button
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"BashBashVS完整版\n有11個遊戲，街機及Random5模式\n可作線上對戰",nil) 
													message:NSLocalizedString(@"透過iTune 購買拍拍機BashBashVS完整版？",nil)
												   delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"購買!",nil), NSLocalizedString(@"先試搶包山",nil),nil];
	alert.tag = 1;
	[alert show];	
	[alert release];
	
}

- (void) liteMultiPlayersJoinGameButtonClicked
{
	// open an alert with just an OK button
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"可參與完整版或Lite版\n所開始的各項Wifi/藍芽對戰",nil) 
													message:nil
												   delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Good!",nil),nil];
	alert.tag = 2;
	[alert show];	
	[alert release];
	
}

-(void) gcLevelSelectButtonClicked:(Game)game
{	
	NSLog(@"game to send is %d", game);
	GKMatchRequest *matchRequest = [[GKMatchRequest alloc] init]; 
	matchRequest.minPlayers = 2; 
	matchRequest.maxPlayers = 2; 
	matchRequest.playerGroup = game;
	
	GKMatchmakerViewController *controller = [[[GKMatchmakerViewController alloc] initWithMatchRequest:matchRequest] autorelease];
	controller.matchmakerDelegate = [GameCenterManager sharedInstance]; 
	[[GameCenterManager sharedInstance] setTheGame:game];
	[[GameCenterManager sharedInstance] setTheGameLevel:self.difficultiesLevel];
	[[GameCenterManager sharedInstance] setVc:self];
	[[GameCenterManager sharedInstance] setIsHost:YES];
	[[GameCenterManager sharedInstance] setIsLite:self.isLite];
	[self presentModalViewController:controller animated:YES];
	
}

-(void) localMPLevelSelectButtonClicked:(Game)game
{	
	[[GameCenterManager sharedInstance] setTheGame:game];
	[[GameCenterManager sharedInstance] setTheGameLevel:self.difficultiesLevel];
	[[GameCenterManager sharedInstance] setVc:self];
	[[GameCenterManager sharedInstance] setIsHost:YES];
	[[GameCenterManager sharedInstance] setIsLite:self.isLite];
	[[GameCenterManager sharedInstance] startP2PServer];
	
	
	self.waitingForClientsAlertView = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"等待挑戰者連接...\n\n\n", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles: nil] autorelease];
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	// Adjust the indicator so it is up a few pixels from the bottom of the alert
	indicator.center = CGPointMake(135, 65);
	[indicator startAnimating];
	[self.waitingForClientsAlertView addSubview:indicator];
	[indicator release];	
	
	[self.waitingForClientsAlertView show];
	
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == 1)	{
		if (buttonIndex==0)	{
			NSString *buyString=@"itms://itunes.com/apps/redsoldier/拍拍機bashbash";
			NSURL *url = [[NSURL alloc] initWithString:[buyString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
			[[UIApplication sharedApplication] openURL:url];
			[url release];
		}
		else if (buttonIndex==1)	{
			self.difficultiesLevel=kHard;
			[self localMPLevelSelectButtonClicked:kbunhill];
		}
	}
	else if (alertView.tag == 2)	{
		if (buttonIndex==0)	{
			[self multiPlayersJoinGameButtonClicked];
		}
	}
	else if (alertView.tag == 3)	{
		if (buttonIndex==0)	{
			NSString *buyString=@"itms://itunes.com/apps/redsoldier/拍拍機bashbash";
			NSURL *url = [[NSURL alloc] initWithString:[buyString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
			[[UIApplication sharedApplication] openURL:url];
			[url release];			
		}
		else if (buttonIndex==1)	{
			self.difficultiesLevel=kHard;
			[self gcLevelSelectButtonClicked:kbunhill];			
		}
	}
	
	// the user clicked one of the OK/Cancel buttons
	else if (buttonIndex == 0){
		NSLog(@"cancel");
		[self.waitingForClientsAlertView dismissWithClickedButtonIndex:0 animated:YES];
		[self backButtonClicked];
	}
}


- (void)onePlayerButtonClicked{
	[self.sharedSoundEffectsManager playUFOFlyPassSound];
	
	{
		
		GameViewController* gameViewController = [[GameViewController alloc]init];
		gameViewController.navigationController = self.navigationController;
		gameViewController.isLite = self.isLite;
		gameViewController.difficultiesLevel = self.difficultiesLevel;
		
		if (self.isFreeGame){
			gameViewController.gameType = one_player_level_select;
			gameViewController.theGame = self.selectedGame;
		}
		else	{
			gameViewController.gameType = one_player_arcade;
			if (self.isLite)
				gameViewController.theGame = [[Constants sharedInstance] firstGameForMode:kArcadeLite];				
			else
				gameViewController.theGame = [[Constants sharedInstance] firstGameForMode:kArcade];
		}
		[self.navigationController pushViewController:gameViewController animated:YES];
		[gameViewController release];
	}	
}

- (void)onePlayerEasyLevelButtonClicked{
	self.difficultiesLevel = kEasy;
	if (self.isFreeGame) {
		[self.sharedSoundEffectsManager playUFOFlyPassSound];
		self.currentMenu = one_player_level_select_menu;
		[self pushInOnePlayerDifficultysSelectPane];
		[self pushInLevelSelectPane];
	}else{
		[self onePlayerButtonClicked];
	}
}

- (void)onePlayerNormalLevelButtonClicked{
	self.difficultiesLevel = kNormal;
	if (self.isFreeGame){
		[self.sharedSoundEffectsManager playUFOFlyPassSound];
		self.currentMenu = one_player_level_select_menu;
		[self pushInOnePlayerDifficultysSelectPane];
		[self pushInLevelSelectPane];
		// set menu
	}else{
		[self onePlayerButtonClicked];
	}
}

- (void)onePlayerHardLevelButtonClicked{
	self.difficultiesLevel = kHard;
	if (self.isFreeGame){
		[self.sharedSoundEffectsManager playUFOFlyPassSound];
		self.currentMenu = one_player_level_select_menu;
		[self pushInOnePlayerDifficultysSelectPane];
		[self pushInLevelSelectPane];
		// set menu
	}else{
		[self onePlayerButtonClicked];
	}
}

- (void) onePlayersWorldClassLevelButtonClicked	{
	self.difficultiesLevel = kWorldClass;
	if (self.isFreeGame){
		[self.sharedSoundEffectsManager playUFOFlyPassSound];
		self.currentMenu = one_player_level_select_menu;
		[self pushInOnePlayerDifficultysSelectPane];
		[self pushInLevelSelectPane];
		// set menu
	}else{
		[self onePlayerButtonClicked];
	}
}


- (void)unHideBottomButtons{
	if (![self.socialPanel isDescendantOfView:self.view])	{
		SocialPanel* socialPanel = [[SocialPanel sharedInstance] initWithFrame:socialPanelRect WithMsgBoard:self.msgBoard AndOwner:self];
		self.socialPanel = socialPanel;
		[socialPanel release];
		[self.view addSubview:self.socialPanel];
	} 
	[UIView beginAnimations:@"slide up buttons" context:nil];
	[UIView setAnimationDuration:1]; 
	
	self.msgBoard.frame = CGRectOffset(self.msgBoard.frame, 320, 0);
	self.youtubeBut.frame = CGRectOffset(self.youtubeBut.frame, -320,0);
	self.mapBut.frame = CGRectOffset(self.mapBut.frame, -320,0);
	self.fbBut.frame = CGRectOffset(self.fbBut.frame, -320,0);

	CGRect frame = self.newBottomPanel.frame;
	frame.origin = CGPointMake(self.newBottomPanel.frame.origin.x, self.newBottomPanel.frame.origin.y-80);
	self.newBottomPanel.frame = frame;
	[self.view addSubview:self.newBottomPanel];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(slideUpButtonsDone:finished:context:)];
	[UIView commitAnimations];
}

- (void)hideBottomButtons{
	[UIView beginAnimations:@"slide down buttons" context:nil];
	[UIView setAnimationDuration:1]; 
	
	self.msgBoard.frame = CGRectOffset(self.msgBoard.frame, -320, 0);
	self.youtubeBut.frame = CGRectOffset(self.youtubeBut.frame, 320,0);
	self.mapBut.frame = CGRectOffset(self.mapBut.frame, 320,0);
	self.fbBut.frame = CGRectOffset(self.fbBut.frame, 320,0);
	
	CGRect frame = self.newBottomPanel.frame;
	frame.origin = CGPointMake(self.newBottomPanel.frame.origin.x, self.newBottomPanel.frame.origin.y+80);
	self.newBottomPanel.frame = frame;
	
	[UIView commitAnimations];
}




- (void)initButtons{
	/* init social panel */
	if (!self.socialPanel)	{
		SocialPanel* socialPanel = [[SocialPanel sharedInstance] initWithFrame:socialPanelRect WithMsgBoard:self.msgBoard AndOwner:self];
		self.socialPanel = socialPanel;
		[socialPanel release];
		[self.view addSubview:self.socialPanel];
		
		UIImageView* dottedLine = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dottedline" ofType:@"png"]]];
		dottedLine.frame = dottedLineRect;
		[self.view addSubview:dottedLine];
		[dottedLine release];

	}
	
	if (!self.soundBut)	{
		self.soundBut = [UIButton buttonWithType:UIButtonTypeCustom];
		self.soundBut.frame = CGRectMake(290,5,25,25);		
		self.soundBut.backgroundColor = [UIColor clearColor];
		if (![LocalStorageManager boolForKey:SOUNDOFF]){
			[self.soundBut setImage:[UIImage imageNamed:@"soundon.png"] forState:UIControlStateNormal];
		}else{
			[self.soundBut setImage:[UIImage imageNamed:@"soundoff.png"] forState:UIControlStateNormal];
		}
		[self.view addSubview:self.soundBut];
		[self.soundBut addTarget:self action:@selector(soundButClicked) forControlEvents:UIControlEventTouchDown];
	}
	
	
	CGRect textViewFrame = CGRectMake(0, 400+80, 480.0, 90);		
//	UIImage *image1 = [UIImage imageNamed:@"button_bar_background.png"];
	UIImageView* newBottomPanel = [[UIImageView alloc] initWithFrame:textViewFrame];
	self.newBottomPanel = newBottomPanel;
	[newBottomPanel release];
//	self.newBottomPanel.image = image1;
//	self.newBottomPanel.backgroundColor = [UIColor grayColor];
	self.newBottomPanel.userInteractionEnabled = YES;
	
	
	UIButton* tmpBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[tmpBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];	
	[tmpBut setBackgroundImage:[UIImage imageNamed:@"bluebutton.png"] forState:UIControlStateNormal];
	[tmpBut setBackgroundImage:[UIImage imageNamed:@"bluebutton_pressed.png"] forState:UIControlStateHighlighted];	
	[tmpBut setFrame:CGRectMake(220, 0, 80, 80)];
	self.blueBut = tmpBut;
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leaderboard.png"]];
	tmpView.frame = CGRectMake(30, 22, 25,25);
	[self.blueBut addSubview:tmpView];
	[tmpView release];
	

	tmpBut = [UIButton buttonWithType:UIButtonTypeCustom];
/*	tmpBut.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
	[tmpBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[tmpBut setTitle:@"2P" forState: UIControlStateNormal];		
*/	
	[tmpBut setBackgroundImage:[UIImage imageNamed:@"greenbutton.png"] forState:UIControlStateNormal];
	[tmpBut setBackgroundImage:[UIImage imageNamed:@"greenbutton_pressed.png"] forState:UIControlStateHighlighted];	
	[tmpBut setFrame:CGRectMake(120, 0, 80, 80)];
	self.greenBut = tmpBut;
	UILabel* tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(30,22,40,25)];
	tmpLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:22.0];
	tmpLabel.backgroundColor = [UIColor clearColor];
	tmpLabel.textColor = [UIColor whiteColor];
	tmpLabel.text = @"2P";
	[self.greenBut addSubview:tmpLabel];
	[tmpBut release];
	
	tmpBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[tmpBut setBackgroundImage:[UIImage imageNamed:@"redbutton.png"] forState:UIControlStateNormal];
	[tmpBut setBackgroundImage:[UIImage imageNamed:@"redbutton_pressed.png"] forState:UIControlStateHighlighted];
	/*tmpBut.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
	[tmpBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[tmpBut setTitle:@"1P" forState: UIControlStateNormal];	
	*/[tmpBut setFrame:CGRectMake(25, 0, 80, 80)];
	self.redBut = tmpBut;
	tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(30,22,40,25)];
	tmpLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:22.0];
	tmpLabel.backgroundColor = [UIColor clearColor];
	tmpLabel.textColor = [UIColor whiteColor];
	tmpLabel.text = @"1P";
	[self.redBut addSubview:tmpLabel];
	[tmpBut release];
	
	[self.blueBut addTarget:self action:@selector(blueButClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.greenBut addTarget:self action:@selector(greenButClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.redBut addTarget:self action:@selector(redButClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.newBottomPanel addSubview:self.blueBut];
	[self.newBottomPanel addSubview:self.redBut];
	[self.newBottomPanel addSubview:self.greenBut];	

	[self.view addSubview:self.newBottomPanel];

	
	tmpBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[tmpBut setBackgroundImage:[UIImage imageNamed:@"video.png"] forState:UIControlStateNormal];
	[tmpBut setFrame:videoButRect];
	self.youtubeBut = tmpBut;
	[self.view addSubview:self.youtubeBut];
	tmpBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[tmpBut setBackgroundImage:[UIImage imageNamed:@"globe.png"] forState:UIControlStateNormal];
	[tmpBut setFrame:globeButRect];
	self.mapBut = tmpBut;
	[self.view addSubview:self.mapBut];
	tmpBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[tmpBut setBackgroundImage:[UIImage imageNamed:@"fb-icon.png"] forState:UIControlStateNormal];
	[tmpBut setFrame:fbButRect];
	self.fbBut = tmpBut;
	[self.view addSubview:self.fbBut];
	
	[self.youtubeBut addTarget:self action:@selector(youtubeButClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.mapBut addTarget:self action:@selector(mapButClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.fbBut addTarget:self action:@selector(fbButClicked) forControlEvents:UIControlEventTouchUpInside];

	
	[UIView beginAnimations:@"slide up buttons" context:nil];
	[UIView setAnimationDuration:1]; 
	

	CGRect frame = self.newBottomPanel.frame;
	frame.origin = CGPointMake(self.newBottomPanel.frame.origin.x, self.newBottomPanel.frame.origin.y-80);
	self.newBottomPanel.frame = frame;
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(slideUpButtonsDone:finished:context:)];
	[UIView commitAnimations];
	
}

-(void) stampCollectionButClicked
{
	[self.sharedSoundEffectsManager playUFOFlyPassSound];
	self.title = NSLocalizedString(@"目錄",nil);
	StampCollectionViewController* theConfigView = [[StampCollectionViewController alloc]init];
	[self.navigationController pushViewController:theConfigView animated:YES];	
	[theConfigView release];
		
}
-(void) fbButClicked
{
	[self.sharedSoundEffectsManager playUFOFlyPassSound];
	self.title = NSLocalizedString(@"目錄",nil);
	FBViewController* theConfigView = [[FBViewController alloc]init];
	[self.navigationController pushViewController:theConfigView animated:YES];	
	[theConfigView release];
}
-(void) mapButClicked
{
	[self.sharedSoundEffectsManager playUFOFlyPassSound];
	self.title = NSLocalizedString(@"目錄",nil);
	AroundTheWorldViewController* theConfigView = [[AroundTheWorldViewController alloc]init];
	[self.navigationController pushViewController:theConfigView animated:YES];	
	[theConfigView release];
}
-(void) youtubeButClicked
{
	[self.sharedSoundEffectsManager playUFOFlyPassSound];
	self.title = NSLocalizedString(@"目錄",nil);
	VideoTableViewController* theConfigView = [[VideoTableViewController alloc]initWithPage:-1];
	[self.navigationController pushViewController:theConfigView animated:YES];	
	[theConfigView release];
}

- (void)slideUpButtonsDone:(NSString *)animationID finished:(NSNumber *) finished context:(void *) context {
}

- (void)soundButClicked{
	if (![LocalStorageManager boolForKey:SOUNDOFF]){
		// turn sound off
		[LocalStorageManager setBool:YES forKey:SOUNDOFF];
		[self.soundBut setImage:[UIImage imageNamed:@"soundoff.png"] forState:UIControlStateNormal];
		[[self sharedSoundEffectsManager] pauseTitleScreenBGM];
	}else{
		// turn sound on
		[LocalStorageManager setBool:NO forKey:SOUNDOFF];
		[self.soundBut setImage:[UIImage imageNamed:@"soundon.png"] forState:UIControlStateNormal];
		[[self sharedSoundEffectsManager] playTitleScreenBGM];
	}
	
}


- (void) redButClicked{
	[self.sharedSoundEffectsManager playUFOFlyPassSound];
	[self pushInOnePlayerButtonsPane];
	[self hideBottomButtons];
	self.currentMenu = one_player_menu;
}

- (void) blueButClicked{
	[self.sharedSoundEffectsManager playUFOFlyPassSound];
	[self pushInExtraButtonsPane];
	[self hideBottomButtons];
	self.currentMenu = extra_menu;
	
}

- (void) greenButClicked{
	[self.sharedSoundEffectsManager playUFOFlyPassSound];
	[self pushInMultiPlayersButtonsPane];
	[self hideBottomButtons];
	self.currentMenu = multi_players_menu;
}

- (void) configButClicked{
	[self.sharedSoundEffectsManager playUFOFlyPassSound];
	self.title = NSLocalizedString(@"目錄",nil);
	ConfigViewController* theConfigView = [[ConfigViewController alloc]init];
	[self.navigationController pushViewController:theConfigView animated:YES];	
	[theConfigView release];
}


- (void) creditsButClicked{
	[self.sharedSoundEffectsManager playUFOFlyPassSound];
	CreditsViewController* creditsViewController = [[CreditsViewController alloc]initWithGameType:kcreditsview];
	[self presentModalViewController:creditsViewController animated:NO];
	[creditsViewController release];
	
}

- (void) recordButClicked{
	[self.sharedSoundEffectsManager playUFOFlyPassSound];
	GameRecordMenuViewController*  theConfigView = [[GameRecordMenuViewController alloc] init];
	[self.navigationController pushViewController:theConfigView animated:YES];	
	[theConfigView release];
}

- (void)gcIconClicked{
	NSString* prefix = @"bashbash.";
#ifdef LITE_VERSION
	prefix = @"bashbashlite.";
#endif
	
	if ([[Constants sharedInstance] gameCenterEnabled]) {
		GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
		leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
		
			leaderboardController.category = [NSString stringWithFormat:@"%@arcade", prefix];			
			
			NSLog(leaderboardController.category);
			
			if (leaderboardController != nil)
			{
				leaderboardController.leaderboardDelegate = self;
				[self presentModalViewController: leaderboardController animated: YES];
			}
			[leaderboardController release];
	}
	
}

-(void) mbIconClicked{
	SinaConfigViewController* sinaConfigViewController = [[SinaConfigViewController alloc]init];
	[self presentModalViewController:sinaConfigViewController animated:YES];
	[sinaConfigViewController release];
	self.currentMenu = no_change;
}

- (void) twIconClicked{
	MBConfigViewController* mbConfigViewController = [[MBConfigViewController alloc]init];
	[self presentModalViewController:mbConfigViewController animated:YES];
	[mbConfigViewController release];
	self.currentMenu = no_change;
}
/*
- (void) FBLoginedWithUserName:(NSString*)username AndImageUrl:(NSString*) imageurl AndUid:(NSString*) uid;
{
	[self.fbPhoto initImageUrl:imageurl];
	if (uid)	{
		[self.msgBoard.msgGetter addKey:@"fbuid" AndVal:uid];
		[self.msgBoard.msgGetter sendReq];
	}
	else {
		[self.msgBoard clear];
	}

}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	/*
	self.onePlayerButtonsPaneView=nil;
	self.onePlayerButtonsDifficultiesSelectView=nil;
	self.multiPlayersButtonsPaneView=nil;
	self.multiPlayersButtonsDifficultiesSelectView=nil;
	self.extraButtonsPaneView=nil;
	self.billBoard=nil;
	self.levelSelectPaneView=nil;
	self.multiPlayersLevelSelectPaneView=nil;
    */
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)dealloc {
	NSLog(@"dealloc titleMenuViewController");
	self.waitingForClientsAlertView = nil;
	self.masterLevelSelectButton = nil;
	self.stampBut = nil;
	self.fbBut = nil;
	self.youtubeBut = nil;
	self.mapBut = nil;
	self.soundBut = nil;
	self.msgBoard = nil;
	[[FBDataSource sharedInstance] setDelegate:nil];
	self.backBut = nil;
	self.multiPlayerBackBut=nil;
	self.billBoard = nil;
	self.redBut = nil;
	self.greenBut = nil;
	self.blueBut = nil;
	self.logoImageView = nil;
	self.onePlayerButtonsPaneView = nil;
	self.onePlayerButtonsDifficultiesSelectView = nil;
	self.extraButtonsPaneView = nil;
	self.levelSelectPaneView = nil;
	self.multiPlayersButtonsPaneView= nil;
	self.multiPlayersButtonsDifficultiesSelectView=nil;
	self.multiPlayersLevelSelectPaneView = nil;
	self.multiPlayersLevelSelectPageControl = nil;
	self.multiPlayersLevelSelectScrollView = nil;
	self.newBottomPanel = nil;
	self.socialPanel = nil;
    [super dealloc];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if ([animationID isEqualToString:@"push out Levels"])	{
		NSLog(@"stop billboard timer");
		[[self.billBoard theTimer] invalidate];
	}
}

@end
