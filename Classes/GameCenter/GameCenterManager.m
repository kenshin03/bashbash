/*
 
 File: GameCenterManager.m
 Abstract: Basic introduction to GameCenter
 
 Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc.
 ("Apple") in consideration of your agreement to the following terms, and your
 use, installation, modification or redistribution of this Apple software
 constitutes acceptance of these terms.  If you do not agree with these terms,
 please do not use, install, modify or redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and subject
 to these terms, Apple grants you a personal, non-exclusive license, under
 Apple's copyrights in this original Apple software (the "Apple Software"), to
 use, reproduce, modify and redistribute the Apple Software, with or without
 modifications, in source and/or binary forms; provided that if you redistribute
 the Apple Software in its entirety and without modifications, you must retain
 this notice and the following text and disclaimers in all such redistributions
 of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may be used
 to endorse or promote products derived from the Apple Software without specific
 prior written permission from Apple.  Except as expressly stated in this notice,
 no other rights or licenses, express or implied, are granted by Apple herein,
 including but not limited to any patent rights that may be infringed by your
 derivative works or by other works in which the Apple Software may be
 incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
 WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
 WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
 COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR
 DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF
 CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
 APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

#import "GameCenterManager.h"
#import <GameKit/GameKit.h>
#import "LocalStorageManager.h"

static GameCenterManager *sharedInstance = nil;

@implementation GameCenterManager


@synthesize earnedAchievementCache;
@synthesize delegate;

@synthesize uid = _uid;
@synthesize alias = _alias;
@synthesize imageUrl = _imageUrl;
@synthesize opponentAlias = _opponentAlias;
@synthesize opponentImageUrl = _opponentImageUrl;

@synthesize vc = _vc;
@synthesize rcvPacket = _rcvPacket;

@synthesize theGame = _theGame;
@synthesize theGameLevel = _theGameLevel;

@synthesize isHost  = _isHost;
@synthesize theMatch = _theMatch;
@synthesize theSession = _theSession;
@synthesize peerID = _peerID;
@synthesize theGameVC = _theGameVC;
@synthesize gameMode = _gameMode;

@synthesize matchStarted = _matchStarted;


@synthesize theGameState = _theGameState;
@synthesize theOpponentGameState = _theOpponentGameState;

@synthesize myCountry = _myCountry;
@synthesize opponentCountry = _opponentCountry;

@synthesize isLite = _isLite;

@synthesize opponentNumMatches = _opponentNumMatches;
@synthesize opponentNumWins = _opponentNumWins;

@synthesize scenarios = _scenarios;

@synthesize localPlayServerSelectDelegate = _localPlayServerSelectDelegate;
@synthesize waitingForServerAlertView= _waitingForServerAlertView;

+ (id)sharedInstance {
    @synchronized(self) {
        if(sharedInstance == nil)
            [[self alloc] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if(sharedInstance == nil)  {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id) init
{
	self = [super init];
	if(self!= NULL)
	{
		earnedAchievementCache= NULL;
		self.theGameState = kGKGameStateMatchNotFound;
		self.theOpponentGameState = kGKGameStateMatchNotFound;
	}
	return self;
}

- (void) dealloc
{
	self.earnedAchievementCache= NULL;
	self.alias = nil;
	self.opponentAlias = nil;
	self.opponentImageUrl = nil;
	self.imageUrl = nil;
	self.uid = nil;
	self.myCountry = nil;
	self.opponentCountry = nil;
	self.theMatch = nil;
	self.theSession = nil;
	self.peerID = nil;
	[super dealloc];
}


// NOTE:  GameCenter does not guarantee that callback blocks will be execute on the main thread. 
// As such, your application needs to be very careful in how it handles references to view
// controllers.  If a view controller is referenced in a block that executes on a secondary queue,
// that view controller may be released (and dealloc'd) outside the main queue.  This is true
// even if the actual block is scheduled on the main thread.  In concrete terms, this code
// snippet is not safe, even though viewController is dispatching to the main queue:
//
//	[object doSomethingWithCallback:  ^()
//	{
//		dispatch_async(dispatch_get_main_queue(), ^(void)
//		{
//			[viewController doSomething];
//		});
//	}];
//
// UIKit view controllers should only be accessed on the main thread, so the snippet above may
// lead to subtle and hard to trace bugs.  Many solutions to this problem exist.  In this sample,
// I'm bottlenecking everything through  "callDelegateOnMainThread" which calls "callDelegate". 
// Because "callDelegate" is the only method to access the delegate, I can ensure that delegate
// is not visible in any of my block callbacks.

- (void) callDelegate: (SEL) selector withArg: (id) arg error: (NSError*) err
{
	assert([NSThread isMainThread]);
	if([delegate respondsToSelector: selector])
	{
		if(arg != NULL)
		{
			[delegate performSelector: selector withObject: arg withObject: err];
		}
		else
		{
			[delegate performSelector: selector withObject: err];
		}
	}
	else
	{
		NSLog(@"Missed Method");
	}
}


- (void) callDelegateOnMainThread: (SEL) selector withArg: (id) arg error: (NSError*) err
{
	dispatch_async(dispatch_get_main_queue(), ^(void)
	{
	   [self callDelegate: selector withArg: arg error: err];
	});
}

+ (BOOL) isGameCenterAvailable
{
	// check for presence of GKLocalPlayer API
	Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
	
	// check if the device is running iOS 4.1 or later
	NSString *reqSysVer = @"4.1";
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
	
	return (gcClass && osVersionSupported);
}


- (void) authenticateLocalUser
{
	if([GKLocalPlayer localPlayer].authenticated == NO)
	{
		[[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) 
		{
			[self callDelegateOnMainThread: @selector(processGameCenterAuth:) withArg: NULL error: error];
		}];
	}
}

- (void) reloadHighScoresForCategory: (NSString*) category
{
	GKLeaderboard* leaderBoard= [[[GKLeaderboard alloc] init] autorelease];
	leaderBoard.category= category;
	leaderBoard.timeScope= GKLeaderboardTimeScopeAllTime;
	leaderBoard.range= NSMakeRange(1, 1);
	
	[leaderBoard loadScoresWithCompletionHandler:  ^(NSArray *scores, NSError *error)
	{
		[self callDelegateOnMainThread: @selector(reloadScoresComplete:error:) withArg: leaderBoard error: error];
	}];
}

- (void) reportScore: (int64_t) score forCategory: (NSString*) category 
{
	GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];	
	scoreReporter.value = score;
	[scoreReporter reportScoreWithCompletionHandler: ^(NSError *error) 
	 {
		 [self callDelegateOnMainThread: @selector(scoreReported:) withArg: NULL error: error];
	 }];
}

- (void) submitAchievement: (NSString*) identifier percentComplete: (double) percentComplete
{
	//GameCenter check for duplicate achievements when the achievement is submitted, but if you only want to report 
	// new achievements to the user, then you need to check if it's been earned 
	// before you submit.  Otherwise you'll end up with a race condition between loadAchievementsWithCompletionHandler
	// and reportAchievementWithCompletionHandler.  To avoid this, we fetch the current achievement list once,
	// then cache it and keep it updated with any new achievements.
	if(self.earnedAchievementCache == NULL)
	{
		[GKAchievement loadAchievementsWithCompletionHandler: ^(NSArray *scores, NSError *error)
		{
			if(error == NULL)
			{
				NSMutableDictionary* tempCache= [NSMutableDictionary dictionaryWithCapacity: [scores count]];
				for (GKAchievement* score in tempCache)
				{
					[tempCache setObject: score forKey: score.identifier];
				}
				self.earnedAchievementCache= tempCache;
				[self submitAchievement: identifier percentComplete: percentComplete];
			}
			else
			{
				//Something broke loading the achievement list.  Error out, and we'll try again the next time achievements submit.
				[self callDelegateOnMainThread: @selector(achievementSubmitted:error:) withArg: NULL error: error];
			}

		}];
	}
	else
	{
		 //Search the list for the ID we're using...
		GKAchievement* achievement= [self.earnedAchievementCache objectForKey: identifier];
		if(achievement != NULL)
		{
			if((achievement.percentComplete >= 100.0) || (achievement.percentComplete >= percentComplete))
			{
				//Achievement has already been earned so we're done.
				achievement= NULL;
			}
			achievement.percentComplete= percentComplete;
		}
		else
		{
			achievement= [[[GKAchievement alloc] initWithIdentifier: identifier] autorelease];
			achievement.percentComplete= percentComplete;
			//Add achievement to achievement cache...
			[self.earnedAchievementCache setObject: achievement forKey: achievement.identifier];
		}
		if(achievement!= NULL)
		{
			//Submit the Achievement...
			[achievement reportAchievementWithCompletionHandler: ^(NSError *error)
			{
				 [self callDelegateOnMainThread: @selector(achievementSubmitted:error:) withArg: achievement error: error];
			}];
		}
	}
}

- (void) resetAchievements
{
	self.earnedAchievementCache= NULL;
	[GKAchievement resetAchievementsWithCompletionHandler: ^(NSError *error) 
	{
		 [self callDelegateOnMainThread: @selector(achievementResetResult:) withArg: NULL error: error];
	}];
}

- (void) mapPlayerIDtoPlayer: (NSString*) playerID
{
	[GKPlayer loadPlayersForIdentifiers: [NSArray arrayWithObject: playerID] withCompletionHandler:^(NSArray *playerArray, NSError *error)
	{
		GKPlayer* player= NULL;
		for (GKPlayer* tempPlayer in playerArray)
		{
			if([tempPlayer.playerID isEqualToString: playerID])
			{
				player= tempPlayer;
				break;
			}
		}
		[self callDelegateOnMainThread: @selector(mappedPlayerIDToPlayer:error:) withArg: player error: error];
	}];
	
}


+ (BOOL) leaderboardReUpload
{
	NSString* gameCategory = [LocalStorageManager objectForKey:LEADERBOARD_UPLOAD_FAILED_CATEGORY];
	int gameScore = [LocalStorageManager integerForKey:LEADERBOARD_UPLOAD_FAILED_SCORE];
	
	GKScore *scoreReporter = nil;
	scoreReporter = [[[GKScore alloc] initWithCategory:gameCategory] autorelease];
	scoreReporter.value = gameScore;
	[scoreReporter reportScoreWithCompletionHandler: ^(NSError *error) 
	 {}];
	
	// reset all the values
	[LocalStorageManager setBool:NO forKey:LEADERBOARD_UPLOAD_FAILED];
	[LocalStorageManager setObject:nil forKey:LEADERBOARD_UPLOAD_FAILED_CATEGORY];
	[LocalStorageManager setInteger:0 forKey:LEADERBOARD_UPLOAD_FAILED_SCORE];
}


+ (void) postFriendsList
{
	[[GKLocalPlayer localPlayer] loadFriendsWithCompletionHandler:^(NSArray *friends, NSError *error)	{
		if (friends)	{
			
			NSMutableString* contentStr = [NSMutableString stringWithCapacity:500];
			[contentStr appendFormat:@"uid=%@&alias=%@&numPlay=%d&vsNumPlay=%d&vsNumArcadeGames=%d&vsNumArcadeLiteGames=%d&vsNumFreeSelectGames=%d&vsNumWins=%d", 
			 [[GKLocalPlayer localPlayer] playerID], 
			 [[GKLocalPlayer localPlayer] alias],
			 [LocalStorageManager integerForKey:NUMGAMEPLAY],
			 [LocalStorageManager integerForKey:VSNUMGAMES],
			 [LocalStorageManager integerForKey:VSNUMARCADEGAMES],
			 [LocalStorageManager integerForKey:VSNUMARCADELITEGAMES],
			 [LocalStorageManager integerForKey:VSNUMFREESELECTGAMES],
			 [LocalStorageManager integerForKey:VSNUMWINS]
			 ];
			NSMutableString *shared_secret = [[NSMutableString alloc] init];
			[shared_secret appendString:contentStr];
			[shared_secret appendString:SHAREDSECRET];
			NSMutableData *signedData = [[NSMutableData alloc] init];
			[signedData appendData:[[shared_secret stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]];
			NSMutableString *codeString = [NSMutableString string];
			
			unsigned char digest[CC_MD5_DIGEST_LENGTH];
			if (CC_MD5([signedData bytes], [signedData length], digest)) {
				for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
					[codeString appendFormat: @"%02x", (int)(digest[i])];
				}
			}
			[contentStr appendFormat:@"&code=%@", codeString];
			[shared_secret release];
			[signedData release];
			
			
			NSString* urlStr = [NSString stringWithFormat:@"%@%@%@", HOSTURL,ADDGCUSERREQ,contentStr];
			NSString* escapedUrl = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			NSURL* url = [NSURL URLWithString:escapedUrl];
			NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
			[req setHTTPMethod:@"POST"];
			
			if ([friends count]>0)	{
				NSMutableString* fduids = [NSMutableString stringWithCapacity:200];
				[fduids appendString:[friends objectAtIndex:0]];
				for (int i=1; i<[friends count]; i++)	
					[fduids appendFormat:@",%@",[friends objectAtIndex:i]];
				[req setHTTPBody:[[NSString stringWithFormat:@"fduids=%@",fduids] dataUsingEncoding:NSUTF8StringEncoding]];
			}
			[NSURLConnection connectionWithRequest:req delegate:nil];
			
		}
		
	}];	
	
}

#pragma mark -
#pragma mark GKMatchmakerViewControllerDelegate methods
- (void)matchmakerViewController:(GKMatchmakerViewController *) viewController didFindMatch:(GKMatch *)match
{ 
	self.theGameState = kGKGameStateMatchFound;
	self.theMatch = match;
	match.delegate = self; 
	NSLog(@"Set match delegate");
	self.alias = [[GKLocalPlayer localPlayer] alias];
	
	[GKPlayer loadPlayersForIdentifiers:match.playerIDs withCompletionHandler:^(NSArray* players, NSError*error)	{
		if (players!=nil)	{
			for (GKPlayer* player in players)	{
				if (![player.alias isEqualToString:[[GKLocalPlayer localPlayer] alias]])	{
					[[GameCenterManager sharedInstance] setOpponentAlias:player.alias];
					break;
				}
			}
			// if I'm Host to Invite, i would init my game VC(with game View and match) and send others the Game and Type 
			if (self.isHost)	{
				[self startAsHost:match];
			}
			
		}
		
/*		
		// Auto Match case
		else{
			GKPacket* gamePacket = [[GKPacket alloc] init];
			gamePacket.packetType = kGKPacketTypeExchangeName;
			gamePacket.name = [[GKLocalPlayer localPlayer] alias];
			[match sendDataToAllPlayers:[gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];
			[gamePacket release];
		}
*/			
		
	}];
	
	
	
} 

- (void)match:(GKMatch *)match player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state
{
	UIAlertView* waitingForClientsAlertView;
    switch (state)
    {
        case GKPlayerStateConnected:
            // handle a new player connection.
			NSLog(@"player connect");
			break;
		case GKPlayerStateDisconnected:
            // a player just disconnected.
			// Handle error 
			if (self.theGameVC)
				[self.theGameVC.theMainView leaveGame];
			self.theGameVC= nil;
			
			waitingForClientsAlertView = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"對方已離線", nil) message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
			[waitingForClientsAlertView show];
			
			self.theMatch = nil;
			self.theSession = nil;
			break;
    }
    if (self.theGameState == kGKGameStateMatchFound && match.expectedPlayerCount == 0)
    {
		self.theGameState = kGKGameStateAllConnected;
		self.theOpponentGameState = kGKGameStateAllConnected;
		
		//       self.matchStarted = YES;
        // handle initial match negotiation.
		NSLog(@"handle initial match negotiation");
		[GKPlayer loadPlayersForIdentifiers:match.playerIDs withCompletionHandler:^(NSArray* players, NSError*error)	{
			if (players!=nil)	{
				for (GKPlayer* player in players)	{
					if (![player.alias isEqualToString:[[GKLocalPlayer localPlayer] alias]])	{
						[[GameCenterManager sharedInstance] setOpponentAlias:player.alias];
						break;
					}
				}
			}
			if ([self.opponentAlias compare:[[GKLocalPlayer localPlayer] alias]] == NSOrderedAscending)	{
				[self startAsHost:match];
			}
			else{
				self.isHost = NO;
			}
			
		}];
	}
}

- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *) viewController
{ 
	// Handle cancellation 
	UIAlertView* waitingForClientsAlertView = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"對方已離線", nil) message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
	[waitingForClientsAlertView show];
	
	[[self.vc navigationController] dismissModalViewControllerAnimated:YES];
	
}

- (void)matchmakerViewController:(GKMatchmakerViewController *) viewController didFailWithError:(NSError *)error
{ 
	// Handle error 
	UIAlertView* waitingForClientsAlertView = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"對方已離線", nil) message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
	[waitingForClientsAlertView show];

	[[self.vc navigationController] dismissModalViewControllerAnimated:YES];
	
}

#pragma mark -
#pragma mark GKSessionDelegate methods
- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context{
	[self receiveData:data fromPlayer:peer];
}

#pragma mark -
#pragma mark GKMatchDelegate methods
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID
{
	[self receiveData:data fromPlayer:playerID];
}
	
#pragma mark -
#pragma mark Message Handling 
- (void) receiveData:(NSData*)data fromPlayer:(NSString*)playerID	{
	
	if (!self.rcvPacket)	{
		GKPacket* gkPacket = [[GKPacket alloc]init];
		self.rcvPacket = gkPacket;
		[gkPacket release];
	}
	@synchronized(self)	{
	[self.rcvPacket initWithNSData:data];
	switch (self.rcvPacket.packetType)	{
		case kGKPacketTypeGame:
			NSLog(@"recv game is %d", self.rcvPacket.game);
			self.theGame = self.rcvPacket.game;
			break;
		case kGKPacketTypeGameMode:
			NSLog(@"recv game mode is %d", self.rcvPacket.gameMode);
			int numVSGames = [LocalStorageManager integerForKey:VSNUMGAMES];
			[LocalStorageManager  setInteger:numVSGames+1 forKey:VSNUMGAMES];
			self.gameMode = self.rcvPacket.gameMode;
			if (self.gameMode == kVSArcadeLite)	{
				self.isLite = YES;
				int numVSGames = [LocalStorageManager integerForKey:VSNUMARCADELITEGAMES];
				[LocalStorageManager setInteger:numVSGames+1 forKey:VSNUMARCADELITEGAMES];
			}
			else if (self.gameMode == kVSArcade)	{
				self.isLite = NO;
				int numVSGames = [LocalStorageManager integerForKey:VSNUMARCADEGAMES];
				[LocalStorageManager  setInteger:numVSGames+1 forKey:VSNUMARCADEGAMES];
			}
			else {
				int numVSGames = [LocalStorageManager integerForKey:VSNUMFREESELECTGAMES];
				[LocalStorageManager setInteger:numVSGames+1 forKey:VSNUMFREESELECTGAMES];				
			}
			break;
			
		/* Game Level is the last negotiating message, will start the game */
		case kGKPacketTypeGameLevel:
			NSLog(@"recv gamelevel is %d", self.rcvPacket.gameLevel);
			self.theGameLevel = self.rcvPacket.gameLevel;
			[self.vc dismissModalViewControllerAnimated:YES];
			
			GKPacket* gamePacket = [[GKPacket alloc] init];
			NSError* error;
			
			// set and send imageurl
			gamePacket.packetType = kGKPacketTypeImageUrl;
			if ([[[FBDataSource sharedInstance] fbSession] isConnected])	{
				self.imageUrl=[LocalStorageManager objectForKey:FACEBOOK_IMAGE_URL];
				gamePacket.name = [LocalStorageManager objectForKey:FACEBOOK_IMAGE_URL];
			} 
			else {
				self.imageUrl= [NSString stringWithFormat:@"%@%@", HOSTURL,ANONYMOUSPHOTOURL];
				gamePacket.name = self.imageUrl;				
			}
			if (self.theMatch)
				[self.theMatch sendDataToAllPlayers:[gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];					
			else
				[self.theSession sendDataToAllPeers:[gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];					
			NSLog(@"sending imageurl %@", gamePacket.name);
			
			
			self.myCountry=[[LocalStorageManager objectForKey:COUNTRY] lowercaseString];
			// init and start Game View Controller			
			GameViewController* gameViewController = [[GameViewController alloc]init];
			gameViewController.navigationController = [self.vc navigationController];
			gameViewController.difficultiesLevel = self.theGameLevel;
			gameViewController.theGame = self.theGame;
			gameViewController.isLite = self.isLite;
			if (self.theMatch)
				gameViewController.gkMatch = self.theMatch;
			else
				gameViewController.gkSession = self.theSession;
			gameViewController.alias = self.alias;
			gameViewController.opponentImageUrl = self.opponentImageUrl;
			gameViewController.opponentAlias = self.opponentAlias;
			gameViewController.imageUrl = self.imageUrl;
			gameViewController.myCountry = self.myCountry;
			
			switch (self.gameMode)	{
				case (kVSArcadeLite):
					gameViewController.myNumMatches = [LocalStorageManager integerForKey:VSNUMARCADELITEGAMES];
					gameViewController.myNumWins = [LocalStorageManager integerForKey:VSNUMARCADELITEWINS];
					gameViewController.gameType = multi_players_arcade;
					break;
				case (kVSArcade):
					gameViewController.myNumMatches = [LocalStorageManager integerForKey:VSNUMARCADEGAMES];
					gameViewController.myNumWins = [LocalStorageManager integerForKey:VSNUMARCADEWINS];			
					gameViewController.gameType = multi_players_arcade;
					break;
				case (kVSSingle):
					gameViewController.myNumMatches = [LocalStorageManager integerForKey:VSNUMFREESELECTGAMES];
					gameViewController.myNumWins = [LocalStorageManager integerForKey:VSNUMFREESELECTWINS];
					gameViewController.gameType = multi_players_level_select;
					break;
			}

			//set and send country
			gamePacket.packetType = kGKPacketTypeCountry;
			gamePacket.numMatches = gameViewController.myNumMatches;
			gamePacket.numWins = gameViewController.myNumWins;
			gamePacket.name = [[LocalStorageManager objectForKey:COUNTRY] lowercaseString];
			if (self.theMatch)
				[self.theMatch sendDataToAllPlayers:[gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];					
			else
				[self.theSession sendDataToAllPeers:[gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];	
			NSLog(@"sending country %@", gamePacket.name);
			[gamePacket release];

			
			[[self.vc navigationController] pushViewController:gameViewController animated:YES];
			self.theGameVC = gameViewController;
			[gameViewController release];
			
			GameView* g1View = [[[self.theGameVC.gameViews objectAtIndex:self.theGameVC.theGame] alloc]initWithFrame:CGRectMake(0,0,320,480) AndOwner:self.theGameVC AndGame:self.theGameVC.theGame AndGameType:self.theGameVC.gameType AndLevel:self.theGameVC.difficultiesLevel];
			g1View.lifes = self.theGameVC.lifes;
			
			self.theGameVC.theMainView = g1View;
			if (self.theGameVC.gkMatch || self.theGameVC.gkSession)	{
				if (self.theGameVC.gkMatch)
					g1View.gkMatch = self.theGameVC.gkMatch;
				else
					g1View.gkSession = self.theGameVC.gkSession;
				g1View.scoreView.type = kScoreViewType_beforeGameMultiplay;
				[g1View setVSScoreBar];
			}
			[g1View release];			
			break;
	
			
		case kGKPacketTypeButtonClicked:
			if([self.theGameVC.theMainView respondsToSelector:@selector(greenButClickedOpponent)])	{
				if (self.rcvPacket.butState==kRed)
					[self.theGameVC.theMainView redButClickedOpponent];
				else if (self.rcvPacket.butState==kGreen)
					[self.theGameVC.theMainView greenButClickedOpponent];
				else if (self.rcvPacket.butState==kBlue)
					[self.theGameVC.theMainView blueButClickedOpponent];
			}
			break;
		case kGKPacketTypeScoreUpdated:
			if (self.theOpponentGameState != kGKGameStateEnded)	{
				[self.theGameVC.theMainView.opponentTimeBar setCurrentValue:self.rcvPacket.score];
			}
			break;
			
		case kGKPacketTypeImageUrl:
			NSLog(@"recv ImageUrl%@", self.rcvPacket.name);
			self.opponentImageUrl = self.rcvPacket.name;
			self.theGameVC.opponentImageUrl = self.rcvPacket.name;
			[[self.theGameVC.theMainView opponentPhoto] initImageUrl:self.rcvPacket.name];
			break;

		case kGKPacketTypeCountry:
			NSLog(@"recv country%@ numMatches %d numWins %d ", self.rcvPacket.name, self.rcvPacket.numMatches, self.rcvPacket.numWins);
			self.opponentCountry = self.rcvPacket.name;
			self.theGameVC.opponentCountry = self.rcvPacket.name;
			self.opponentNumWins = self.rcvPacket.numWins;
			self.opponentNumMatches = self.rcvPacket.numMatches;
			[self.theGameVC setOpponentNumMatches:self.opponentNumMatches AndOpponentNumWins:self.opponentNumWins];
			[[self.theGameVC.theMainView opponentPhoto] initImageUrl:self.rcvPacket.name];
			break;

		case kGKPacketTypeStart:
			NSLog(@"recv start packet ");
			NSLog(@"recv sceanrio is %@", self.rcvPacket.scenarios);
			NSLog(@"my GameState is %d", self.theGameState);
			self.theGameVC.theMainView.scenarios = self.rcvPacket.scenarios;
			self.scenarios = self.rcvPacket.scenarios;
			
			if (self.theOpponentGameState == kGKGameStateEnded)	{
				[self.theGameVC.theMainView.scoreView opponentPlayAgain];
				[self.theGameVC.theMainView showVsMsg:NSLocalizedString(@"對手要求重玩", nil)];
			}
			self.theOpponentGameState = kGKGameStateReadyToStart;
			if (self.theGameState == kGKGameStateReadyToStart)	{
				[self.theGameVC.theMainView prepareToStartGameWithNewScenario:NO];
				[self.theGameVC.theMainView bePrepareToStartShowingCountDownMessage];
			}
			break;
			
		case kGKPacketTypeGamesSequence:
			NSLog(@"recv game seq packet ");
			NSLog(@"recv games is %@", self.rcvPacket.games);
			[[Constants sharedInstance] setGames:self.rcvPacket.games ForMode:self.gameMode];
			break;
			
		case kGKPacketTypeAckStart:
			NSLog(@"recv ack start packet ");
			if (self.theOpponentGameState == kGKGameStateEnded)	{
				[self.theGameVC.theMainView.scoreView opponentPlayAgain];
				[self.theGameVC.theMainView showVsMsg:NSLocalizedString(@"對手要求重玩", nil)];
			}
			self.theOpponentGameState = kGKGameStateStarted;
			[self.theGameVC.theMainView startShowingCountDownMessage];
			break;
			
		case kGKPacketTypeTimeUsed:
			[self.theGameVC.theMainView setOpponentTimeUsed:self.rcvPacket.timeUsed];
			NSLog(@"recv timeused is %f", self.theGameVC.theMainView.opponentTimeUsed);
			if ([self.theGameVC.theMainView VSModeIsRoundBased])
				[self.theGameVC.theMainView showRoundVSResult];
			break;
			
		case kGKPacketTypeEndWithScore:
			NSLog(@"recv end with socre packet");
			self.theOpponentGameState = kGKGameStateEnded;
			NSLog(@"recv score is %d", self.rcvPacket.score);
			NSLog(@"set packet scenario to nil for next initialization and prevent GameView to get it");
			self.rcvPacket.scenarios = [NSMutableArray arrayWithCapacity:50];
			[self.theGameVC.theMainView.opponentTimeBar setCurrentValue:self.rcvPacket.score];
			if (self.theGameState == kGKGameStateEnded)	{
				[self.theGameVC.theMainView prepareVSFilms];
				NSLog(@"get kGKPacketTypeEndWithScore and kGKGameStateEnded prepareVSFilms");
//				[[self.theGameVC.theMainView scoreView] showVSResult];
			}
			break;
			
		case kGKPacketTypeEndWithTimeUsed:
			NSLog(@"recv end with time used packet");
			self.theOpponentGameState = kGKGameStateEnded;
			NSLog(@"recv timeused is %f", self.rcvPacket.timeUsed);
			NSLog(@"set packet scenario to nil for next initialization and prevent GameView to get it");
			self.rcvPacket.scenarios = [NSMutableArray arrayWithCapacity:50];
			self.theGameVC.theMainView.opponentTimeUsed = self.rcvPacket.timeUsed;
			if (self.theGameState == kGKGameStateEnded && self.theGameVC.theGame!=ksmallnumber && self.theGameVC.theGame!=k3bo)
				[self.theGameVC.theMainView prepareVSFilms];
//				[[self.theGameVC.theMainView scoreView] showVSResult];
			break;
			
		

	}
	}
}


-(void) startAsHost:(id) match
{
	if ([self.vc respondsToSelector:@selector(waitingForClientsAlertView)] && ([self.vc waitingForClientsAlertView]))
		[[self.vc waitingForClientsAlertView] dismissWithClickedButtonIndex:0 animated:YES];
	
	if ([match isKindOfClass:[GKMatch class]])	{
		self.theMatch = match;
		self.theSession =nil;
	}
	else if ([match isKindOfClass:[GKSession class]])	{
		self.theMatch = nil;
		self.theSession = match;
	}
	
	NSLog(@"is HOst");
	int numVSGames = [LocalStorageManager integerForKey:VSNUMGAMES];
	[LocalStorageManager setInteger:numVSGames+1 forKey:VSNUMGAMES];
	self.isHost = YES;
	[self.vc dismissModalViewControllerAnimated:YES];
	NSError *error;
	int myNumMatches;
	int myNumWins;

	if (self.theGame == -2)	{
		if (self.isLite)	{
			self.gameMode = kVSArcadeLite;
			int myNumMatches = [LocalStorageManager integerForKey:VSNUMARCADELITEGAMES];
			int myNumWins = [LocalStorageManager integerForKey:VSNUMARCADELITEWINS];
			int numVSGames = [LocalStorageManager integerForKey:VSNUMARCADELITEGAMES];
			[LocalStorageManager  setInteger:numVSGames+1 forKey:VSNUMARCADELITEGAMES];
		}
		else	{
			self.gameMode = kVSArcade;
			int myNumMatches = [LocalStorageManager integerForKey:VSNUMARCADEGAMES];
			int myNumWins = [LocalStorageManager integerForKey:VSNUMARCADEWINS];
			int numVSGames = [LocalStorageManager integerForKey:VSNUMARCADEGAMES];
			[LocalStorageManager  setInteger:numVSGames+1 forKey:VSNUMARCADEGAMES];
		}
	}
	else	{
		self.gameMode = kVSSingle;
		int myNumMatches = [LocalStorageManager integerForKey:VSNUMFREESELECTGAMES];
		int myNumWins = [LocalStorageManager integerForKey:VSNUMFREESELECTWINS];
		int numVSGames = [LocalStorageManager integerForKey:VSNUMFREESELECTGAMES];
		[LocalStorageManager  setInteger:numVSGames+1 forKey:VSNUMFREESELECTGAMES];
	}

	
	GKPacket* gamePacket = [[GKPacket alloc] init];

	/* send kGKPacketTypeGameMode */
	gamePacket.packetType = kGKPacketTypeGameMode;
	gamePacket.gameMode = self.gameMode;
	NSLog(@"sending game mode %d", gamePacket.gameMode);
	if (self.theMatch)
		[self.theMatch sendDataToAllPlayers:[gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];
	else if (self.theSession)
		[self.theSession sendDataToAllPeers:[gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];
	
	/* send kGKPacketTypeGameSequence */
	if (self.gameMode == kVSArcadeLite)	{
		gamePacket.packetType = kGKPacketTypeGamesSequence;
		gamePacket.games = [[Constants sharedInstance] getGamesForMode:(kVSArcadeLite)];
		if (self.theMatch)
			[self.theMatch sendDataToAllPlayers:[gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];
		else if (self.theSession)
			[self.theSession sendDataToAllPeers:[gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];
	}
	
	/* send kGKPacketTypeGame */	
	gamePacket.packetType = kGKPacketTypeGame;
	if (self.gameMode!=kVSSingle)
		self.theGame = [[Constants sharedInstance] firstGameForMode:self.gameMode];
	
	gamePacket.game = self.theGame;
	if (self.theMatch)
		[self.theMatch sendDataToAllPlayers:[gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];
	else if (self.theSession)
		[self.theSession sendDataToAllPeers:[gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];

	
	/* send kGKPacketTypeGameLevel */
	gamePacket.packetType = kGKPacketTypeGameLevel;
	gamePacket.gameLevel = self.theGameLevel;
	NSLog(@"sending game level %d", gamePacket.gameLevel);
	if (self.theMatch)
		[self.theMatch sendDataToAllPlayers:[gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];
	else if (self.theSession)
		[self.theSession sendDataToAllPeers:[gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];

	
	// set and send imageurl
	gamePacket.packetType = kGKPacketTypeImageUrl;
	if ([[[FBDataSource sharedInstance] fbSession] isConnected])	{
		self.imageUrl=[LocalStorageManager objectForKey:FACEBOOK_IMAGE_URL];
		gamePacket.name = [LocalStorageManager objectForKey:FACEBOOK_IMAGE_URL];
	} 
	else {
		self.imageUrl= [NSString stringWithFormat:@"%@%@", HOSTURL,ANONYMOUSPHOTOURL];
		gamePacket.name = self.imageUrl;				
	}		
	if (self.theMatch)
		[self.theMatch sendDataToAllPlayers:[gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];					
	else
		[self.theSession sendDataToAllPeers:[gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];					
	NSLog(@"sending imageurl %@", gamePacket.name);

	
	//set and send country
	self.myCountry=[[LocalStorageManager objectForKey:COUNTRY] lowercaseString];
	GameViewController* gameViewController = [[GameViewController alloc]init];
	gameViewController.navigationController = [self.vc navigationController];
	gameViewController.difficultiesLevel = self.theGameLevel;
	gameViewController.theGame = self.theGame;
	gameViewController.isLite = self.isLite;
	if (self.theMatch)
		gameViewController.gkMatch = match;
	else
		gameViewController.gkSession = match;
	gameViewController.alias = self.alias;
	gameViewController.opponentImageUrl = self.opponentImageUrl;
	gameViewController.opponentAlias = self.opponentAlias;
	gameViewController.imageUrl = self.imageUrl;
	gameViewController.myCountry = self.myCountry;
	
	switch (self.gameMode)	{
		case (kVSArcadeLite):
			gameViewController.myNumMatches = [LocalStorageManager integerForKey:VSNUMARCADELITEGAMES];
			gameViewController.myNumWins = [LocalStorageManager integerForKey:VSNUMARCADELITEWINS];
			gameViewController.gameType = multi_players_arcade;
			break;
		case (kVSArcade):
			gameViewController.myNumMatches = [LocalStorageManager integerForKey:VSNUMARCADEGAMES];
			gameViewController.myNumWins = [LocalStorageManager integerForKey:VSNUMARCADEWINS];			
			gameViewController.gameType = multi_players_arcade;
			break;
		case (kVSSingle):
			gameViewController.myNumMatches = [LocalStorageManager integerForKey:VSNUMFREESELECTGAMES];
			gameViewController.myNumWins = [LocalStorageManager integerForKey:VSNUMFREESELECTWINS];
			gameViewController.gameType = multi_players_level_select;
			break;
	}


	gamePacket.packetType = kGKPacketTypeCountry;
	gamePacket.numMatches = gameViewController.myNumMatches;
	gamePacket.numWins = gameViewController.myNumWins;
	gamePacket.name = [[LocalStorageManager objectForKey:COUNTRY] lowercaseString];
	if (self.theMatch)
		[self.theMatch sendDataToAllPlayers:[gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];					
	else
		[self.theSession sendDataToAllPeers:[gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];	
	NSLog(@"sending country %@", gamePacket.name);
	[gamePacket release];

	
	[[self.vc navigationController] pushViewController:gameViewController animated:YES];
	self.theGameVC = gameViewController;
	[gameViewController release];

	GameView* g1View = [[[self.theGameVC.gameViews objectAtIndex:self.theGameVC.theGame] alloc]initWithFrame:CGRectMake(0,0,320,480) AndOwner:self.theGameVC AndGame:self.theGameVC.theGame AndGameType:self.theGameVC.gameType AndLevel:self.theGameVC.difficultiesLevel];
	g1View.lifes = self.theGameVC.lifes;
	
	self.theGameVC.theMainView = g1View;
	if (self.theGameVC.gkMatch || self.theGameVC.gkSession)	{
		if (self.theGameVC.gkMatch)
			g1View.gkMatch = self.theGameVC.gkMatch;
		else
			g1View.gkSession = self.theGameVC.gkSession;
		[g1View setVSScoreBar];
		g1View.scoreView.type = kScoreViewType_beforeGameMultiplay;
	}
	[g1View release];
}


- (void) startP2PServer
{
	if ([LocalStorageManager objectForKey:USER_NAME]){
		self.alias = [LocalStorageManager objectForKey:USER_NAME];
	}else{
		self.alias = [[UIDevice currentDevice] name];
	}
	NSLog(@"starting server..., my name is: %@", self.alias);
	
	GKSession* theSession = [[GKSession alloc] initWithSessionID:@"bashbashmultiplayersession"  displayName:self.alias sessionMode:GKSessionModePeer];
	self.theSession = theSession;
	[theSession release];
	self.theSession.delegate = self;
	self.theSession.available = YES;	
	self.theSession.disconnectTimeout = 4;
	[self.theSession peersWithConnectionState:GKPeerStateAvailable];
	[self.theSession setDataReceiveHandler:self withContext:nil];
}

#pragma mark GKSessionDelegate Protocol
- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
	NSLog(@"didFailWithError called... %@", [error localizedDescription]);
    if ([[error domain] isEqual:@"com.apple.gamekit.GKSessionErrorDomain"] &&
        ([error code] == GKSessionCannotEnableError))
    {
        // Bluetooth/Network disabled, prompt the user to turn it on
		
		
		//		self.waitingForClientsAlertView.title = NSLocalizedString(@"Please enable Wireless and Bluetooth.\n\n\n", nil);
				
    } else {
        // Some other error, get the description from the NSError object
    }	
	[self invalidateSession];
	
    // destroy the GKSession and clean up
}

- (void)session:(GKSession*) session didReceiveConnectionRequestFromPeer:(NSString*) peerID {
	NSLog(@"didReceiveConnectionRequestFromPeer $@:", [self.theSession displayNameForPeer:peerID]);
    [self.theSession acceptConnectionFromPeer:peerID error:nil];
}


- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
	
	// Retain new session.
	self.theSession = session;
	NSLog(@"didChangeState peerName %@", [self.theSession displayNameForPeer:peerID]);
	
	// Do stuff depending on state.
	switch (state) {
		case GKPeerStateAvailable:
			NSLog(@"Peer Available");
			[self.localPlayServerSelectDelegate serverListUpdated:[session displayNameForPeer:peerID] WithPeerId:peerID];
			[self.waitingForServerAlertView dismissWithClickedButtonIndex:0 animated:YES];
			break;
		case GKPeerStateConnected:
			self.theGameState = kGKGameStateAllConnected;
			self.theOpponentGameState = kGKGameStateAllConnected;
			self.opponentAlias=[session displayNameForPeer:peerID];

			NSLog(@"my name is %@", self.alias);
			NSLog(@"Server connected: %@", [session displayNameForPeer:peerID]);
			if (self.isHost)	{
				[self startAsHost:session];
			}
			else{
				self.isHost = NO;
			}
			break;
		case GKPeerStateDisconnected:
			[self invalidateSession];
			NSLog(@"Connection has been reset.");
			break;
	}
}


//
// invalidate session
//
- (void)invalidateSession{
	NSLog(@"invalidateSession");
    if(self.theSession != nil) {
        [self.theSession disconnectFromAllPeers]; 
        self.theSession.available = NO; 
        [self.theSession setDataReceiveHandler: nil withContext: NULL]; 
        self.theSession.delegate = nil; 
		UIAlertView* waitingForClientsAlertView = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"對方已離線", nil) message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
		[waitingForClientsAlertView show];

		//		[self.waitingForClientsAlertView dismissWithClickedButtonIndex:0 animated:YES];
		//[self.delegate connectionDisconnected];
		
		
    }
	self.localPlayServerSelectDelegate=nil;
	if (self.theGameVC)
		[self.theGameVC.theMainView leaveGame];
	self.theGameVC= nil;

	self.theSession = nil;
	self.theMatch = nil;
}

#pragma mark UIAlertViewDelegate Protocol
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	self.opponentAlias = nil;
	self.opponentImageUrl = nil;
	self.imageUrl = nil;
	self.alias = nil;
	self.myCountry = nil;
	self.opponentCountry = nil;
	self.uid = nil;
	self.rcvPacket = nil;
	self.theGameState = kGKGameStateMatchNotFound;
	self.theOpponentGameState = kGKGameStateMatchNotFound;

}

#pragma mark client functions for LocalPlay
-(void)connectToServer:(NSString*) selectedPeerID{
	
	[self.theSession connectToPeer:selectedPeerID withTimeout:0];
}

-(void)scansForServer{
	
	NSString *clientName;
	if ([LocalStorageManager objectForKey:USER_NAME]){
		clientName = [LocalStorageManager objectForKey:USER_NAME];
	}else{
		clientName = [[UIDevice currentDevice] name];
	}
	NSLog(@"scansForServer..., my name is: %@", clientName);
	
	GKSession* gameSession = [[GKSession alloc] initWithSessionID:@"bashbashmultiplayersession"  displayName:clientName sessionMode:GKSessionModeClient];
	self.theSession = gameSession;
	[gameSession release];
	self.theSession.delegate = self;
	self.theSession.available = YES;	
	self.theSession.disconnectTimeout = 4;
	[self.theSession peersWithConnectionState:GKPeerStateAvailable];
	[self.theSession setDataReceiveHandler:self withContext:nil];
	self.alias = clientName;
	
	
	self.waitingForServerAlertView = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"尋找對手中...\n\n\n",nil) message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil] autorelease];
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	// Adjust the indicator so it is up a few pixels from the bottom of the alert
	indicator.center = CGPointMake(135, 65);
	[indicator startAnimating];
	[self.waitingForServerAlertView addSubview:indicator];
	[indicator release];	
	
	
	[self.waitingForServerAlertView show];
}
@end
