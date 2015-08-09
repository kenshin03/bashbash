//
//  ScoreView.m
//  bishibashi
//
//  Created by Eric on 02/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ScoreView.h"


@implementation ScoreView
@synthesize type = _type;
@synthesize currentGameType = _currentGameType;
@synthesize peerHosted = _peerHosted;
@synthesize isPass = _isPass;
@synthesize theGameRecord = _theGameRecord;
@synthesize game = _game;
@synthesize theFrame = _theFrame;
@synthesize score = _score;
@synthesize totalScore = _totalScore;
@synthesize level = _level;
@synthesize lives = _lives;
@synthesize orientation = _orientation;

@synthesize livesImgs = _livesImgs;

@synthesize submitScoreBut = _submitScoreBut;
@synthesize readScoreBut = _readScoreBut;

@synthesize playAgainBut = _playAgainBut;
@synthesize menuBut = _menuBut;

@synthesize levelLbl = _levelLbl;
@synthesize gameLbl = _gameLbl;
@synthesize scoreLbl = _scoreLbl;
@synthesize aiView = _aiView;

@synthesize owner = _owner;
@synthesize gameView = _gameView;

@synthesize directorBoardView = _directorBoardView;

@synthesize mePlayAgainLbl = _mePlayAgainLbl;
@synthesize opponentPlayAgainLbl = _opponentPlayAgainLbl;

static const CGRect rectP = {{20, 100}, {280,240}};
static const CGRect rectL = {{30, 45}, {280,240}};


static const CGRect levelRectP = {{30, 80}, {100,20}};
static const CGRect levelRectL = {{30, 80}, {100,20}};

static const CGRect gameRectP = {{30, 100}, {180, 20}};
static const CGRect gameRectL = {{30, 100}, {180,20}};

static const CGRect scoreRectP = {{30, 140}, {180, 25}};
static const CGRect scoreRectL = {{30, 140}, {180,25}};

static const CGRect aiViewFrame = {{180, 140}, {25, 25}};


static const CGRect submitScoreRectP = {{186, 134}, {80, 40}};
static const CGRect readScoreRectP = {{183, 87}, {80, 40}};
static const CGRect playAgainRectP = {{50, 180}, {100, 40}};
static const CGRect multiPlayAgainRectP = {{30, 180}, {100, 40}};
static const CGRect mePlayAgainRectP = {{120, 180}, {20, 40}};
static const CGRect opponentPlayAgainRectP = {{150, 180}, {20, 40}};
static const CGRect menuRectP = {{183, 180}, {80, 40}};

static const CGRect submitScoreRectL = {{186, 135}, {80, 40}};
static const CGRect readScoreRectL = {{183, 85}, {80, 40}};
static const CGRect playAgainRectL = {{50, 180}, {100, 40}};
static const CGRect menuRectL = {{183, 180}, {80, 40}};


- (id) initWithOrientation:(UIInterfaceOrientation)orientation  AndScore:(int)score AndLives:(int)lives AndType:(scoreViewType) type
{
	switch (orientation)	{
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
			self = [super initWithFrame:rectL];
			break;
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
			self = [super initWithFrame:rectP];
			break;
		case (10):
			[self release];
			return nil;
	}
	self.type = type;
	self.livesImgs = [[NSMutableArray alloc] initWithCapacity:5];
	self.orientation = orientation;										  
	self.score = score;
	self.lives = lives;
	self.level = -1;
	self.backgroundColor = [UIColor clearColor];
	
	self.theFrame = self.frame;
	self.game = -1;
	self.level = -1;
	[self initInterface];
	return self;
}

- (id) initWithOrientation:(UIInterfaceOrientation)orientation  AndScore:(int)score AndLives:(int)lives AndGame:(Game)game AndGameLevel:(GameLevel)level AndType:(scoreViewType) type
{
	switch (orientation)	{
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
			self = [super initWithFrame:rectL];
			break;
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
			self = [super initWithFrame:rectP];
			break;
		case (10):
			[self release];
			return nil;
	}
	self.type = type;
	self.livesImgs = [[NSMutableArray alloc] initWithCapacity:5];
	self.game = -1;
	self.orientation = orientation;										  
	self.score = score;
	self.lives = lives;
	self.level = -1;
	self.backgroundColor = [UIColor clearColor];
	
	self.theFrame = self.frame;
	self.game = game;
	self.level = level;
	[self initInterface];
	return self;
}


- (void) dealloc
{
	NSLog(@"dealloc ScoreView");
	
	self.readScoreBut = nil;
	self.submitScoreBut = nil;
	self.theGameRecord = nil;
	
	self.levelLbl = nil;
	self.scoreLbl = nil;
	self.aiView = nil;
	self.gameLbl = nil;
	self.playAgainBut = nil;
	self.menuBut = nil;
	self.directorBoardView = nil;
	
	self.mePlayAgainLbl=nil;
	self.opponentPlayAgainLbl = nil;
	[super dealloc];
}



-(UILabel*) getLabel:(CGRect) rect withFont:(UIFont*) font
{
	UILabel * label = [[[UILabel alloc] initWithFrame:rect] autorelease];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setTextColor:[UIColor whiteColor]];
	[label setFont:font];
	return label;
}



- (void) initInterface
{
	sharedSoundEffectsManager = [MediaManager sharedInstance];
	UIImageView* directorBoard = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"directorboard.png"]];
	directorBoard.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height);
	[self addSubview:directorBoard];
	self.directorBoardView = directorBoard;
	[directorBoard release];
	
	UILabel* levelLbl = [self getLabel:levelRectP withFont:[UIFont boldSystemFontOfSize:16]];
	self.levelLbl = levelLbl;
	self.levelLbl.textColor = [UIColor lightGrayColor];
	[self addSubview:self.levelLbl];
	
	UILabel* gameLbl = [self getLabel:gameRectP withFont:[UIFont boldSystemFontOfSize:20]];
	self.gameLbl = gameLbl;
	[self addSubview:self.gameLbl];

	UILabel* scoreLbl = [self getLabel:scoreRectP withFont:[UIFont boldSystemFontOfSize:20]];
	self.scoreLbl = scoreLbl;
	[self addSubview:self.scoreLbl];
	self.scoreLbl.text = [NSString stringWithFormat:@"%@ %d", NSLocalizedString(@"分數:",nil),self.score];
	
	if (self.type != kScoreViewType_afterGameArcade)	{
		self.readScoreBut = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.readScoreBut setTitle:NSLocalizedString(@"最高紀錄",nil) forState:UIControlStateNormal];
		[self.readScoreBut setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
		[self.readScoreBut setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
		[self.readScoreBut.titleLabel setTextAlignment:UITextAlignmentRight];
		self.readScoreBut.frame = readScoreRectP;
		self.submitScoreBut = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.submitScoreBut setTitle:NSLocalizedString(@"遞交記錄",nil) forState:UIControlStateNormal];
		[self.submitScoreBut setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
		[self.submitScoreBut setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
		self.submitScoreBut.frame = submitScoreRectP;
		[self.readScoreBut addTarget:self action:@selector(readScoreButClicked) forControlEvents:UIControlEventTouchUpInside];
		[self.submitScoreBut addTarget:self action:@selector(submitScoreButClicked) forControlEvents:UIControlEventTouchUpInside];
		[self.submitScoreBut.titleLabel setTextAlignment:UITextAlignmentRight];
		[self addSubview:self.readScoreBut];
		[self addSubview:self.submitScoreBut];
		
		self.playAgainBut = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.playAgainBut setTitle:NSLocalizedString(@"再玩",nil) forState:UIControlStateNormal];
		self.playAgainBut.frame = playAgainRectP;
		[self.playAgainBut setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
		[self.playAgainBut setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
		self.menuBut = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.menuBut setTitle:NSLocalizedString(@"目錄",nil) forState:UIControlStateNormal];
		[self.menuBut.titleLabel setTextAlignment:UITextAlignmentRight];
		self.menuBut.frame = menuRectP;
		[self.menuBut setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
		[self.menuBut setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
		[self.playAgainBut addTarget:self.gameView action:@selector(playAgainButClickedFromScoreView) forControlEvents:UIControlEventTouchUpInside];
		[self.menuBut addTarget:self.gameView action:@selector(leaveGame) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:self.playAgainBut];
		[self addSubview:self.menuBut];
		for (UIImageView* img in self.livesImgs)
			[img removeFromSuperview];
	}
	
}	
#pragma mark ButtonClicked
- (void) readScoreButClicked
{
	GameRecordMenuViewController*  theView = [[GameRecordMenuViewController alloc] init];
	if (self.type == kScoreViewType_afterGameArcade)
		theView.section = -2;
	else
		theView.section = self.game;
	
	[[self.owner navigationController] setNavigationBarHidden:NO animated:NO];
	[[self.owner navigationController] pushViewController:theView animated:YES];
	[theView release];
}

- (void) submitScoreButClicked
{
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	UIGraphicsBeginImageContext(screenRect.size);
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	[[UIColor blackColor] set];
	CGContextFillRect(ctx, screenRect);
	
	[[[[self.gameView owner] view ]layer] renderInContext:ctx];
	
	UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
	NSData * imageData = UIImageJPEGRepresentation(image1, 0.1);
	NSString* imageStr = [NSString base64StringFromData:imageData length:[imageData length]];

	self.theGameRecord.imageStr = imageStr;
	UIGraphicsEndImageContext();
	CFUUIDRef   uuid; 
    
	uuid = CFUUIDCreate(NULL); 
	self.theGameRecord.uuid    = (NSString *) CFUUIDCreateString(NULL, uuid); 
	CFRelease(uuid); 
	
								 
	[self.theGameRecord submitGameRecord];	
	self.submitScoreBut.enabled = NO;
	self.submitScoreBut.highlighted = YES;
	/*
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"成功遞交分數",nil) 
													message:nil
												   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];	
	[alert release];
	 */
}


- (void) saveScore
{
	GameRecord* gameRecord = [[GameRecord alloc] init];
	gameRecord.time = [NSDate date];
	gameRecord.name = [LocalStorageManager objectForKey:USER_NAME];
	gameRecord.hasGps = NO;
	gameRecord.country = [LocalStorageManager objectForKey:COUNTRY];
	gameRecord.deviceType = [[UIDevice currentDevice] model];
	if (self.type == kScoreViewType_afterGameArcade)	{
		if ([self.owner isLite])
			gameRecord.gameMode = kArcadeLite;
		else
			gameRecord.gameMode = kArcade;
		gameRecord.game = -1;
		gameRecord.score = self.totalScore;
	}
	else {
		gameRecord.gameMode = kSingle;
		gameRecord.game = self.game;
		gameRecord.score = self.score;
	}
	gameRecord.gameLevel = self.level;
		
	[LocalStorageManager addGameRecordToStorage:gameRecord];
	self.theGameRecord = gameRecord;
	[gameRecord release];
	
}
	

- (void) setScore:(int)score
{
	_score = score;
	NSString* tmp;
	if (self.game == -1 && self.type == kScoreViewType_beforeGame)	{
		tmp = [NSString stringWithFormat:NSLocalizedString(@"過關分數:%d",nil), score];
		self.scoreLbl.text = tmp;
	}
	else if (self.type == kScoreViewType_afterGameArcade){
		tmp = [NSString stringWithFormat:NSLocalizedString(@"分數:%d 總分:%d",nil), score, self.totalScore];
		self.scoreLbl.text = tmp;
		[self.scoreLbl setAdjustsFontSizeToFitWidth:YES];
	}
	else if (self.type==kScoreViewType_afterGameNonArcade){
		tmp = [NSString stringWithFormat:NSLocalizedString(@"分數:%d",nil), score];
		self.scoreLbl.text = tmp;
	}
}
	
- (void) setLives:(int)lives
{
	_lives = lives;
	for (UIImageView* img in self.livesImgs)
		[img removeFromSuperview];
	[self.livesImgs removeAllObjects];
	if (self.game==-1)	{
		for (int i=0; i<self.lives; i++)	{
			NSString* lifeiconfilename = [LocalStorageManager stringForKey:LIFEICON];
			UIView* lifeicon;
			if (lifeiconfilename == nil)	{   
				lifeicon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heartwithline.png"]];
				lifeicon.frame = CGRectMake(20+50*i,180, 50,50);
			}
			else if ([lifeiconfilename isEqualToString:LIFEICON])					{
				lifeicon = [[Baby alloc] initWithFrame:CGRectMake(14+22*i,87, 50,50) AndColor:(i%3) AndOrientation:11];			
			}
			else {
				lifeicon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:lifeiconfilename]];
				lifeicon.frame = CGRectMake(20+50*i,180, 50,50);
			}

			[self addSubview:lifeicon];
			[self.livesImgs addObject:lifeicon];
			[lifeicon release];
		}
	}
}

- (void) pass
{
	[sharedSoundEffectsManager playClapSound];
	UILabel* rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,160,160)];
	rankLabel.textColor = [UIColor orangeColor];
	rankLabel.font = [UIFont boldSystemFontOfSize:28];
	rankLabel.backgroundColor = [UIColor clearColor];
	if (self.score>=80)
		rankLabel.text = @"S";
	else if (self.score >=70)
		rankLabel.text = @"A";
	else if (self.score >=60)
		rankLabel.text = @"B";
	else if (self.score >=50)
		rankLabel.text = @"C";
	else if (self.score >=40)
		rankLabel.text = @"D";
	else if (self.score >=30)
		rankLabel.text = @"E";
	else
		rankLabel.text = @"F";
	
	
	//UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pass.png"]];
	rankLabel.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height);
	[self addSubview:rankLabel];
	[UIView beginAnimations:@"pass0" context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
	[rankLabel setFrame:CGRectMake(200, 180, 40, 40)];
	[UIView commitAnimations];	
	
}

- (void) lostLife
{
	_lives --;
	UIImageView* liveImage = [self.livesImgs lastObject];
	
	[UIView beginAnimations:@"lostLife0" context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
	[liveImage setFrame:CGRectMake(liveImage.frame.origin.x,liveImage.frame.origin.y+120, liveImage.frame.size.width*2, liveImage.frame.size.height*2)];
	[UIView commitAnimations];	
}
	
- (void) setType:(scoreViewType) type
{
	_type = type;
	if (type==kScoreViewType_beforeGameMultiplay)	{
		self.scoreLbl.text = NSLocalizedString(@"等待對手連線中", nil);
		UIActivityIndicatorView* aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		self.aiView = aiView;
		[aiView release];
		self.aiView.frame = aiViewFrame;
		[self addSubview:self.aiView];
		self.aiView.hidesWhenStopped = YES;
		[self.aiView startAnimating];
	}
}

-(void) dismiss
{
	if (self.aiView)
		[self.aiView stopAnimating];
	if (self.mePlayAgainLbl)
		[self.mePlayAgainLbl removeFromSuperview];
	if (self.opponentPlayAgainLbl)
		[self.opponentPlayAgainLbl removeFromSuperview];
		
	[self setUserInteractionEnabled:NO];	
	[UIView beginAnimations:@"dismiss0" context:nil];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
	[self setFrame:CGRectMake(self.theFrame.origin.x-10,self.theFrame.origin.y, self.frame.size.width, self.frame.size.height)];
	self.directorBoardView.image = [UIImage imageNamed:@"directorboardclosed.png"];
	[UIView commitAnimations];	
}	

- (void) mePlayAgain{
	[self addSubview:self.mePlayAgainLbl];
}

- (void) opponentPlayAgain{
	[self addSubview:self.opponentPlayAgainLbl];
}

- (void) showVSResult{
	
	[self.playAgainBut setHidden:NO];
	self.playAgainBut.enabled = YES;

	[self.aiView stopAnimating];
	if ([[self.gameView opponentTimeBar] currentValue] >[[self.gameView timeBar ]currentValue])	{
		self.scoreLbl.textColor = [UIColor redColor];
		self.scoreLbl.text = [NSString stringWithFormat:@"%@ %@", [[self.gameView opponentTimeBar] name], NSLocalizedString(@"勝出", nil)];
	}
	else if ([[self.gameView opponentTimeBar] currentValue] <[[self.gameView timeBar] currentValue])	{
		self.scoreLbl.textColor = [UIColor orangeColor];
		self.scoreLbl.text = [NSString stringWithFormat:@"%@ %@", [[self.gameView timeBar] name], NSLocalizedString(@"勝出", nil)];
	}
	else	{
		if ([self.gameView myTimeUsed]<[self.gameView opponentTimeUsed]){
			self.scoreLbl.textColor = [UIColor redColor];
			self.scoreLbl.text = [NSString stringWithFormat:@"%@ %@", [[self.gameView timeBar] name], NSLocalizedString(@"勝出", nil)];
		}
		else if ([self.gameView myTimeUsed]>[self.gameView opponentTimeUsed])	{
			self.scoreLbl.textColor = [UIColor orangeColor];
			self.scoreLbl.text = [NSString stringWithFormat:@"%@ %@", [[self.gameView opponentTimeBar] name], NSLocalizedString(@"勝出", nil)];
		}
		else	{
			self.scoreLbl.textColor = [UIColor whiteColor];
			self.scoreLbl.text = NSLocalizedString(@"打成平手", nil);
		}
	}
	 
}


- (void) show
{
	if (self.type == kScoreViewType_beforeGameMultiplay)	{
		[self.readScoreBut setHidden:YES];
		[self.submitScoreBut setHidden:YES];
		[self.menuBut setHidden:YES];
		self.submitScoreBut.enabled = NO;
		self.readScoreBut.enabled = NO;
		self.menuBut.enabled = NO;
		self.submitScoreBut.highlighted = NO;
		self.scoreLbl.text =NSLocalizedString(@"等待對手連線中", nil);
		
	}
	else if (self.type == kScoreViewType_afterGameMultiplayNonArcade)	{
		[self.readScoreBut setHidden:YES];
		[self.submitScoreBut setHidden:YES];
		[self.menuBut setHidden:NO];
		self.submitScoreBut.enabled = NO;
		self.readScoreBut.enabled = NO;
		self.menuBut.enabled = YES;
		self.submitScoreBut.highlighted = NO;
		[self.playAgainBut setHidden:YES];
		self.playAgainBut.enabled = NO;
		self.scoreLbl.textColor = [UIColor whiteColor];
		self.scoreLbl.text =NSLocalizedString(@"等待對手完成", nil);
		[self.aiView startAnimating];

		
		if (!self.mePlayAgainLbl)	{
			UILabel* mePlayAgainLbl = [self getLabel:mePlayAgainRectP withFont:[UIFont boldSystemFontOfSize:20]];
			self.mePlayAgainLbl = mePlayAgainLbl;
			self.mePlayAgainLbl.textColor = [UIColor redColor];
			self.mePlayAgainLbl.text = @"好";
		}
		if (!self.opponentPlayAgainLbl)	{
			UILabel* opponentPlayAgainLbl = [self getLabel:opponentPlayAgainRectP withFont:[UIFont boldSystemFontOfSize:20]];
			self.opponentPlayAgainLbl = opponentPlayAgainLbl;
			self.opponentPlayAgainLbl.textColor = [UIColor orangeColor];
			self.opponentPlayAgainLbl.text = @"好";
		}
		self.playAgainBut.frame = multiPlayAgainRectP;
	}
	else if (self.type == kScoreViewType_afterGameNonArcade)	{
		[self.readScoreBut setHidden:NO];
		[self.submitScoreBut setHidden:NO];
		[self.menuBut setHidden:NO];
		self.submitScoreBut.enabled = YES;
		self.readScoreBut.enabled = YES;
		self.menuBut.enabled = YES;
		self.submitScoreBut.highlighted = NO;
		if (self.type == kScoreViewType_afterGameNonArcade)	{
			[self.playAgainBut setHidden:NO];
			self.playAgainBut.enabled = YES;
		}			
	}
	
	else	{
		[self.readScoreBut setHidden:YES];
		[self.submitScoreBut setHidden:YES];
		[self.playAgainBut setHidden:YES];
		[self.menuBut setHidden:YES];
	}		

//	if ((self.type==kScoreViewType_afterGameArcade && [self.gameView game] == noGames-1)
//	int currentGameTypeInView = [self.gameView gameType];
//	NSLog(@"xxxxxxxxxxxxxxxxxx gameType: %i", currentGameTypeInView);
	if (self.currentGameType == multi_players_level_select){
		// Not the BT game host
		if (self.peerHosted == YES){
			[self.playAgainBut setHidden:YES];
			[self.menuBut setHidden:YES];
		}
	}
	
	
	switch ((GameLevel)([self.gameView difficultiesLevel]))	{
		case (kEasy):
			self.levelLbl.text = @"Easy";
			break;
		case (kNormal):
			self.levelLbl.text = @"Normal";
			break;
		case (kHard):
			self.levelLbl.text = @"Hard";
			break;
		case (kWorldClass):
			self.levelLbl.text = @"Master";
			break;
	}
	self.gameLbl.text = [[[Constants sharedInstance] getGameNamesDictionary] objectForKey:[NSNumber numberWithInt:[self.gameView game]]];

	
	[self setUserInteractionEnabled:NO];
	[self.gameView addSubview:self];
	[self setFrame:CGRectMake(320,self.theFrame.origin.y, self.frame.size.width, self.frame.size.height)];
	[UIView beginAnimations:@"show0" context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
	[self setFrame:CGRectMake(self.theFrame.origin.x-10,self.theFrame.origin.y, self.frame.size.width, self.frame.size.height)];
	self.directorBoardView.image = [UIImage imageNamed:@"directorboardclosed.png"];
	[UIView commitAnimations];	
	
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	
	if ([animationID isEqualToString:@"dismiss0"])	{
		[UIView beginAnimations:@"dismiss1" context:nil];
		[UIView setAnimationDuration:0.2];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
		[self setFrame:CGRectMake(320,self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
		self.directorBoardView.image = [UIImage imageNamed:@"directorboard.png"];
		[UIView commitAnimations];	
	}
	if([animationID isEqualToString:@"dismiss1"])	{
		[self removeFromSuperview];
		[self setUserInteractionEnabled:YES];
	}
	else if ([animationID isEqualToString:@"show0"]){
		[UIView beginAnimations:@"show1" context:nil];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
		[self setFrame:CGRectMake(self.theFrame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
		self.directorBoardView.image = [UIImage imageNamed:@"directorboard.png"];
		[UIView commitAnimations];	
		NSLog(@"self.type is %d, self.gameview game is %d", self.type, [self.gameView game]);
		if (self.type == kScoreViewType_afterGameNonArcade  || (self.type==kScoreViewType_afterGameArcade && [self.gameView game]==[[Constants sharedInstance] availableGames][[[Constants sharedInstance] noAvailableGames][kArcade]-1]))	
			[self saveScore];
		[self setUserInteractionEnabled:YES];
		if (self.type == kScoreViewType_afterGameArcade)	{
			[[Constants sharedInstance] updateAttributeScore:self.score ForGame:[self.gameView game]];
			[[Constants sharedInstance] logAttributeScores];
			if (self.isPass)	{
				[self pass];
			}
			else
				[self lostLife];
		}
		else if (self.type == kScoreViewType_afterGameMultiplayArcade)	{
			[self pass];
		}
		/*
		if ((self.type == kScoreViewType_afterGameArcade)&&([self.gameView gameType] == one_player_arcade || [self.gameView gameType] == multi_players_arcade || [self.gameView gameType] == none)) {
			if (_lives==0)	{
				PentagonChartViewController* resultView = [[PentagonChartViewController alloc]initWithScore:self.totalScore AndScores:[[Constants sharedInstance] attributeScoresArray] AndNumGame:noGames AndGameView:self.gameView AndPass:NO];
				[[[self.gameView owner] navigationController] pushViewController:resultView animated:YES];	
				[resultView release];				
			}
			else if ([self.gameView game]!=noGames-1)
				[self.gameView performSelector:@selector(showTransitionOut) withObject:nil afterDelay:4];
			else	{
				PentagonChartViewController* resultView = [[PentagonChartViewController alloc]initWithScore:self.totalScore AndScores:[[Constants sharedInstance] attributeScoresArray] AndNumGame:noGames AndGameView:self.gameView AndPass:YES];
				[[[self.gameView owner] navigationController] pushViewController:resultView animated:YES];	
				[resultView release];
			}
		}
		 */
	}
	else if ([animationID isEqualToString:@"pass0"])	{
			GameMode mode;
			if ([self.owner gameType]==multi_players_arcade)
				if ([self.owner isLite])
					mode = kVSArcadeLite;
				else
					mode = kVSArcade;
			else if ([self.owner gameType]==one_player_arcade)
				if ([self.owner isLite])
					mode = kArcadeLite;
				else
					mode = kArcade;
			 
			if ([self.gameView game]!=[[Constants sharedInstance]lastGameForMode:mode]) {
				[self.gameView performSelector:@selector(showTransitionOut) withObject:nil afterDelay:5];
			}
			else	
				if (self.type == kScoreViewType_afterGameMultiplayArcade){
					;
				}
				else {
					PentagonChartViewController* resultView = [[PentagonChartViewController alloc]initWithScore:self.totalScore AndScores:[[Constants sharedInstance] attributeScoresArray] AndNumGame:[[Constants sharedInstance] noAvailableGames][mode] AndGameView:self.gameView AndPass:YES];
					[[[self.gameView owner] navigationController] pushViewController:resultView animated:YES];	
					[resultView release];
				}
		
	}	
	else if ([animationID isEqualToString:@"lostLife0"])	{
		UIImageView* liveImage = [self.livesImgs lastObject];
		[UIView beginAnimations:@"lostLife1" context:nil];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
		[liveImage setFrame:CGRectMake(liveImage.frame.origin.x,liveImage.frame.origin.y-50, liveImage.frame.size.width*2, liveImage.frame.size.height*2)];
		[UIView commitAnimations];	
	}	
	else if ([animationID isEqualToString:@"lostLife1"])	{
		UIImageView* liveImage = [self.livesImgs lastObject];
		[UIView beginAnimations:@"lostLife2" context:nil];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
		[liveImage setFrame:CGRectMake(liveImage.frame.origin.x,liveImage.frame.origin.y+50, liveImage.frame.size.width*2, liveImage.frame.size.height*2)];
		[UIView commitAnimations];	
	}
	else if ([animationID isEqualToString:@"lostLife2"])	{
		GameMode mode;
		NSLog(@"mode is %d", mode);
		NSLog(@"gameType is %d", [self.owner gameType]);
		
		if ([self.owner gameType]==multi_players_arcade)
			if ([self.owner isLite])
				mode = kVSArcadeLite;
			else
				mode = kVSArcade;
		else if ([self.owner gameType]==one_player_arcade)
			if ([self.owner isLite])
				mode = kArcadeLite;
			else
				mode = kArcade;
		
		[[self.livesImgs lastObject] removeFromSuperview];
		if ([self.livesImgs count]>0)
			[self.livesImgs removeLastObject];
		if (_lives==0)	{
			PentagonChartViewController* resultView = [[PentagonChartViewController alloc]initWithScore:self.totalScore AndScores:[[Constants sharedInstance] attributeScoresArray] AndNumGame:[[Constants sharedInstance] noAvailableGames][mode] AndGameView:self.gameView AndPass:NO];
			[[[self.gameView owner] navigationController] pushViewController:resultView animated:YES];	
			[resultView release];				
		}


		else if ([self.gameView game]!=[[Constants sharedInstance]lastGameForMode:mode])	{
			[self.gameView performSelector:@selector(showTransitionOut) withObject:nil afterDelay:5];
		}
		else	{
			PentagonChartViewController* resultView = [[PentagonChartViewController alloc]initWithScore:self.totalScore AndScores:[[Constants sharedInstance] attributeScoresArray] AndNumGame:[[Constants sharedInstance] noAvailableGames][mode] AndGameView:self.gameView AndPass:YES];
			[[[self.gameView owner] navigationController] pushViewController:resultView animated:YES];	
			[resultView release];
		}
	}
}

@end
