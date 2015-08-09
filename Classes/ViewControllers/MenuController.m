    //
//  MenuController.m
//  bishibashi
//
//  Created by ktang on 10/25/10.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "MenuController.h"
#import "FontLabel.h"

@implementation MenuController

@synthesize sharedSoundEffectsManager = _sharedSoundEffectsManager;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize mainOptionsView = _mainOptionsView;
@synthesize versusOptionsView = _versusOptionsView;
@synthesize settingOptionsView = _settingOptionsView;
@synthesize singlePlayerOptionsView = _singlePlayerOptionsView;
@synthesize gameCenterOptionsView = _gameCenterOptionsView;
@synthesize arcadeModeDifficultyView = _arcadeModeDifficultyView;
@synthesize randomFiveModeDifficultyView = _randomFiveModeDifficultyView;
@synthesize freeSelectDifficultyView = _freeSelectDifficultyView;
@synthesize versusFreeSelectDifficultyView = _versusFreeSelectDifficultyView;
@synthesize versusCreateGameOptionsView = _versusCreateGameOptionsView;
@synthesize levelSelectPaneView = _levelSelectPaneView;
@synthesize versusModeLevelSelectPaneView = _versusModeLevelSelectPaneView;
@synthesize meCommunityScrollViewContentsView = _meCommunityScrollViewContentsView;
@synthesize communityMenuView = _communityMenuView;
@synthesize gameViewController = _gameViewController;
@synthesize billBoard = _billBoard;
@synthesize multiPlayerBillBoard = _multiPlayerBillBoard;
@synthesize meCommunityOverlayView = _meCommunityOverlayView;
@synthesize communityCommunityOverlayView = _communityCommunityOverlayView;
@synthesize newsCommunityOverlayView = _newsCommunityOverlayView;
@synthesize soundOnOffLabel = _soundOnOffLabel;
@synthesize musicOnOffLabel = _musicOnOffLabel;
@synthesize mePhotoImageView = mePhotoImageView;
@synthesize myNameTextField = myNameTextField;
@synthesize msgGetter = _msgGetter;
@synthesize newsTableView = _newsTableView;
@synthesize msgs = _msgs;
@synthesize gcLeaderBoardImageView = _gcLeaderBoardImageView;
@synthesize gcLeaderBoardButton = _gcLeaderBoardButton;
@synthesize waitingForClientsAlertView = _waitingForClientsAlertView;

#pragma mark -
#pragma mark Lifecycle methods

- (void)reloadCommunityOverlay{
	NSLog(@"reloadCommunityViews");
	NSLog(@"reloadCommunityViews USER_NAME: %@", [LocalStorageManager objectForKey:USER_NAME]);
	NSLog(@"reloadCommunityViews USER_IMAGE: %@", [LocalStorageManager objectForKey:USER_IMAGE]);
	if ([LocalStorageManager objectForKey:USER_NAME] != nil){
		self.myNameTextField.text = @"";
		self.myNameTextField.text = [LocalStorageManager objectForKey:USER_NAME];
	}else{
		if ([[Constants sharedInstance] gameCenterEnabled]) {
			// check and populate textfield with gamecenter alias
			if (myNameTextField.text != nil){
				myNameTextField.text = [[GKLocalPlayer localPlayer] alias];
			}
		}
	}
	
	if ([LocalStorageManager objectForKey:USER_IMAGE] != nil){
		if (self.mePhotoImageView != nil){
			[self.mePhotoImageView removeFromSuperview];
		}
		if (self.mePhotoImageView != nil){
			[self.mePhotoImageView release];
		}
		
		NSURL *url = [NSURL URLWithString:[LocalStorageManager stringForKey:USER_IMAGE]];
		NSData *data = [NSData dataWithContentsOfURL:url];
		UIImage* userProfileImage =  [[UIImage alloc] initWithData:data];
		
		UIImageView* localMePhotoImageView = [[UIImageView alloc] initWithImage:userProfileImage];
		localMePhotoImageView.frame = CGRectMake(35, -60, 60, 60);
		self.mePhotoImageView = localMePhotoImageView;
		
		[self.meCommunityScrollViewContentsView addSubview:self.mePhotoImageView];
		
		NSLog(@"changed image?");
		[userProfileImage release];
	}else{
		if (self.mePhotoImageView != nil){
			[self.mePhotoImageView removeFromSuperview];
		}
		if (self.mePhotoImageView.image != nil){
			[self.mePhotoImageView.image release];
		}
		
		UIImage *meImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"me_logo" ofType:@"png"]];
		
		UIImageView* localMePhotoImageView = [[UIImageView alloc] initWithImage:meImage];
		localMePhotoImageView.frame = CGRectMake(35, -60, 60, 60);
		self.mePhotoImageView = localMePhotoImageView;
		
		[self.meCommunityScrollViewContentsView addSubview:self.mePhotoImageView];
		
	}
	
	if ([[Constants sharedInstance] gameCenterEnabled]) {
		[self.gcLeaderBoardImageView setAlpha:1.0];
		[self.gcLeaderBoardButton setEnabled:YES];
	}else{
		[self.gcLeaderBoardImageView setAlpha:0.5];
		[self.gcLeaderBoardButton setEnabled:NO];
	}
	
}

- (void)loadView {
    [super loadView];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
	[self.billBoard reload];
	[self.billBoard startTimer];
	[self reloadCommunityOverlay];
}

- (void)viewWillDisappear:(BOOL)animated{
	NSLog(@"viewWillDisappear");
	[self.navigationController setNavigationBarHidden:NO animated:animated];
	[super viewWillDisappear:animated];
	[[self.billBoard theTimer] invalidate];
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

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

-(void)viewDidLoad{
	[super viewDidLoad];
	NSLog(@"viewDidLoad");
}

- (void)dealloc {
    [super dealloc];
	[self.backgroundImageView release];
}



#pragma mark -
#pragma mark Init Interface methods

- (id)init {
	self = [ super init ];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	
	CGRect windowBounds = [[UIScreen mainScreen] applicationFrame];
	UIView* view = [[UIView alloc] initWithFrame: windowBounds];
	self.view = view;
	[view release];
	
	// background
	UIImage *backgroundImage = [[UIImage imageNamed:@"menu_background_grey.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
	UIImageView* backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	backgroundImageView.image = backgroundImage;
	[self.view addSubview:backgroundImageView];
	[self.view sendSubviewToBack:backgroundImageView];
	[backgroundImageView release];
	
	
	UIImageView* backgroundIconGeneralImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"background_icon_general" ofType:@"png"]]];
	backgroundIconGeneralImageView.frame = CGRectMake(5, 245, 101, 101);
	[backgroundIconGeneralImageView setAlpha:0.3f];
	[self.view addSubview:backgroundIconGeneralImageView];
	
	
	[self initTitleLogo];
	[self initMainOptions];	
	[self initFreeSelectBillBoard];
	[self initVersusFreeSelectBillBoard];
	[self initCommunityMenu];	
	[self initCommunityOverlay];
	[self initNewsOverlay];
	[self initFooterText];
	
	showingOverlay = NO;
	self.sharedSoundEffectsManager = [MediaManager sharedInstance];
	
	return self;
}

- (void)initTitleLogo{
	UIImageView* logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NSLocalizedString(@"logo",nil) ofType:@"png"]]];
	logoImageView.frame = CGRectMake(50, 10, 207, 74);
	[self.view addSubview:logoImageView];
	[logoImageView release];
	
}

- (void)initFooterText{
	FontLabel *footerLabel = [[FontLabel alloc] initWithFrame:CGRectMake(170, 90, 150, 10) fontName:@"BADABB.ttf" pointSize:12.0f];
	[footerLabel setText:@"v1.5  2010 Red Soldier Limited."];
	footerLabel.textColor = [UIColor whiteColor];
	footerLabel.textAlignment = UITextAlignmentLeft;
	footerLabel.backgroundColor = [UIColor clearColor];
	footerLabel.numberOfLines = 0;
	[self.view addSubview:footerLabel];
	[footerLabel release];
}


- (void)initCommunityMenu{
	UIView *communityMenuView = [[UIView alloc]initWithFrame:CGRectMake(0, 390, 320, 85)];
	UIImageView* communityMenuBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"community_menu_background" ofType:@"png"]]];
	communityMenuBackgroundImageView.frame = CGRectMake(0, 0, 320, 85);
	[communityMenuView addSubview:communityMenuBackgroundImageView];
	[communityMenuBackgroundImageView release];
	
	UIImageView* meImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"me_logo" ofType:@"png"]]];
	meImageView.frame = CGRectMake(25, 10, 50, 50);
	FontLabel *meLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		meLabel = [[FontLabel alloc] initWithFrame:CGRectMake(17, 58, 60, 10) fontName:@"BADABB.ttf" pointSize:14.0f];
	}else{
		meLabel = [[FontLabel alloc] initWithFrame:CGRectMake(6, 60, 60, 10) fontName:@"wt005.ttf" pointSize:11.0f];
	}
	[meLabel setText:NSLocalizedString(@"Me",nil)];
	meLabel.textColor = [UIColor whiteColor];
	meLabel.backgroundColor = [UIColor clearColor];
	[meImageView addSubview:meLabel];
	UIButton *meButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[meButton setFrame: CGRectMake(25, 10, 50, 50)];
	[meButton addTarget:self action:@selector(meButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[meButton setBackgroundImage:[UIImage imageNamed:@"logo_pressed.png"] forState:UIControlStateHighlighted];
	[communityMenuView addSubview:meImageView];	
	[communityMenuView addSubview:meButton];	
	[meLabel release];
	[meImageView release];
	
	
	UIImageView* communityImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"achievements_logo" ofType:@"png"]]];
	communityImageView.frame = CGRectMake(135, 10, 50, 50);
	FontLabel *communityLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		communityLabel = [[FontLabel alloc] initWithFrame:CGRectMake(-2, 58, 65, 10) fontName:@"BADABB.ttf" pointSize:14.0f];
	}else{
		communityLabel = [[FontLabel alloc] initWithFrame:CGRectMake(13, 60, 65, 10) fontName:@"wt005.ttf" pointSize:11.0f];
	}
	[communityLabel setText:NSLocalizedString(@"Community",nil)];
	communityLabel.textColor = [UIColor whiteColor];
	communityLabel.backgroundColor = [UIColor clearColor];
	[communityImageView addSubview:communityLabel];
	UIButton *communityButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[communityButton setFrame: CGRectMake(135, 10, 50, 50)];
	[communityButton addTarget:self action:@selector(communityButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[communityButton setBackgroundImage:[UIImage imageNamed:@"logo_pressed.png"] forState:UIControlStateHighlighted];
	[communityMenuView addSubview:communityImageView];	
	[communityMenuView addSubview:communityButton];	
	[communityLabel release];
	[communityImageView release];
	
	UIImageView* newsImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"news_logo" ofType:@"png"]]];
	newsImageView.frame = CGRectMake(245, 10, 50, 50);
	FontLabel *newsLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		newsLabel = [[FontLabel alloc] initWithFrame:CGRectMake(256, 68, 65, 10) fontName:@"BADABB.ttf" pointSize:14.0];
	}else{
		newsLabel = [[FontLabel alloc] initWithFrame:CGRectMake(258, 70, 65, 10) fontName:@"wt005.ttf" pointSize:11.0f];
	}
	[newsLabel setText:NSLocalizedString(@"News",nil)];
	newsLabel.textColor = [UIColor whiteColor];
	newsLabel.backgroundColor = [UIColor clearColor];
	[communityMenuView addSubview:newsImageView];
	[communityMenuView addSubview:newsLabel];

	 UIButton *newsButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[newsButton setFrame: CGRectMake(245, 10, 50, 50)];
	[newsButton addTarget:self action:@selector(newsButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[newsButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	[communityMenuView addSubview:newsButton];	
	[newsLabel release];
	[newsImageView release];
	
	 
	self.communityMenuView = communityMenuView;
	[self.view addSubview:self.communityMenuView];	
	[communityMenuView release];
	
}

- (void)initMainOptions{
	
	UIView *mainOptionsView = [[UIView alloc]initWithFrame:CGRectMake(80, 110, 300, 250)];
	
	
	NSArray *singlePlayerButtonImagesArray  = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"menu_main_button_shine_none.png"], [UIImage imageNamed:@"menu_main_button_shine_quarter.png"], [UIImage imageNamed:@"menu_main_button_shine_half.png"], [UIImage imageNamed:@"menu_main_button_shine_full.png"],[UIImage imageNamed:@"menu_main_button_shine_half.png"], nil];
	UIImageView* singlePlayerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 262, 90)];
	singlePlayerImageView.animationImages = singlePlayerButtonImagesArray;
	singlePlayerImageView.contentMode = UIViewContentModeBottomLeft;
	singlePlayerImageView.animationDuration = 0.8;
	singlePlayerImageView.animationRepeatCount = 0;
	[singlePlayerImageView startAnimating];
	
	FontLabel *beginGameLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		beginGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(90, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:23.0f];
	}else{
		beginGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(100, 15, 250, 60) fontName:@"wt005.ttf" pointSize:20.0f];
	}
	[beginGameLabel setText:NSLocalizedString(@"Start Game",nil)];
	beginGameLabel.textColor = [UIColor blackColor];
	beginGameLabel.backgroundColor = [UIColor clearColor];
	[singlePlayerImageView addSubview:beginGameLabel];
	// invisible button overlay
	UIButton *singlePlayerButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[singlePlayerButton setFrame: CGRectMake(0, 0, 262, 90)];
	[singlePlayerButton addTarget:self action:@selector(singlePlayerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[singlePlayerButton setBackgroundImage:[UIImage imageNamed:@"menu_main_button_pressed.png"] forState:UIControlStateHighlighted];
	
	[mainOptionsView addSubview:singlePlayerImageView];
	[mainOptionsView addSubview:singlePlayerButton];
	[singlePlayerImageView release];
	[singlePlayerButtonImagesArray release];
	
	UIImageView* versusImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	versusImageView.frame = CGRectMake(25, 80, 232, 90);
	
	FontLabel *versusGameLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		versusGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(90, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:23.0f];
	}else{
		versusGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(90, 15, 250, 60) fontName:@"wt005.ttf" pointSize:20.0f];
	}
	[versusGameLabel setText:NSLocalizedString(@"Versus",nil)];
	versusGameLabel.textColor = [UIColor blackColor];
	versusGameLabel.backgroundColor = [UIColor clearColor];
	[versusImageView addSubview:versusGameLabel];
	
	UIButton *versusButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[versusButton setFrame: CGRectMake(25, 80, 232, 90)];
	[versusButton addTarget:self action:@selector(versusButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[versusButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	
	[mainOptionsView addSubview:versusImageView];	
	[mainOptionsView addSubview:versusButton];	
	[versusGameLabel release];
	[versusImageView release];
	
	
	UIImageView* othersImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	othersImageView.frame = CGRectMake(25, 160, 232, 90);
	
	FontLabel *othersGameLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		othersGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(85, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:23.0f];
	}else{
		othersGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(100, 15, 250, 60) fontName:@"wt005.ttf" pointSize:20.0f];
	}
	[othersGameLabel setText:NSLocalizedString(@"Settings",nil)];
	othersGameLabel.textColor = [UIColor blackColor];
	othersGameLabel.backgroundColor = [UIColor clearColor];
	[othersImageView addSubview:othersGameLabel];
	
	
	UIButton *othersButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[othersButton setFrame: CGRectMake(25, 160, 232, 90)];
	[othersButton addTarget:self action:@selector(othersButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[othersButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	
	[mainOptionsView addSubview:othersImageView];	
	[mainOptionsView addSubview:othersButton];	
	[othersGameLabel release];
	[othersImageView release];
	
	
	self.mainOptionsView = mainOptionsView;
	[mainOptionsView release];
	
	[self.view addSubview:self.mainOptionsView];
}



- (void)initVersusOptions{
	
	UIView *versusOptionsView = [[UIView alloc]initWithFrame:CGRectMake(80, 110, 300, 250)];
	
	UIImageView* gcImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	gcImageView.frame = CGRectMake(25, 0, 232, 90);
	
	FontLabel *gcGameLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		gcGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:23.0f];
	}else{
		gcGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(58, 15, 250, 60) fontName:@"wt005.ttf" pointSize:16.0f];
	}
	[gcGameLabel setText:NSLocalizedString(@"Game Center對戰",nil)];
	gcGameLabel.textColor = [UIColor blackColor];
	gcGameLabel.backgroundColor = [UIColor clearColor];
	[gcImageView addSubview:gcGameLabel];
	
	UIButton *bcButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[bcButton setFrame: CGRectMake(25, 0, 232, 90)];
	[bcButton addTarget:self action:@selector(gameCenterButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[bcButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	
	if (![[Constants sharedInstance] gameCenterEnabled]) {
		[bcButton setEnabled:NO];
		[gcImageView setAlpha:0.5f];
		[bcButton setAlpha:0.5f];
		[gcGameLabel setAlpha:0.5f];
	}
	
	[versusOptionsView addSubview:gcImageView];	
	[versusOptionsView addSubview:bcButton];	
	[gcGameLabel release];
	[gcImageView release];
	
	
	UIImageView* createLocalImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	createLocalImageView.frame = CGRectMake(25, 70, 232, 90);
	
	FontLabel *createLocalGameLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		createLocalGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(60, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:18.0f];
	}else{
		createLocalGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(54, 15, 250, 60) fontName:@"wt005.ttf" pointSize:13.0f];
	}
	[createLocalGameLabel setText:NSLocalizedString(@"開始 Wifi /\n藍芽 對戰",nil)];
	createLocalGameLabel.textColor = [UIColor blackColor];
	createLocalGameLabel.backgroundColor = [UIColor clearColor];
	[createLocalImageView addSubview:createLocalGameLabel];
	UIButton *createGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[createGameButton setFrame: CGRectMake(25, 70, 232, 90)];
	[createGameButton addTarget:self action:@selector(createLocalGameButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[createGameButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	
	[versusOptionsView addSubview:createLocalImageView];	
	[versusOptionsView addSubview:createGameButton];	
	[createLocalGameLabel release];
	[createLocalImageView release];
	
	
	UIImageView* joinLocalImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	joinLocalImageView.frame = CGRectMake(25, 140, 232, 90);
	
	FontLabel *joinLocalGameLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		joinLocalGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(60, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:19.0f];
	}else{
		joinLocalGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(54, 15, 250, 60) fontName:@"wt005.ttf" pointSize:13.0f];
	}
	[joinLocalGameLabel setText:NSLocalizedString(@"加入 Wifi /\n藍芽 對戰",nil)];
	joinLocalGameLabel.textColor = [UIColor blackColor];
	joinLocalGameLabel.backgroundColor = [UIColor clearColor];
	[joinLocalImageView addSubview:joinLocalGameLabel];
	UIButton *joinGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[joinGameButton setFrame: CGRectMake(25, 140, 232, 90)];
	[joinGameButton addTarget:self action:@selector(joinLocalGameButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[joinGameButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	[versusOptionsView addSubview:joinLocalImageView];	
	[versusOptionsView addSubview:joinGameButton];	
	[joinLocalGameLabel release];
	[joinLocalImageView release];
	
	UIImageView* backArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"back_arrow" ofType:@"png"]]];
	backArrowImageView.frame = CGRectMake(-20, 25, 35, 35);
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setFrame: CGRectMake(-20, 25, 35, 35)];
	[backButton addTarget:self action:@selector(backToMainButtonFromVersusClicked) forControlEvents:UIControlEventTouchUpInside];
	[versusOptionsView addSubview:backArrowImageView];	
	[versusOptionsView addSubview:backButton];	
	[backArrowImageView release];
	
	self.versusOptionsView = versusOptionsView;
	[versusOptionsView release];
}


- (void)initSettingsOptions{
	
	UIView *settingOptionsView = [[UIView alloc]initWithFrame:CGRectMake(80, 110, 300, 250)];
	
	UIImageView* menuLanguageImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	menuLanguageImageView.frame = CGRectMake(25, 0, 232, 90);
	FontLabel *languageLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		languageLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:20.0f];
	}else{
		languageLabel = [[FontLabel alloc] initWithFrame:CGRectMake(80, 15, 250, 60) fontName:@"wt005.ttf" pointSize:18.0f];
	}
	[languageLabel setText: NSLocalizedString(@"Menu Language",nil)];
	languageLabel.textColor = [UIColor blackColor];
	languageLabel.backgroundColor = [UIColor clearColor];
	[menuLanguageImageView addSubview:languageLabel];
	
	UIButton *languageButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[languageButton setFrame: CGRectMake(25, 0, 232, 90)];
	[languageButton addTarget:self action:@selector(menuLanguageButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[languageButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	[settingOptionsView addSubview:menuLanguageImageView];	
	[settingOptionsView addSubview:languageButton];	
	[languageLabel release];
	[menuLanguageImageView release];
	
	UIImageView* soundOnOffImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	soundOnOffImageView.frame = CGRectMake(25, 80, 232, 90);
	
	FontLabel *soundOnOffLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		soundOnOffLabel = [[FontLabel alloc] initWithFrame:CGRectMake(80, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:20.0f];
	}else{
		soundOnOffLabel = [[FontLabel alloc] initWithFrame:CGRectMake(80, 15, 250, 60) fontName:@"wt005.ttf" pointSize:18.0f];
	}
	if (![LocalStorageManager boolForKey:SOUNDOFF]){
		[soundOnOffLabel setText: NSLocalizedString(@"Sound Off",nil)];
	}else{
		[soundOnOffLabel setText: NSLocalizedString(@"Sound On",nil)];
	}
	soundOnOffLabel.textColor = [UIColor blackColor];
	soundOnOffLabel.backgroundColor = [UIColor clearColor];
	self.soundOnOffLabel = soundOnOffLabel;
	[soundOnOffImageView addSubview:self.soundOnOffLabel];
	[soundOnOffLabel release];
	
	UIButton *soundOnOffButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[soundOnOffButton setFrame: CGRectMake(25, 80, 232, 90)];
	[soundOnOffButton addTarget:self action:@selector(soundOnOffButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[soundOnOffButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	[settingOptionsView addSubview:soundOnOffImageView];	
	[settingOptionsView addSubview:soundOnOffButton];	
	[soundOnOffLabel release];
	[soundOnOffImageView release];
	
//
	UIImageView* musicOnOffImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	musicOnOffImageView.frame = CGRectMake(25, 150, 232, 90);
	
	FontLabel *musicOnOffLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		musicOnOffLabel = [[FontLabel alloc] initWithFrame:CGRectMake(80, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:20.0f];
	}else{
		musicOnOffLabel = [[FontLabel alloc] initWithFrame:CGRectMake(80, 15, 250, 60) fontName:@"wt005.ttf" pointSize:18.0f];
	}
	if (![LocalStorageManager boolForKey:MUSIC_OFF]){
		[musicOnOffLabel setText: NSLocalizedString(@"Music Off",nil)];
	}else{
		[musicOnOffLabel setText: NSLocalizedString(@"Music On",nil)];
	}
	musicOnOffLabel.textColor = [UIColor blackColor];
	musicOnOffLabel.backgroundColor = [UIColor clearColor];
	self.musicOnOffLabel = musicOnOffLabel;
	[musicOnOffImageView addSubview:self.musicOnOffLabel];
	[musicOnOffLabel release];
	
	UIButton *musicOnOffButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[musicOnOffButton setFrame: CGRectMake(25, 150, 232, 90)];
	[musicOnOffButton addTarget:self action:@selector(musicOnOffButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[musicOnOffButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	[settingOptionsView addSubview:musicOnOffImageView];	
	[settingOptionsView addSubview:musicOnOffButton];	
	[musicOnOffLabel release];
	[musicOnOffImageView release];	
//	
	
	UIImageView* backArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"back_arrow" ofType:@"png"]]];
	backArrowImageView.frame = CGRectMake(-20, 25, 35, 35);
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setFrame: CGRectMake(-20, 25, 50, 50)];
	[backButton addTarget:self action:@selector(backToMainButtonFromSettingsClicked) forControlEvents:UIControlEventTouchUpInside];
	[settingOptionsView addSubview:backArrowImageView];	
	[settingOptionsView addSubview:backButton];	
	[backArrowImageView release];
	
	self.settingOptionsView = settingOptionsView;
	[settingOptionsView release];
}

- (void)initGameCenterOptions{
	
	UIView *gameCenterOptionsView = [[UIView alloc]initWithFrame:CGRectMake(80, 130, 300, 250)];
	
	UIImageView* arcadeModeImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	arcadeModeImageView.frame = CGRectMake(25, 0, 232, 90);
	
	FontLabel *arcadeModeGameLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		arcadeModeGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:23.0f];
	}else{
		arcadeModeGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"wt005.ttf" pointSize:20.0f];
	}
	[arcadeModeGameLabel setText:NSLocalizedString(@"街機模式",nil)];
	arcadeModeGameLabel.textColor = [UIColor blackColor];
	arcadeModeGameLabel.backgroundColor = [UIColor clearColor];
	[arcadeModeImageView addSubview:arcadeModeGameLabel];
	
	UIButton *arcadeModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[arcadeModeButton setFrame: CGRectMake(25, 0, 232, 90)];
	[arcadeModeButton addTarget:self action:@selector(gameCenterArcadeModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[arcadeModeButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	[gameCenterOptionsView addSubview:arcadeModeImageView];	
	[gameCenterOptionsView addSubview:arcadeModeButton];	
	[arcadeModeGameLabel release];
	[arcadeModeImageView release];
	
	
	UIImageView* randomFiveModeImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	randomFiveModeImageView.frame = CGRectMake(25, 70, 232, 90);
	FontLabel *randomFiveModeGameLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		randomFiveModeGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:23.0f];
	}else{
		randomFiveModeGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:23.0f];
	}
	[randomFiveModeGameLabel setText:NSLocalizedString(@"Random 5",nil)];
	randomFiveModeGameLabel.textColor = [UIColor blackColor];
	randomFiveModeGameLabel.backgroundColor = [UIColor clearColor];
	[randomFiveModeImageView addSubview:randomFiveModeGameLabel];
	UIButton *randomFiveModeGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[randomFiveModeGameButton setFrame: CGRectMake(25, 70, 232, 90)];
	[randomFiveModeGameButton addTarget:self action:@selector(gameCenterRandomFiveModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[randomFiveModeGameButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	[gameCenterOptionsView addSubview:randomFiveModeImageView];	
	[gameCenterOptionsView addSubview:randomFiveModeGameButton];	
	[randomFiveModeGameLabel release];
	[randomFiveModeImageView release];	
	
	
	UIImageView* freeSelectImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	freeSelectImageView.frame = CGRectMake(25, 140, 232, 90);
	FontLabel *freeSelectGameLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		freeSelectGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:23.0f];
	}else{
		freeSelectGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"wt005.ttf" pointSize:20.0f];
	}
	[freeSelectGameLabel setText:NSLocalizedString(@"自由選關",nil)];
	freeSelectGameLabel.textColor = [UIColor blackColor];
	freeSelectGameLabel.backgroundColor = [UIColor clearColor];
	[freeSelectImageView addSubview:freeSelectGameLabel];
	UIButton *freeSelectGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[freeSelectGameButton setFrame: CGRectMake(25, 140, 232, 90)];
	[freeSelectGameButton addTarget:self action:@selector(gameCenterFreeSelectModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[freeSelectGameButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	[gameCenterOptionsView addSubview:freeSelectImageView];	
	[gameCenterOptionsView addSubview:freeSelectGameButton];	
	[freeSelectGameLabel release];
	[freeSelectImageView release];
	
	UIImageView* backArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"back_arrow" ofType:@"png"]]];
	backArrowImageView.frame = CGRectMake(-20, 25, 35, 35);
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setFrame: CGRectMake(-15, 20, 50, 50)];
	[backButton addTarget:self action:@selector(backToVersusFromGameCenterButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[gameCenterOptionsView addSubview:backArrowImageView];	
	[gameCenterOptionsView addSubview:backButton];	
	[backArrowImageView release];
	
	self.gameCenterOptionsView = gameCenterOptionsView;
	[gameCenterOptionsView release];
}

- (void)initVersusCreateGameOptions{
	
	UIView *versusCreateGameOptionsView = [[UIView alloc]initWithFrame:CGRectMake(80, 130, 300, 250)];
	
	UIImageView* arcadeModeImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	arcadeModeImageView.frame = CGRectMake(25, 0, 232, 90);
	
	FontLabel *arcadeModeGameLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		arcadeModeGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:23.0f];
	}else{
		arcadeModeGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"wt005.ttf" pointSize:20.0f];
	}
	[arcadeModeGameLabel setText:NSLocalizedString(@"街機模式",nil)];
	arcadeModeGameLabel.textColor = [UIColor blackColor];
	arcadeModeGameLabel.backgroundColor = [UIColor clearColor];
	[arcadeModeImageView addSubview:arcadeModeGameLabel];
	
	UIButton *arcadeModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[arcadeModeButton setFrame: CGRectMake(25, 0, 232, 90)];
	[arcadeModeButton addTarget:self action:@selector(versusCreateGameArcadeModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[arcadeModeButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	[versusCreateGameOptionsView addSubview:arcadeModeImageView];	
	[versusCreateGameOptionsView addSubview:arcadeModeButton];	
	[arcadeModeGameLabel release];
	[arcadeModeImageView release];
	
	
	UIImageView* randomFiveModeImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	randomFiveModeImageView.frame = CGRectMake(25, 70, 232, 90);
	FontLabel *randomFiveModeGameLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		randomFiveModeGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:23.0f];
	}else{
		randomFiveModeGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"wt005.ttf" pointSize:23.0f];
	}
	[randomFiveModeGameLabel setText:NSLocalizedString(@"Random 5",nil)];
	randomFiveModeGameLabel.textColor = [UIColor blackColor];
	randomFiveModeGameLabel.backgroundColor = [UIColor clearColor];
	[randomFiveModeImageView addSubview:randomFiveModeGameLabel];
	UIButton *randomFiveModeGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[randomFiveModeGameButton setFrame: CGRectMake(25, 70, 232, 90)];
	[randomFiveModeGameButton addTarget:self action:@selector(versusCreateGameRandomFiveModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[randomFiveModeGameButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	[versusCreateGameOptionsView addSubview:randomFiveModeImageView];	
	[versusCreateGameOptionsView addSubview:randomFiveModeGameButton];	
	[randomFiveModeGameLabel release];
	[randomFiveModeImageView release];	
	
	
	UIImageView* freeSelectImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	freeSelectImageView.frame = CGRectMake(25, 140, 232, 90);
	FontLabel *freeSelectGameLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		freeSelectGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:23.0f];
	}else{
		freeSelectGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"wt005.ttf" pointSize:20.0f];
	}
	[freeSelectGameLabel setText:NSLocalizedString(@"自由選關",nil)];
	freeSelectGameLabel.textColor = [UIColor blackColor];
	freeSelectGameLabel.backgroundColor = [UIColor clearColor];
	[freeSelectImageView addSubview:freeSelectGameLabel];
	UIButton *freeSelectGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[freeSelectGameButton setFrame: CGRectMake(25, 140, 232, 90)];
	[freeSelectGameButton addTarget:self action:@selector(versusCreateGameFreeSelectModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[freeSelectGameButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	[versusCreateGameOptionsView addSubview:freeSelectImageView];	
	[versusCreateGameOptionsView addSubview:freeSelectGameButton];	
	[freeSelectGameLabel release];
	[freeSelectImageView release];
	
	UIImageView* backArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"back_arrow" ofType:@"png"]]];
	backArrowImageView.frame = CGRectMake(-20, 25, 35, 35);
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setFrame: CGRectMake(-15, 20, 35, 35)];
	[backButton addTarget:self action:@selector(backToVersusFromGameCenterButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[versusCreateGameOptionsView addSubview:backArrowImageView];	
	[versusCreateGameOptionsView addSubview:backButton];	
	[backArrowImageView release];
	
	self.versusCreateGameOptionsView = versusCreateGameOptionsView;
	[versusCreateGameOptionsView release];
}




- (void)initSinglePlayerOptions{
	
	UIView *singlePlayerOptionsView = [[UIView alloc]initWithFrame:CGRectMake(80, 130, 300, 250)];
	
	UIImageView* arcadeModeImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	arcadeModeImageView.frame = CGRectMake(25, 0, 232, 90);
	
	FontLabel *arcadeModeGameLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		arcadeModeGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:23.0f];
	}else{
		arcadeModeGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(80, 15, 250, 60) fontName:@"wt005.ttf" pointSize:18.0f];
	}
	[arcadeModeGameLabel setText:NSLocalizedString(@"街機模式",nil)];
	arcadeModeGameLabel.textColor = [UIColor blackColor];
	arcadeModeGameLabel.backgroundColor = [UIColor clearColor];
	[arcadeModeImageView addSubview:arcadeModeGameLabel];
	
	UIButton *arcadeModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[arcadeModeButton setFrame: CGRectMake(25, 0, 232, 90)];
	[arcadeModeButton addTarget:self action:@selector(arcadeModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[arcadeModeButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	[singlePlayerOptionsView addSubview:arcadeModeImageView];	
	[singlePlayerOptionsView addSubview:arcadeModeButton];	
	[arcadeModeGameLabel release];
	[arcadeModeImageView release];
	
	
	UIImageView* randomFiveModeImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	randomFiveModeImageView.frame = CGRectMake(25, 70, 232, 90);
	FontLabel *randomFiveModeGameLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		randomFiveModeGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:23.0f];
	}else{
		randomFiveModeGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(80, 15, 250, 60) fontName:@"wt005.ttf" pointSize:20.0f];
	}
	[randomFiveModeGameLabel setText:NSLocalizedString(@"Random 5",nil)];
	randomFiveModeGameLabel.textColor = [UIColor blackColor];
	randomFiveModeGameLabel.backgroundColor = [UIColor clearColor];
	[randomFiveModeImageView addSubview:randomFiveModeGameLabel];
	UIButton *randomFiveModeGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[randomFiveModeGameButton setFrame: CGRectMake(25, 70, 232, 90)];
	[randomFiveModeGameButton addTarget:self action:@selector(randomFiveModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[randomFiveModeGameButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	[singlePlayerOptionsView addSubview:randomFiveModeImageView];	
	[singlePlayerOptionsView addSubview:randomFiveModeGameButton];	
	[randomFiveModeGameLabel release];
	[randomFiveModeImageView release];	
	
	
	UIImageView* freeSelectImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	freeSelectImageView.frame = CGRectMake(25, 140, 232, 90);
	FontLabel *freeSelectGameLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		freeSelectGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:23.0f];
	}else{
		freeSelectGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(80, 15, 250, 60) fontName:@"wt005.ttf" pointSize:18.0f];
	}
	[freeSelectGameLabel setText:NSLocalizedString(@"自由選關",nil)];
	freeSelectGameLabel.textColor = [UIColor blackColor];
	freeSelectGameLabel.backgroundColor = [UIColor clearColor];
	[freeSelectImageView addSubview:freeSelectGameLabel];
	UIButton *freeSelectGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[freeSelectGameButton setFrame: CGRectMake(25, 140, 232, 90)];
	[freeSelectGameButton addTarget:self action:@selector(freeSelectModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[freeSelectGameButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	[singlePlayerOptionsView addSubview:freeSelectImageView];	
	[singlePlayerOptionsView addSubview:freeSelectGameButton];	
	[freeSelectGameLabel release];
	[freeSelectImageView release];
	
	UIImageView* backArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"back_arrow" ofType:@"png"]]];
	backArrowImageView.frame = CGRectMake(-20, 25, 35, 35);
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setFrame: CGRectMake(-20, 25, 35, 35)];
	[backButton addTarget:self action:@selector(backToMainButtonFromSinglePlayerClicked) forControlEvents:UIControlEventTouchUpInside];
	[singlePlayerOptionsView addSubview:backArrowImageView];	
	[singlePlayerOptionsView addSubview:backButton];	
	[backArrowImageView release];
	
	self.singlePlayerOptionsView = singlePlayerOptionsView;
	[singlePlayerOptionsView release];
}


- (void)initArcadeModeDifficultyOptions{
	
	UIView *arcadeModeDifficultyView = [[UIView alloc]initWithFrame:CGRectMake(80, 90, 300, 250)];
	
	UIImageView* easyImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	easyImageView.frame = CGRectMake(25, 0, 232, 90);
	
	FontLabel *easyGameLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		easyGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:23.0f];
	}else{
		easyGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(100, 15, 250, 60) fontName:@"wt005.ttf" pointSize:18.0f];
	}
	[easyGameLabel setText:NSLocalizedString(@"好易",nil)];
	easyGameLabel.textColor = [UIColor blackColor];
	easyGameLabel.backgroundColor = [UIColor clearColor];
	[easyImageView addSubview:easyGameLabel];
	
	UIButton *easyButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[easyButton setFrame: CGRectMake(25, 0, 232, 90)];
	[easyButton addTarget:self action:@selector(easyArcadeModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[easyButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	[arcadeModeDifficultyView addSubview:easyImageView];	
	[arcadeModeDifficultyView addSubview:easyButton];	
	[easyGameLabel release];
	[easyImageView release];
	
	
	UIImageView* mediumImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	mediumImageView.frame = CGRectMake(25, 70, 232, 90);
	FontLabel *mediumLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		mediumLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:23.0f];
	}else{
		mediumLabel = [[FontLabel alloc] initWithFrame:CGRectMake(100, 15, 250, 60) fontName:@"wt005.ttf" pointSize:18.0f];
	}
	[mediumLabel setText:NSLocalizedString(@"正常",nil)];
	mediumLabel.textColor = [UIColor blackColor];
	mediumLabel.backgroundColor = [UIColor clearColor];
	[mediumImageView addSubview:mediumLabel];
	UIButton *mediumButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[mediumButton setFrame: CGRectMake(25, 70, 232, 90)];
	[mediumButton addTarget:self action:@selector(normalArcadeModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[mediumButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	[arcadeModeDifficultyView addSubview:mediumImageView];	
	[arcadeModeDifficultyView addSubview:mediumButton];	
	[mediumLabel release];
	[mediumImageView release];
	
	UIImageView* hardImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	hardImageView.frame = CGRectMake(25, 140, 232, 90);
	FontLabel *hardLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		hardLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:23.0f];
	}else{
		hardLabel = [[FontLabel alloc] initWithFrame:CGRectMake(100, 15, 250, 60) fontName:@"wt005.ttf" pointSize:18.0f];
	}
	[hardLabel setText:NSLocalizedString(@"難爆",nil)];
	hardLabel.textColor = [UIColor blackColor];
	hardLabel.backgroundColor = [UIColor clearColor];
	[hardImageView addSubview:hardLabel];
	UIButton *hardButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[hardButton setFrame: CGRectMake(25, 140, 232, 90)];
	[hardButton addTarget:self action:@selector(hardArcadeModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[hardButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	[arcadeModeDifficultyView addSubview:hardImageView];	
	[arcadeModeDifficultyView addSubview:hardButton];	
	[hardLabel release];
	[hardImageView release];
	
	UIImageView* backArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"back_arrow" ofType:@"png"]]];
	backArrowImageView.frame = CGRectMake(-20, 25, 35, 35);
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setFrame: CGRectMake(-20, 25, 35, 35)];
	[backButton addTarget:self action:@selector(backToSinglePlayerFromArcadeDifficultyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[arcadeModeDifficultyView addSubview:backArrowImageView];	
	[arcadeModeDifficultyView addSubview:backButton];	
	[backArrowImageView release];
	
	self.arcadeModeDifficultyView = arcadeModeDifficultyView;
	[arcadeModeDifficultyView release];
}



- (void)initVersusFreeSelectDifficultyOptions{
	
	UIView *versusFreeSelectDifficultyView = [[UIView alloc]initWithFrame:CGRectMake(80, 90, 300, 250)];
	
	UIImageView* easyImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	easyImageView.frame = CGRectMake(25, 0, 232, 90);
	
	FontLabel *easyGameLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		easyGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:23.0f];
	}else{
		easyGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(100, 15, 250, 60) fontName:@"wt005.ttf" pointSize:18.0f];
	}
	[easyGameLabel setText:NSLocalizedString(@"好易",nil)];
	easyGameLabel.textColor = [UIColor blackColor];
	easyGameLabel.backgroundColor = [UIColor clearColor];
	[easyImageView addSubview:easyGameLabel];
	
	UIButton *easyButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[easyButton setFrame: CGRectMake(25, 0, 232, 90)];
	[easyButton addTarget:self action:@selector(easyVersusFreeSelectModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[easyButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	[versusFreeSelectDifficultyView addSubview:easyImageView];	
	[versusFreeSelectDifficultyView addSubview:easyButton];	
	[easyGameLabel release];
	[easyImageView release];
	
	
	UIImageView* mediumImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	mediumImageView.frame = CGRectMake(25, 70, 232, 90);
	FontLabel *mediumLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		mediumLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:23.0f];
	}else{
		mediumLabel = [[FontLabel alloc] initWithFrame:CGRectMake(100, 15, 250, 60) fontName:@"wt005.ttf" pointSize:18.0f];
	}
	[mediumLabel setText:NSLocalizedString(@"正常",nil)];
	mediumLabel.textColor = [UIColor blackColor];
	mediumLabel.backgroundColor = [UIColor clearColor];
	[mediumImageView addSubview:mediumLabel];
	UIButton *mediumButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[mediumButton setFrame: CGRectMake(25, 70, 232, 90)];
	[mediumButton addTarget:self action:@selector(normalVersusFreeSelectModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[mediumButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	[versusFreeSelectDifficultyView addSubview:mediumImageView];	
	[versusFreeSelectDifficultyView addSubview:mediumButton];	
	[mediumLabel release];
	[mediumImageView release];
	
	UIImageView* hardImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	hardImageView.frame = CGRectMake(25, 140, 232, 90);
	FontLabel *hardLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		hardLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:23.0f];
	}else{
		hardLabel = [[FontLabel alloc] initWithFrame:CGRectMake(100, 15, 250, 60) fontName:@"wt005.ttf" pointSize:18.0f];
	}
	[hardLabel setText:NSLocalizedString(@"難爆",nil)];
	hardLabel.textColor = [UIColor blackColor];
	hardLabel.backgroundColor = [UIColor clearColor];
	[hardImageView addSubview:hardLabel];
	UIButton *hardButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[hardButton setFrame: CGRectMake(25, 140, 232, 90)];
	[hardButton addTarget:self action:@selector(hardVersusFreeSelectModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[hardButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	[versusFreeSelectDifficultyView addSubview:hardImageView];	
	[versusFreeSelectDifficultyView addSubview:hardButton];	
	[hardLabel release];
	[hardImageView release];
	
	UIImageView* backArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"back_arrow" ofType:@"png"]]];
	backArrowImageView.frame = CGRectMake(-20, 25, 35, 35);
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setFrame: CGRectMake(-20, 25, 35, 35)];
	[backButton addTarget:self action:@selector(backToVersusFromDifficultyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[versusFreeSelectDifficultyView addSubview:backArrowImageView];	
	[versusFreeSelectDifficultyView addSubview:backButton];	
	[backArrowImageView release];
	
	self.versusFreeSelectDifficultyView = versusFreeSelectDifficultyView;
	[versusFreeSelectDifficultyView release];
}


- (void)initFreeSelectDifficultyOptions{
	
	UIView *freeSelectDifficultyView = [[UIView alloc]initWithFrame:CGRectMake(80, 90, 300, 250)];
	
	UIImageView* easyImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	easyImageView.frame = CGRectMake(25, 0, 232, 90);
	
	FontLabel *easyGameLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		easyGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:23.0f];
	}else{
		easyGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(100, 15, 250, 60) fontName:@"wt005.ttf" pointSize:18.0f];
	}
	[easyGameLabel setText:NSLocalizedString(@"好易",nil)];
	easyGameLabel.textColor = [UIColor blackColor];
	easyGameLabel.backgroundColor = [UIColor clearColor];
	[easyImageView addSubview:easyGameLabel];
	
	UIButton *easyButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[easyButton setFrame: CGRectMake(25, 0, 232, 90)];
	[easyButton addTarget:self action:@selector(freeSelectEasyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[easyButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	[freeSelectDifficultyView addSubview:easyImageView];	
	[freeSelectDifficultyView addSubview:easyButton];	
	[easyGameLabel release];
	[easyImageView release];
	
	
	UIImageView* mediumImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	mediumImageView.frame = CGRectMake(25, 70, 232, 90);
	FontLabel *mediumLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		mediumLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:23.0f];
	}else{
		mediumLabel = [[FontLabel alloc] initWithFrame:CGRectMake(100, 15, 250, 60) fontName:@"wt005.ttf" pointSize:18.0f];
	}
	[mediumLabel setText:NSLocalizedString(@"正常",nil)];
	mediumLabel.textColor = [UIColor blackColor];
	mediumLabel.backgroundColor = [UIColor clearColor];
	[mediumImageView addSubview:mediumLabel];
	UIButton *mediumButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[mediumButton setFrame: CGRectMake(25, 70, 232, 90)];
	[mediumButton addTarget:self action:@selector(freeSelectMediumButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[mediumButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	[freeSelectDifficultyView addSubview:mediumImageView];	
	[freeSelectDifficultyView addSubview:mediumButton];	
	[mediumLabel release];
	[mediumImageView release];
	
	UIImageView* hardImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	hardImageView.frame = CGRectMake(25, 140, 232, 90);
	FontLabel *hardLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		hardLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:23.0f];
	}else{
		hardLabel = [[FontLabel alloc] initWithFrame:CGRectMake(100, 15, 250, 60) fontName:@"wt005.ttf" pointSize:18.0f];
	}
	[hardLabel setText:NSLocalizedString(@"難爆",nil)];
	hardLabel.textColor = [UIColor blackColor];
	hardLabel.backgroundColor = [UIColor clearColor];
	[hardImageView addSubview:hardLabel];
	UIButton *hardButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[hardButton setFrame: CGRectMake(25, 140, 232, 90)];
	[hardButton addTarget:self action:@selector(freeSelectHardButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[hardButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	[freeSelectDifficultyView addSubview:hardImageView];	
	[freeSelectDifficultyView addSubview:hardButton];	
	[hardLabel release];
	[hardImageView release];
	
	
	UIImageView* masterImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	masterImageView.frame = CGRectMake(25, 210, 232, 90);
	FontLabel *masterLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		masterLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:23.0f];
	}else{
		masterLabel = [[FontLabel alloc] initWithFrame:CGRectMake(100, 15, 250, 60) fontName:@"wt005.ttf" pointSize:18.0f];
	}
	[masterLabel setText:NSLocalizedString(@"神級",nil)];
	masterLabel.textColor = [UIColor redColor];
	masterLabel.backgroundColor = [UIColor clearColor];
	[masterImageView addSubview:masterLabel];
	UIButton *masterButton = [UIButton buttonWithType:UIButtonTypeCustom];
	
	// disable upon init
	[masterButton setEnabled:NO];
	[masterImageView setAlpha:0.2f];
	[masterButton setFrame: CGRectMake(25, 210, 232, 90)];
	[masterButton addTarget:self action:@selector(freeSelectMasterButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[masterButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	[freeSelectDifficultyView addSubview:masterImageView];	
	[freeSelectDifficultyView addSubview:masterButton];	
	[masterLabel release];
	[masterImageView release];
	
	
	UIImageView* backArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"back_arrow" ofType:@"png"]]];
	backArrowImageView.frame = CGRectMake(-20, 25, 35, 35);
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setFrame: CGRectMake(-20, 25, 35, 35)];
	[backButton addTarget:self action:@selector(backToSinglePlayerFromFreeSelectDifficultyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[freeSelectDifficultyView addSubview:backArrowImageView];	
	[freeSelectDifficultyView addSubview:backButton];	
	[backArrowImageView release];
	
	self.freeSelectDifficultyView = freeSelectDifficultyView;
	[freeSelectDifficultyView release];
}

- (void)initRandomFiveModeDifficultyOptions{
	
	NSLog(@"initRandomFiveModeDifficultyOptions");
	
	UIView *randomFiveModeDifficultyView = [[UIView alloc]initWithFrame:CGRectMake(80, 90, 300, 250)];
	
	UIImageView* easyImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	easyImageView.frame = CGRectMake(25, 0, 232, 90);
	
	FontLabel *easyGameLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		easyGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:23.0f];
	}else{
		easyGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(100, 15, 250, 60) fontName:@"wt005.ttf" pointSize:18.0f];
	}
	[easyGameLabel setText:NSLocalizedString(@"好易",nil)];
	easyGameLabel.textColor = [UIColor blackColor];
	easyGameLabel.backgroundColor = [UIColor clearColor];
	[easyImageView addSubview:easyGameLabel];
	
	UIButton *easyButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[easyButton setFrame: CGRectMake(25, 0, 232, 90)];
	[easyButton addTarget:self action:@selector(easyRandomFiveModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[easyButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	[randomFiveModeDifficultyView addSubview:easyImageView];	
	[randomFiveModeDifficultyView addSubview:easyButton];	
	[easyGameLabel release];
	[easyImageView release];
	
	
	UIImageView* mediumImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	mediumImageView.frame = CGRectMake(25, 70, 232, 90);
	FontLabel *mediumLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		mediumLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:23.0f];
	}else{
		mediumLabel = [[FontLabel alloc] initWithFrame:CGRectMake(100, 15, 250, 60) fontName:@"wt005.ttf" pointSize:18.0f];
	}
	[mediumLabel setText:NSLocalizedString(@"正常",nil)];
	mediumLabel.textColor = [UIColor blackColor];
	mediumLabel.backgroundColor = [UIColor clearColor];
	[mediumImageView addSubview:mediumLabel];
	UIButton *mediumButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[mediumButton setFrame: CGRectMake(25, 70, 232, 90)];
	[mediumButton addTarget:self action:@selector(normalRandomFiveModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[mediumButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	[randomFiveModeDifficultyView addSubview:mediumImageView];	
	[randomFiveModeDifficultyView addSubview:mediumButton];	
	[mediumLabel release];
	[mediumImageView release];
	
	UIImageView* hardImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	hardImageView.frame = CGRectMake(25, 140, 232, 90);
	FontLabel *hardLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		hardLabel = [[FontLabel alloc] initWithFrame:CGRectMake(70, 15, 250, 60) fontName:@"BADABB.ttf" pointSize:23.0f];
	}else{
		hardLabel = [[FontLabel alloc] initWithFrame:CGRectMake(100, 15, 250, 60) fontName:@"wt005.ttf" pointSize:18.0f];
	}
	[hardLabel setText:NSLocalizedString(@"難爆",nil)];
	hardLabel.textColor = [UIColor blackColor];
	hardLabel.backgroundColor = [UIColor clearColor];
	[hardImageView addSubview:hardLabel];
	UIButton *hardButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[hardButton setFrame: CGRectMake(25, 140, 232, 90)];
	[hardButton addTarget:self action:@selector(hardRandomFiveModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[hardButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	[randomFiveModeDifficultyView addSubview:hardImageView];	
	[randomFiveModeDifficultyView addSubview:hardButton];	
	[hardLabel release];
	[hardImageView release];
	
	UIImageView* backArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"back_arrow" ofType:@"png"]]];
	backArrowImageView.frame = CGRectMake(-20, 25, 35, 35);
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setFrame: CGRectMake(-20, 25, 35, 35)];
	[backButton addTarget:self action:@selector(backToSinglePlayerFromRandomFiveModeDifficultyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[randomFiveModeDifficultyView addSubview:backArrowImageView];	
	[randomFiveModeDifficultyView addSubview:backButton];	
	[backArrowImageView release];
	
	self.randomFiveModeDifficultyView = randomFiveModeDifficultyView;
	[randomFiveModeDifficultyView release];
}


-(void)initVersusFreeSelectBillBoard{
	
	CGRect viewFrame = CGRectMake(0, 120, 320, 440);
	UIView* versusModeLevelSelectPaneView = [[UIView alloc]initWithFrame:viewFrame];
	self.versusModeLevelSelectPaneView = versusModeLevelSelectPaneView;
	[versusModeLevelSelectPaneView release];
	
	UIImageView* backArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"back_arrow" ofType:@"png"]]];
	backArrowImageView.frame = CGRectMake(5, -10, 35, 35);
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setFrame: CGRectMake(5, -10, 50, 50)];
	[backButton addTarget:self action:@selector(backToVersusFromFreeSelectBillBoardButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.versusModeLevelSelectPaneView addSubview:backArrowImageView];	
	[self.versusModeLevelSelectPaneView addSubview:backButton];	
	[backArrowImageView release];
	
	FontLabel *selectGameLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		selectGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(55, -5, 240, 20) fontName:@"BADABB.ttf" pointSize:17.0f];
	}else{
		selectGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(55, -5, 240, 20) fontName:@"wt005.ttf" pointSize:13.0f];
	}
	[selectGameLabel setText:NSLocalizedString(@"Scroll and tap to start versus game:",nil)];
	selectGameLabel.textColor = [UIColor blackColor];
	selectGameLabel.backgroundColor = [UIColor clearColor];
	[self.versusModeLevelSelectPaneView addSubview:selectGameLabel];
	
	
	UIView* backBoard = [[UIView alloc] initWithFrame:CGRectMake(0,80,320,220)];
	backBoard.backgroundColor = [UIColor blackColor];
	[self.versusModeLevelSelectPaneView addSubview:backBoard];
	[backBoard release];
	
}


-(void)initFreeSelectBillBoard{
	
	CGRect viewFrame = CGRectMake(0, 120, 320, 440);
	UIView* levelSelectPaneView = [[UIView alloc]initWithFrame:viewFrame];
	self.levelSelectPaneView = levelSelectPaneView;
	[levelSelectPaneView release];
	
	UIImageView* backArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"back_arrow" ofType:@"png"]]];
	backArrowImageView.frame = CGRectMake(5, -10, 35, 35);
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setFrame: CGRectMake(5, -10, 50, 50)];
	[backButton addTarget:self action:@selector(backToSinglePlayerFromFreeSelectBillBoardButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.levelSelectPaneView addSubview:backArrowImageView];	
	[self.levelSelectPaneView addSubview:backButton];	
	[backArrowImageView release];

	FontLabel *selectGameLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		selectGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(55, -5, 240, 20) fontName:@"BADABB.ttf" pointSize:21.0f];
	}else{
		selectGameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(55, -5, 240, 20) fontName:@"wt005.ttf" pointSize:13.0f];
	}
	[selectGameLabel setText:NSLocalizedString(@"Scroll and tap game to start:",nil)];
	selectGameLabel.textColor = [UIColor blackColor];
	selectGameLabel.backgroundColor = [UIColor clearColor];
	[self.levelSelectPaneView addSubview:selectGameLabel];
	
	
	UIView* backBoard = [[UIView alloc] initWithFrame:CGRectMake(0,80,320,220)];
	backBoard.backgroundColor = [UIColor blackColor];
	[self.levelSelectPaneView addSubview:backBoard];
	[backBoard release];
	
}


-(void)initCommunityOverlay{
	
	UIView *meCommunityOverlayView = [[UIView alloc]initWithFrame:CGRectMake(2, 24, 310, 346)];
	UIImageView* meCommunityImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"community_overlay" ofType:@"png"]]];
	meCommunityImageView.frame = CGRectMake(2, 24, 310, 346);
	[meCommunityOverlayView addSubview:meCommunityImageView];
	
	UIImageView* meCommunityArrowTipImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"community_arrow" ofType:@"png"]]];
	meCommunityArrowTipImageView.frame = CGRectMake(30, 328, 29, 31);
	[meCommunityOverlayView addSubview:meCommunityArrowTipImageView];
	
	
	FontLabel *meCommunityLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		meCommunityLabel = [[FontLabel alloc] initWithFrame:CGRectMake(25, 60, 150, 20) fontName:@"BADABB.ttf" pointSize:22.0f];
	}else{
		meCommunityLabel = [[FontLabel alloc] initWithFrame:CGRectMake(25, 60, 150, 20) fontName:@"wt005.ttf" pointSize:19.0f];
	}
	[meCommunityLabel setText:NSLocalizedString(@"Me",nil)];
	meCommunityLabel.textColor = [UIColor whiteColor];
	meCommunityLabel.backgroundColor = [UIColor clearColor];
	[meCommunityOverlayView addSubview:meCommunityLabel];
	
	UIScrollView *meCommunityScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,80, 280, 230)];
	[meCommunityOverlayView addSubview:meCommunityScrollView];
	meCommunityScrollView.showsVerticalScrollIndicator = YES;
	meCommunityScrollView.showsHorizontalScrollIndicator = NO;
	meCommunityScrollView.contentMode = UIViewContentModeScaleAspectFit;
	meCommunityScrollView.contentSize = CGSizeMake(200, 400);
//	meCommunityScrollView.delaysContentTouches = NO;
	meCommunityScrollView.scrollEnabled = YES;
//	meCommunityScrollView.canCancelContentTouches = NO;
	
	UIView *meCommunityScrollViewContentsView = [[UIView alloc]initWithFrame:CGRectMake(0,80, 280, 500)];
	meCommunityScrollViewContentsView.userInteractionEnabled = YES;
	[meCommunityScrollView addSubview:meCommunityScrollViewContentsView];
	
	if ([LocalStorageManager objectForKey:USER_IMAGE] != nil){
		NSURL *url = [NSURL URLWithString:[LocalStorageManager stringForKey:USER_IMAGE]];
		NSData *data = [NSData dataWithContentsOfURL:url];
		UIImage* userProfileImage =  [[UIImage alloc] initWithData:data];
		UIImageView* localMePhotoImageView = [[UIImageView alloc] initWithImage:userProfileImage];
		localMePhotoImageView.frame = CGRectMake(35, -60, 60, 60);
		self.mePhotoImageView = localMePhotoImageView;
		[meCommunityScrollViewContentsView addSubview:self.mePhotoImageView];
	}else{
		UIImageView* localMePhotoImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"me_logo" ofType:@"png"]]];
		localMePhotoImageView.frame = CGRectMake(35, -60, 60, 60);
		self.mePhotoImageView = localMePhotoImageView;
		[meCommunityScrollViewContentsView addSubview:self.mePhotoImageView];
	}
	
	UITextField *myNameTextFieldLocal  = [[UITextField alloc] initWithFrame:CGRectMake(100, -60, 180, 60)];
	myNameTextFieldLocal.borderStyle = UITextBorderStyleRoundedRect;
	myNameTextFieldLocal.font = [UIFont systemFontOfSize:14.0];
	if ([LocalStorageManager objectForKey:USER_NAME]){
		myNameTextFieldLocal.text = [LocalStorageManager objectForKey:USER_NAME];
	}else{
		myNameTextFieldLocal.placeholder = NSLocalizedString(@"<輸入稱呼>",nil);
	}
	myNameTextFieldLocal.backgroundColor = [UIColor clearColor];
	myNameTextFieldLocal.textColor = [UIColor blackColor];
	myNameTextFieldLocal.autocorrectionType = UITextAutocorrectionTypeNo;
	myNameTextFieldLocal.keyboardType = UIKeyboardTypeDefault;
	myNameTextFieldLocal.returnKeyType = UIReturnKeyDone;
	myNameTextFieldLocal.clearButtonMode = UITextFieldViewModeWhileEditing;
	myNameTextFieldLocal.delegate = self;
	myNameTextFieldLocal.userInteractionEnabled = YES;
	self.myNameTextField = myNameTextFieldLocal;
	[meCommunityScrollViewContentsView addSubview:self.myNameTextField];
	[meCommunityScrollViewContentsView bringSubviewToFront:self.myNameTextField];
	[myNameTextFieldLocal release];
	

	FontLabel *loginByFacebookLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		loginByFacebookLabel = [[FontLabel alloc] initWithFrame:CGRectMake(35, -5, 250, 40) fontName:@"BADABB.ttf" pointSize:13.0f];
	}else{
		loginByFacebookLabel = [[FontLabel alloc] initWithFrame:CGRectMake(35, -5, 250, 40) fontName:@"wt005.ttf" pointSize:13.0f];
	}
	[loginByFacebookLabel setText:NSLocalizedString(@"Connect to:",nil)];
	loginByFacebookLabel.textColor = [UIColor whiteColor];
	loginByFacebookLabel.backgroundColor = [UIColor clearColor];
	loginByFacebookLabel.numberOfLines = 2;
	[meCommunityScrollViewContentsView addSubview:loginByFacebookLabel];
	
	UIImageView* loginToFacebookImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"facebook_logo_small" ofType:@"png"]]];
	loginToFacebookImageView.frame = CGRectMake(120, 10, 40, 40);
	[meCommunityScrollViewContentsView addSubview:loginToFacebookImageView];
	UIButton *loginToFacebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[loginToFacebookButton setBackgroundImage:[UIImage imageNamed:@"logo_pressed.png"] forState:UIControlStateHighlighted];
	[loginToFacebookButton setFrame: CGRectMake(120, 10, 40, 40)];
	[loginToFacebookButton addTarget:self action:@selector(loginToFacebookButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[meCommunityScrollViewContentsView addSubview:loginToFacebookButton];	
	
	UIImageView* loginToTwitterImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"twitter_logo_small" ofType:@"png"]]];
	loginToTwitterImageView.frame = CGRectMake(170, 10, 40, 40);
	[meCommunityScrollViewContentsView addSubview:loginToTwitterImageView];
	UIButton *loginToTwitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[loginToTwitterButton setBackgroundImage:[UIImage imageNamed:@"logo_pressed.png"] forState:UIControlStateHighlighted];
	[loginToTwitterButton setFrame: CGRectMake(170, 10, 40, 40)];
	[loginToTwitterButton addTarget:self action:@selector(loginToTwitterButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[meCommunityScrollViewContentsView addSubview:loginToTwitterButton];	
	
	UIImageView* loginToSinaImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sina_logo_small" ofType:@"png"]]];
	loginToSinaImageView.frame = CGRectMake(220, 10, 40, 40);
	[meCommunityScrollViewContentsView addSubview:loginToSinaImageView];
	UIButton *loginToSinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[loginToSinaButton setBackgroundImage:[UIImage imageNamed:@"logo_pressed.png"] forState:UIControlStateHighlighted];
	[loginToSinaButton setFrame: CGRectMake(220, 10, 40, 40)];
	[loginToSinaButton addTarget:self action:@selector(loginToSinaButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[meCommunityScrollViewContentsView addSubview:loginToSinaButton];	
	
	UIImageView* whiteLineImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"white_line" ofType:@"png"]]];
	whiteLineImageView.frame = CGRectMake(-30, 50, 255, 20);
	whiteLineImageView.alpha = 0.5;
	[meCommunityScrollViewContentsView addSubview:whiteLineImageView];
	
	UIImageView* stampsCollectionImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"stamps_library_logo" ofType:@"png"]]];
	stampsCollectionImageView.frame = CGRectMake(55, 70, 60, 60);
	[meCommunityScrollViewContentsView addSubview:stampsCollectionImageView];
	UIButton *stampsCollectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[stampsCollectionButton setBackgroundImage:[UIImage imageNamed:@"logo_pressed.png"] forState:UIControlStateHighlighted];
	[stampsCollectionButton setFrame: CGRectMake(55, 70, 60, 60)];
	[stampsCollectionButton addTarget:self action:@selector(stampsCollectionButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[meCommunityScrollViewContentsView addSubview:stampsCollectionButton];	
	FontLabel *stampsCollectionLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		stampsCollectionLabel = [[FontLabel alloc] initWithFrame:CGRectMake(40, 135, 150, 20) fontName:@"BADABB.ttf" pointSize:14.0f];
	}else{
		stampsCollectionLabel = [[FontLabel alloc] initWithFrame:CGRectMake(55, 135, 150, 20) fontName:@"wt005.ttf" pointSize:14.0f];
	}
	[stampsCollectionLabel setText:NSLocalizedString(@"Stamps Collection",nil)];
	stampsCollectionLabel.textColor = [UIColor whiteColor];
	stampsCollectionLabel.backgroundColor = [UIColor clearColor];
	[meCommunityScrollViewContentsView addSubview:stampsCollectionLabel];
	
	
	UIImageView* countrySelectImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"country_logo" ofType:@"png"]]];
	countrySelectImageView.frame = CGRectMake(195, 70, 60, 60);
	[meCommunityScrollViewContentsView addSubview:countrySelectImageView];
	UIButton *countrySelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[countrySelectButton setBackgroundImage:[UIImage imageNamed:@"logo_pressed.png"] forState:UIControlStateHighlighted];
	[countrySelectButton setFrame: CGRectMake(195, 70, 60, 60)];
	[countrySelectButton addTarget:self action:@selector(countrySelectButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[meCommunityScrollViewContentsView addSubview:countrySelectButton];	
	FontLabel *countrySelectLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		countrySelectLabel = [[FontLabel alloc] initWithFrame:CGRectMake(200, 135, 160, 20) fontName:@"BADABB.ttf" pointSize:16.0f];
	}else{
		countrySelectLabel = [[FontLabel alloc] initWithFrame:CGRectMake(190, 135, 160, 20) fontName:@"wt005.ttf" pointSize:14.0f];
	}
	[countrySelectLabel setText:NSLocalizedString(@"國家/地區",nil)];
	countrySelectLabel.textColor = [UIColor whiteColor];
	countrySelectLabel.backgroundColor = [UIColor clearColor];
	[meCommunityScrollViewContentsView addSubview:countrySelectLabel];
	
	UIImageView* inGameCameraImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"in_game_camera_logo" ofType:@"png"]]];
	inGameCameraImageView.frame = CGRectMake(55, 180, 60, 60);
	[meCommunityScrollViewContentsView addSubview:inGameCameraImageView];
	UIButton *inGameCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[inGameCameraButton setBackgroundImage:[UIImage imageNamed:@"logo_pressed.png"] forState:UIControlStateHighlighted];
	[inGameCameraButton setFrame: CGRectMake(55, 180, 60, 60)];
	[inGameCameraButton addTarget:self action:@selector(inGameCameraButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[meCommunityScrollViewContentsView addSubview:inGameCameraButton];	
	FontLabel *inGameCameraLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		inGameCameraLabel = [[FontLabel alloc] initWithFrame:CGRectMake(40, 245, 150, 20) fontName:@"BADABB.ttf" pointSize:14.0f];
	}else{
		inGameCameraLabel = [[FontLabel alloc] initWithFrame:CGRectMake(55, 245, 150, 20) fontName:@"wt005.ttf" pointSize:12.0f];
	}
	[inGameCameraLabel setText:NSLocalizedString(@"Customize Game",nil)];
	inGameCameraLabel.textColor = [UIColor whiteColor];
	inGameCameraLabel.backgroundColor = [UIColor clearColor];
	[meCommunityScrollViewContentsView addSubview:inGameCameraLabel];	
	//
	self.meCommunityScrollViewContentsView = meCommunityScrollViewContentsView;
	self.meCommunityOverlayView = meCommunityOverlayView;
	[meCommunityOverlayView release];
	
	//
	NSLog(@"initCommunityOverlay");
	UIView *communityCommunityOverlayView = [[UIView alloc]initWithFrame:CGRectMake(2, 24, 310, 346)];
	UIImageView* communityCommunityImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"community_overlay" ofType:@"png"]]];
	communityCommunityImageView.frame = CGRectMake(2, 24, 310, 346);
	[communityCommunityOverlayView addSubview:communityCommunityImageView];
	
	UIImageView* communityArrowTipImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"community_arrow" ofType:@"png"]]];
	communityArrowTipImageView.frame = CGRectMake(145, 328, 29, 31);
	[communityCommunityOverlayView addSubview:communityArrowTipImageView];
	
	
	
	FontLabel *communityCommunityLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		communityCommunityLabel = [[FontLabel alloc] initWithFrame:CGRectMake(25, 60, 150, 20) fontName:@"BADABB.ttf" pointSize:22.0f];
	}else{
		communityCommunityLabel = [[FontLabel alloc] initWithFrame:CGRectMake(25, 60, 150, 20) fontName:@"wt005.ttf" pointSize:20.0f];
	}
	[communityCommunityLabel setText:NSLocalizedString(@"Community",nil)];
	communityCommunityLabel.textColor = [UIColor whiteColor];
	communityCommunityLabel.backgroundColor = [UIColor clearColor];
	[communityCommunityOverlayView addSubview:communityCommunityLabel];
	
	UIScrollView *communityCommunityScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 90, 280, 220)];
	[communityCommunityOverlayView addSubview:communityCommunityScrollView];	
	communityCommunityScrollView.showsVerticalScrollIndicator = YES;
	communityCommunityScrollView.showsHorizontalScrollIndicator = NO;
	communityCommunityScrollView.contentMode = UIViewContentModeScaleAspectFit;
	communityCommunityScrollView.contentSize = CGSizeMake(200, 380);
	
	UIView *communityCommunityScrollViewContentsView = [[UIView alloc]initWithFrame:CGRectMake(0,80, 280, 500)];
	[communityCommunityScrollView addSubview:communityCommunityScrollViewContentsView];

	UIImageView* bashersWorldwideImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"globe_icon" ofType:@"png"]]];
	bashersWorldwideImageView.frame = CGRectMake(55, -40, 60, 60);
	[communityCommunityScrollViewContentsView addSubview:bashersWorldwideImageView];
	UIButton *bashersWorldwideButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[bashersWorldwideButton setBackgroundImage:[UIImage imageNamed:@"logo_pressed.png"] forState:UIControlStateHighlighted];
	[bashersWorldwideButton setFrame: CGRectMake(55, -40, 60, 60)];
	[bashersWorldwideButton addTarget:self action:@selector(bashersWorldwideButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[communityCommunityScrollViewContentsView addSubview:bashersWorldwideButton];	
	FontLabel *bashersWorldwideLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		bashersWorldwideLabel = [[FontLabel alloc] initWithFrame:CGRectMake(35, 25, 150, 20) fontName:@"BADABB.ttf" pointSize:16.0f];
	}else{
		bashersWorldwideLabel = [[FontLabel alloc] initWithFrame:CGRectMake(35, 25, 150, 20) fontName:@"wt005.ttf" pointSize:14.0f];
	}
	[bashersWorldwideLabel setText:NSLocalizedString(@"Bashers Worldwide",nil)];
	bashersWorldwideLabel.textColor = [UIColor whiteColor];
	bashersWorldwideLabel.backgroundColor = [UIColor clearColor];
	[communityCommunityScrollViewContentsView addSubview:bashersWorldwideLabel];
	
	UIImageView* coolReplaysImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"youtube_logo" ofType:@"png"]]];
	coolReplaysImageView.frame = CGRectMake(195, -40, 60, 60);
	[communityCommunityScrollViewContentsView addSubview:coolReplaysImageView];
	UIButton *coolReplaysButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[coolReplaysButton setBackgroundImage:[UIImage imageNamed:@"logo_pressed.png"] forState:UIControlStateHighlighted];
	[coolReplaysButton setFrame: CGRectMake(195, -40, 60, 60)];
	[coolReplaysButton addTarget:self action:@selector(coolReplaysButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[communityCommunityScrollViewContentsView addSubview:coolReplaysButton];	
	FontLabel *coolReplaysLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		coolReplaysLabel = [[FontLabel alloc] initWithFrame:CGRectMake(190, 25, 150, 20) fontName:@"BADABB.ttf" pointSize:16.0f];
	}else{
		coolReplaysLabel = [[FontLabel alloc] initWithFrame:CGRectMake(190, 25, 150, 20) fontName:@"wt005.ttf" pointSize:14.0f];
	}
	[coolReplaysLabel setText:NSLocalizedString(@"Cool Replays",nil)];
	coolReplaysLabel.textColor = [UIColor whiteColor];
	coolReplaysLabel.backgroundColor = [UIColor clearColor];
	[communityCommunityScrollViewContentsView addSubview:coolReplaysLabel];
	
	UIImageView* leaderBoardImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"leaderboard_logo" ofType:@"png"]]];
	leaderBoardImageView.frame = CGRectMake(55, 80, 60, 60);
	[communityCommunityScrollViewContentsView addSubview:leaderBoardImageView];
	UIButton *leaderBoardButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[leaderBoardButton setBackgroundImage:[UIImage imageNamed:@"logo_pressed.png"] forState:UIControlStateHighlighted];
	[leaderBoardButton setFrame: CGRectMake(55, 80, 60, 60)];
	[leaderBoardButton addTarget:self action:@selector(leaderBoardButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[communityCommunityScrollViewContentsView addSubview:leaderBoardButton];	
	FontLabel *leaderBoardLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		leaderBoardLabel = [[FontLabel alloc] initWithFrame:CGRectMake(50, 145, 150, 20) fontName:@"BADABB.ttf" pointSize:16.0f];
	}else{
		leaderBoardLabel = [[FontLabel alloc] initWithFrame:CGRectMake(60, 145, 150, 20) fontName:@"wt005.ttf" pointSize:14.0f];
	}
	[leaderBoardLabel setText:NSLocalizedString(@"Leaderboard",nil)];
	leaderBoardLabel.textColor = [UIColor whiteColor];
	leaderBoardLabel.backgroundColor = [UIColor clearColor];
	[communityCommunityScrollViewContentsView addSubview:leaderBoardLabel];
	
	
	UIImageView* localGCLeaderBoardImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"gc_logo" ofType:@"png"]]];
	localGCLeaderBoardImageView.frame = CGRectMake(195, 80, 60, 60);
	UIButton *localGCLeaderBoardButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[localGCLeaderBoardButton setBackgroundImage:[UIImage imageNamed:@"logo_pressed.png"] forState:UIControlStateHighlighted];
	[localGCLeaderBoardButton setFrame: CGRectMake(195, 80, 60, 60)];
	[localGCLeaderBoardButton addTarget:self action:@selector(gcLeaderBoardButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	FontLabel *gcLeaderBoardLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		gcLeaderBoardLabel = [[FontLabel alloc] initWithFrame:CGRectMake(180, 145, 150, 20) fontName:@"BADABB.ttf" pointSize:16.0f];
	}else{
		gcLeaderBoardLabel = [[FontLabel alloc] initWithFrame:CGRectMake(200, 145, 150, 20) fontName:@"wt005.ttf" pointSize:14.0f];
	}
	[gcLeaderBoardLabel setText:NSLocalizedString(@"GC Leaderboard",nil)];
	gcLeaderBoardLabel.textColor = [UIColor whiteColor];
	gcLeaderBoardLabel.backgroundColor = [UIColor clearColor];
	[communityCommunityScrollViewContentsView addSubview:gcLeaderBoardLabel];
	if (![[Constants sharedInstance] gameCenterEnabled]) {
		[localGCLeaderBoardButton setEnabled:NO];
		[localGCLeaderBoardImageView setAlpha:0.5f];
	}
	self.gcLeaderBoardImageView = localGCLeaderBoardImageView;
	self.gcLeaderBoardButton = localGCLeaderBoardButton;
	[communityCommunityScrollViewContentsView addSubview:self.gcLeaderBoardImageView];
	[communityCommunityScrollViewContentsView addSubview:self.gcLeaderBoardButton];	
	[localGCLeaderBoardImageView release];
	[localGCLeaderBoardButton release];
	
	UIImageView* facebookGroupImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"facebook_logo" ofType:@"png"]]];
	facebookGroupImageView.frame = CGRectMake(55, 200, 60, 60);
	[communityCommunityScrollViewContentsView addSubview:facebookGroupImageView];
	UIButton *facebookGroupButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[facebookGroupButton setBackgroundImage:[UIImage imageNamed:@"logo_pressed.png"] forState:UIControlStateHighlighted];
	[facebookGroupButton setFrame: CGRectMake(55, 200, 60, 60)];
	[facebookGroupButton addTarget:self action:@selector(facebookGroupButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[communityCommunityScrollViewContentsView addSubview:facebookGroupButton];	
	FontLabel *facebookGroupLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		facebookGroupLabel = [[FontLabel alloc] initWithFrame:CGRectMake(40, 270, 150, 20) fontName:@"BADABB.ttf" pointSize:16.0f];
	}else{
		facebookGroupLabel = [[FontLabel alloc] initWithFrame:CGRectMake(40, 270, 150, 20) fontName:@"wt005.ttf" pointSize:14.0f];
	}
	[facebookGroupLabel setText:NSLocalizedString(@"Facebook Group",nil)];
	facebookGroupLabel.textColor = [UIColor whiteColor];
	facebookGroupLabel.backgroundColor = [UIColor clearColor];
	[communityCommunityScrollViewContentsView addSubview:facebookGroupLabel];
	
	[communityCommunityScrollView release];
	self.communityCommunityOverlayView = communityCommunityOverlayView;
	[communityCommunityOverlayView release];
	
	

	
}



-(void)initNewsOverlay{
	
	UIView *newsCommunityOverlayView = [[UIView alloc]initWithFrame:CGRectMake(2, 24, 310, 346)];
	UIImageView* newsCommunityImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"community_overlay" ofType:@"png"]]];
	newsCommunityImageView.frame = CGRectMake(2, 24, 310, 346);
	[newsCommunityOverlayView addSubview:newsCommunityImageView];
	
	
	UIImageView* newsCommunityArrowTipImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"community_arrow" ofType:@"png"]]];
	newsCommunityArrowTipImageView.frame = CGRectMake(250, 328, 29, 31);
	[newsCommunityOverlayView addSubview:newsCommunityArrowTipImageView];
	
	
	FontLabel *newsCommunityLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		newsCommunityLabel = [[FontLabel alloc] initWithFrame:CGRectMake(25, 60, 150, 20) fontName:@"BADABB.ttf" pointSize:22.0f];
	}else{
		newsCommunityLabel = [[FontLabel alloc] initWithFrame:CGRectMake(25, 60, 150, 20) fontName:@"wt005.ttf" pointSize:22.0f];
	}
	[newsCommunityLabel setText:NSLocalizedString(@"News",nil)];
	newsCommunityLabel.textColor = [UIColor whiteColor];
	newsCommunityLabel.backgroundColor = [UIColor clearColor];
	[newsCommunityOverlayView addSubview:newsCommunityLabel];
	
	self.newsCommunityOverlayView = newsCommunityOverlayView;
	[newsCommunityOverlayView release];	
	
	GetMsg* msgGetter = [[GetMsg alloc] initWithDelegate:self];
	self.msgGetter = msgGetter;
	[msgGetter release];
	
	NSString *twitterUserName = [LocalStorageManager objectForKey:TWITTER_USER];
	if (twitterUserName != nil)	{
		[self.msgGetter addKey:@"twscreenname" AndVal:twitterUserName];
	}
	
	[self.msgGetter addKey:@"lang" AndVal:[[Constants sharedInstance] language]];
	
	// for posting scores with game centere player id
	if ([[Constants sharedInstance] gameCenterEnabled]){
		[self.msgGetter  addKey:@"gcid" AndVal:[[GKLocalPlayer localPlayer] playerID]];
	}
	[self.msgGetter sendReq];
	
	
	
	UITableView* newsTableView = [[UITableView alloc] initWithFrame:CGRectMake(25, 100, 260, 210) style:UITableViewStylePlain];
	newsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	newsTableView.backgroundColor = [UIColor clearColor];
	self.newsTableView = newsTableView;
	[newsTableView release];
	self.newsTableView.delegate = self;
	self.newsTableView.dataSource = self;
	[self.newsTableView setRowHeight:100];
	[self.newsCommunityOverlayView addSubview:self.newsTableView];
	
	
}	


#pragma mark -
#pragma mark News Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.msgs count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	else {
		for (UIView* view in cell.contentView.subviews)
			[view removeFromSuperview];
	}
	cell.backgroundView = [[[UIImageView alloc] init] autorelease];
	cell.selectedBackgroundView = [[[UIImageView alloc] init] autorelease];
	
	if ([self.msgs count] > indexPath.row){
		[((Msg*)[self.msgs objectAtIndex:indexPath.row]) initInterfaceWithWidth:(float)(320.0)];
		[cell.contentView addSubview: [self.msgs objectAtIndex:indexPath.row]];
	}
    
	UIImage *rowBackground;
	UIImage *selectionBackground;
	NSInteger row = [indexPath row];
	NSInteger sectionRows = [tableView numberOfRowsInSection:[indexPath section]];
	
	
	if (row == 0 && row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"topAndBottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"topAndBottomRowSelected.png"];
	}
	else if (row == 0)
	{
		rowBackground = [UIImage imageNamed:@"topRow.png"];
		selectionBackground = [UIImage imageNamed:@"topRowSelected.png"];
	}
	else if (row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"bottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"bottomRowSelected.png"];
	}
	else
	{
		rowBackground = [UIImage imageNamed:@"middleRow.png"];
		selectionBackground = [UIImage imageNamed:@"middleRowSelected.png"];
	}
	((UIImageView *)cell.backgroundView).image = rowBackground;
	
	NSLog(@"cell.selectedBackgroundView : %@", cell.selectedBackgroundView);
	NSLog(@"cell.sectionRows : %i", sectionRows);
	
//	((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;
//	NSLog(@"rowBackground : %@", rowBackground);
	
    return cell;
}


#pragma mark -
#pragma mark GetMsgDelegate	
- (void)finished:(NSMutableArray*) msgs;
{
	self.msgs = msgs;
	[self.newsTableView reloadData];
	
}


#pragma mark -
#pragma mark Button Clicked methods

- (void)meButtonClicked{
	[self.sharedSoundEffectsManager playElectricBeepSound];
	
	CATransition* trans = [CATransition animation];
	[trans setType:kCATransitionFade];
	[trans setDuration:0.2];
	
	if ((showingOverlay == NO) && (showingMeOverlay == NO)){
		[self.view addSubview:self.meCommunityOverlayView];
		
		showingOverlay = YES;
		showingCommunityOverlay = NO;
		showingNewsOverlay = NO;
		showingMeOverlay = YES;
		
	}else if ((showingOverlay == YES) && (showingMeOverlay == NO)){
		[self.meCommunityOverlayView removeFromSuperview];
		[self.communityCommunityOverlayView removeFromSuperview];
		[self.newsCommunityOverlayView removeFromSuperview];
		[self.view addSubview:self.meCommunityOverlayView];
		showingOverlay = YES;
		showingCommunityOverlay = NO;
		showingNewsOverlay = NO;
		showingMeOverlay = YES;
		
	}else if ((showingOverlay == YES) && (showingMeOverlay == YES)){
		[self.meCommunityOverlayView removeFromSuperview];
		[self.communityCommunityOverlayView removeFromSuperview];
		[self.newsCommunityOverlayView removeFromSuperview];
		showingOverlay = NO;
		showingCommunityOverlay = NO;
		showingNewsOverlay = NO;
		showingMeOverlay = NO;
	}
	
	CALayer *layer = self.view.layer;
	[layer addAnimation:trans forKey:@"Transition"];
	
}

- (void)communityButtonClicked{
	[self.sharedSoundEffectsManager playElectricBeepSound];
	
	CATransition* trans = [CATransition animation];
	[trans setType:kCATransitionFade];
	[trans setDuration:0.2];
	
	if ((showingOverlay == NO) && (showingCommunityOverlay == NO)){
		[self.view addSubview:self.communityCommunityOverlayView];		
		[self.view bringSubviewToFront:self.communityCommunityOverlayView];
		showingOverlay = YES;
		showingCommunityOverlay = YES;
		showingNewsOverlay = NO;
		showingMeOverlay = NO;
		
	}else if ((showingOverlay == YES) && (showingCommunityOverlay == NO)){
		[self.meCommunityOverlayView removeFromSuperview];
		[self.communityCommunityOverlayView removeFromSuperview];
		[self.newsCommunityOverlayView removeFromSuperview];
		[self.view addSubview:self.communityCommunityOverlayView];		
		[self.view bringSubviewToFront:self.communityCommunityOverlayView];
		showingOverlay = YES;
		showingCommunityOverlay = YES;
		showingNewsOverlay = NO;
		showingMeOverlay = NO;
		
	}else if ((showingOverlay == YES) && (showingCommunityOverlay == YES)){
		[self.meCommunityOverlayView removeFromSuperview];
		[self.communityCommunityOverlayView removeFromSuperview];
		[self.newsCommunityOverlayView removeFromSuperview];
		showingOverlay = NO;
		showingCommunityOverlay = NO;
		showingNewsOverlay = NO;
		showingMeOverlay = NO;
	}	
	CALayer *layer = self.view.layer;
	[layer addAnimation:trans forKey:@"Transition"];
}

- (void)newsButtonClicked{
	[self.sharedSoundEffectsManager playElectricBeepSound];
	
	CATransition* trans = [CATransition animation];
	[trans setType:kCATransitionFade];
	[trans setDuration:0.2];
	
	if ((showingOverlay == NO) && (showingNewsOverlay == NO)){
		[self.view addSubview:self.newsCommunityOverlayView];
		showingOverlay = YES;
		showingCommunityOverlay = NO;
		showingNewsOverlay = YES;
		showingMeOverlay = NO;
		
	}else if ((showingOverlay == YES) && (showingNewsOverlay == NO)){
		[self.meCommunityOverlayView removeFromSuperview];
		[self.communityCommunityOverlayView removeFromSuperview];
		[self.newsCommunityOverlayView removeFromSuperview];
		[self.view addSubview:self.newsCommunityOverlayView];
		showingOverlay = YES;
		showingCommunityOverlay = NO;
		showingNewsOverlay = YES;
		showingMeOverlay = NO;
		
	}else if ((showingOverlay == YES) && (showingNewsOverlay == YES)){
		[self.meCommunityOverlayView removeFromSuperview];
		[self.communityCommunityOverlayView removeFromSuperview];
		[self.newsCommunityOverlayView removeFromSuperview];
		showingOverlay = NO;
		showingCommunityOverlay = NO;
		showingNewsOverlay = NO;
		showingMeOverlay = NO;
	}	
	CALayer *layer = self.view.layer;
	[layer addAnimation:trans forKey:@"Transition"];
}

- (void)stampsCollectionButtonClicked{
	[self.sharedSoundEffectsManager playElectricBeepSound];
	self.title = NSLocalizedString(@"目錄",nil);
	StampCollectionViewController* theConfigView = [[StampCollectionViewController alloc]init];
	[self.navigationController pushViewController:theConfigView animated:YES];	
	[theConfigView release];
	
}

- (void)facebookGroupButtonClicked{
	[self.sharedSoundEffectsManager playElectricBeepSound];
	NSURL *url = [[NSURL alloc] initWithString:@"http://www.facebook.com/pages/Hong-Kong/Red-Soldier/104123529642835"];
	[[UIApplication sharedApplication]openURL:url];
	[url release];
}

- (void)freeSelectClicked:(NSInteger)difficultyLevel{
	[self.sharedSoundEffectsManager playElectricBeepSound];
	
	if ((self.billBoard != nil)){
		NSLog(@"freeSelectClicked self.billBoad not empty, erleasing");
		[self.billBoard removeFromSuperview];
		[self.billBoard.scrollView removeFromSuperview];
		[self.levelSelectPaneView removeFromSuperview];
	}
	if (self.multiPlayerBillBoard != nil){
		[self.multiPlayerBillBoard removeFromSuperview];
		[self.multiPlayerBillBoard.scrollView removeFromSuperview];
	}
	
	BillBoard* board = [[BillBoard alloc] initWithPosterSize:CGSizeMake(160,200) andPosters:[[Constants sharedInstance] gameScreensArray] andOwner:self andGameLevel:difficultyLevel andGameMode:kSingle];
	self.billBoard = board;
	[board release];
	[self.levelSelectPaneView addSubview:self.billBoard.scrollView];
	[self.levelSelectPaneView addSubview:self.billBoard];
	self.billBoard.theInner.gameLevel = difficultyLevel;
	[self.billBoard reload];
	[self.billBoard startTimer];

	
	CATransition* trans = [CATransition animation];
	[trans setType:kCATransitionPush];
	[trans setSubtype:kCATransitionFromRight];
	[trans setDuration:0.4];
	
	[self.communityMenuView removeFromSuperview];
	[self.freeSelectDifficultyView removeFromSuperview];
	[self.view addSubview:self.levelSelectPaneView];
	
	
	CALayer *layer = self.view.layer;
	[layer addAnimation:trans forKey:@"Transition"];
	
}

- (void)freeSelectVersusModeClicked:(NSInteger)difficultyLevel{
	[self.sharedSoundEffectsManager playElectricBeepSound];
	if ((self.billBoard != nil)){
		NSLog(@"freeSelectClicked self.billBoad not empty, erleasing");
		[self.billBoard removeFromSuperview];
		[self.billBoard.scrollView removeFromSuperview];
		[self.levelSelectPaneView removeFromSuperview];
	}
	if (self.multiPlayerBillBoard != nil){
		[self.multiPlayerBillBoard removeFromSuperview];
		[self.multiPlayerBillBoard.scrollView removeFromSuperview];
	}
	
	BillBoard* board = [[BillBoard alloc] initWithPosterSize:CGSizeMake(160,200) andPosters:[[Constants sharedInstance] gameScreensArray] andOwner:self andGameLevel:difficultyLevel andGameMode:kSingle];
	self.multiPlayerBillBoard = board;
	[board release];
	[self.versusModeLevelSelectPaneView addSubview:self.multiPlayerBillBoard.scrollView];
	[self.versusModeLevelSelectPaneView addSubview:self.multiPlayerBillBoard];
	self.multiPlayerBillBoard.theInner.gameLevel = difficultyLevel;
	[self.multiPlayerBillBoard reload];
	[self.multiPlayerBillBoard startTimer];
	
	
	CATransition* trans = [CATransition animation];
	[trans setType:kCATransitionPush];
	[trans setSubtype:kCATransitionFromRight];
	[trans setDuration:0.4];
	
	[self.communityMenuView removeFromSuperview];
	[self.versusFreeSelectDifficultyView removeFromSuperview];
	[self.view addSubview:self.versusModeLevelSelectPaneView];
	
	
	CALayer *layer = self.view.layer;
	[layer addAnimation:trans forKey:@"Transition"];
	
}


- (void) gcLeaderBoardButtonClicked{
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

- (void) inGameCameraButtonClicked{
	[self.sharedSoundEffectsManager playElectricBeepSound];
	self.title = NSLocalizedString(@"目錄",nil);
	ImageSettingsViewController* imageSettingsVC = [[ImageSettingsViewController alloc] init];
	//imageSettingsVC.delegate = self;
	[self.navigationController pushViewController:imageSettingsVC animated:YES];
	[imageSettingsVC release];
	
}

- (void) countrySelectButtonClicked{
	[self.sharedSoundEffectsManager playElectricBeepSound];
	self.title = NSLocalizedString(@"目錄",nil);
	CountryTableViewController* countryTableViewController = [[CountryTableViewController alloc]init];
	countryTableViewController.delegate = self;
	[self.navigationController pushViewController:countryTableViewController animated:YES];
	[countryTableViewController release];
	
}

- (void) loginToSinaButtonClicked{
	[self.sharedSoundEffectsManager playElectricBeepSound];
	SinaConfigViewController* sinaConfigViewController = [[SinaConfigViewController alloc]init];
	[self.navigationController presentModalViewController:sinaConfigViewController animated:YES];
	[sinaConfigViewController release];
}

- (void) loginToTwitterButtonClicked{
	[self.sharedSoundEffectsManager playElectricBeepSound];
	MBConfigViewController* mbConfigViewController = [[MBConfigViewController alloc]init];
	[self.navigationController presentModalViewController:mbConfigViewController animated:YES];
	[mbConfigViewController release];
	
}

- (void) soundOnOffButtonClicked{
	if (![LocalStorageManager boolForKey:SOUNDOFF]){
		// turn sound off
		[LocalStorageManager setBool:YES forKey:SOUNDOFF];
		[self.soundOnOffLabel setText: NSLocalizedString(@"Sound On",nil)];
	}else{
		// turn sound on
		[LocalStorageManager setBool:NO forKey:SOUNDOFF];
		[self.sharedSoundEffectsManager playElectricBeepSound];
		[self.soundOnOffLabel setText: NSLocalizedString(@"Sound Off",nil)];
	}
}


- (void) musicOnOffButtonClicked{
	if (![LocalStorageManager boolForKey:MUSIC_OFF]){
		// turn sound off
		[LocalStorageManager setBool:YES forKey:MUSIC_OFF];
		[[self sharedSoundEffectsManager] pauseTitleScreenBGM];
		[self.musicOnOffLabel setText: NSLocalizedString(@"Music On",nil)];
	}else{
		// turn sound on
		[LocalStorageManager setBool:NO forKey:MUSIC_OFF];
		[self.sharedSoundEffectsManager playElectricBeepSound];
		[[self sharedSoundEffectsManager] playTitleScreenBGM];
		[self.musicOnOffLabel setText: NSLocalizedString(@"Music Off",nil)];
	}
}


- (void) loginToFacebookButtonClicked{
	[self.sharedSoundEffectsManager playElectricBeepSound];
	FBConfigViewController* fbConfigViewController = [[FBConfigViewController alloc]init];
	[self.navigationController presentModalViewController:fbConfigViewController animated:YES];
	[fbConfigViewController release];
}

- (void) leaderBoardButtonClicked{
	[self.sharedSoundEffectsManager playElectricBeepSound];
	self.title = NSLocalizedString(@"目錄",nil);
	GameRecordMenuViewController*  theConfigView = [[GameRecordMenuViewController alloc] init];
	[self.navigationController pushViewController:theConfigView animated:YES];	
	[theConfigView release];
}

- (void)coolReplaysButtonClicked{
	[self.sharedSoundEffectsManager playElectricBeepSound];
	self.title = NSLocalizedString(@"目錄",nil);
	VideoTableViewController* theConfigView = [[VideoTableViewController alloc]initWithPage:-1];
	[self.navigationController pushViewController:theConfigView animated:YES];	
	[theConfigView release];
}


- (void)bashersWorldwideButtonClicked{
	[self.sharedSoundEffectsManager playElectricBeepSound];
	self.title = NSLocalizedString(@"目錄",nil);
	AroundTheWorldViewController* theConfigView = [[AroundTheWorldViewController alloc]init];
	[self.navigationController pushViewController:theConfigView animated:YES];	
	[theConfigView release];
}


- (void)freeSelectEasyButtonClicked{
	[self freeSelectClicked:kEasy];
}

- (void)freeSelectMediumButtonClicked{
	[self freeSelectClicked:kNormal];
}

- (void)freeSelectHardButtonClicked{
	[self freeSelectClicked:kHard];
}

- (void)freeSelectMasterButtonClicked{
	[self freeSelectClicked:kWorldClass];
}


- (void)startSinglePlayerArcade:(NSInteger)difficultyLevel{
	[self.sharedSoundEffectsManager playElectricBeepSound];
	GameViewController* gameViewController = [[GameViewController alloc]init];
	gameViewController.navigationController = self.navigationController;
	gameViewController.difficultiesLevel = difficultyLevel;
	gameViewController.gameType = one_player_arcade;
	self.gameViewController = gameViewController;
	[gameViewController release];
	
	gameViewController.theGame = [[Constants sharedInstance] firstGameForMode:kArcade];
	
	[self.navigationController pushViewController:self.gameViewController animated:YES];
	self.gameViewController = nil;
	
}


- (void)startSinglePlayerRandomFive:(NSInteger)difficultyLevel{
	[self.sharedSoundEffectsManager playElectricBeepSound];
	GameViewController* gameViewController = [[GameViewController alloc]init];
	gameViewController.navigationController = self.navigationController;
	gameViewController.difficultiesLevel = difficultyLevel;
	gameViewController.gameType = one_player_arcade;
	gameViewController.isLite = YES;
	gameViewController.theGame = [[Constants sharedInstance] firstGameForMode:kArcadeLite];				
	
	self.gameViewController = gameViewController;
	[gameViewController release];
	[self.navigationController pushViewController:self.gameViewController animated:YES];
	self.gameViewController = nil;
	
}


- (void)easyVersusFreeSelectModeButtonClicked{
	NSLog(@"easyVersusFreeSelectModeButtonClicked");
	[self freeSelectVersusModeClicked:kEasy];
}

- (void)normalVersusFreeSelectModeButtonClicked{
	NSLog(@"normalVersusFreeSelectModeButtonClicked");
	[self freeSelectVersusModeClicked:kNormal];
}

- (void)hardVersusFreeSelectModeButtonClicked{
	NSLog(@"hardVersusFreeSelectModeButtonClicked");
	[self freeSelectVersusModeClicked:kHard];
}

- (void)easyArcadeModeButtonClicked{
	NSLog(@"easyArcadeModeButtonClicked");
	[self startSinglePlayerArcade:kEasy];
}

- (void)normalArcadeModeButtonClicked{
	NSLog(@"normalArcadeModeButtonClicked");
	[self startSinglePlayerArcade:kNormal];
}

- (void)hardArcadeModeButtonClicked{
	NSLog(@"hardArcadeModeButtonClicked");
	[self startSinglePlayerArcade:kHard];
}

- (void)masterButtonClicked{
	NSLog(@"masterButtonClicked");
	[self startSinglePlayer:kWorldClass];
}

- (void)easyRandomFiveModeButtonClicked{
	NSLog(@"easyRandomFiveModeButtonClicked");
	[self startSinglePlayerRandomFive:kEasy];
}

- (void)normalRandomFiveModeButtonClicked{
	NSLog(@"normalRandomFiveModeButtonClicked");
	[self startSinglePlayerRandomFive:kNormal];
}

- (void)hardRandomFiveModeButtonClicked{
	NSLog(@"hardRandomFiveModeButtonClicked");
	[self startSinglePlayerRandomFive:kHard];
}


- (void)singlePlayerButtonClicked{
	NSLog(@"singlePlayerButtonClicked");
	
	[self.sharedSoundEffectsManager playElectricBeepSound];
	
	CATransition* trans = [CATransition animation];
	[trans setType:kCATransitionFade];
	[trans setDuration:0.4];
	
	[self.mainOptionsView removeFromSuperview];
	if (self.singlePlayerOptionsView == nil){
		[self initSinglePlayerOptions];
	}
	[self.view addSubview:self.singlePlayerOptionsView];
	CALayer *layer = self.view.layer;
	[layer addAnimation:trans forKey:@"Transition"];
	
}

-(void)versusCreateGameFreeSelectModeButtonClicked{
		[self.sharedSoundEffectsManager playElectricBeepSound];
	
		if ((self.billBoard != nil)){
			[self.billBoard removeFromSuperview];
			[self.billBoard.scrollView removeFromSuperview];
			[self.levelSelectPaneView removeFromSuperview];
		}
		if (self.multiPlayerBillBoard != nil){
			[self.multiPlayerBillBoard removeFromSuperview];
			[self.multiPlayerBillBoard.scrollView removeFromSuperview];
		}
	
		BillBoard* board = [[BillBoard alloc] initWithPosterSize:CGSizeMake(160,200) andPosters:[[Constants sharedInstance] gameScreensArray] andOwner:self andGameLevel:kHard andGameMode:kGCVSSingle];
		self.multiPlayerBillBoard = board;
		[board release];
		[self.versusModeLevelSelectPaneView addSubview:self.multiPlayerBillBoard.scrollView];
		[self.versusModeLevelSelectPaneView addSubview:self.multiPlayerBillBoard];
		self.multiPlayerBillBoard.theInner.gameLevel = kHard;
		[self.multiPlayerBillBoard reload];
		[self.multiPlayerBillBoard startTimer];
		
		
		CATransition* trans = [CATransition animation];
		[trans setType:kCATransitionPush];
		[trans setSubtype:kCATransitionFromRight];
		[trans setDuration:0.4];
		
		[self.communityMenuView removeFromSuperview];
		[self.versusCreateGameOptionsView removeFromSuperview];
		[self.view addSubview:self.versusModeLevelSelectPaneView];
		
		
		CALayer *layer = self.view.layer;
		[layer addAnimation:trans forKey:@"Transition"];
		
	
}

-(void)versusCreateGameArcadeModeButtonClicked{
	[self.sharedSoundEffectsManager playElectricBeepSound];
	[self localMPLevelSelectButtonClicked:karcade];
}

-(void)versusCreateGameRandomFiveModeButtonClicked{
	[self.sharedSoundEffectsManager playElectricBeepSound];
	[self localMPLevelSelectButtonClicked:karcadelite];
}


-(void) localMPLevelSelectButtonClicked:(Game)game
{	
	[[GameCenterManager sharedInstance] setTheGame:game];
	[[GameCenterManager sharedInstance] setTheGameLevel:kHard];
	[[GameCenterManager sharedInstance] setVc:self];
	[[GameCenterManager sharedInstance] setIsHost:YES];
	if (game == karcadelite){
		[[GameCenterManager sharedInstance] setIsLite:YES];
	}else{
		[[GameCenterManager sharedInstance] setIsLite:NO];
	}
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


- (void)arcadeModeButtonClicked{
	NSLog(@"arcadeModeButtonClicked");
	[self.sharedSoundEffectsManager playElectricBeepSound];
	
	CATransition* trans = [CATransition animation];
	[trans setType:kCATransitionFade];
	[trans setDuration:0.4];
	
	[self.singlePlayerOptionsView removeFromSuperview];
	if (self.arcadeModeDifficultyView == nil){
		[self initArcadeModeDifficultyOptions];
	}
	[self.view addSubview:self.arcadeModeDifficultyView];
	CALayer *layer = self.view.layer;
	[layer addAnimation:trans forKey:@"Transition"];
	
}

-(void)gameCenterArcadeModeButtonClicked{
	NSLog(@"gameCenterArcadeModeButtonClicked");
	[self.sharedSoundEffectsManager playElectricBeepSound];
	[self gcLevelSelectButtonClicked:karcade];
}


-(void)gameCenterRandomFiveModeButtonClicked{
	NSLog(@"gameCenterRandomFiveModeButtonClicked");
	[self.sharedSoundEffectsManager playElectricBeepSound];
	[self gcLevelSelectButtonClicked:karcadelite];
}

-(void)gameCenterFreeSelectModeButtonClicked{
	NSLog(@"gameCenterFreeSelectModeButtonClicked");
	[self.sharedSoundEffectsManager playElectricBeepSound];
	
	if ((self.billBoard != nil)){
		NSLog(@"freeSelectClicked self.billBoad not empty, erleasing");
		[self.billBoard removeFromSuperview];
		[self.billBoard.scrollView removeFromSuperview];
		[self.levelSelectPaneView removeFromSuperview];
	}
	if (self.multiPlayerBillBoard != nil){
		[self.multiPlayerBillBoard removeFromSuperview];
		[self.multiPlayerBillBoard.scrollView removeFromSuperview];
	}
		
	BillBoard* board = [[BillBoard alloc] initWithPosterSize:CGSizeMake(160,200) andPosters:[[Constants sharedInstance] gameScreensArray] andOwner:self andGameLevel:kHard andGameMode:kVSSingle];
	self.multiPlayerBillBoard = board;
	[board release];
	[self.versusModeLevelSelectPaneView addSubview:self.multiPlayerBillBoard.scrollView];
	[self.versusModeLevelSelectPaneView addSubview:self.multiPlayerBillBoard];
	self.multiPlayerBillBoard.theInner.gameLevel = kHard;
	[self.multiPlayerBillBoard reload];
	[self.multiPlayerBillBoard startTimer];
		
		
	CATransition* trans = [CATransition animation];
	[trans setType:kCATransitionPush];
	[trans setSubtype:kCATransitionFromRight];
	[trans setDuration:0.4];
		
	[self.communityMenuView removeFromSuperview];
	[self.gameCenterOptionsView removeFromSuperview];
	[self.view addSubview:self.versusModeLevelSelectPaneView];
		
		
	CALayer *layer = self.view.layer;
	[layer addAnimation:trans forKey:@"Transition"];
	
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
	[[GameCenterManager sharedInstance] setTheGameLevel:kHard];
	[[GameCenterManager sharedInstance] setVc:self];
	[[GameCenterManager sharedInstance] setIsHost:YES];
	[[GameCenterManager sharedInstance] setIsLite:YES];
	[self presentModalViewController:controller animated:YES];
	
}

- (void)freeSelectModeButtonClicked{
	[self.sharedSoundEffectsManager playElectricBeepSound];
	
	CATransition* trans = [CATransition animation];
	[trans setType:kCATransitionFade];
	[trans setDuration:0.4];
	
	[self.singlePlayerOptionsView removeFromSuperview];
	if (self.freeSelectDifficultyView == nil){
		[self initFreeSelectDifficultyOptions];
	}
	[self.view addSubview:self.freeSelectDifficultyView];
	CALayer *layer = self.view.layer;
	[layer addAnimation:trans forKey:@"Transition"];
	
}


- (void)randomFiveModeButtonClicked{
	NSLog(@"randomFiveModeButtonClicked");
	[self.sharedSoundEffectsManager playElectricBeepSound];

	CATransition* trans = [CATransition animation];
	[trans setType:kCATransitionFade];
	[trans setDuration:0.4];
	
	[self.singlePlayerOptionsView removeFromSuperview];
	if (self.randomFiveModeDifficultyView == nil){
		[self initRandomFiveModeDifficultyOptions];
	}
	[self.view addSubview:self.randomFiveModeDifficultyView];
	CALayer *layer = self.view.layer;
	[layer addAnimation:trans forKey:@"Transition"];
	
}

- (void)versusButtonClicked{
	[self.sharedSoundEffectsManager playElectricBeepSound];
	
	CATransition* trans = [CATransition animation];
	[trans setType:kCATransitionFade];
	[trans setDuration:0.4];
	
	[self.mainOptionsView removeFromSuperview];
	if (self.versusOptionsView == nil){
		[self initVersusOptions];
	}
	[self.view addSubview:self.versusOptionsView];
	CALayer *layer = self.view.layer;
	[layer addAnimation:trans forKey:@"Transition"];
	
}

- (void)othersButtonClicked{
	[self.sharedSoundEffectsManager playElectricBeepSound];
	
	CATransition* trans = [CATransition animation];
	[trans setType:kCATransitionFade];
	[trans setDuration:0.4];
	
	[self.mainOptionsView removeFromSuperview];
	if (self.settingOptionsView == nil){
		[self initSettingsOptions];
	}
	[self.view addSubview:self.settingOptionsView];
	CALayer *layer = self.view.layer;
	[layer addAnimation:trans forKey:@"Transition"];	
}

- (void)gameCenterButtonClicked{
	NSLog(@"gameCenterButtonClicked");
	[self.sharedSoundEffectsManager playElectricBeepSound];
	
	CATransition* trans = [CATransition animation];
	[trans setType:kCATransitionFade];
	[trans setDuration:0.4];
	
	[self.versusOptionsView removeFromSuperview];
	if (self.versusFreeSelectDifficultyView == nil){
		[self initGameCenterOptions];
	}
	[self.view addSubview:self.gameCenterOptionsView];
	CALayer *layer = self.view.layer;
	[layer addAnimation:trans forKey:@"Transition"];
	
}

- (void)createLocalGameButtonClicked{
	NSLog(@"createLocalGameButtonClicked");
	CATransition* trans = [CATransition animation];
	[trans setType:kCATransitionFade];
	[trans setDuration:0.4];
	
	[self.versusOptionsView removeFromSuperview];
	if (self.versusCreateGameOptionsView == nil){
		[self initVersusCreateGameOptions];
	}
	[self.view addSubview:self.versusCreateGameOptionsView];
	CALayer *layer = self.view.layer;
	[layer addAnimation:trans forKey:@"Transition"];
}


- (void)joinLocalGameButtonClicked{
	NSLog(@"joinLocalGameButtonClicked");
	MultiPlayersJoinGameViewController* joinGameView = [[MultiPlayersJoinGameViewController alloc]init];
	[self.navigationController pushViewController:joinGameView animated:YES];	
	[joinGameView release];
	
}

- (void)backToMainButtonFromVersusClicked{
	[self.sharedSoundEffectsManager playElectricBeepSound];
	
	CATransition* trans = [CATransition animation];
	[trans setType:kCATransitionFade];
	[trans setDuration:0.4];
	
	[self.versusOptionsView removeFromSuperview];
	[self.view addSubview:self.mainOptionsView];
	CALayer *layer = self.view.layer;
	[layer addAnimation:trans forKey:@"Transition"];
	
}

- (void)backToMainButtonFromSettingsClicked{
	NSLog(@"backToMainButtonFromSettingsClicked");
	[self.sharedSoundEffectsManager playElectricBeepSound];
	
	CATransition* trans = [CATransition animation];
	[trans setType:kCATransitionFade];
	[trans setDuration:0.4];
	
	[self.settingOptionsView removeFromSuperview];
	[self.view addSubview:self.mainOptionsView];
	CALayer *layer = self.view.layer;
	[layer addAnimation:trans forKey:@"Transition"];
	
}

- (void)backToMainButtonFromSinglePlayerClicked{
	NSLog(@"backToMainButtonFromSinglePlayerClicked");
	[self.sharedSoundEffectsManager playElectricBeepSound];
	
	CATransition* trans = [CATransition animation];
	[trans setType:kCATransitionFade];
	[trans setDuration:0.4];
	
	[self.singlePlayerOptionsView removeFromSuperview];
	[self.view addSubview:self.mainOptionsView];
	CALayer *layer = self.view.layer;
	[layer addAnimation:trans forKey:@"Transition"];
	
}

- (void)backToSinglePlayerFromArcadeDifficultyButtonClicked{
	NSLog(@"backToSinglePlayerFromArcadeDifficultyButtonClicked");
	[self.sharedSoundEffectsManager playElectricBeepSound];
	
	CATransition* trans = [CATransition animation];
	[trans setType:kCATransitionFade];
	[trans setDuration:0.4];
	
	[self.arcadeModeDifficultyView removeFromSuperview];
	[self.view addSubview:self.singlePlayerOptionsView];
	CALayer *layer = self.view.layer;
	[layer addAnimation:trans forKey:@"Transition"];
}

- (void)backToSinglePlayerFromFreeSelectDifficultyButtonClicked{
	NSLog(@"backToSinglePlayerFromFreeSelectDifficultyButtonClicked");
	[self.sharedSoundEffectsManager playElectricBeepSound];
	
	CATransition* trans = [CATransition animation];
	[trans setType:kCATransitionFade];
	[trans setDuration:0.4];
	
	[self.freeSelectDifficultyView removeFromSuperview];
	[self.view addSubview:self.singlePlayerOptionsView];
	CALayer *layer = self.view.layer;
	[layer addAnimation:trans forKey:@"Transition"];
}

- (void)backToSinglePlayerFromRandomFiveModeDifficultyButtonClicked{
	NSLog(@"backToSinglePlayerFromRandomFiveModeDifficultyButtonClicked");
	[self.sharedSoundEffectsManager playElectricBeepSound];
	
	CATransition* trans = [CATransition animation];
	[trans setType:kCATransitionFade];
	[trans setDuration:0.4];
	
	[self.randomFiveModeDifficultyView removeFromSuperview];
	[self.view addSubview:self.singlePlayerOptionsView];
	CALayer *layer = self.view.layer;
	[layer addAnimation:trans forKey:@"Transition"];
}


- (void) backToVersusFromGameCenterButtonClicked{
	[self.sharedSoundEffectsManager playElectricBeepSound];
	
	CATransition* trans = [CATransition animation];
	[trans setType:kCATransitionFade];
	[trans setDuration:0.4];
	
	[self.gameCenterOptionsView removeFromSuperview];
	[self.versusCreateGameOptionsView removeFromSuperview];
	[self.view addSubview:self.versusOptionsView];
	CALayer *layer = self.view.layer;
	[layer addAnimation:trans forKey:@"Transition"];
	
}

- (void) backToVersusFromDifficultyButtonClicked{
	[self.sharedSoundEffectsManager playElectricBeepSound];
	
	CATransition* trans = [CATransition animation];
	[trans setType:kCATransitionFade];
	[trans setDuration:0.4];
	
	[self.versusFreeSelectDifficultyView removeFromSuperview];
	[self.view addSubview:self.versusOptionsView];
	CALayer *layer = self.view.layer;
	[layer addAnimation:trans forKey:@"Transition"];
	
}


-(void)backToSinglePlayerFromFreeSelectBillBoardButtonClicked{
	[self.sharedSoundEffectsManager playElectricBeepSound];
	
	CATransition* trans = [CATransition animation];
	[trans setType:kCATransitionPush];
	[trans setSubtype:kCATransitionFromLeft];
	[trans setDuration:0.4];
	
	[self.levelSelectPaneView removeFromSuperview];
	[self.view addSubview:self.freeSelectDifficultyView];
	[self.view addSubview:self.communityMenuView];
	
	CALayer *layer = self.view.layer;
	[layer addAnimation:trans forKey:@"Transition"];
	
}

-(void)backToVersusFromFreeSelectBillBoardButtonClicked{
	[self.sharedSoundEffectsManager playElectricBeepSound];
	NSLog(@"backToVersusFromFreeSelectBillBoardButtonClicked");
	
	CATransition* trans = [CATransition animation];
	[trans setType:kCATransitionPush];
	[trans setSubtype:kCATransitionFromLeft];
	[trans setDuration:0.4];
	
	[self.versusModeLevelSelectPaneView removeFromSuperview];
	[self.view addSubview:self.versusCreateGameOptionsView];
	[self.view addSubview:self.communityMenuView];
	
	CALayer *layer = self.view.layer;
	[layer addAnimation:trans forKey:@"Transition"];
	
}




- (void)menuLanguageButtonClicked{
	[self.sharedSoundEffectsManager playElectricBeepSound];
	
	CATransition* trans = [CATransition animation];
	[trans setType:kCATransitionFade];
	[trans setDuration:0.4];
	
	UILanguageSelectionViewController* gameSelectionViewController = [[UILanguageSelectionViewController alloc]init];
	gameSelectionViewController.delegate = self;
	[self.navigationController pushViewController:gameSelectionViewController animated:YES];
	[gameSelectionViewController release];
		
	CALayer *layer = self.view.layer;
	[layer addAnimation:trans forKey:@"Transition"];	
}

#pragma mark -
#pragma mark delegate method for BillBoard

-(void) gcLevelSelectButtonClicked:(Game)game gameLevel:(GameLevel)gameLevel
{	
	GKMatchRequest *matchRequest = [[GKMatchRequest alloc] init]; 
	matchRequest.minPlayers = 2; 
	matchRequest.maxPlayers = 2; 
	matchRequest.playerGroup = game;
	
	GKMatchmakerViewController *controller = [[[GKMatchmakerViewController alloc] initWithMatchRequest:matchRequest] autorelease];
	controller.matchmakerDelegate = [GameCenterManager sharedInstance]; 
	[[GameCenterManager sharedInstance] setTheGame:game];
	[[GameCenterManager sharedInstance] setTheGameLevel:gameLevel];
	[[GameCenterManager sharedInstance] setVc:self];
	[[GameCenterManager sharedInstance] setIsHost:YES];
	[self presentModalViewController:controller animated:YES];
	
}

-(void)onePlayerGameSelectButtonClicked:(Game)theGame{
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	[self onePlayerButtonClicked:theGame];
}

- (void)onePlayerButtonClicked:(NSInteger)inSelectedGame{
	[self.sharedSoundEffectsManager playUFOFlyPassSound];
	{
//		if (inSelectedGame == kheartnhand){
//			inSelectedGame = kpencil;
//		}
		NSLog(@"inSelectedGame: %i", inSelectedGame);
		[self.navigationController setNavigationBarHidden:YES animated:NO];
		[self.sharedSoundEffectsManager stopTitleScreenBGM];
		
		GameViewController* gameViewController = [[GameViewController alloc]init];
		self.gameViewController = gameViewController;
		[gameViewController release];
		self.gameViewController.navigationController = self.navigationController;
		self.gameViewController.difficultiesLevel = self.billBoard.theInner.gameLevel;
		self.gameViewController.theGame = inSelectedGame;
		self.gameViewController.gameType = one_player_level_select;
		[self.navigationController setNavigationBarHidden:YES animated:NO];
		[self.navigationController pushViewController:self.gameViewController animated:YES];
		[self.navigationController setNavigationBarHidden:YES animated:NO];
		self.gameViewController = nil;
	}	
}

#pragma mark -
#pragma mark delegate method for UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	NSLog(@"textFieldShouldReturn");
	[LocalStorageManager setObject:textField.text forKey:USER_NAME];
	
	if ([textField.text isEqualToString:@"Ka Ka"] || [textField.text isEqualToString:@"Kenny"] || [textField.text isEqualToString:@"Adelene"])	{
		[[Constants sharedInstance] setAPPVERSION:@"version2" ];
		
		// open an alert with just an OK button
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unlock Full Version" message:@"You have just unlocked the full version of BashBash! Enjoy!"
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];
	}
	else
		[textField resignFirstResponder];
	return YES;
}

-(BOOL) textFieldShouldBeginEditing:(UITextField*)textField {
	NSLog(@"textFieldShouldBeginEditing");
	return YES;
}


#pragma mark -
#pragma mark delegate method for CountryTableViewController

- (void) countrySelected:(NSString*) country
{
	[LocalStorageManager setObject:country forKey:COUNTRY];
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark delegate method for UILanguageSelectionViewController

- (void) uiLanguageSelected:(NSString*) lang
{
	[LocalStorageManager setObject:lang forKey:UILANGUAGE];
	[[Constants sharedInstance] setLanguage:lang];
	[self.navigationController popViewControllerAnimated:YES];
}



#pragma mark -
#pragma mark delegate method for GC Leaderboard

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [self dismissModalViewControllerAnimated:YES];
}



@end
