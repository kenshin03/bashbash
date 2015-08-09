//
//  bishibashiAppDelegate.m
//  bishibashi
//
//  Created by Eric on 06/03/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "bishibashiAppDelegate.h"

@implementation bishibashiAppDelegate

@synthesize window;
@synthesize sharedSoundEffectsManager = _sharedSoundEffectsManager;

- (void)applicationDidFinishLaunching:(UIApplication *)application {   
	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
	/*
	 NSString *path = [[NSBundle mainBundle] pathForResource:@"splash_screen_iphone" ofType:@"mp4"];
	 
	 MPMoviePlayerController* thePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:path]];
	 thePlayer.scalingMode = MPMovieScalingModeAspectFill;
	 thePlayer.movieControlMode = MPMovieControlModeHidden;
	 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(splashMovieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:thePlayer];
	 [thePlayer play];
	 */
	NSNumber* numGamePlay = [LocalStorageManager objectForKey:NUMGAMEPLAY];
	if (numGamePlay)	{
		NSLog(@"numPlay is %d", [numGamePlay intValue]);
#ifdef LITE_VERSION
		if ([numGamePlay intValue]==5)	{
			// open an alert with just an OK button
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"多謝遊玩BashBash! Lite",nil) 
															message:NSLocalizedString(@"若喜歡BashBash! Lite,可以透過AppStore給我們一些意見嗎？",nil)
														   delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"寫意見",nil), NSLocalizedString(@"再玩多陣",nil),nil];
			[alert show];	
			[alert release];
		}		
#endif
//		[LocalStorageManager setObject:[NSNumber numberWithInt:6] forKey:NUMGAMEPLAY];		
		[LocalStorageManager setObject:[NSNumber numberWithInt:[numGamePlay intValue]+1] forKey:NUMGAMEPLAY];
	}
	else
		[LocalStorageManager setObject:[NSNumber numberWithInt:1] forKey:NUMGAMEPLAY];
			
	[self initMainMenu];
	[self authenticateLocalPlayer];
    [window makeKeyAndVisible];
	
}

- (void) authenticateLocalPlayer
{
	if ([GameCenterManager isGameCenterAvailable])	{
		[[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
			if (error == nil)
			{
				// Insert code here to handle a successful authentication.
				[[Constants sharedInstance] setGameCenterEnabled:YES];
				[GameCenterManager postFriendsList];
				
				if ([LocalStorageManager boolForKey:LEADERBOARD_UPLOAD_FAILED] == YES){
					[GameCenterManager leaderboardReUpload];
				}

				[[SocialPanel sharedInstance] addGCIcon];
				
				NSString* userName = [LocalStorageManager objectForKey:USER_NAME];
				if (!userName || [userName isEqualToString:@""])
					[LocalStorageManager setObject:[[GKLocalPlayer localPlayer] alias]  forKey:USER_NAME];

				[GKMatchmaker sharedMatchmaker].inviteHandler = ^(GKInvite *acceptedInvite, NSArray *playersToInvite) {
					// Insert application-specific code here to clean up any games in progress.
					if (acceptedInvite)
					{
						GKMatchmakerViewController *mmvc = [[[GKMatchmakerViewController alloc] initWithInvite:acceptedInvite] autorelease];
						mmvc.matchmakerDelegate = [GameCenterManager sharedInstance];
//						[[GameCenterManager sharedInstance] setVc:menuViewController];
						[[GameCenterManager sharedInstance] setIsHost:NO];
						[menuController presentModalViewController:mmvc animated:YES];
					}
					else if (playersToInvite)
					{
						GKMatchRequest *request = [[[GKMatchRequest alloc] init] autorelease];
						request.minPlayers = 2;
						request.maxPlayers = 2;
						request.playersToInvite = playersToInvite;
						
						GKMatchmakerViewController *mmvc = [[[GKMatchmakerViewController alloc] initWithMatchRequest:request] autorelease];
						mmvc.matchmakerDelegate =[GameCenterManager sharedInstance];
//						[[GameCenterManager sharedInstance] setVc:menuViewController];
						[menuController presentModalViewController:mmvc animated:YES];
					}
				};
				
				/*
				NSLog(@"menuController reload 1");
				if (menuController != nil){
					NSLog(@"menuController reload 2");
					[menuController reloadCommunityOverlay];
				 
				}
				*/
				
/*
				[[GKLocalPlayer localPlayer] loadFriendsWithCompletionHandler:^(NSArray *friends, NSError *error)	{
					if (friends)	{
							[GKPlayer loadPlayersForIdentifiers: friends withCompletionHandler:^(NSArray *playerArray, NSError *error)
							 {
								 for (GKPlayer* tempPlayer in playerArray)
								 {
									 NSLog(@"player id is %@", tempPlayer.playerID);
									 NSLog(@"player alias is %@", tempPlayer.alias);
								 }
							 }];
							
						}
					
				}];
 */
			}
			else
			{
				// Your application can process the error parameter to report the error to the player.
				[[Constants sharedInstance] setGameCenterEnabled:NO];
			}
		}];
	}
	else
		[[Constants sharedInstance] setGameCenterEnabled:NO];

}


-(void)splashMovieFinishedCallback:(NSNotification*)aNotification
{
	/*
	 MPMoviePlayerController* thePlayer = [aNotification object];
	 [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:thePlayer];
	 
	 // Release the movie instance created in playMovieAtURL:
	 [thePlayer release];
	 */
    // Override point for customization after application launch
	[self initMainMenu];
    [window makeKeyAndVisible];
}

- (void)dealloc {
	[menuController release];
    [window release];
    [super dealloc];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonInd
{
	if 	([[LocalStorageManager objectForKey:NUMGAMEPLAY] intValue]==6)	{
		if (buttonInd==0)	{
			NSString *buyString=@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=379884431";
			NSURL *url = [[NSURL alloc] initWithString:[buyString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
			[[UIApplication sharedApplication] openURL:url];
			[url release];
		}
		else if (buttonInd==1)	{
			[LocalStorageManager setObject:[NSNumber numberWithInt:0] forKey:NUMGAMEPLAY];		
		}
		return;
	}

	switch (buttonInd)	{
		case(0):
			[[Constants sharedInstance ]setLanguage:@"zh-hk"];
			[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hk", nil]  forKey:@"AppleLanguages"];
			break;
		case(1):
			[[Constants sharedInstance]  setLanguage:@"zh-Hans"];
			[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-Hans", nil]  forKey:@"AppleLanguages"];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"选择了简体中文" 
															message:@"你选择的语言设定会在重新启动後生效"
														   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];	
			[alert release];
			break;
		case(2):
			[[Constants sharedInstance]  setLanguage:@"zh_TW"];
			[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh_TW", nil]  forKey:@"AppleLanguages"];
			alert = [[UIAlertView alloc] initWithTitle:@"選擇了繁體中文(台灣）" 
															message:@"你選擇的語言設定會在重新啟動後生效"
														   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];	
			[alert release];
			break;
		case(3):
			[[Constants sharedInstance]  setLanguage:@"en-hk"];
			[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"en-hk", nil]  forKey:@"AppleLanguages"];
			alert = [[UIAlertView alloc] initWithTitle:@"English Selected" 
															message:@"Selected Language Setting Would be Effective After App Restart"
														   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];	
			[alert release];
			break;
	}
}

- (void) initMainMenu	{
	NSString* _language = [[NSUserDefaults standardUserDefaults] objectForKey:UILANGUAGE];
	if (_language==nil)	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"首次使用本軟體\nFirst Time Use" 
													message:@"請選擇語言 Please Select Language"
												   delegate:self cancelButtonTitle:nil otherButtonTitles:@"繁體中文（香港廣東話）", @"简体中文", @"繁體中文（台灣）",@"English",nil];
		[alert show];	
		[alert release];
	}
	menuController = [[TitleMenuViewController alloc]init];
	navigationController = [[UINavigationController alloc] initWithRootViewController: menuController];
	[window addSubview:[navigationController view]];
	self.sharedSoundEffectsManager = [MediaManager sharedInstance];
	[self.sharedSoundEffectsManager playTitleScreenBGM];
	
}



@end
