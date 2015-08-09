    //
//  PentagonChartViewController.m
//  bishibashi
//
//  Created by Eric on 22/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PentagonChartViewController.h"


@implementation PentagonChartViewController
@synthesize theChart = _theChart;
@synthesize titleLabel = _titleLabel;
@synthesize totalScore = _totalScore;
@synthesize rank = _rank;
@synthesize redBut = _redBut;
@synthesize greenBut = _greenBut;
@synthesize blueBut = _blueBut;
@synthesize gameView = _gameView;
@synthesize bottomPanel = _bottomPanel;
@synthesize nickNames = _nickNames;
@synthesize gameFrame = _gameFrame;
@synthesize polaroid = _polaroid;
@synthesize note = _note;
@synthesize redLabel = _redLabel;

@synthesize socialPanel = _socialPanel;

@synthesize exitBut = _exitBut;
@synthesize infoBut = _infoBut;
@synthesize globeBut = _globeBut;
@synthesize soundBut = _soundBut;
@synthesize socialBut = _socialBut;

@synthesize submitPanel = _submitPanel;
@synthesize replayPanel = _replayPanel;
@synthesize submitScoreBut = _submitScoreBut;
@synthesize readScoreBut = _readScoreBut;
@synthesize gcBut = _gcBut;
@synthesize replayBut = _replayBut;
@synthesize homeBut = _homeBut;

@synthesize submitAi = _submitAi;

static const CGRect avgRect={{70,235},{120,25}};
static const CGRect rankRect = {{190,235},{120,25}};
static const CGRect titleRect= {{65,45},{150,35}};
static const CGRect pentagonChartRect = {{80,90},{160, 150}};

static const CGRect socialButRect = {{250, 20}, {25,25}};
static const CGRect soundButRect = {{280, 20}, {25,25}};
static const CGRect infoButRect = {{190, 20}, {25,25}};
static const CGRect globeButRect = {{220, 20}, {25,25}};
static const CGRect exitButRect = {{25, 20}, {25,25}};

static const CGRect noteRect = {{15, 60}, {290,348}};
static const CGRect redLabelRect = {{50, 45}, {200,37}};
static const CGRect polaroidRect = {{45, 25}, {200,180}};

static const CGRect redButRect = {{20, 400}, {80, 80}};
static const CGRect greenButRect = {{120, 400}, {80, 80}};
static const CGRect blueButRect = {{220, 400}, {80, 80}};

static const CGRect submitPanelRect = {{15,400}, {291,80}};
static const CGRect replayPanelRect = {{15,400}, {291,80}};

static const CGRect socialPanelRectP = {{15, 45}, {291, 40}};


-(id) initWithScore:(int)score AndScores:(NSArray*)scores AndNumGame:(int)numGames AndGameView:(id) gameView AndPass:(BOOL)pass{
	self = [ super init ];
	
	[self setGameFrame];
	self.gameView = gameView;

	self.view.backgroundColor = [UIColor darkGrayColor];

	UILabel* titleLabel = [[UILabel alloc] initWithFrame:titleRect];
	titleLabel.font = [UIFont boldSystemFontOfSize:16];
	if (pass)
		titleLabel.text = NSLocalizedString(@"完成街機模式",nil);
	else
		titleLabel.text = NSLocalizedString(@"未能完成街機模式",nil);
	titleLabel.textAlignment = UITextAlignmentLeft;
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.backgroundColor = [UIColor clearColor];
	self.titleLabel = titleLabel;
	[titleLabel release];
	[self.view addSubview:self.titleLabel];

	PentagonChart* theChart = [[PentagonChart alloc] initWithFrame:pentagonChartRect AndScores:scores 
													AndTotalScores:[[Constants sharedInstance] attributeTotalScoresArray] 
													AndScoreLabels:[[Constants sharedInstance] attributesArray]
													AndShowRank:YES];
	self.theChart = theChart;
	[theChart release];
	[self.view addSubview:self.theChart];
	
	NSMutableArray* hasNickNames = [LocalStorageManager customObjectForKey:NICKNAME];
	if (hasNickNames == NULL)	{
		hasNickNames = [NSMutableArray arrayWithCapacity:6];
		for (int j=0; j<6; j++)	{
			[hasNickNames addObject:[NSNumber numberWithInt:0]]; //0 - no, 1 - grey, 2 - master
		}
	}

	NSDictionary* _nickNamePinsArray = [NSDictionary dictionaryWithObjectsAndKeys:	@"speed", NSLocalizedString(@"閃電手",nil), 
																					@"reaction",NSLocalizedString(@"反應王",nil),  
																					@"brain",NSLocalizedString(@"轉數高",nil),
																					@"commander",NSLocalizedString(@"指揮官",nil),
																					@"bit",NSLocalizedString(@"啱BIT霸",nil),
																					@"overall",NSLocalizedString(@"全能俠",nil),  nil];

	for (int i=0; i<[scores count]; i++)	{
		NSArray* totalscores = [[Constants sharedInstance] attributeTotalScoresArray];
		NSString* nickname = [[[Constants sharedInstance] nickNamesArray] objectAtIndex:i];
		NSLog(@"nickname is %@", nickname);
		NSLog(@"nickname filename is %@", [_nickNamePinsArray objectForKey:nickname] );
		
				
		
		float attributeScore;
		if (fabs([[totalscores objectAtIndex:i] floatValue])<0.00001)
			attributeScore = 0.0;
		else
			attributeScore = [[scores objectAtIndex:i] floatValue] / [[totalscores objectAtIndex:i] floatValue];

		UIImageView* imageView;
		
		if (attributeScore >=70)	{
			imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:[[[Constants sharedInstance]arcadeAchievementsArray] objectAtIndex:i] ofType:@"png"]]];
//			[self stampCollected:i];
			[hasNickNames replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:2]];
		//	label.textColor = [UIColor orangeColor];
			/* submit Master achievement */
			
			 if ([[Constants sharedInstance] gameCenterEnabled])	{
				 NSLog(@"submitting beginner pin ");
				 NSString* achievementId = [NSString stringWithFormat:@"%@%Master", [[Constants sharedInstance] appVersionPrefix], [[[Constants sharedInstance] arcadeAchievementsArray] objectAtIndex:i]];
				 GKAchievement* myAchievement = [[[GKAchievement alloc] initWithIdentifier:achievementId] autorelease];
				 myAchievement.percentComplete = 100;
				 [myAchievement reportAchievementWithCompletionHandler:^(NSError *error)	{NSLog(@"finished submitting");}];
			 }
			 
			
		}
		else if (attributeScore >=35)	{
			imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource: [NSString stringWithFormat:@"%@%@",[[[Constants sharedInstance]arcadeAchievementsArray] objectAtIndex:i],@"grey"] ofType:@"png"]]];
			//			[self stampCollected:i];
			if ([[hasNickNames objectAtIndex:i] intValue]==0)	{
				[hasNickNames replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:1]];
				/* submit Master achievement */
				
				if ([[Constants sharedInstance] gameCenterEnabled])	{
					NSLog(@"submitting beginner pin ");
					NSString* achievementId = [NSString stringWithFormat:@"%@%@Beginner", [[Constants sharedInstance] appVersionPrefix], [[[Constants sharedInstance] arcadeAchievementsArray] objectAtIndex:i]];
					GKAchievement* myAchievement = [[[GKAchievement alloc] initWithIdentifier:achievementId] autorelease];
					myAchievement.percentComplete = 100;
					[myAchievement reportAchievementWithCompletionHandler:^(NSError *error)	{NSLog(@"finished submitting");}];
				}
			}				
		}
		else {
			imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"question" ofType:@"png"]]];
		}

		imageView.frame = CGRectMake((i%3)*70+65, 270+(int)(i/3)*60, 60,60);		
		[self.nickNames addObject:imageView];
		[self.view addSubview:imageView];
		[imageView release];

		if (attributeScore>=70)	{
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((i%3)*70+95, 265+(int)(i/3)*60, 45,25)];
			label.text = [[[Constants sharedInstance] nickNamesArray] objectAtIndex:i];
			label.numberOfLines = 2;
			label.textAlignment = UITextAlignmentCenter;
			label.font = [UIFont systemFontOfSize:9];
			label.textColor = [UIColor whiteColor];
			label.backgroundColor = [UIColor orangeColor];
			label.transform = CGAffineTransformMakeRotation(radians((float)(arc4random()%10-5.0+35.0)));
			[self.view addSubview:label];
		}
		else if (attributeScore>=35)	{
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((i%3)*70+95, 265+(int)(i/3)*60, 45,25)];
			label.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"見習\n", nil), [[[Constants sharedInstance] nickNamesArray] objectAtIndex:i]];
			label.numberOfLines = 2;
			label.textAlignment = UITextAlignmentCenter;
			label.font = [UIFont systemFontOfSize:9];
			label.textColor = [UIColor whiteColor];
			label.backgroundColor = [UIColor orangeColor];
			label.transform = CGAffineTransformMakeRotation(radians((float)(arc4random()%10-5.0+35.0)));
			[self.view addSubview:label];
		}
		
		//	 [self.nickNames addObject:label];
		
		/*
		else if ([[hasNickNames objectAtIndex:i] boolValue] == YES)
			label.textColor = [UIColor whiteColor];

		[label release];
		 */
	}
	
	UIImageView* imageView;
	if (score/numGames >=70)	{
		[hasNickNames replaceObjectAtIndex:5 withObject:[NSNumber numberWithInt:2]];
		imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"overall" ofType:@"png"]]];
							  imageView.frame = CGRectMake((5%3)*70+65, 270+(int)(5/3)*60, 60,60);
	}
	else if (score/numGames >=35)	{
		if ([[hasNickNames objectAtIndex:5] intValue]==0)
			[hasNickNames replaceObjectAtIndex:5 withObject:[NSNumber numberWithInt:1]];
		imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"overallgrey" ofType:@"png"]]];
		imageView.frame = CGRectMake((5%3)*70+65, 270+(int)(5/3)*60, 60,60);
	}
	else	{
		imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"question" ofType:@"png"]]];
							imageView.frame = CGRectMake((5%3)*70+65, 270+(int)(5/3)*60, 60,60);
	}
		 
	[self.nickNames addObject:imageView];
	[self.view addSubview:imageView];
	[imageView release];

	if (score/numGames>=70)	{
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((5%3)*70+95, 265+(int)(5/3)*60, 45,25)];
		label.text = [[[Constants sharedInstance] nickNamesArray] objectAtIndex:5];
		label.numberOfLines = 2;
		label.textAlignment = UITextAlignmentCenter;
		label.font = [UIFont systemFontOfSize:9];
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor orangeColor];
		label.transform = CGAffineTransformMakeRotation(radians((float)(arc4random()%10-5.0+35.0)));
		//	 [self.nickNames addObject:label];
		[self.view addSubview:label];
	}
	else if (score/numGames>=35)	{
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((5%3)*70+95, 265+(int)(5/3)*60, 45,25)];
		label.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"見習\n", nil), [[[Constants sharedInstance] nickNamesArray] objectAtIndex:5]];
		label.numberOfLines = 2;
		label.textAlignment = UITextAlignmentCenter;
		label.font = [UIFont systemFontOfSize:9];
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor orangeColor];
		label.transform = CGAffineTransformMakeRotation(radians((float)(arc4random()%10-5.0+35.0)));
		//	 [self.nickNames addObject:label];
		[self.view addSubview:label];
	}
	
	
	[LocalStorageManager setCustomObject:hasNickNames forKey:NICKNAME];
	
	
	
	UILabel* totalScore = [[UILabel alloc] initWithFrame:avgRect];
	totalScore.backgroundColor = [UIColor clearColor];
	totalScore.font = [UIFont boldSystemFontOfSize:16];
	totalScore.text = [NSString stringWithFormat:@"%@%.1f",NSLocalizedString(@"平均分數:",nil), (float)(score/numGames)];
	totalScore.textColor = [UIColor purpleColor];
	self.totalScore = totalScore;
	[totalScore release];
	[self.view addSubview:self.totalScore];
	
	[[self.gameView scoreView] saveScore];
	[[[self.gameView scoreView] theGameRecord] setScore:(int)(score/numGames)];
	


	UILabel* rank = [[UILabel alloc] initWithFrame:rankRect];
	rank.backgroundColor = [UIColor clearColor];
	rank.font = [UIFont boldSystemFontOfSize:16];
	if (score/numGames>=80)
		rank.text=[NSString stringWithFormat:@"%@ S",NSLocalizedString(@"等級:",nil)];
	else if (score/numGames >=70)
		rank.text=[NSString stringWithFormat:@"%@ A",NSLocalizedString(@"等級:",nil)];
	else if (score/numGames >=60)
		rank.text=[NSString stringWithFormat:@"%@ B",NSLocalizedString(@"等級:",nil)];
	else if (score/numGames >=50)
		rank.text=[NSString stringWithFormat:@"%@ C",NSLocalizedString(@"等級:",nil)];
	else if (score/numGames >=40)
		rank.text=[NSString stringWithFormat:@"%@ D",NSLocalizedString(@"等級:",nil)];
	else if (score/numGames >=30)
		rank.text=[NSString stringWithFormat:@"%@ E",NSLocalizedString(@"等級:",nil)];
	else
		rank.text=[NSString stringWithFormat:@"%@ F",NSLocalizedString(@"等級:",nil)];
	rank.textColor = [UIColor purpleColor];
	self.rank = rank;
	[rank release];
	[self.view addSubview:self.rank];
	

	
		
	self.redBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.redBut setBackgroundImage:[UIImage imageNamed:@"redbutton.png"] forState:UIControlStateNormal];
	[self.redBut setBackgroundImage:[UIImage imageNamed:@"redbutton_pressed.png"] forState:UIControlStateHighlighted];
	self.redBut.frame = redButRect;
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin.png"]];
	tmpView.frame = CGRectMake(29, 24, 25,25);
	[self.redBut addSubview:tmpView];
	[tmpView release];
	
	self.greenBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.greenBut setBackgroundImage:[UIImage imageNamed:@"greenbutton.png"] forState:UIControlStateNormal];
	[self.greenBut setBackgroundImage:[UIImage imageNamed:@"greenbutton_pressed.png"] forState:UIControlStateHighlighted];
	self.greenBut.frame = greenButRect;
	tmpView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"submit.png"]];
	tmpView.frame = CGRectMake(29, 24, 25,25);
	[self.greenBut addSubview:tmpView];
	[tmpView release];
	
	self.blueBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.blueBut setBackgroundImage:[UIImage imageNamed:@"bluebutton.png"] forState:UIControlStateNormal];
	[self.blueBut setBackgroundImage:[UIImage imageNamed:@"bluebutton_pressed.png"] forState:UIControlStateHighlighted];
	self.blueBut.frame = blueButRect;
	tmpView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"replay.png"]];
	tmpView.frame = CGRectMake(29, 24, 25,25);
	[self.blueBut addSubview:tmpView];
	[tmpView release];
	
	
	[self.redBut addTarget:self action:@selector(pinClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.greenBut addTarget:self action:@selector(toggleSubmitPanel) forControlEvents:UIControlEventTouchUpInside];
	[self.blueBut addTarget:self action:@selector(toggleReplayPanel) forControlEvents:UIControlEventTouchUpInside];

	
	[self.view addSubview:self.redBut];
	[self.view addSubview:self.greenBut];
	[self.view addSubview:self.blueBut];	
	
	[self initIcons];
	
	return self;
}

- (void) initIcons
{
	SocialPanel *socialPanel = [[SocialPanel sharedInstance] initWithFrame:socialPanelRectP WithMsgBoard:nil AndOwner:self];
	self.socialPanel = socialPanel;
	[socialPanel release];
	
	self.infoBut = [UIButton buttonWithType:UIButtonTypeCustom];
	self.infoBut.frame = infoButRect;
	[self.infoBut setImage:[UIImage imageNamed:@"video.png"] forState:UIControlStateNormal];
	[self.view addSubview:self.infoBut];
	[self.infoBut addTarget:self action:@selector(videoButClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.infoBut addTarget:self action:@selector(infoButTapped) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
	[self.infoBut addTarget:self action:@selector(infoButUnTapped) forControlEvents:UIControlEventTouchDragOutside|UIControlEventTouchDragExit|UIControlEventTouchUpOutside|UIControlEventTouchUpInside];

	self.globeBut = [UIButton buttonWithType:UIButtonTypeCustom];
	self.globeBut.frame = globeButRect;
	[self.globeBut setImage:[UIImage imageNamed:@"globe.png"] forState:UIControlStateNormal];
	[self.view addSubview:self.globeBut];
	[self.globeBut addTarget:self action:@selector(globeButClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.globeBut addTarget:self action:@selector(globeButTapped) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
	[self.globeBut addTarget:self action:@selector(globeButUnTapped) forControlEvents:UIControlEventTouchDragOutside|UIControlEventTouchDragExit|UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
	
	self.exitBut = [UIButton buttonWithType:UIButtonTypeCustom];
	self.exitBut.frame = exitButRect;
	self.exitBut.backgroundColor = [UIColor clearColor];
	[self.exitBut setImage:[UIImage imageNamed:@"exit.png"] forState:UIControlStateNormal];
	[self.view addSubview:self.exitBut];
	[self.exitBut addTarget:self action:@selector(exitButClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.exitBut addTarget:self action:@selector(exitButTapped) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
	[self.exitBut addTarget:self action:@selector(exitButUnTapped) forControlEvents:UIControlEventTouchDragOutside|UIControlEventTouchDragExit|UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
	
	self.socialBut = [UIButton buttonWithType:UIButtonTypeCustom];
	self.socialBut.frame = socialButRect;
	self.socialBut.backgroundColor = [UIColor clearColor];
	[self.socialBut setImage:[UIImage imageNamed:@"social.png"] forState:UIControlStateNormal];
	[self.view addSubview:self.socialBut];
	[self.socialBut addTarget:self action:@selector(socialButClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.socialBut addTarget:self action:@selector(socialButTapped) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
	[self.socialBut addTarget:self action:@selector(socialButUnTapped) forControlEvents:UIControlEventTouchDragOutside|UIControlEventTouchDragExit|UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
	
	self.soundBut = [UIButton buttonWithType:UIButtonTypeCustom];
	self.soundBut.frame = soundButRect;		
	self.soundBut.backgroundColor = [UIColor clearColor];
	if (![LocalStorageManager boolForKey:SOUNDOFF]){
		[self.soundBut setImage:[UIImage imageNamed:@"soundon.png"] forState:UIControlStateNormal];
	}else{
		[self.soundBut setImage:[UIImage imageNamed:@"soundoff.png"] forState:UIControlStateNormal];
	}
	[self.view addSubview:self.soundBut];
	[self.soundBut addTarget:self action:@selector(soundButClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.soundBut addTarget:self action:@selector(soundButTapped) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
	[self.soundBut addTarget:self action:@selector(soundButUnTapped) forControlEvents:UIControlEventTouchDragOutside|UIControlEventTouchDragExit|UIControlEventTouchUpOutside|UIControlEventTouchUpInside];

	UIImageView* panel = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"expandbox" ofType:@"png"]]];
	self.submitPanel = panel;
	[self.submitPanel setUserInteractionEnabled:YES];
	[panel release];
	self.submitPanel.frame = submitPanelRect;
	[self.view addSubview:self.submitPanel];
	if ([[Constants sharedInstance] gameCenterEnabled]) {
		self.gcBut = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.gcBut setImage:[UIImage imageNamed:@"gamecenter_icon.png"] forState:UIControlStateNormal];
		self.gcBut.frame = CGRectMake(230, 20, 40,40);
		[self.submitPanel addSubview:self.gcBut];
		[self.gcBut addTarget:self action:@selector(gcIconClicked) forControlEvents:UIControlEventTouchUpInside];
		[self.gcBut addTarget:self action:@selector(gcButTapped) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
		[self.gcBut addTarget:self action:@selector(gcButUnTapped) forControlEvents:UIControlEventTouchDragOutside|UIControlEventTouchDragExit|UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
	}
	self.submitScoreBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.submitScoreBut setBackgroundImage:[UIImage imageNamed:@"submit.png"] forState:UIControlStateNormal];
	[self.submitScoreBut addTarget:self action:@selector(submitScoreButClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.submitScoreBut addTarget:self action:@selector(submitScoreButTapped) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
	[self.submitScoreBut addTarget:self action:@selector(submitScoreButUnTapped) forControlEvents:UIControlEventTouchDragOutside|UIControlEventTouchDragExit|UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
	self.submitScoreBut.frame = CGRectMake(130, 20, 30,30);
	[self.submitPanel addSubview:self.submitScoreBut];
	
	self.readScoreBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.readScoreBut setBackgroundImage:[UIImage imageNamed:@"leaderboard.png"] forState:UIControlStateNormal];
	[self.readScoreBut addTarget:self action:@selector(readScoreButClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.readScoreBut addTarget:self action:@selector(readScoreButTapped) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
	[self.readScoreBut addTarget:self action:@selector(readScoreButUnTapped) forControlEvents:UIControlEventTouchDragOutside|UIControlEventTouchDragExit|UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
	self.readScoreBut.frame = CGRectMake(30, 20, 30,30);
	[self.submitPanel addSubview:self.readScoreBut];
	[self.submitPanel setHidden:YES];
	
	panel = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"expandbox" ofType:@"png"]]];
	self.replayPanel = panel;
	[self.replayPanel setUserInteractionEnabled:YES];
	[panel release];
	self.replayPanel.frame = replayPanelRect;
	[self.view addSubview:self.replayPanel];
	self.replayBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.replayBut setBackgroundImage:[UIImage imageNamed:@"replay.png"] forState:UIControlStateNormal];
	[self.replayBut addTarget:self action:@selector(playAgainButClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.replayBut addTarget:self action:@selector(replayButTapped) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
	[self.replayBut addTarget:self action:@selector(replayButUnTapped) forControlEvents:UIControlEventTouchDragOutside|UIControlEventTouchDragExit|UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
	self.replayBut.frame = CGRectMake(200, 20, 30,30);
	[self.replayPanel addSubview:self.replayBut];
	
	self.homeBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.homeBut setBackgroundImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
	[self.homeBut addTarget:self action:@selector(leaveGame) forControlEvents:UIControlEventTouchUpInside];
	[self.homeBut addTarget:self action:@selector(homeButTapped) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
	[self.homeBut addTarget:self action:@selector(homeButUnTapped) forControlEvents:UIControlEventTouchDragOutside|UIControlEventTouchDragExit|UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
	[self.homeBut setUserInteractionEnabled:YES];
	self.homeBut.frame = CGRectMake(50, 20, 30,30);
	[self.replayPanel addSubview:self.homeBut];
	[self.replayPanel setHidden:YES];
	
}

-(void) videoButClicked
{
	[self setTitle:NSLocalizedString(@"遊戲",nil)];
	VideoTableViewController* theConfigView = [[VideoTableViewController alloc]initWithPage:-1];
	[[self navigationController] pushViewController:theConfigView animated:YES];	
	[theConfigView release];	
}

-(void) globeButClicked
{
	[self setTitle:NSLocalizedString(@"遊戲",nil)];
	AroundTheWorldViewController* theConfigView = [[AroundTheWorldViewController alloc]init];
	[[self navigationController] pushViewController:theConfigView animated:YES];	
	[theConfigView release];
	
}


-(void) playAgainButClicked
{
	[[self.gameView owner] init];
	[[self.gameView owner] setIsShowingGameView:NO];
	[[self.gameView owner] setLifes:3];
	[[self.gameView owner] setTotalScore:0];
	[[self.gameView owner] setRoundNo:1];
	[[self.gameView owner] setNumRoundWin:0];
	[[self.gameView owner] setNumRoundLose:0];
	
	[[Constants sharedInstance] clearAttributeScores];
	
	if ([[self.gameView owner] isLite])
		[[self.gameView owner] setTheGame:[[Constants sharedInstance]firstGameForMode:kArcadeLite]];	
	else
		[[self.gameView owner] setTheGame:[[Constants sharedInstance]firstGameForMode:kArcade]];	
	[[self.gameView owner] setGameType:one_player_arcade];
	[[self.gameView owner] setTheMainView:nil];
	[[self.gameView owner] loadView];
	[self.navigationController popViewControllerAnimated:YES];

}

-(void) stampCollected:(int)idx
{
	Pin* thePin =nil;
	NSMutableArray* pins = [NSMutableArray arrayWithArray:[LocalStorageManager customObjectForKey:OTHERPIN]];
		
	thePin = [[Pin alloc] initWithGame:idx+OTHERPINBOUNDARY AndPinLevel:kMaster];
		
	
	/* no need to add / submit if there is already master pin collected */
	if ([pins indexOfObject:thePin]!=NSNotFound)	{
		[thePin release];
		thePin = nil;
	}
	else{
		Pin* theBeginnerPin = [[Pin alloc] initWithGame:idx+OTHERPINBOUNDARY AndPinLevel:kIntermediate];
		/* add beginner pin together */
		if ([pins indexOfObject:theBeginnerPin]==NSNotFound)	{
			[pins addObject:theBeginnerPin];
			[theBeginnerPin release];
			/* submit beginner achievement */
			/*
			if ([[Constants sharedInstance] gameCenterEnabled])	{
				NSLog(@"submitting beginner pin ");
				NSString* achievementId = [NSString stringWithFormat:@"%@%@Beginner", [[Constants sharedInstance] appVersionPrefix], [[[Constants sharedInstance] gameAchievementsArray] objectAtIndex:self.game]];
				GKAchievement* myAchievement = [[[GKAchievement alloc] initWithIdentifier:achievementId] autorelease];
				myAchievement.percentComplete = 100;
				[myAchievement reportAchievementWithCompletionHandler:^(NSError *error)	{NSLog(@"finished submitting");}];
			}
			 */
		}
		
		/* submit master achievement */
		/*
		if ([[Constants sharedInstance] gameCenterEnabled])	{
			NSLog(@"submitting master pin ");
			NSString* achievementId = [NSString stringWithFormat:@"%@%@Master", [[Constants sharedInstance] appVersionPrefix], [[[Constants sharedInstance] gameAchievementsArray] objectAtIndex:self.game]];
			GKAchievement* myAchievement = [[[GKAchievement alloc] initWithIdentifier:achievementId] autorelease];
			myAchievement.percentComplete = 100;
			[myAchievement reportAchievementWithCompletionHandler:^(NSError *error)	{NSLog(@"finished submitting");}];
		}
		 */
	}
}


-(void) exitButTapped
{
	self.exitBut.transform = CGAffineTransformMakeScale(2.0, 2.0);
	[self socialButUnTapped];
	[self soundButUnTapped];
	[self infoButUnTapped];
	[self globeButUnTapped];
}

-(void) exitButUnTapped
{
	//	[UIView animateWithDuration:0.1 animations:^{
	self.exitBut.transform = CGAffineTransformMakeScale(1.0,1.0);		
	//	}];
}

-(void) socialButTapped
{
	//	[UIView animateWithDuration:0.5 animations:^{
	//		self.socialBut.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(-self.socialBut.frame.size.width/4,-self.socialBut.frame.size.height/4), 1.5, 1.5);		
	self.socialBut.transform = CGAffineTransformMakeScale(2.0, 2.0);		
	[self soundButUnTapped];
	[self exitButUnTapped];
	[self infoButUnTapped];
	[self globeButUnTapped];
	//	}];
}

-(void) socialButUnTapped
{
	//	[UIView animateWithDuration:0.1 animations:^{
	self.socialBut.transform = CGAffineTransformMakeScale(1.0,1.0);		
	//	}];
}

-(void) globeButTapped
{
	self.globeBut.transform = CGAffineTransformMakeScale(2.0, 2.0);		
	[self soundButUnTapped];
	[self exitButUnTapped];
	[self infoButUnTapped];
	[self socialButUnTapped];
}

-(void) globeButUnTapped
{
	self.globeBut.transform = CGAffineTransformMakeScale(1.0,1.0);		
}


-(void) soundButTapped
{
	//	[UIView animateWithDuration:0.1 animations:^{
	self.soundBut.transform = CGAffineTransformMakeScale(2.0, 2.0);		
	[self socialButUnTapped];
	[self exitButUnTapped];
	[self infoButUnTapped];
	[self globeButUnTapped];
}

-(void) soundButUnTapped
{
	//	[UIView animateWithDuration:0.1 animations:^{
	self.soundBut.transform = CGAffineTransformMakeScale(1.0, 1.0);		
	//	}];
}

-(void) infoButTapped
{
	//	[UIView animateWithDuration:0.1 animations:^{
	self.infoBut.transform = CGAffineTransformMakeScale(2.0, 2.0);		
	[self soundButUnTapped];
	[self socialButUnTapped];
	[self exitButUnTapped];
	[self globeButUnTapped];
}

-(void) infoButUnTapped
{
	[UIView animateWithDuration:0.1 animations:^{
		self.infoBut.transform = CGAffineTransformMakeScale(1.0,1.0);		
	}];
}

- (void) exitButClicked
{
	// open an alert with just an OK button
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"離開遊戲",nil) 
													message:NSLocalizedString(@"確定離開遊戲？",nil)
												   delegate:self cancelButtonTitle:nil otherButtonTitles: NSLocalizedString(@"確定",nil),NSLocalizedString(@"取消",nil),nil];
	[alert show];	
	[alert release];
}

-(void) toggleSubmitPanel
{
	if ([self.submitPanel isHidden])	{
		[self.submitPanel setHidden:NO];
		[self.view bringSubviewToFront:self.submitPanel];
		[self.view bringSubviewToFront:self.gameFrame];
		[self.view bringSubviewToFront:self.blueBut];
		[self.view bringSubviewToFront:self.greenBut];
		[self.view bringSubviewToFront:self.redBut];
		[UIView animateWithDuration:0.5 animations:^{
			self.submitPanel.frame = CGRectOffset(self.submitPanel.frame, 0, -80);
		}];
	}
	else {
		[UIView animateWithDuration:1 animations:^{
			self.submitPanel.frame = CGRectOffset(self.submitPanel.frame, 0, 80);
		}
						 completion:^(BOOL finished){
							 [self.submitPanel setHidden:YES];				 
						 }];
	}
	
	
}

-(void) toggleReplayPanel
{
	if ([self.replayPanel isHidden])	{
		[self.replayPanel setHidden:NO];
		[self.view bringSubviewToFront:self.replayPanel];
		[self.view bringSubviewToFront:self.gameFrame];
		[self.view bringSubviewToFront:self.blueBut];
		[self.view bringSubviewToFront:self.greenBut];
		[self.view bringSubviewToFront:self.redBut];
		[UIView animateWithDuration:0.5 animations:^{
			self.replayPanel.frame = CGRectOffset(self.replayPanel.frame, 0, -80);
		}];
	}
	else {
		[UIView animateWithDuration:1 animations:^{
			self.replayPanel.frame = CGRectOffset(self.replayPanel.frame, 0, 80);
		}
						 completion:^(BOOL finished){
							 [self.replayPanel setHidden:YES];				 
						 }];		
	}
}


- (void)soundButClicked{
	if (![LocalStorageManager boolForKey:SOUNDOFF]){
		// turn sound off
		[LocalStorageManager setBool:YES forKey:SOUNDOFF];
		[self.soundBut setImage:[UIImage imageNamed:@"soundoff.png"] forState:UIControlStateNormal];
	}else{
		// turn sound on
		[LocalStorageManager setBool:NO forKey:SOUNDOFF];
		[self.soundBut setImage:[UIImage imageNamed:@"soundon.png"] forState:UIControlStateNormal];
	}
	
}

-(void) socialButClicked
{
	if ([self.socialPanel isDescendantOfView:self.view])	{
		[self.socialPanel disableButtons];
	}
	else	{
		[self.view addSubview:self.socialPanel];
		[self.socialPanel enableButtons];
	}	
}

-(void) gcButTapped
{
	self.gcBut.transform = CGAffineTransformMakeScale(2.0, 2.0);	
}

-(void) gcButUnTapped
{
	self.gcBut.transform = CGAffineTransformMakeScale(1.0, 1.0);	
}

-(void) readScoreButTapped
{
	self.readScoreBut.transform = CGAffineTransformMakeScale(2.0, 2.0);	
}

-(void) readScoreButUnTapped
{
	self.readScoreBut.transform = CGAffineTransformMakeScale(1.0, 1.0);	
}

-(void) submitScoreButTapped
{
	self.submitScoreBut.transform = CGAffineTransformMakeScale(2.0, 2.0);	
}

-(void) submitScoreButUnTapped
{
	self.submitScoreBut.transform = CGAffineTransformMakeScale(1.0, 1.0);	
}

-(void) replayButTapped
{
	self.replayBut.transform = CGAffineTransformMakeScale(2.0, 2.0);	
}

-(void) replayButUnTapped
{
	self.replayBut.transform = CGAffineTransformMakeScale(1.0, 1.0);	
}

-(void) homeButTapped
{
	self.homeBut.transform = CGAffineTransformMakeScale(2.0, 2.0);	
}

-(void) homeButUnTapped
{
	self.homeBut.transform = CGAffineTransformMakeScale(1.0, 1.0);	
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


-(void) leaveGame
{
	[self.navigationController popViewControllerAnimated:NO];
	[self.gameView leaveGame];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//	[sharedSoundEffectsManager playUFOFlyPassSound];
	if (buttonIndex == 0)
	{
		[self leaveGame];
	}
}

- (void) setGameFrame
{
	if (!self.gameFrame)	{
		NSString* gameFrame = [LocalStorageManager objectForKey:GAMEFRAME];
		if (gameFrame)	{
//			UIImageView* theView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"frame_%@2.png",gameFrame]]];
			UIImageView* theView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame_black.png"]];
			self.gameFrame = theView;
			[self.view addSubview:self.gameFrame];
			[theView release];
		}
	}
	if (!self.note)	{
		UIImageView* theView = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"note" ofType:@"png"]]];
		self.note = theView;
		self.note.frame = noteRect;
		[self.view addSubview:self.note];
		[theView release];
	}		
	if (!self.redLabel)	{
		UIImageView* theView = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"redlabel" ofType:@"png"]]];
		self.redLabel = theView;
		self.redLabel.frame = redLabelRect;
		[self.view addSubview:self.redLabel];
		[theView release];
	}		
	if (!self.polaroid)	{
		UIImageView* theView = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"polaroidfilm" ofType:@"png"]]];
		self.polaroid = theView;
		self.polaroid.frame = polaroidRect;
		[self.note addSubview:self.polaroid];
		[theView release];
	}		
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
}
*/

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
	NSLog(@"dealloc PentagonChartViewController");
	self.submitAi = nil;
	self.socialPanel = nil;
	self.theChart = nil;
	self.titleLabel = nil;
	self.totalScore = nil;
	self.rank = nil;
	self.redBut = nil;
	self.greenBut = nil;
	self.blueBut = nil;
	self.bottomPanel = nil;
	self.nickNames = nil;
	self.gameFrame = nil;
	self.polaroid = nil;
	self.redLabel = nil;
	
	self.gcBut = nil;
	self.replayBut = nil;
	self.homeBut = nil;
	self.readScoreBut = nil;
	self.submitScoreBut = nil;
	
	self.submitPanel = nil;
	self.replayPanel = nil;
	self.exitBut = nil;
	self.infoBut = nil;
	self.globeBut = nil;
	self.soundBut = nil;
	self.socialBut = nil;
	
    [super dealloc];
}

#pragma mark ButtonClicked

- (void) submitScoreButClicked
{
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	UIGraphicsBeginImageContext(screenRect.size);
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	[[UIColor blackColor] set];
	CGContextFillRect(ctx, screenRect);
	
	[self.view.layer renderInContext:ctx];
	
	UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
	NSData * imageData = UIImageJPEGRepresentation(image1, 0.1);
	NSString* imageStr = [NSString base64StringFromData:imageData length:[imageData length]];
	
	[[[self.gameView scoreView] theGameRecord]setImageStr:imageStr];
	UIGraphicsEndImageContext();
	CFUUIDRef   uuid; 
    
	uuid = CFUUIDCreate(NULL); 
	[[[self.gameView scoreView] theGameRecord] setUuid:(NSString *) CFUUIDCreateString(NULL, uuid)]; 
	CFRelease(uuid); 
	
	[[[self.gameView scoreView] theGameRecord] setDelegate:self];		
	[[[self.gameView scoreView] theGameRecord] submitGameRecord];
	UIActivityIndicatorView* aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	self.submitAi = aiView;
	[aiView release];
	self.submitAi.frame = self.submitScoreBut.frame;
	[self.submitAi startAnimating];
	[self.submitPanel addSubview:self.submitAi];
	[self.submitScoreBut setHidden:YES];
	
}

-(void) finishedSubmitting
{
	[self.submitAi removeFromSuperview];
	self.submitAi = nil;
//	[self.submitScoreBut setHidden:NO];
}
	

- (void) readScoreButClicked
{
	GameRecordMenuViewController*  theView = [[GameRecordMenuViewController alloc] init];
	theView.section = -2;
	
	[[self navigationController] setNavigationBarHidden:NO animated:NO];
	[[self navigationController] pushViewController:theView animated:YES];
	[theView release];
}




-(void) pinClicked
{
	StampCollectionViewController* theConfigView = [[StampCollectionViewController alloc]init];
	[[self navigationController] pushViewController:theConfigView animated:YES];	
	[theConfigView release];
}

@end
