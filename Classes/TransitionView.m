//
//  TransitionView.m
//  bishibashi
//
//  Created by Kenny Tang on 4/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TransitionView.h"
#import "Constants.h"
#import "MediaManager.h"
#import "AdMobView.h"


@implementation TransitionView
@synthesize polaroid = _polaroid;
@synthesize pentagonChart = _pentagonChart;

@synthesize levelInfoLevelNumberLabel = _levelInfoLevelNumberLabel;
@synthesize levelInfoLevelNameLabel = _levelInfoLevelNameLabel;
@synthesize levelInstructionsTitleLabel = _levelInstructionsTitleLabel;
@synthesize currentGame, levelNumber, levelScore, delegate;
@synthesize mainView = _mainView;
@synthesize levelInstructionsView = _levelInstructionsView;
@synthesize levelInstructionsGameInstructionsLabels = _levelInstructionsGameInstructionsLabels;
@synthesize levelInfoLevelScriptsLabel = _levelInfoLevelScriptsLabel;
@synthesize toPlayBtn = _toPlayBtn;
@synthesize toPlayLbl = _toPlayLbl;
@synthesize orientation = _orientation;
@synthesize infoBut = _infoBut;
@synthesize mapBut = _mapBut;
@synthesize iAdBannerView = _iAdBannerView;
@synthesize adMobView = _adMobView;
@synthesize bannerIsVisible, admobBannerIsVisible;
@synthesize snowFlakeView = _snowFlakeView;
@synthesize note = _note;
static const CGRect iAdBannerP = {{0, 0}, {320, 50}};


//static const CGRect levelInfoLevelNumberLabelRectP = {{10, 70}, {280, 50}};
static const CGRect levelInfoLevelNumberLabelRectP = {{50, 70}, {200, 40}};
static const CGRect levelInfoLevelNumberLabelRectE = {{40, 70}, {250, 40}};

static const CGRect levelInfoLevelNameLabelRectP = {{50, 120}, {220, 35}};
static const CGRect levelInfoLevelNameLabelRectE = {{40, 120}, {250, 35}};

static const CGRect levelInfoLevelScriptLabelRectP = {{50, 130}, {200, 30}};
static const CGRect levelInfoLevelScriptLabelRectE = {{40, 130}, {260, 30}};

static const CGRect levelInstructionsTitleLabelRectP = {{0, 10}, {320, 30}};

static const CGRect levelInstructionsGameInstructionsLabelRectP = {{0, 50}, {320, 30}};

static const CGRect levelInstructionsViewRectP = {{40,140},{240,260}};

static const CGRect transitionOutTitleLabelRectP = {{10, 50}, {280, 40}};

static const CGRect transitionOutScoreLabelRectP = {{10, 230}, {280, 40}};

static const CGRect toPlayBtnRectP = {{280, 435}, {33, 33}};
static const CGRect toPlayLblRectP = {{250, 460}, {50, 20}};
static const CGRect infoButRectP = {{285, 70}, {30, 30}};
static const CGRect mapButRectP = {{285, 100}, {30, 30}};


static const CGRect polaroidRect = {{55, 300}, {200,175}};
static const CGRect pentagonChartRect = {{78,310},{160, 140}};
static const CGRect avgRect={{55,445},{120,25}};
static const CGRect rankRect = {{155,445},{120,25}};
static const CGRect difficultiesRect = {{50,300},{80,30}};

static const CGRect noteRect = {{0,0}, {320,480}};



-(void) switchToCreditView
{	
	[NSObject cancelPreviousPerformRequestsWithTarget:self];

	[self.delegate setTitle:NSLocalizedString(@"遊戲",nil)];
	VideoTableViewController* theConfigView = [[VideoTableViewController alloc]initWithPage:self.currentGame];
	[[self.delegate navigationController] pushViewController:theConfigView animated:YES];	
	[theConfigView release];
}

-(void) mapButClicked
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[self.delegate setTitle:NSLocalizedString(@"遊戲",nil)];
	AroundTheWorldViewController* theConfigView = [[AroundTheWorldViewController alloc]initWithGame:self.currentGame];
	[[self.delegate navigationController] pushViewController:theConfigView animated:YES];	
	[theConfigView release];
	
}

- (void)showLevelInfo{
	_type = showLevelInfo;
    CGRect screenBounds = [ [ UIScreen mainScreen ] bounds ];
	
	if (self.mainView){
		[self.mainView removeFromSuperview];
	}
	
	UIView* mainView = [[UIView alloc]initWithFrame:screenBounds];
	self.mainView = mainView;
	[mainView release];
	[self.mainView setBackgroundColor:[UIColor blackColor]];
	
	[sharedSoundEffectsManager playDramaticAccentSound];
	
	BOOL isEnglish = NO;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"])
		isEnglish = YES;

	if (!self.note)	{
		UIImageView* theView = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"blackboard" ofType:@"png"]]];
		self.note = theView;
		self.note.frame = noteRect;
		[self.mainView addSubview:self.note];
		[theView release];
	}		
	
	if (!self.polaroid)	{
		UIImageView* theView = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"polaroidfilm" ofType:@"png"]]];
		self.polaroid = theView;
		self.polaroid.frame = polaroidRect;
		[self.mainView addSubview:self.polaroid];
		[theView release];
		
		
		UILabel *label = [[UILabel alloc] initWithFrame:difficultiesRect];
		switch ([self.delegate difficultiesLevel])	{
			case (kEasy):					
				label.text = NSLocalizedString(@"好易", nil);
				break;
			case (kNormal):					
				label.text = NSLocalizedString(@"普通", nil);
				break;
			case (kHard):					
				label.text = NSLocalizedString(@"難爆", nil);
				break;
			case (kWorldClass):					
				label.text = NSLocalizedString(@"大師", nil);
				break;
		}
		label.numberOfLines = 1;
		label.textAlignment = UITextAlignmentCenter;
		label.font = [UIFont systemFontOfSize:18];
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor brownColor];
		label.transform = CGAffineTransformMakeRotation(radians((float)(arc4random()%10-5.0-35.0)));
		[self.mainView addSubview:label];
		
	}		

	PentagonChart* theChart = [[PentagonChart alloc] initWithFrame:pentagonChartRect AndScores:[[[Constants sharedInstance] attributeRatiosArray] objectAtIndex:currentGame]
													AndTotalScores:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.007],[NSNumber numberWithFloat:0.007],[NSNumber numberWithFloat:0.007],[NSNumber numberWithFloat:0.007],[NSNumber numberWithFloat:0.007],nil] 
													AndScoreLabels:[[Constants sharedInstance] attributesArray]
													AndShowRank:(BOOL)NO];
	self.pentagonChart = theChart;
	[theChart release];
	[self.mainView addSubview:self.pentagonChart];

	
	if (0 == (self.currentGame)){
		[sharedSoundEffectsManager playTransitionLevelOneSound];
	}else if (1 == (self.currentGame)){
		[sharedSoundEffectsManager playTransitionLevelTwoSound];
	}else if (2 == (self.currentGame)){
		[sharedSoundEffectsManager playTransitionLevelThreeSound];
	}else if (3 == (self.currentGame)){
		[sharedSoundEffectsManager playTransitionLevelFourSound];
	}else if (4 == (self.currentGame)){
		[sharedSoundEffectsManager playTransitionLevelFiveSound];
	}else if (5 == (self.currentGame)){
		[sharedSoundEffectsManager playTransitionLevelSixSound];
	}else if (6 == (self.currentGame)){
		[sharedSoundEffectsManager playTransitionLevelSevenSound];
	}else if (7 == (self.currentGame)){
		[sharedSoundEffectsManager playTransitionLevelEightSound];
	}else if (8 == (self.currentGame)){
		[sharedSoundEffectsManager playTransitionLevelNineSound];
	}else if (9 == (self.currentGame)){
		[sharedSoundEffectsManager playTransitionLevelTenSound];
	}else if (10 == (self.currentGame)){
		[sharedSoundEffectsManager playTransitionLevelElevenSound];
	}else if (11 == (self.currentGame)){
		[sharedSoundEffectsManager playTransitionLevelTwlveSound];
	}

#ifdef LITE_VERSION
	if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)])	{
//	if (self.currentGame != kdancing)
	if (NSClassFromString(@"ADBannerView")!=nil)
	if (self.orientation == UIInterfaceOrientationPortrait || self.orientation == UIInterfaceOrientationPortraitUpsideDown)	{
		ADBannerView *adView = [[ADBannerView alloc] initWithFrame:iAdBannerP];
		adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifier320x50;
		adView.requiredContentSizeIdentifiers = [NSSet setWithObjects: ADBannerContentSizeIdentifier320x50, ADBannerContentSizeIdentifier480x32,nil];
		[self.mainView addSubview:adView];
		self.iAdBannerView = adView;
		self.iAdBannerView.delegate = self;
		adView.frame = CGRectOffset(adView.frame, 0, -50);
		self.bannerIsVisible=NO;
		[adView release];
	}
	}
#endif
	
	self.infoBut = [UIButton buttonWithType:UIButtonTypeCustom];
	self.infoBut.backgroundColor = [UIColor clearColor];
	[self.infoBut setImage:[UIImage imageNamed:@"video.png"] forState:UIControlStateNormal];
	
	[self.mainView addSubview:self.infoBut];
	[self.infoBut addTarget:self action:@selector(switchToCreditView) forControlEvents:UIControlEventTouchDown];
	self.infoBut.frame = infoButRectP;

	self.mapBut = [UIButton buttonWithType:UIButtonTypeCustom];
	self.mapBut.backgroundColor = [UIColor clearColor];
	[self.mapBut setImage:[UIImage imageNamed:@"globe.png"] forState:UIControlStateNormal];
	
	[self.mainView addSubview:self.mapBut];
	[self.mapBut addTarget:self action:@selector(mapButClicked) forControlEvents:UIControlEventTouchDown];
	self.mapBut.frame = mapButRectP;
	
	
	/*
	self.toPlayLbl = [UIButton buttonWithType:UIButtonTypeCustom];
	self.toPlayLbl.tag = 0;
	[self.toPlayLbl setTitle:@"PLAY" forState:UIControlStateNormal];
	self.toPlayLbl.titleLabel.font = [UIFont systemFontOfSize:16];
	self.toPlayLbl.backgroundColor = [UIColor clearColor];
	[self.mainView addSubview:self.toPlayLbl];
*/
	self.toPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.toPlayBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"forward" ofType:@"png"]] forState:UIControlStateNormal];
	self.toPlayBtn.frame = toPlayBtnRectP;
	[self.mainView addSubview:self.toPlayBtn];
	[self.toPlayBtn addTarget:self action:@selector(toPlayBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

/*	
	self.toPlayBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	self.toPlayBtn.tag = 0;
	[self.toPlayBtn addTarget:self action:@selector(toPlayBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	[self.toPlayLbl addTarget:self action:@selector(toPlayBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	[self.mainView addSubview:self.toPlayBtn];
	self.toPlayLbl.frame = toPlayLblRectP;
	self.toPlayBtn.frame = toPlayBtnRectP;
 */

	
	NSString *levelNumberString;
	
	/* show 第%i版 only for arcade mode */
	if ([self.delegate gameType] == one_player_arcade)		{		
		levelNumberString = [NSString stringWithFormat:NSLocalizedString(@"第%i版",nil),self.levelNumber];

		UILabel* totalScore = [[UILabel alloc] initWithFrame:avgRect];
		totalScore.backgroundColor = [UIColor clearColor];
		totalScore.font = [UIFont boldSystemFontOfSize:16];
		totalScore.text = [NSString stringWithFormat:@"%@%.0f",NSLocalizedString(@"過關分數:",nil), [[[[[Constants sharedInstance] gamePassingScoreArray] objectAtIndex:self.currentGame] objectAtIndex:[self.delegate difficultiesLevel]]floatValue]];
		totalScore.textColor = [UIColor purpleColor];
		[self.mainView addSubview:totalScore];
		[totalScore release];

		totalScore = [[UILabel alloc] initWithFrame:rankRect];
		totalScore.backgroundColor = [UIColor clearColor];
		totalScore.font = [UIFont boldSystemFontOfSize:16];
		totalScore.text = NSLocalizedString(@"生命",nil);
		totalScore.textColor = [UIColor purpleColor];
		[self.mainView addSubview:totalScore];
		[totalScore release];
		
		for (int i=0; i<[self.delegate lifes]; i++)	{
			NSString* lifeiconfilename = [LocalStorageManager stringForKey:LIFEICON];
			UIView* lifeicon;
			if (lifeiconfilename == nil)	{   
				lifeicon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heartwithline.png"]];
				lifeicon.frame = CGRectMake(200+15*i,455, 15,15);
			}
			else if ([lifeiconfilename isEqualToString:LIFEICON])					{
				lifeicon = [[Baby alloc] initWithFrame:CGRectMake(200+15*i,455, 15,15) AndColor:(i%3) AndOrientation:11];			
			}
			else {
				lifeicon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:lifeiconfilename]];
				lifeicon.frame = CGRectMake(200+15*i,455, 15,15);
			}
			
			[self.mainView addSubview:lifeicon];
			[lifeicon release];
		}
		
	}
	else
		levelNumberString = NSLocalizedString(@"自由選關",nil);
	
	DymoLabel* levelInfoLevelNumberLabel;
	if (isEnglish)
		levelInfoLevelNumberLabel = [[DymoLabel alloc] initWithFrame:levelInfoLevelNumberLabelRectE AndText:levelNumberString AndColor:[UIColor redColor] AndTextFontSize:32];
	else
		levelInfoLevelNumberLabel = [[DymoLabel alloc] initWithFrame:levelInfoLevelNumberLabelRectP AndText:levelNumberString AndColor:[UIColor redColor] AndTextFontSize:36];
//	UILabel* levelInfoLevelNumberLabel = [[UILabel alloc] initWithFrame:levelInfoLevelNumberLabelRectP];
	levelInfoLevelNumberLabel.transform = CGAffineTransformMakeRotation(radians((float)(arc4random()%6-3.0)));	
	self.levelInfoLevelNumberLabel = levelInfoLevelNumberLabel;
//	self.levelInfoLevelNumberLabel = levelInfoLevelNumberLabel;
	[levelInfoLevelNumberLabel release];
//	self.levelInfoLevelNumberLabel.textAlignment = UITextAlignmentCenter;
//	[self.levelInfoLevelNumberLabel setFont:[UIFont systemFontOfSize:38]];
//	[self.levelInfoLevelNumberLabel setText:levelNumberString];
	
//	self.levelInfoLevelNumberLabel.textColor = [UIColor whiteColor];
//	self.levelInfoLevelNumberLabel.backgroundColor = [UIColor clearColor];
//	self.levelInfoLevelNumberLabel.shadowColor = [UIColor blackColor];
//	self.levelInfoLevelNumberLabel.shadowOffset = CGSizeMake(2, 2);
//	[self.mainView addSubview:self.levelInfoLevelNumberLabel];
	[self.mainView addSubview:self.levelInfoLevelNumberLabel];
	
	DymoLabel* levelInfoLevelNameLabel;
	if (isEnglish)
		levelInfoLevelNameLabel = [[DymoLabel alloc] initWithFrame:levelInfoLevelNameLabelRectE AndText:[[constantsInstance getGameNamesDictionary] objectForKey:[NSNumber numberWithInt:self.currentGame]] AndColor:[UIColor blueColor] AndTextFontSize:22];
	else
		levelInfoLevelNameLabel = [[DymoLabel alloc] initWithFrame:levelInfoLevelNameLabelRectP AndText:[[constantsInstance getGameNamesDictionary] objectForKey:[NSNumber numberWithInt:self.currentGame]] AndColor:[UIColor blueColor] AndTextFontSize:26];
//	UILabel* levelInfoLevelNameLabel = [[UILabel alloc] initWithFrame:levelInfoLevelNameLabelRectP];
	levelInfoLevelNameLabel.transform = CGAffineTransformMakeRotation(radians((float)(arc4random()%6-3.0)));	
	self.levelInfoLevelNameLabel = levelInfoLevelNameLabel;
	[levelInfoLevelNameLabel release];
//	self.levelInfoLevelNameLabel.textAlignment = UITextAlignmentCenter;
//	[self.levelInfoLevelNameLabel setFont:[UIFont systemFontOfSize:28]];
//	[self.levelInfoLevelNameLabel setText:[[constantsInstance getGameNamesDictionary] objectForKey:[NSNumber numberWithInt:self.currentGame]]];
//	self.levelInfoLevelNameLabel.textColor = [UIColor whiteColor];
//	self.levelInfoLevelNameLabel.backgroundColor = [UIColor clearColor];
//	self.levelInfoLevelNameLabel.shadowColor = [UIColor blackColor];
//	self.levelInfoLevelNameLabel.shadowOffset = CGSizeMake(2, 2);
	[self.mainView addSubview:self.levelInfoLevelNameLabel];
	/* for one player mode, without auto play */
	if ([self.delegate gameType] != one_player_arcade && [self.delegate gameType] != one_player_level_select)				
		[self performSelector:@selector(showLevelInstructions) withObject:nil afterDelay:4];

	self.levelInfoLevelScriptsLabel = [NSMutableArray arrayWithCapacity:4];
	int i=1;
	for (NSString *script in [constantsInstance.gameScriptsArray objectAtIndex:self.currentGame])	{
		if ([script length]>0)	{

			DymoLabel* label;
			if (isEnglish)
				label = [[DymoLabel alloc] initWithFrame:levelInfoLevelScriptLabelRectE AndText:script AndColor:[UIColor orangeColor] AndTextFontSize:18];
			else
				label = [[DymoLabel alloc] initWithFrame:levelInfoLevelScriptLabelRectP AndText:script AndColor:[UIColor orangeColor] AndTextFontSize:20];
	//		UILabel* label = [[UILabel alloc] initWithFrame:levelInfoLevelScriptLabelRectP];
			label.frame = CGRectMake(label.frame.origin.x,i*1.2*label.frame.size.height+label.frame.origin.y,label.frame.size.width,label.frame.size.height);
	//		label.textAlignment = UITextAlignmentCenter;
	//		label.minimumFontSize=16;
	//		label.adjustsFontSizeToFitWidth = YES;
	//		[label setFont:[UIFont systemFontOfSize:22]];
	//		[label setText:script];
	//		label.textColor = [UIColor whiteColor];
	//		label.backgroundColor = [UIColor clearColor];
	//		label.shadowColor = [UIColor blackColor];
	//		label.shadowOffset = CGSizeMake(2, 2);
			[self.levelInfoLevelScriptsLabel addObject:label];
			i++;
			[label release];		
		}
	}
	[self.mainView addSubview:[self.levelInfoLevelScriptsLabel objectAtIndex:0]];
	UILabel* label = [self.levelInfoLevelScriptsLabel objectAtIndex:0];
	float x = arc4random()%200;
	float y = arc4random()%200;
	label.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(8.0, 8.0), x, y);
	[UIView beginAnimations:@"showGameScript" context:[NSNumber numberWithInt:0]];
	[UIView setAnimationDelay:0.4];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];
//	label.transform = CGAffineTransformMakeTranslation(0,0);
	label.transform = CGAffineTransformMakeRotation(radians((float)(arc4random()%6-3.0)));	
	[UIView commitAnimations];
	
	[self.mainView bringSubviewToFront:self.toPlayBtn];
	
	[self addSubview:self.mainView];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	int idx = [(NSNumber*)context intValue]+1;
	if (idx < [self.levelInfoLevelScriptsLabel count] && _type == showLevelInfo)	{
		UILabel* label = [self.levelInfoLevelScriptsLabel objectAtIndex:idx];
		[self.mainView addSubview:label];
		float x = arc4random()%200;
		float y = arc4random()%200;
		label.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(8.0, 8.0), x, y);
		[UIView beginAnimations:@"showGameScript" context:[NSNumber numberWithInt:idx]];
		[UIView setAnimationDelay:0.4];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
//		label.transform = CGAffineTransformMakeTranslation(0,0);
		label.transform = CGAffineTransformMakeRotation(radians((float)(arc4random()%6-3.0)));	

		[UIView commitAnimations];
	}
}



- (void)showLevelInstructions{	
//	[self removeAllSnowFlakes];
	self.iAdBannerView.delegate = nil;
	self.iAdBannerView = nil;
	_type = showLevelInstruction;
	if (self.mainView){
		[self.mainView removeFromSuperview];
	}
	
    CGRect screenBounds = [ [ UIScreen mainScreen ] bounds ];
	UIView* mainView = [[UIView alloc]initWithFrame:screenBounds];
	self.mainView = mainView;
	[mainView release];
	[self.mainView setBackgroundColor:[UIColor blackColor]];
	
	self.infoBut = [UIButton buttonWithType:UIButtonTypeCustom];
	self.infoBut.backgroundColor = [UIColor clearColor];
	[self.infoBut setImage:[UIImage imageNamed:@"video.png"] forState:UIControlStateNormal];
	
	[self.mainView addSubview:self.infoBut];
	[self.infoBut addTarget:self action:@selector(switchToCreditView) forControlEvents:UIControlEventTouchDown];

	self.mapBut = [UIButton buttonWithType:UIButtonTypeCustom];
	self.mapBut.backgroundColor = [UIColor clearColor];
	[self.mapBut setImage:[UIImage imageNamed:@"globe.png"] forState:UIControlStateNormal];
	
	[self.mainView addSubview:self.mapBut];
	[self.mapBut addTarget:self action:@selector(mapButClicked) forControlEvents:UIControlEventTouchDown];
	self.mapBut.frame = mapButRectP;

	/*
	self.infoBut = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[self.infoBut addTarget:self action:@selector(switchToCreditView) forControlEvents:UIControlEventTouchDown];
	[self.mainView performSelector:@selector(addSubview:) withObject:self.infoBut afterDelay:12];
*/	
/*	self.toPlayLbl = [UIButton buttonWithType:UIButtonTypeCustom];
	self.toPlayLbl.tag = 1;
	[self.toPlayLbl setTitle:@"PLAY" forState:UIControlStateNormal];
	self.toPlayLbl.titleLabel.font = [UIFont systemFontOfSize:16];
	self.toPlayLbl.backgroundColor = [UIColor clearColor];
	[self.mainView addSubview:self.toPlayLbl];
*/	
	self.toPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.toPlayBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"forward" ofType:@"png"]] forState:UIControlStateNormal];
	self.toPlayBtn.frame = toPlayBtnRectP;
	self.toPlayBtn.tag = 1;
	[self.mainView addSubview:self.toPlayBtn];
	[self.toPlayBtn addTarget:self action:@selector(toPlayBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	
	
		self.infoBut.frame = infoButRectP;
	
	UILabel* levelInstructionsTitleLabel = [[UILabel alloc] initWithFrame:levelInstructionsTitleLabelRectP];
	levelInstructionsTitleLabel.textAlignment = UITextAlignmentCenter;
	[levelInstructionsTitleLabel setFont:[UIFont systemFontOfSize:36]];
	[levelInstructionsTitleLabel setText:NSLocalizedString(@"解說!!",nil)];
	levelInstructionsTitleLabel.textColor = [UIColor whiteColor];
	levelInstructionsTitleLabel.backgroundColor = [UIColor clearColor];
	levelInstructionsTitleLabel.shadowColor = [UIColor blackColor];
	levelInstructionsTitleLabel.shadowOffset = CGSizeMake(2, 2);
	[self.mainView addSubview:levelInstructionsTitleLabel];
	self.levelInstructionsTitleLabel = levelInstructionsTitleLabel;
	[levelInstructionsTitleLabel release];

	self.levelInstructionsGameInstructionsLabels = [NSMutableArray arrayWithCapacity:3];
	for (int i =0; i<3; i++)	{
			UILabel* levelInstructionsGameInstructionsLabel = [[UILabel alloc] initWithFrame:levelInstructionsGameInstructionsLabelRectP];
			levelInstructionsGameInstructionsLabel.frame = CGRectMake(levelInstructionsGameInstructionsLabel.frame.origin.x,i*levelInstructionsGameInstructionsLabel.frame.size.height+levelInstructionsGameInstructionsLabel.frame.origin.y,levelInstructionsGameInstructionsLabel.frame.size.width,levelInstructionsGameInstructionsLabel.frame.size.height);
			levelInstructionsGameInstructionsLabel.textAlignment = UITextAlignmentCenter;
			[levelInstructionsGameInstructionsLabel setFont:[UIFont systemFontOfSize:20]];
			[levelInstructionsGameInstructionsLabel setText:[[[constantsInstance getGameInstructionsDictionary] objectForKey:[NSNumber numberWithInt:self.currentGame]] objectAtIndex:i]];
			levelInstructionsGameInstructionsLabel.textColor = [UIColor whiteColor];
			levelInstructionsGameInstructionsLabel.backgroundColor = [UIColor clearColor];
			levelInstructionsGameInstructionsLabel.shadowColor = [UIColor blackColor];
			levelInstructionsGameInstructionsLabel.shadowOffset = CGSizeMake(2, 2);
			levelInstructionsGameInstructionsLabel.numberOfLines = 1;
			[self.mainView addSubview:levelInstructionsGameInstructionsLabel];
			[self.levelInstructionsGameInstructionsLabels addObject:levelInstructionsGameInstructionsLabel];
			[levelInstructionsGameInstructionsLabel release];
	}
	InstructionView* levelInstructionsView=nil;
	if (self.currentGame == keatbeans)
		levelInstructionsView = [[EatbeansInstructionView alloc] initWithFrame:CGRectMake(0,160,240,320)];	
	else if (self.currentGame == k3in1)
		levelInstructionsView = [[the3in1InstructionView alloc] initWithFrame:CGRectMake(0,160,240,320)];	
	else if (self.currentGame == kburgerseq)
		levelInstructionsView = [[BurgerseqInstructionView alloc] initWithFrame:CGRectMake(0,160,240,320)];
	else if (self.currentGame == kjumpinggirl)
		levelInstructionsView = [[JumpingGirlInstructionView alloc] initWithFrame:CGRectMake(0,160,240,320)];
	else if (self.currentGame == k3bo)
		levelInstructionsView = [[the3boInstructionView alloc] initWithFrame:CGRectMake(0,160,240,320)];
	else if (self.currentGame == ksmallnumber)
		levelInstructionsView = [[SmallnumberInstructionView alloc] initWithFrame:CGRectMake(0,160,240,320)];
	else if (self.currentGame == kufo)
		levelInstructionsView = [[UFOInstructionView alloc] initWithFrame:CGRectMake(0,160,240,320)];
	else if (self.currentGame == kburgerset)
		levelInstructionsView = [[BurgersetInstructionView alloc] initWithFrame:CGRectMake(0,160,240,320)];
	else if (self.currentGame == kbignumber)
		levelInstructionsView = [[BignumberInstructionView alloc] initWithFrame:CGRectMake(0,160,240,320)];		
	else if (self.currentGame == kalarmclock)
		levelInstructionsView = [[AlarmClockInstructionView alloc] initWithFrame:CGRectMake(0,160,240,320)];		
	else if (self.currentGame == kdancing)
		levelInstructionsView = [[DancingInstructionView alloc] initWithFrame:CGRectMake(0,160,240,320)];		
	else if (self.currentGame == kbunhill)
		levelInstructionsView = [[BunHillInstructionView alloc] initWithFrame:CGRectMake(0,160,240,320)];		
	else if (self.currentGame == kpencil)
		levelInstructionsView = [[QuickPencilInstructionView alloc] initWithFrame:CGRectMake(0,160,240,320)];		
	self.levelInstructionsView = levelInstructionsView;
	[levelInstructionsView release];
	/*
	NSString *fileNameString = [[constantsInstance getGameTransitionScreenDictionary] objectForKey:[NSNumber numberWithInt:self.currentGame]];
	fileNameString = [fileNameString stringByAppendingString:@".png"];
	UIImage *image1 = [[UIImage imageNamed:fileNameString] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
	levelInstructionsImageView = [[UIImageView alloc] initWithFrame:levelInstructionsImageViewRectP];
	levelInstructionsImageView.image = image1;
	*/
	self.levelInstructionsView.frame = levelInstructionsViewRectP;
	[self.mainView addSubview:self.levelInstructionsView];
	
	/* for one player mode, without auto play */
	if ([self.delegate gameType] != one_player_arcade && [self.delegate gameType] != one_player_level_select)				
		[self performSelector:@selector(hideTransitionInGameTitle) withObject:nil afterDelay:12];
	
	[self addSubview:self.mainView];
	[sharedSoundEffectsManager playTransitionInstruction];
	[sharedSoundEffectsManager playDramaticAccentSound];

	[self.levelInstructionsView startScenarios];	
	
}


- (id)initWithFrame:(CGRect)frameRect{
    self = [super initWithFrame:frameRect];
	/*
	SnowFlakeView* snowFlakeView = [[SnowFlakeView alloc] initWithFrame:frameRect];
	self.snowFlakeView = snowFlakeView;
	[snowFlakeView release];
	[self addSubview:self.snowFlakeView];
	[self.snowFlakeView initSnowFlakes];
	[self addSubview:self.snowFlakeView];
	 */
	return self;
}	

- (id)init{
    self = [super init];
	self.orientation = UIInterfaceOrientationPortrait;
	sharedSoundEffectsManager = [MediaManager sharedInstance];
	constantsInstance = [Constants sharedInstance];
	[self setBackgroundColor:[UIColor blackColor]];
//	[self initSnowFlakes];
	return self;
	
}

- (void)showTransitionOut{
	/*
	if (self.mainView){
		[self.mainView removeFromSuperview];
	}
    CGRect screenBounds = [ [ UIScreen mainScreen ] bounds ];
	UIView* mainView = [[UIView alloc]initWithFrame:screenBounds];
	self.mainView = mainView;
	[mainView release];
	[self.mainView setBackgroundColor:[UIColor blackColor]];
	
	transitionOutTitleLabel = [[UILabel alloc] initWithFrame:transitionOutTitleLabelRectP];
	transitionOutTitleLabel.textAlignment = UITextAlignmentCenter;
	[transitionOutTitleLabel setFont:[UIFont systemFontOfSize:44]];
	[transitionOutTitleLabel setText:@"過版了!!"];
	
	transitionOutTitleLabel.textColor = [UIColor whiteColor];
	transitionOutTitleLabel.backgroundColor = [UIColor clearColor];
	transitionOutTitleLabel.shadowColor = [UIColor blackColor];
	transitionOutTitleLabel.shadowOffset = CGSizeMake(2, 2);
	[self.mainView addSubview:transitionOutTitleLabel];
	[transitionOutTitleLabel release];
	

	transitionOutScoreLabel = [[UILabel alloc] initWithFrame:transitionOutScoreLabelRectP];
	transitionOutScoreLabel.textAlignment = UITextAlignmentCenter;
	[transitionOutScoreLabel setFont:[UIFont systemFontOfSize:30]];
	
	NSString *scoreString = @"分數:";
	scoreString = [scoreString stringByAppendingFormat:@"%i", self.levelScore];
	[transitionOutScoreLabel setText:scoreString];
	transitionOutScoreLabel.textColor = [UIColor whiteColor];
	transitionOutScoreLabel.backgroundColor = [UIColor clearColor];
	transitionOutScoreLabel.shadowColor = [UIColor blackColor];
	transitionOutScoreLabel.shadowOffset = CGSizeMake(2, 2);
	[self.mainView addSubview:transitionOutScoreLabel];
	[transitionOutScoreLabel release];
	
	
	[self addSubview:self.mainView];
	[self.mainView release];
	[self performSelector:@selector(hideTransitionOut) withObject:nil afterDelay:4];
	*/
}


- (void)showTransitionInGameTitle{
	[self showLevelInfo];
}


- (void)hideTransitionInGameTitle{
	[NSObject cancelPreviousPerformRequestsWithTarget:self.levelInstructionsView];
	if ([self.levelInstructionsView isKindOfClass:[AlarmClockInstructionView class]])	{
		[self.levelInstructionsView setToQuit:YES];
		[[self.levelInstructionsView theTimer]invalidate];
	}
	[self.levelInstructionsView removeFromSuperview];
	self.levelInstructionsView = nil;
	
	[delegate finishedTransitionIn];
}

- (void)hideTransitionOut{
	[delegate finishedTransitionOut];
}

- (void) dealloc	{
	NSLog(@"dealloc TransitionView");
	self.snowFlakeView = nil;
	self.note = nil;
	self.pentagonChart = nil;
	self.polaroid = nil;
	self.iAdBannerView.delegate = nil;
	self.iAdBannerView = nil;
	self.infoBut = nil;
	self.mapBut = nil;
	self.toPlayBtn = nil;
	self.toPlayLbl = nil;
	self.levelInfoLevelScriptsLabel = nil;
	self.levelInstructionsGameInstructionsLabels = nil;
	self.levelInstructionsView=nil;
	self.levelInfoLevelNumberLabel=nil;
	self.levelInfoLevelNameLabel=nil;
	self.levelInstructionsTitleLabel=nil;
	self.mainView= nil;
	self.adMobView = nil;
	
	[super dealloc];
}

- (void) toPlayBtnClicked:(id)sender {
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	if ([sender tag] == 0)	{
		[self showLevelInstructions];
	}
	else if ([sender tag] == 1)	{
		[self hideTransitionInGameTitle];
	}
}

#ifdef LITE_VERSION
#pragma mark -
#pragma mark ADBannerViewDelegate
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
	if (!willLeave)
		return YES;
	else {
		UIDevice* device = [UIDevice currentDevice];
		if ([device respondsToSelector:@selector(isMultitaskingSupported)]){
			return YES;
		}
		else
			return NO;
	}
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
		// assumes the banner view is offset 50 pixels so that it is not visible.
        banner.frame = CGRectOffset(banner.frame, 0, 50);
        [UIView commitAnimations];
        self.bannerIsVisible = YES;
		
		// hide admob
		if (self.adMobView != nil){
			[self.adMobView removeFromSuperview];  // Not necessary since never added to a view, but doesn't hurt and is good practice
			[self.adMobView release];
			self.adMobView = nil;
			self.admobBannerIsVisible = NO;
		}
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	NSLog(@"iAd didFailToReceiveAdWithError...");
	if ((self.bannerIsVisible) && (!self.admobBannerIsVisible))
    {
		NSLog(@"hide iAd banner, show admob banner instead");
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
		// assumes the banner view is at the top of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, -50);
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
		
		self.adMobView = [AdMobView requestAdWithDelegate:self];
		[self.adMobView retain];
        self.admobBannerIsVisible = YES;
		
    }else if ((!self.bannerIsVisible) && (!self.admobBannerIsVisible)){
		NSLog(@"iAd banner wasn't shown anyways, show admob banner directly");
		self.adMobView = [AdMobView requestAdWithDelegate:self];
		[self.adMobView retain];
		self.admobBannerIsVisible = YES;
	
	}else if (self.admobBannerIsVisible){
		NSLog(@"admob banner is now showing, do nothing");
	}
		
}
#endif



#pragma mark -
#pragma mark AdMobDelegate methods

- (NSString *)publisherIdForAd:(AdMobView *)adView {
	return @"a14c999e3ad241c"; // this should be prefilled; if not, get it from www.admob.com
}

- (UIViewController *)currentViewControllerForAd:(AdMobView *)adView {
	return self.delegate;
}

- (UIColor *)adBackgroundColorForAd:(AdMobView *)adView {
	return [UIColor colorWithRed:1 green:0.569 blue:0.098 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

- (UIColor *)primaryTextColorForAd:(AdMobView *)adView {
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

- (UIColor *)secondaryTextColorForAd:(AdMobView *)adView {
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

- (BOOL)useTestAd{
	return [Constants showTestAdmobAds];
}

- (BOOL)refreshAd:(NSTimer*)timer{
	[self requestFreshAd];
}



// Sent when an ad request loaded an ad; this is a good opportunity to attach
// the ad view to the hierachy.
- (void)didReceiveAd:(AdMobView *)adView {
	// get the view frame
	CGRect frame = self.frame;
	
	// put the ad at the bottom of the screen
//	self.adMobView.frame = CGRectMake(0, frame.size.height - 48, frame.size.width, 48);
	
	// assumes the banner view is at the top of the screen.
	self.adMobView.frame = CGRectMake(0, 0, frame.size.width, 48);
	
	
	[self addSubview:self.adMobView];
	
	
}

// Sent when an ad request failed to load an ad
- (void)didFailToReceiveAd:(AdMobView *)adView {
	[self.adMobView removeFromSuperview];  // Not necessary since never added to a view, but doesn't hurt and is good practice
	[self.adMobView release];
	self.adMobView = nil;
	self.admobBannerIsVisible = NO;

	// we could start a new ad request here, but in the interests of the user's battery life, let's not
}


@end
