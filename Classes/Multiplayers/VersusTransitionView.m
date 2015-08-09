//
//  VersusTransitionView.m
//  bishibashi
//
//  Created by ktang on 9/28/10.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//peer

#import "VersusTransitionView.h"

@implementation VersusTransitionProfileBottom
@synthesize profileName, profileImageView;
@synthesize webImageView = _webImageView;
@synthesize playerTextLabel = _playerTextLabel;
@synthesize countryFlag = _countryFlag;
@synthesize playerMatchesTextLabel = _playerMatchesTextLabel;

- (id) initWithFrame:(CGRect)frameRect profile:(PlayerProfilePacket*)profilePacket{
    self = [super initWithFrame:frameRect];
	self.backgroundColor = [UIColor blackColor];
	
	UIImageView* transitionBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 241, 64)];
	[transitionBackgroundView setImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"transitionbadge" ofType:@"png"]]];
	[self addSubview:transitionBackgroundView];
	[transitionBackgroundView release];
	
	NSString* playerName = [profilePacket playerName];
	NSString* facebookImageURL = [profilePacket facebookImageURL];
	
	UILabel *playerTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 140, 20)];
	[playerTextLabel setText:playerName];
	playerTextLabel.contentMode = UIViewContentModeLeft;
	playerTextLabel.font = [UIFont fontWithName:@"Verdana-BoldItalic" size:13.0];
	playerTextLabel.textColor = [UIColor whiteColor];
	[playerTextLabel setBackgroundColor:[UIColor clearColor]];
	[self addSubview:playerTextLabel];
	[playerTextLabel release];
	
	UILabel *playerWinLoseTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 35, 140, 20)];
	NSString *playerWinLoseString =  [NSString stringWithFormat:@"win:%i  lose:%i", [profilePacket winCount], [profilePacket loseCount]];
	[playerWinLoseTextLabel setText:playerWinLoseString];
	playerWinLoseTextLabel.contentMode = UIViewContentModeLeft;
	playerWinLoseTextLabel.font = [UIFont fontWithName:@"Verdana" size:10.0];
	playerWinLoseTextLabel.textColor = [UIColor whiteColor];
	[playerWinLoseTextLabel setBackgroundColor:[UIColor clearColor]];
	[self addSubview:playerWinLoseTextLabel];
	[playerWinLoseTextLabel release];
	
		
	UIImageView* playerProfileImage = [[UIImageView alloc] initWithFrame:CGRectMake(170, 5, 40, 40)];
	[playerProfileImage setImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:facebookImageURL]]]];
	playerProfileImage.opaque = YES;
	[self addSubview:playerProfileImage];
	[playerProfileImage release];
	NSLog(@"VersusTransitionProfileBottom initWithFrame end");
	
	NSLog(@"VersusTransitionProfileBottom 3: %@", playerName);
	NSLog(@"VersusTransitionProfileBottom 4: %@", facebookImageURL);
	
	return self;
}

- (id) initWithFrame:(CGRect)frameRect WithAlias:(NSString*)alias WithImageUrl:(NSString*) imageUrl WithNumRoundWin:(NSInteger)numRoundWin WithNumRoundLose:(NSInteger)numRoundLose WithNumMatches:(NSInteger)numMatches WithNumWins:(NSInteger) numWins	{
    self = [super initWithFrame:frameRect];
	self.backgroundColor = [UIColor blackColor];
	
	UIImageView* transitionBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 241, 64)];
	[transitionBackgroundView setImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"transitionbadge" ofType:@"png"]]];
	[self addSubview:transitionBackgroundView];
	[transitionBackgroundView release];
	
	NSString* playerName = alias;
	NSString* facebookImageURL = imageUrl;
	
	UILabel *playerTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 3, 140, 15)];
	[playerTextLabel setText:playerName];
	playerTextLabel.contentMode = UIViewContentModeLeft;
	playerTextLabel.font = [UIFont fontWithName:@"Verdana-BoldItalic" size:13.0];
	playerTextLabel.textColor = [UIColor whiteColor];
	[playerTextLabel setBackgroundColor:[UIColor clearColor]];
	[self addSubview:playerTextLabel];
	self.playerTextLabel = playerTextLabel;
	[playerTextLabel release];
	
	
	UILabel *playerWinLoseTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 25, 100, 15)];
	NSString *playerWinLoseString =  [NSString stringWithFormat:@"win:%i  lose:%i", numRoundWin, numRoundLose];
	[playerWinLoseTextLabel setText:playerWinLoseString];
	playerWinLoseTextLabel.contentMode = UIViewContentModeLeft;
	playerWinLoseTextLabel.font = [UIFont fontWithName:@"Verdana" size:10.0];
	playerWinLoseTextLabel.textColor = [UIColor whiteColor];
	[playerWinLoseTextLabel setBackgroundColor:[UIColor clearColor]];
	[self addSubview:playerWinLoseTextLabel];
	[playerWinLoseTextLabel release];

	UILabel *playerMatchesTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 45, 120, 15)];
	NSString *playerMatchesTextString =  [NSString stringWithFormat:@"Matches/Wins:%i/%i", numMatches, numWins];
	[playerMatchesTextLabel setText:playerMatchesTextString];
	playerMatchesTextLabel.contentMode = UIViewContentModeLeft;
	playerMatchesTextLabel.font = [UIFont fontWithName:@"Verdana" size:10.0];
	playerMatchesTextLabel.textColor = [UIColor redColor];
	[playerMatchesTextLabel setBackgroundColor:[UIColor clearColor]];
	[self addSubview:playerMatchesTextLabel];
	self.playerMatchesTextLabel = playerMatchesTextLabel;
	[playerMatchesTextLabel release];

	if (!imageUrl)
		imageUrl = [NSString stringWithFormat:@"%@%@", HOSTURL, ANONYMOUSPHOTOURL];
	WebImageView* webImageView = [[WebImageView alloc] initWithFrame:CGRectMake(170, 5, 40, 40) AndImageUrl:imageUrl];
	webImageView.opaque = YES;
	[self addSubview:webImageView];
	self.webImageView = webImageView;
	[webImageView release];
	NSLog(@"VersusTransitionProfileBottom initWithFrame end");
	
	NSLog(@"VersusTransitionProfileBottom 3: %@", playerName);
	NSLog(@"VersusTransitionProfileBottom 4: %@", facebookImageURL);
	
	return self;
}

- (void) setCountry:(NSString*) country
{
	UIImageView* countryFlag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",country]]];
	self.countryFlag = countryFlag;
	self.countryFlag.frame = CGRectMake(-20,35,40,40);
	[self addSubview:self.countryFlag];
	[countryFlag release];	
}

- (void) setNumMatches:(NSInteger) numMatches AndNumWins:(NSInteger) numWins
{
	self.playerMatchesTextLabel.text = [NSString stringWithFormat:@"Matches/Wins:%i/%i", numMatches, numWins];
	[self addSubview:self.playerMatchesTextLabel];
	NSLog(@"set opponent text as %@", self.playerMatchesTextLabel.text);
}


-(void) dealloc {
	self.webImageView = nil;
	self.playerTextLabel = nil;
	self.countryFlag = nil;
	self.playerMatchesTextLabel = nil;
	self.profileName = nil;
	self.profileImageView = nil;
	[super dealloc];
}

@end

@implementation VersusTransitionProfileTop
@synthesize profileName, profileImageView;
@synthesize webImageView = _webImageView;
@synthesize playerTextLabel = _playerTextLabel;
@synthesize countryFlag = _countryFlag;
@synthesize playerMatchesTextLabel = _playerMatchesTextLabel;

- (id) initWithFrame:(CGRect)frameRect profile:(PlayerProfilePacket*)profilePacket{
    self = [super initWithFrame:frameRect];
	
	UIImageView* transitionBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 241, 64)];
	[transitionBackgroundView setImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"transitionbadge" ofType:@"png"]]];
	[self addSubview:transitionBackgroundView];
	[transitionBackgroundView release];
	
	NSString* playerName = [profilePacket playerName];
	NSString* facebookImageURL = [profilePacket facebookImageURL];
	
	UILabel *playerTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 5, 140, 20)];
	[playerTextLabel setText:playerName];
	playerTextLabel.contentMode = UIViewContentModeLeft;
	playerTextLabel.font = [UIFont fontWithName:@"Verdana-BoldItalic" size:13.0];
	playerTextLabel.textColor = [UIColor whiteColor];
	[playerTextLabel setBackgroundColor:[UIColor clearColor]];
	[self addSubview:playerTextLabel];
	[playerTextLabel release];
	
	
	UILabel *playerWinLoseTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 35, 140, 20)];
	NSString *playerWinLoseString =  [NSString stringWithFormat:@"win:%i  lose:%i", [profilePacket winCount], [profilePacket loseCount]];
	[playerWinLoseTextLabel setText:playerWinLoseString];
	playerWinLoseTextLabel.contentMode = UIViewContentModeLeft;
	playerWinLoseTextLabel.font = [UIFont fontWithName:@"Verdana" size:10.0];
	playerWinLoseTextLabel.textColor = [UIColor whiteColor];
	[playerWinLoseTextLabel setBackgroundColor:[UIColor clearColor]];
	[self addSubview:playerWinLoseTextLabel];
	[playerWinLoseTextLabel release];
	
	UIImageView* playerProfileImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
	[playerProfileImage setImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:facebookImageURL]]]];
	playerProfileImage.opaque = YES;
	[self addSubview:playerProfileImage];
	[playerProfileImage release];
	NSLog(@"VersusTransitionProfileTop initWithFrame end");
	
	return self;
}

- (id) initWithFrame:(CGRect)frameRect  WithAlias:(NSString*)alias WithImageUrl:(NSString*) imageUrl WithNumRoundWin:(NSInteger)numRoundWin WithNumRoundLose:(NSInteger)numRoundLose WithNumMatches:(NSInteger)numMatches WithNumWins:(NSInteger) numWins	{
    self = [super initWithFrame:frameRect];
	
	UIImageView* transitionBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 241, 64)];
	[transitionBackgroundView setImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"transitionbadge" ofType:@"png"]]];
	[self addSubview:transitionBackgroundView];
	[transitionBackgroundView release];
	
	NSString* playerName = alias;
	NSString* facebookImageURL = imageUrl;
	
	UILabel *playerTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 3, 140, 15)];
	[playerTextLabel setText:playerName];
	playerTextLabel.contentMode = UIViewContentModeLeft;
	playerTextLabel.font = [UIFont fontWithName:@"Verdana-BoldItalic" size:13.0];
	playerTextLabel.textColor = [UIColor whiteColor];
	[playerTextLabel setBackgroundColor:[UIColor clearColor]];
	[self addSubview:playerTextLabel];
	self.playerTextLabel = playerTextLabel;
	[playerTextLabel release];
	
	UILabel *playerWinLoseTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 25, 100, 15)];
	NSString *playerWinLoseString =  [NSString stringWithFormat:@"win:%i  lose:%i", numRoundWin, numRoundLose];
	[playerWinLoseTextLabel setText:playerWinLoseString];
	playerWinLoseTextLabel.contentMode = UIViewContentModeLeft;
	playerWinLoseTextLabel.font = [UIFont fontWithName:@"Verdana" size:10.0];
	playerWinLoseTextLabel.textColor = [UIColor whiteColor];
	[playerWinLoseTextLabel setBackgroundColor:[UIColor clearColor]];
	[self addSubview:playerWinLoseTextLabel];
	[playerWinLoseTextLabel release];
	
	UILabel *playerMatchesTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, 120, 15)];
	NSString *playerMatchesTextString =  [NSString stringWithFormat:@"Matches/Wins:%i/%i", numMatches, numWins];
	[playerMatchesTextLabel setText:playerMatchesTextString];
	playerMatchesTextLabel.contentMode = UIViewContentModeLeft;
	playerMatchesTextLabel.font = [UIFont fontWithName:@"Verdana" size:10.0];
	playerMatchesTextLabel.textColor = [UIColor redColor];
	[playerMatchesTextLabel setBackgroundColor:[UIColor clearColor]];
	[self addSubview:playerMatchesTextLabel];
	self.playerMatchesTextLabel = playerMatchesTextLabel;
	[playerMatchesTextLabel release];
	
	if (!imageUrl)
		imageUrl = [NSString stringWithFormat:@"%@%@", HOSTURL, ANONYMOUSPHOTOURL];
	WebImageView* webImageView = [[WebImageView alloc] initWithFrame:CGRectMake(170, 5, 40, 40) AndImageUrl:imageUrl];
	webImageView.opaque = YES;
	[self addSubview:webImageView];
	self.webImageView = webImageView;
	[webImageView release];
	NSLog(@"VersusTransitionProfileTop initWithFrame end");
	
	return self;
}

- (void) setCountry:(NSString*) country
{
	UIImageView* countryFlag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",country]]];
	self.countryFlag = countryFlag;
	self.countryFlag.frame = CGRectMake(220,35,40,40);
	[self addSubview:self.countryFlag];
	[countryFlag release];	
}

- (void) setNumMatches:(NSInteger) numMatches AndNumWins:(NSInteger) numWins
{
	self.playerMatchesTextLabel.text = [NSString stringWithFormat:@"Matches/Wins:%i/%i", numMatches, numWins];
}

-(void) dealloc {
	self.webImageView = nil;
	self.playerTextLabel = nil;
	self.countryFlag = nil;
	self.playerMatchesTextLabel = nil;
	self.profileName = nil;
	self.profileImageView = nil;
	[super dealloc];
}

@end


@implementation VersusTransitionView
@synthesize serverPeerID = _serverPeerID;
@synthesize serverPlayerName = _serverPlayerName;
@synthesize serverFacebookImageURL = _serverFacebookImageURL;
@synthesize peerPeerID = _peerPeerID;
@synthesize peerPlayerName = _peerPlayerName;
@synthesize peerFacebookImageURL = _peerFacebookImageURL;
@synthesize versusTransitionViewDelegate = versusTransitionViewDelegate;
@synthesize profileTopView = _profileTopView;
@synthesize profileBottomView = _profileBottomView;

@synthesize roundNo = _roundNo;
@synthesize theGame = _theGame;

@synthesize roundLbl = _roundLbl;
@synthesize gameName = _gameName;
@synthesize gameLogo = _gameLogo;
@synthesize forwardBut = _forwardBut;

- (void) setOpponentNumMatches:(NSInteger) numMatches AndOpponentNumWins:(NSInteger) numWins
{
	[self.profileBottomView setNumMatches:numMatches AndNumWins:numWins];
}


-(void) setServerFacebookImageURL:(NSString*)imageUrl
{
	_serverFacebookImageURL = imageUrl;
	if (self.profileTopView)	{
		NSLog(@"set my image as %@", imageUrl);
		[self.profileTopView.webImageView initImageUrl:imageUrl];
	}
	
}


-(void) setServerPlayerName:(NSString*)name
{
	_serverPlayerName= name;
	if (self.profileTopView)	{
		NSLog(@"set my name as %@", name);
		self.profileTopView.playerTextLabel.text = name;
	} 
	
}
-(void) setServerCountry:(NSString*)country
{
	if (self.profileTopView)	{
		NSLog(@"set my country as %@", country);
		[self.profileTopView setCountry:country];
	}
}


-(void) setPeerFacebookImageURL:(NSString*)imageUrl
{
	_peerFacebookImageURL = imageUrl;
	if (self.profileBottomView)	{
		[self.profileBottomView.webImageView initImageUrl:imageUrl];
	}
	
}

-(void) setPeerPlayerName:(NSString*)name
{
	_peerPlayerName= name;
	if (self.profileBottomView)	{
		self.profileBottomView.playerTextLabel.text = name;
	} 
	
}
-(void) setPeerCountry:(NSString*)country
{
	if (self.profileBottomView)	{
		[self.profileBottomView setCountry:country];
	}
}

- (void) setTheGame:(Game)theGame
{
	_theGame = theGame;
	self.gameName.text =[[[Constants sharedInstance] getGameNamesDictionary] objectForKey:[NSNumber numberWithInt:self.theGame]];
	self.gameLogo.image=[UIImage imageWithContentsOfFile:[[[Constants sharedInstance] gamePinsArray] objectAtIndex:self.theGame]];

}

- (void) setRoundNo:(int)roundNo
{
	_roundNo = roundNo;
	self.roundLbl.text = [NSString stringWithFormat:@"Round %d", self.roundNo];
}

- (id) initWithFrame:(CGRect)frameRect server:(PlayerProfilePacket*)serverPacket peer:(PlayerProfilePacket*)peerPacket
{
    self = [super initWithFrame:frameRect];
	self.backgroundColor = [UIColor lightGrayColor];
	
	UIImageView* logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"starburst_background" ofType:@"png"]]];
	logoImageView.frame = CGRectMake(0, 0, 320, 480);
	[self addSubview:logoImageView];
	[self sendSubviewToBack:logoImageView];
	[logoImageView release];
	
	self.serverPeerID = serverPacket.peerID;
	self.serverPlayerName = serverPacket.playerName;
	self.serverFacebookImageURL = serverPacket.facebookImageURL;
	
	self.peerPeerID = peerPacket.peerID;
	self.peerPlayerName = peerPacket.playerName;
	self.peerFacebookImageURL = peerPacket.facebookImageURL;
	
	NSLog(@"VersusTransitionView peerID: %@", self.serverPeerID);
	NSLog(@"VersusTransitionView serverPlayerName: %@", self.serverPlayerName);
	NSLog(@"VersusTransitionView serverFacebookImageURL: %@", self.serverFacebookImageURL);
	
	NSLog(@"VersusTransitionView peerID: %@", self.serverPeerID);
	NSLog(@"VersusTransitionView peerPlayerName: %@", self.peerPlayerName);
	NSLog(@"VersusTransitionView peerFacebookImageURL: %@", self.peerFacebookImageURL);
	
	VersusTransitionProfileTop* profileTopView = [[VersusTransitionProfileTop alloc]initWithFrame:CGRectMake(5-400, 5, 230, 60) profile:serverPacket];
	self.profileTopView = profileTopView;
	[profileTopView release];
	[self addSubview:self.profileTopView];
	[self bringSubviewToFront:self.profileTopView];
	
	
	VersusTransitionProfileBottom* profileBottomView = [[VersusTransitionProfileBottom alloc]initWithFrame:CGRectMake(75+400, 395, 230, 60) profile:peerPacket];
	self.profileBottomView = profileBottomView;
	[profileBottomView release];
	[self addSubview:self.profileBottomView];
	[self bringSubviewToFront:self.profileBottomView];
	
	
	NSLog(@"initWithFrame....");
	
	sharedSoundEffectsManager = [MediaManager sharedInstance];	
    return self;
}


- (id) initWithFrame:(CGRect)frameRect  WithAlias:(NSString*)alias WithImageUrl:(NSString*) imageUrl 
WithOpponentAlias:(NSString*) opponentAlias WithOpponentImageUrl:(NSString*)opponentImageUrl	 
WithNumRoundWin:(NSInteger)numRoundWin WithNumRoundLose:(NSInteger)numRoundLose 
WithMyNumMatches:(NSInteger)myNumMatches WithMyNumWins:(NSInteger) myNumWins
WithOpponentNumMatches:(NSInteger)opponentNumMatches WithOpponentNumWins:(NSInteger) opponentNumWins
{
    self = [super initWithFrame:frameRect];
	self.backgroundColor = [UIColor lightGrayColor];
	
	UIImageView* logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"starburst_background" ofType:@"png"]]];
	logoImageView.frame = CGRectMake(0, 0, 320, 480);
	[self addSubview:logoImageView];
	[self sendSubviewToBack:logoImageView];
	[logoImageView release];
	
	self.serverPlayerName = alias;
	self.serverFacebookImageURL = imageUrl;
	
	self.peerPlayerName = opponentAlias;
	self.peerFacebookImageURL = opponentImageUrl;

	
	UIImageView*	VSLabel = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"vs" ofType:@"png"]]];
	VSLabel.frame = CGRectMake(60, 150, 200, 100);
	[self addSubview:VSLabel];
	[VSLabel release];
	
	
	self.profileTopView = [[VersusTransitionProfileTop alloc]initWithFrame:CGRectMake(5-400, 5, 230, 60)  WithAlias:self.serverPlayerName WithImageUrl:self.serverFacebookImageURL WithNumRoundWin:numRoundWin WithNumRoundLose:numRoundLose WithNumMatches:myNumMatches WithNumWins:myNumWins];
	[self addSubview:self.profileTopView];
	[self bringSubviewToFront:self.profileTopView];
	[self.profileTopView setCountry:[LocalStorageManager objectForKey:COUNTRY]];

	
	self.profileBottomView = [[VersusTransitionProfileBottom alloc]initWithFrame:CGRectMake(75+400, 350, 230, 60) WithAlias:self.peerPlayerName WithImageUrl:self.peerFacebookImageURL WithNumRoundWin:numRoundLose WithNumRoundLose:numRoundWin WithNumMatches:opponentNumMatches WithNumWins:opponentNumWins];	
	[self addSubview:self.profileBottomView];
	[self bringSubviewToFront:self.profileBottomView];
	
	self.forwardBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.forwardBut setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"forward" ofType:@"png"]] forState:UIControlStateNormal];
	self.forwardBut.frame = CGRectMake(10, 410, 33,33);
	[self addSubview:self.forwardBut];
	[self.forwardBut addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
	NSLog(@"initWithFrame....");
	
	UIImageView* nextStagePanel = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nextstage" ofType:@"png"]]];
	nextStagePanel.frame = CGRectMake(50,423,271,57);
	[self addSubview:nextStagePanel];
	
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[[Constants sharedInstance] gamePinsArray] objectAtIndex:self.theGame]]];
	[nextStagePanel addSubview:tmpView];
	tmpView.frame = CGRectMake(225,5,44,44);
	self.gameLogo = tmpView;
	[tmpView release];
	
	UILabel* gameName = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 120, 14)];
	[nextStagePanel addSubview:gameName];
	gameName.backgroundColor = [UIColor clearColor];
	gameName.textColor = [UIColor grayColor];
	gameName.font = [UIFont systemFontOfSize:14];
	gameName.text = [[[Constants sharedInstance] getGameNamesDictionary] objectForKey:[NSNumber numberWithInt:self.theGame]];
	self.gameName = gameName;
	[gameName release];

	UILabel* roundLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 70, 14)];
	[nextStagePanel addSubview:roundLbl];
	roundLbl.backgroundColor = [UIColor clearColor];
	roundLbl.textColor = [UIColor blackColor];
	roundLbl.font = [UIFont systemFontOfSize:14];
	roundLbl.text = [NSString stringWithFormat:@"Round %d", self.roundNo];
	self.roundLbl = roundLbl;
	[roundLbl release];
	
	[nextStagePanel release];
	
	sharedSoundEffectsManager = [MediaManager sharedInstance];	
    return self;
}


- (void) showView
{
	MediaManager *sharedSoundEffectsManager = [MediaManager sharedInstance];
	[sharedSoundEffectsManager playUFOFlyPassSound];
	[UIView beginAnimations:@"showView" context:nil];
	[UIView setAnimationDuration:0.8]; 
	
	CGRect frame = self.profileTopView.frame;
	frame.origin = CGPointMake(self.profileTopView.frame.origin.x+400, self.profileTopView.frame.origin.y);
	self.profileTopView.frame = frame;
	[self addSubview:self.profileTopView];

	
	CGRect frame2 = self.profileTopView.frame;
	frame2.origin = CGPointMake(self.profileBottomView.frame.origin.x-400, self.profileBottomView.frame.origin.y);
	self.profileBottomView.frame = frame2;
	[self addSubview:self.profileBottomView];
	
	[UIView setAnimationDelay: UIViewAnimationCurveEaseIn];
	[UIView setAnimationDelay: UIViewAnimationCurveEaseOut];
	[UIView commitAnimations];
	
	//[self performSelector:@selector(hideView) withObject:nil afterDelay:5];
}

- (void) hideView
{
	[self.forwardBut setEnabled:NO];
		MediaManager *sharedSoundEffectsManager = [MediaManager sharedInstance];
		[sharedSoundEffectsManager playUFOFlyPassSound];
		[UIView beginAnimations:@"showView2" context:nil];
		[UIView setAnimationDuration:0.8]; 
		
		CGRect frame = self.profileTopView.frame;
		frame.origin = CGPointMake(self.profileTopView.frame.origin.x+400, self.profileTopView.frame.origin.y);
		self.profileTopView.frame = frame;
		[self addSubview:self.profileTopView];
		
		
		CGRect frame2 = self.profileTopView.frame;
		frame2.origin = CGPointMake(self.profileBottomView.frame.origin.x-400, self.profileBottomView.frame.origin.y);
		self.profileBottomView.frame = frame2;
		[self addSubview:self.profileBottomView];
		
		[UIView setAnimationDelay: UIViewAnimationCurveEaseIn];
		[UIView setAnimationDelay: UIViewAnimationCurveEaseOut];
		[UIView commitAnimations];
	
	[sharedSoundEffectsManager stopVersusTransitionBGM];	
	[self.versusTransitionViewDelegate performSelector:@selector(hideTransitionView) withObject:nil afterDelay:0.8];
}


-(void) dealloc
{
	NSLog(@"dealloc VersusTransitionView");
	self.forwardBut = nil;
	self.profileTopView = nil;
	self.profileBottomView = nil;
	self.roundLbl = nil;
	self.gameName = nil;
	self.gameLogo = nil;
	[super dealloc];
}


@end
