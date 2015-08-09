//
//  Constants.m
//  bishibashi
//
//  Created by Kenny Tang on 4/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Constants.h"

static Constants *sharedInstance = nil;

@implementation Constants
@synthesize gameScriptsArray = _gameScriptsArray;
@synthesize gameTimerArray = _gameTimerArray;
@synthesize gamePassingScoreArray = _gamePassingScoreArray;
@synthesize gameScreensArray = _gameScreensArray;
@synthesize availableGameScreensArray = _availableGameScreensArray;
@synthesize attributesArray = _attributesArray;
@synthesize attributeScoresArray = _attributeScoresArray;
@synthesize attributeTotalScoresArray = _attributeTotalScoresArray;
@synthesize attributeRatiosArray = _attributeRatiosArray;
@synthesize APPVERSION = _APPVERSION;
@synthesize noGames = _noGames;
@synthesize noOtherPins = _noOtherPins;
@synthesize noAvailableGames = _noAvailableGames;
@synthesize availableGames = _availableGames;
@synthesize totalNoGames = _totalNoGames;
@synthesize nickNamesArray = _nickNamesArray;
@synthesize language = _language;
@synthesize gameUnLockedArray = _gameUnLockedArray;
@synthesize gamePinsArray = _gamePinsArray;
@synthesize gameGreyPinsArray = _gameGreyPinsArray;
@synthesize otherPinsArray = _otherPinsArray;
@synthesize gamePinScoreArray = _gamePinScoreArray;
@synthesize gameAchievementsArray = _gameAchievementsArray;
@synthesize arcadeAchievementsArray = _arcadeAchievementsArray;
@synthesize appVersionPrefix = _appVersionPrefix;
@synthesize gameCenterEnabled = _gameCenterEnabled;
@synthesize gameLeaderboardsArray = _gameLeaderboardsArray;


- (BOOL) showTestAdmobAdsTouchJSON
{
	return NO;
}


- (BOOL) isGameUnLocked:(Game) game
{
	return [[self.gameUnLockedArray objectAtIndex:game]boolValue];
}

- (void) unLockGame:(Game) game
{
	[self.gameUnLockedArray replaceObjectAtIndex:game withObject:[NSNumber numberWithBool:YES]]; 
	NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.gameUnLockedArray];
	[[NSUserDefaults standardUserDefaults] setObject:myEncodedObject forKey:GAMEUNLOCK];
}
	

- (BOOL) isGameAvailable:(Game) game ForMode:(GameMode)mode
{
	for (int i=0; i<self.noAvailableGames[mode]; i++)	{
		int offset = 0;
		for (int j=0; j<mode; j++)
			offset += self.noAvailableGames[j];
		if (game == self.availableGames[offset+i])	{
			NSLog(@"isGameAvailable %i forMode: %i - true", game, mode);
			return TRUE;
		}
	}
	NSLog(@"isGameAvailable %i forMode: %i - false", game, mode);
	return FALSE;
}

- (int) gamePosition:(Game) game ForMode:(GameMode)mode
{
	int offset = 0;
	for (int j=0; j<mode; j++)
		offset += self.noAvailableGames[j];
	for (int i=0; i<self.noAvailableGames[mode]; i++)	{
		if (game == self.availableGames[offset+i])
			return i+1;
	}
	return 0;
}

- (Game) nextGame:(Game) game ForMode:(GameMode)mode
{
	int offset = 0;
	for (int j=0; j<mode; j++)
		offset += self.noAvailableGames[j];
	for (int i=0; i<self.noAvailableGames[mode]; i++)	{
		if (game == self.availableGames[offset+i])	{
			if (i<self.noAvailableGames[mode]-1)
				return self.availableGames[offset+i+1];
			else if (i==self.noAvailableGames[mode])
				return self.availableGames[offset];
		}
	}
	return (Game)-1;
}

- (Game) firstGameForMode:(GameMode)mode
{
	int offset = [self getOffsetForMode:mode];
	return self.availableGames[offset];
}

- (Game) lastGameForMode:(GameMode)mode
{
	int offset = [self getOffsetForMode:mode]+[self getNoAvailableGamesForMode:mode]-1;
	return self.availableGames[offset];
}

- (int) getOffsetForMode:(GameMode)mode
{
	int offset=0;
	for (int i=0; i<mode; i++)	{
		offset += self.noAvailableGames[i];
	}
	return offset;
}

- (int) getTotalNoGames
{
	return [self getOffsetForMode:kVSArcadeLite+1];
}
										
										
- (NSArray*) getGamesForMode:(GameMode)mode
{
	int no = self.noAvailableGames[mode];
	NSMutableArray* arr = [NSMutableArray arrayWithCapacity:no];
	int offset = [self getOffsetForMode:mode];
	for (int i=0; i<no; i++)	{
		[arr addObject:[NSNumber numberWithInt:self.availableGames[offset+i]]];
	}
	return arr;
}

- (void) setAPPVERSION:(NSString *)version
{
	NSLog(@"kArcade: %i", kArcade);
	NSLog(@"kArcadeLite: %i", kArcadeLite);
	NSLog(@"kSingle: %i", kSingle);
	
	_APPVERSION = version;
	NSLog(@"setAPPVERSION: %@", _APPVERSION);
	if ([_APPVERSION isEqualToString:@"version1"])	{
		self.appVersionPrefix = @"";
		int noAvailableGames[] = {5,5};
		self.noAvailableGames = malloc(sizeof(int)*2);
		memcpy(self.noAvailableGames, noAvailableGames, sizeof(int)*2);

		self.availableGames = malloc(sizeof(int)*11);
		int availableGames[] = {0,6,11,3,8, 
								0,1,5,8,10,13};
		memcpy(self.availableGames, availableGames, sizeof(int)*11);
	}
	else if ([_APPVERSION isEqualToString:@"version2"])	{
		self.appVersionPrefix = @"com.redsoldier.bashbash.";
		int noAvailableGames[] = {13,13,12,12,5,5};
		self.noAvailableGames = malloc(sizeof(int)*6);
		memcpy(self.noAvailableGames, noAvailableGames, sizeof(int)*6);

		self.availableGames = malloc(sizeof(int)*[self getTotalNoGames]);
		int availableGames[] = {0,1,2,3,4,5,6,10,7,8,11,9,12, // kArcade
								0,1,2,3,4,5,6,7,8,9,10,11,12, // kSingle
								0,1,2,3,4,5,6,7,8,9,11,12, // kVSArcade
								0,1,2,3,4,5,6,7,8,9,11,12, // kVSSingle
								0,0,0,0,0, // kArcadeLite
								0,0,0,0,0  // kVSArcadeLite
								};
 /*
		int availableGames[] = {0, // kArcade
			0, // kSingle
			8, // kVSArcade
			0, // kVSSingle
			8, // kArcadeLite
			8  // kVSArcadeLite
  */

	memcpy(self.availableGames, availableGames, sizeof(int)*[self getTotalNoGames]);
	[self regenerateGamesForMode:kArcadeLite FromMode:kArcade];
	[self regenerateGamesForMode:kVSArcadeLite FromMode:kVSArcade];

/*		int offset = [self getOffsetForMode:kArcade];
		int bigoffset = [self getOffsetForMode:kArcadeLite];
		for (int i=0; i<self.noAvailableGames[kArcadeLite]; i++)	{
			int no;
			BOOL found=YES;
			while (found)	{
				no = arc4random()%self.noAvailableGames[kArcade];
				found = NO;
				for (int k=0; k<i; k++)	{
					if (availableGames[no+offset] == availableGames[bigoffset+k])	{
						found=YES;
						break;
					}
				}
			}		
			availableGames[bigoffset+i] = availableGames[no+offset];
		}
		
		offset = [self getOffsetForMode:kVSArcade];		
		bigoffset = [self getOffsetForMode:kVSArcadeLite];
		for (int j=0; j<self.noAvailableGames[kVSArcadeLite]; j++)	{
			int no;
			BOOL found=YES;
			while (found)	{
				no = arc4random()%self.noAvailableGames[kVSArcade];
				found = NO;
				for (int k=0; k<j; k++)	{
					if (availableGames[no+offset] == availableGames[bigoffset+k])	{
						found = YES;
						break;
					}
				}
			}
			availableGames[bigoffset+j] = availableGames[no+offset];						
		}
*/		
		NSLog(@"available Games for single Arcade Lite");
		for (int i=[self getOffsetForMode:kArcadeLite]; i<[self getOffsetForMode:kArcadeLite+1]; i++)	
			NSLog(@"%d\n", self.availableGames[i]);
		NSLog(@"available Games for VS Arcade Lite");
		for (int i=[self getOffsetForMode:kVSArcadeLite]; i<[self getOffsetForMode:kVSArcadeLite+1]; i++)	
			NSLog(@"%d\n", self.availableGames[i]);
		
	}

/*		self.availableGames = malloc(sizeof(int)*2);
		int availableGames[] = {11,
			11};
		memcpy(self.availableGames, availableGames, sizeof(int)*2);
*/		
		
//	[self regenerateGamesForMode:kVSArcade];
//	[self regenerateGamesForMode:kArcade];
	NSLog(@"self.noAvailableGames: %i", self.noAvailableGames);
}

- (void) setGames:(NSArray*) arr ForMode:(GameMode)mode
{
		int offset = [self getOffsetForMode:mode];
	NSLog(@"setGames mode: %i", mode);
	NSLog(@"setGames offset for mode %i:", offset);
		for (NSNumber* number in arr)	{
			self.availableGames[offset++] = [number intValue];
			NSLog(@"offset is %d, value is %d", (offset-1), self.availableGames[offset-1]);
		}
}

- (void) regenerateGamesForMode:(GameMode)mode FromMode:(GameMode)from
{	
	int* availableGames = self.availableGames;
	/* generate random 5 for kArcadeLite */
	int offset = [self getOffsetForMode:from];
	int bigoffset = [self getOffsetForMode:mode];
	for (int i=0; i<self.noAvailableGames[mode]; i++)	{
		int no;
		BOOL found=YES;
		while (found)	{
			no = arc4random()%self.noAvailableGames[from];
			found = NO;
			for (int k=0; k<i; k++)	{
				if (availableGames[no+offset] == availableGames[bigoffset+k])	{
					found=YES;
					break;
				}
			}
		}		
		availableGames[bigoffset+i] = availableGames[no+offset];
	}
}


- (void) regenerateGamesForMode:(GameMode)mode
{
	int hits;
	int offset;
	if (mode == kVSArcadeLite)	{
		hits = [self getNoAvailableGamesForMode:kVSArcade];
		offset = [self getOffsetForMode:kVSArcade];
	}
	else if (mode == kArcadeLite)	{
		hits = [self getNoAvailableGamesForMode:kArcade];
		offset = [self getOffsetForMode:kArcade];
	}
	
	int no = [self getNoAvailableGamesForMode:mode];
	
	NSLog(@"regenerateGamesForMode mode %i no %i", mode, no);
	
	NSMutableArray* arr = [NSMutableArray arrayWithCapacity:no];
	for (int i=0; i<no; i++)	{
		int game = self.availableGames[offset+arc4random()%hits];
		while ([arr containsObject:[NSNumber numberWithInt:game]])
			game = self.availableGames[offset+arc4random()%hits];
		[arr addObject:[NSNumber numberWithInt:game]];
	}
	
	[self setGames:arr ForMode:mode];
}

- (int) getNoAvailableGamesForMode:(GameMode)mode
{
	return self.noAvailableGames[mode];
}

-(void) setLanguage:(NSString*)lang
{
	_language = lang;
	[[NSUserDefaults standardUserDefaults] setObject:_language forKey:UILANGUAGE];
	[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:_language, nil]  forKey:@"AppleLanguages"];
//	[self init];
}
	
-(id)init{
	self = [super init];
	NSString* lang = [[NSUserDefaults standardUserDefaults] objectForKey:UILANGUAGE];
	if (lang)
		_language = lang;
	self.noGames = 13;
	self.noOtherPins = 6;
#ifdef LITE_VERSION
	self.APPVERSION = @"version1";
#else
	self.APPVERSION = @"version2";
#endif
	NSArray *keysArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:keatbeans],
						  [NSNumber numberWithInt:k3in1],
						  [NSNumber numberWithInt:kburgerset],
						  [NSNumber numberWithInt:kufo],
						  [NSNumber numberWithInt:kalarmclock],
						  [NSNumber numberWithInt:kjumpinggirl],
						  [NSNumber numberWithInt:kburgerseq],
						  [NSNumber numberWithInt:k3bo],
						  [NSNumber numberWithInt:ksmallnumber],
						  [NSNumber numberWithInt:kbignumber],
						  [NSNumber numberWithInt:kdancing],
						  [NSNumber numberWithInt:kbunhill],
						  [NSNumber numberWithInt:kpencil],
	//					  [NSNumber numberWithInt:kheartnhand],
						  nil];
	
	NSArray *gameNamesArray = [NSArray arrayWithObjects:NSLocalizedString(@"食豆狂魔", nil), 
							   NSLocalizedString(@"兩鐵合拼",  nil), 
							   NSLocalizedString(@"一盅三件", nil), 
							   NSLocalizedString(@"後巷影快相",  nil), 
							   NSLocalizedString(@"不遷不拆",  nil), 
							   NSLocalizedString(@"畫龍點睛",   nil), 
							   NSLocalizedString(@"雙層牛肉巨無霸",  nil),  
							   NSLocalizedString(@"煎釀三寶",  nil), 
							   NSLocalizedString(@"解拆屏風樓", nil), 
							   NSLocalizedString(@"擲骰鬥大",   nil), 
							   NSLocalizedString(@"節拍動感",  nil), 
							   NSLocalizedString(@"長洲搶包山",  nil), 
							   NSLocalizedString(@"極速鉛芯筆",  nil), 
	//						   NSLocalizedString(@"口不對心",  nil), 
							   nil];
	
	
	NSArray *gameLeaderBoardCategoryArray = [NSArray arrayWithObjects:NSLocalizedString(@"bashbash.freeselect.eatbeans", nil), 
											 NSLocalizedString(@"bashbash.freeselect.3in1",  nil), 
											 NSLocalizedString(@"bashbash.freeselect.burgerset", nil), 
											 NSLocalizedString(@"bashbash.freeselect.ufo",  nil), 
											 NSLocalizedString(@"bashbash.freeselect.alarmclock",  nil), 
											 NSLocalizedString(@"bashbash.freeselect.jumpinggirl",   nil), 
											 NSLocalizedString(@"bashbash.freeselect.burgerseq",   nil), 
											 NSLocalizedString(@"bashbash.freeselect.3bo",  nil),  
											 NSLocalizedString(@"bashbash.freeselect.smallnumber",  nil), 
											 NSLocalizedString(@"bashbash.freeselect.bignumber", nil), 
											 NSLocalizedString(@"bashbash.freeselect.dancing",   nil), 
											 NSLocalizedString(@"bashbash.freeselect.bunhill",  nil), 
											 NSLocalizedString(@"bashbash.freeselect.pencil",  nil), 
	//										 NSLocalizedString(@"bashbash.freeselect.heartnhand",  nil), 
											 nil];
	
	NSArray *gameLeaderBoardLiteCategoryArray = [NSArray arrayWithObjects:NSLocalizedString(@"bashbashlite.freeselect.eatbeans", nil), 
											 NSLocalizedString(@"bashbashlite.freeselect.3in1",  nil), 
											 NSLocalizedString(@"bashbashlite.freeselect.burgerset", nil), 
											 NSLocalizedString(@"bashbashlite.freeselect.ufo",  nil), 
											 NSLocalizedString(@"bashbashlite.freeselect.alarmclock",  nil), 
											 NSLocalizedString(@"bashbashlite.freeselect.jumpinggirl",   nil), 
											 NSLocalizedString(@"bashbashlite.freeselect.burgerseq",   nil), 
											 NSLocalizedString(@"bashbashlite.freeselect.3bo",  nil),  
											 NSLocalizedString(@"bashbashlite.freeselect.smallnumber",  nil), 
											 NSLocalizedString(@"bashbashlite.freeselect.bignumber", nil), 
											 NSLocalizedString(@"bashbashlite.freeselect.dancing",   nil), 
											 NSLocalizedString(@"bashbashlite.freeselect.bunhill",  nil), 
											 NSLocalizedString(@"bashbashlite.freeselect.pencil",  nil), 
	//										NSLocalizedString(@"bashbashlite.freeselect.heartnhand",  nil), 
											 nil];
	
	
	self.attributesArray = [NSArray arrayWithObjects:	NSLocalizedString(@"速度",  nil), 
														NSLocalizedString(@"反應",  nil), 
														NSLocalizedString(@"腦力",  nil), 
														NSLocalizedString(@"協調",  nil), 
														NSLocalizedString(@"節奏",  nil),  nil];
	self.attributeTotalScoresArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0], nil];	
	self.attributeScoresArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0], nil];
	self.attributeRatiosArray = [NSArray arrayWithObjects:
								 [NSArray arrayWithObjects: [NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.5],nil],
								 [NSArray arrayWithObjects: [NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.0],nil],
								 [NSArray arrayWithObjects: [NSNumber numberWithFloat:0.7],[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.0],nil],
								 [NSArray arrayWithObjects: [NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:0.0],nil],
								 [NSArray arrayWithObjects: [NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:1.0],nil],
								 [NSArray arrayWithObjects: [NSNumber numberWithFloat:0.7],[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.0],nil],
								 [NSArray arrayWithObjects: [NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.0],nil],
								 [NSArray arrayWithObjects: [NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.7],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.0],nil],
								 [NSArray arrayWithObjects: [NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.7],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.0],nil],
								 [NSArray arrayWithObjects: [NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.8],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.0],nil],
								 [NSArray arrayWithObjects: [NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:1.0],nil],
								 [NSArray arrayWithObjects: [NSNumber numberWithFloat:0.25],[NSNumber numberWithFloat:0.25],[NSNumber numberWithFloat:0.25],[NSNumber numberWithFloat:0.25],[NSNumber numberWithFloat:0.0],nil],
								 [NSArray arrayWithObjects: [NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.0],nil],
	//							 [NSArray arrayWithObjects: [NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.7],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.0],nil],
								 nil];
									 
	self.nickNamesArray = [NSArray arrayWithObjects:NSLocalizedString(@"閃電手",nil),NSLocalizedString(@"反應王",nil), NSLocalizedString(@"轉數高",nil), NSLocalizedString(@"指揮官",nil), NSLocalizedString(@"啱BIT霸",nil), NSLocalizedString(@"全能俠",nil), nil];
	
	self.gameScriptsArray = [NSArray arrayWithObjects:	[NSArray arrayWithObjects:NSLocalizedString(@"3個豆丁",nil),NSLocalizedString(@"哩係被竇",nil),NSLocalizedString(@"輪流食豆",nil),nil],
								 [NSArray arrayWithObjects:NSLocalizedString(@"兩鐵合拼",nil), NSLocalizedString(@"票務調整",nil), NSLocalizedString(@"可加可減",nil), nil],
								 [NSArray arrayWithObjects:NSLocalizedString(@"星期六日",nil), NSLocalizedString(@"得閒歎吓",nil), NSLocalizedString(@"一盅三件",nil), nil],
								 [NSArray arrayWithObjects:NSLocalizedString(@"不超速駕駛",nil), NSLocalizedString(@"馬路零意外",nil), NSLocalizedString(@"香港人人愛",nil), nil],
								 [NSArray arrayWithObjects:NSLocalizedString(@"尖咀鐘樓",nil), NSLocalizedString(@"法定古蹟",nil), NSLocalizedString(@"不遷不拆 ",nil), nil],
								 [NSArray arrayWithObjects:NSLocalizedString(@"節日慶典",nil), NSLocalizedString(@"一定搵黎",nil), NSLocalizedString(@"醒獅助興",nil), nil],
								 [NSArray arrayWithObjects:NSLocalizedString(@"雙層牛肉巨無霸 ",nil), NSLocalizedString(@"醬汁洋蔥夾青瓜",nil), NSLocalizedString(@"芝士生菜加芝麻",nil), NSLocalizedString(@"人人食過笑哈哈",nil),nil],
								 [NSArray arrayWithObjects:NSLocalizedString(@"旺角街頭",nil), NSLocalizedString(@"五蚊一串",nil), NSLocalizedString(@"好鬼好食",nil), nil],
								 [NSArray arrayWithObjects:NSLocalizedString(@"空氣質素差",nil), NSLocalizedString(@"解拆屏風樓 ",nil), NSLocalizedString(@"香港有得救",nil), nil],
								 [NSArray arrayWithObjects:NSLocalizedString(@"麻雀館內",nil), NSLocalizedString(@"一打就係",nil), NSLocalizedString(@"十三個圈",nil), nil],
								 [NSArray arrayWithObjects:NSLocalizedString(@"一聽節奏",nil), NSLocalizedString(@"眉飛色舞",nil), NSLocalizedString(@"動L起來",nil), nil],
								 [NSArray arrayWithObjects:NSLocalizedString(@"太平清醮",nil), NSLocalizedString(@"一年一度",nil), NSLocalizedString(@"逼爆長洲",nil), nil],
								 [NSArray arrayWithObjects:NSLocalizedString(@"筆墨紙硯",nil), NSLocalizedString(@"文房之尊",nil), NSLocalizedString(@"四寶之首",nil), nil],
	//							[NSArray arrayWithObjects:NSLocalizedString(@"口不對心",nil), NSLocalizedString(@"邊個勁",nil), NSLocalizedString(@"我勁D",nil), nil],
								 nil];

	NSArray *gameInstructionsArray = [NSArray arrayWithObjects:
									  [NSArray arrayWithObjects:NSLocalizedString(@"豆落下前",nil),NSLocalizedString(@"對啱顏色",nil),NSLocalizedString(@"來食豆",nil),nil], 
									  [NSArray arrayWithObjects:NSLocalizedString(@"按下方路線圖",nil),NSLocalizedString(@"左至右的顏色次序",nil),NSLocalizedString(@"來轉車",nil),nil], 
									  [NSArray arrayWithObjects:NSLocalizedString(@"按各點心所需數量",nil),NSLocalizedString(@"次數來按鍵",nil),NSLocalizedString(@"派點心",nil),nil], 
									  [NSArray arrayWithObjects:NSLocalizedString(@"唔好眨眼",nil),NSLocalizedString(@"睇下乜野駛過",nil),NSLocalizedString(@"影快相",nil),nil], 
									  [NSArray arrayWithObjects:NSLocalizedString(@"在分針剛踏正十二時",nil),NSLocalizedString(@"按任何鍵",nil),NSLocalizedString(@"來示威",nil),nil],
									  [NSArray arrayWithObjects:NSLocalizedString(@"以中，右，中，左，中。。。",nil), NSLocalizedString(@"次序按鍵",nil),NSLocalizedString(@"來舞獅",nil),nil], 
									  [NSArray arrayWithObjects:NSLocalizedString(@"以左邊漢堡為樣版",nil), NSLocalizedString(@"下至上按適當鍵",nil),NSLocalizedString(@"製作漢堡",nil),nil], 
									  [NSArray arrayWithObjects:NSLocalizedString(@"下至上",nil),NSLocalizedString(@"按適當顏色鍵",nil),NSLocalizedString(@"桔三寶",nil),nil], 
									  [NSArray arrayWithObjects:NSLocalizedString(@"下至上",nil),NSLocalizedString(@"由小到大按鍵",nil),NSLocalizedString(@"逐層拆上去",nil),nil],
									  [NSArray arrayWithObjects:NSLocalizedString(@"按最大點數的骰",nil),NSLocalizedString(@"博一鋪",nil),NSLocalizedString(@"",nil), nil], 
									  [NSArray arrayWithObjects:NSLocalizedString(@"跟隨所示節拍節奏",nil),NSLocalizedString(@"按任何鍵動L起來",nil),NSLocalizedString(@"（此遊戲需配合聲效）",nil), nil], 
									  [NSArray arrayWithObjects:NSLocalizedString(@"黃掣爬上,紅掣爬落",nil),NSLocalizedString(@"綠掣擲包,鬥拿得多",nil),NSLocalizedString(@"(包越高越高分）",nil), nil], 
									  [NSArray arrayWithObjects:NSLocalizedString(@"㩒㩒㩒㩒㩒",nil),NSLocalizedString(@"再㩒㩒㩒㩒㩒",nil),NSLocalizedString(@"仲係未夠快",nil), nil], 
	//								  [NSArray arrayWithObjects:NSLocalizedString(@"心中所想數字",nil),NSLocalizedString(@"就唔可以",nil),NSLocalizedString(@"按個個數字",nil), nil], 
									  nil];
	
	
	self.gameScreensArray = [NSArray arrayWithObjects:
							 [[NSBundle mainBundle] pathForResource:@"transition_eatbeans_screen_temp" ofType:@"png"], 
									[[NSBundle mainBundle] pathForResource:@"transition_three_in_one_screen_temp" ofType:@"png"],  
									[[NSBundle mainBundle] pathForResource:@"transition_burger_set_screen_temp" ofType:@"png"],  
									[[NSBundle mainBundle] pathForResource:@"transition_ufo_screen_temp" ofType:@"png"],  
									[[NSBundle mainBundle] pathForResource:@"transition_alarm_clock_temp" ofType:@"png"],  
									[[NSBundle mainBundle] pathForResource:@"transition_jumping_girl_screen_temp" ofType:@"png"],  
									[[NSBundle mainBundle] pathForResource:@"transition_burger_seq_screen_temp" ofType:@"png"],  
									[[NSBundle mainBundle] pathForResource:@"transition_3bo_screen_temp" ofType:@"png"],  
									[[NSBundle mainBundle] pathForResource:@"transition_smallnumber_screen_temp" ofType:@"png"],  
									[[NSBundle mainBundle] pathForResource:@"transition_bignumber_screen_temp" ofType:@"png"],  
									[[NSBundle mainBundle] pathForResource:@"transition_dancing_screen_temp" ofType:@"png"],  
									[[NSBundle mainBundle] pathForResource:@"transition_bunhill_screen_temp" ofType:@"png"],  
									[[NSBundle mainBundle] pathForResource:@"transition_quick_pencil_temp" ofType:@"png"],  
	//								[[NSBundle mainBundle] pathForResource:@"transition_bunhill_screen_temp" ofType:@"png"],  
									nil];
	
	self.gamePinsArray = [NSArray arrayWithObjects:
							 [[NSBundle mainBundle] pathForResource:@"eatbeanpin" ofType:@"png"], 
							 [[NSBundle mainBundle] pathForResource:@"3in1pin" ofType:@"png"],  
							 [[NSBundle mainBundle] pathForResource:@"burgersetpin" ofType:@"png"],  
							 [[NSBundle mainBundle] pathForResource:@"ufopin" ofType:@"png"],  
							 [[NSBundle mainBundle] pathForResource:@"alarmclockpin" ofType:@"png"],  
							 [[NSBundle mainBundle] pathForResource:@"jumpinggirlpin" ofType:@"png"],  
							 [[NSBundle mainBundle] pathForResource:@"burgetseqpin" ofType:@"png"],  
							 [[NSBundle mainBundle] pathForResource:@"3bopin" ofType:@"png"],  
							 [[NSBundle mainBundle] pathForResource:@"smallnopin" ofType:@"png"],  
							 [[NSBundle mainBundle] pathForResource:@"bignopin" ofType:@"png"],  
							 [[NSBundle mainBundle] pathForResource:@"dancingpin" ofType:@"png"],  
							 [[NSBundle mainBundle] pathForResource:@"bunhillpin" ofType:@"png"],  
							[[NSBundle mainBundle] pathForResource:@"pencilpin" ofType:@"png"],  
	//						[[NSBundle mainBundle] pathForResource:@"bunhillpin" ofType:@"png"],  
						  	 nil];
	
	self.gameGreyPinsArray = [NSArray arrayWithObjects:
						  [[NSBundle mainBundle] pathForResource:@"eatbeangrey" ofType:@"png"], 
						  [[NSBundle mainBundle] pathForResource:@"3in1grey" ofType:@"png"],  
						  [[NSBundle mainBundle] pathForResource:@"burgersetgrey" ofType:@"png"],  
						  [[NSBundle mainBundle] pathForResource:@"ufogrey" ofType:@"png"],  
						  [[NSBundle mainBundle] pathForResource:@"alarmclockgrey" ofType:@"png"],  
						  [[NSBundle mainBundle] pathForResource:@"jumpinggirlgrey" ofType:@"png"],  
						  [[NSBundle mainBundle] pathForResource:@"burgerseqgrey" ofType:@"png"],  
						  [[NSBundle mainBundle] pathForResource:@"3bogrey" ofType:@"png"],  
						  [[NSBundle mainBundle] pathForResource:@"smallnogrey" ofType:@"png"],  
						  [[NSBundle mainBundle] pathForResource:@"bignogrey" ofType:@"png"],  
						  [[NSBundle mainBundle] pathForResource:@"dancinggrey" ofType:@"png"],  
						  [[NSBundle mainBundle] pathForResource:@"bunhillgrey" ofType:@"png"],  
							  [[NSBundle mainBundle] pathForResource:@"pencilpingrey" ofType:@"png"],  
	//						  [[NSBundle mainBundle] pathForResource:@"bunhillgrey" ofType:@"png"],  
						  nil];

	self.otherPinsArray = [NSArray arrayWithObjects:
						  [[NSBundle mainBundle] pathForResource:@"speed" ofType:@"png"], 
						  [[NSBundle mainBundle] pathForResource:@"reaction" ofType:@"png"],  
						  [[NSBundle mainBundle] pathForResource:@"brain" ofType:@"png"],  
						  [[NSBundle mainBundle] pathForResource:@"commander" ofType:@"png"],  
						  [[NSBundle mainBundle] pathForResource:@"bit" ofType:@"png"],  
						  [[NSBundle mainBundle] pathForResource:@"overall" ofType:@"png"],  
						  nil];
	
	self.gameAchievementsArray = [NSArray arrayWithObjects:
								  @"eatBeans",
								  @"3in1",
								  @"burgerset",
								  @"ufo",
								  @"alarmClock",
								  @"jumpingGirl",
								  @"burgerseq",
								  @"3bo",
								  @"smallno",
								  @"bigno",
								  @"dancing",
								  @"bunhill",
								  @"pencil",
	//							  @"heartnhand",
								  nil];

	self.arcadeAchievementsArray = [NSArray arrayWithObjects:
								  @"speed",
								  @"reaction",
								  @"brain",
								  @"sync",
								  @"rhythm",
								  @"overall",
								  nil];
	
	self.gameLeaderboardsArray = [NSArray arrayWithObjects:
								  @"eatbeans",
								  @"3in1",
								  @"burgerset",
								  @"ufo",
								  @"alarmclock",
								  @"jumpinggirl",
								  @"burgerseq",
								  @"3bo",
								  @"smallnumber",
								  @"bignumber",
								  @"dancing",
								  @"bunhill",
								  @"pencil",
	//							  @"heartnhand",
								  nil];
	
	
	
	
//	self.availableGameScreensArray = [NSArray arrayWithCapacity:10];
//	for (int i=0; i<noGames; i++)	{
//		[self.availableGameScreensArray addObject:[self.gameScreensArray objectAtIndex:self.availableGames[i]]];
//	}
	
	self.gameTimerArray = [NSArray arrayWithObjects:
			/*eatbeans*/					[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.4], [NSNumber numberWithFloat:0.28], [NSNumber numberWithFloat:0.17], [NSNumber numberWithFloat:0.136],nil],
			/*3in1*/						[NSArray arrayWithObjects:[NSNumber numberWithFloat:12], [NSNumber numberWithFloat:2.2], [NSNumber numberWithFloat:1.5], [NSNumber numberWithFloat:1.3],nil],
			/*burgerset*/					[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.4], [NSNumber numberWithFloat:0.3], [NSNumber numberWithFloat:0.2], [NSNumber numberWithFloat:0.16],nil],
			/*UFO*/						[NSArray arrayWithObjects:[NSNumber numberWithFloat:1.0], [NSNumber numberWithFloat:0.7], [NSNumber numberWithFloat:0.55], [NSNumber numberWithFloat:0.4],nil],
			/*alarmclock*/				[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.8], [NSNumber numberWithFloat:0.3], [NSNumber numberWithFloat:0.2], [NSNumber numberWithFloat:0.2],nil],
			/*jumpinggirl*/				[NSArray arrayWithObjects:[NSNumber numberWithFloat:12], [NSNumber numberWithFloat:12], [NSNumber numberWithFloat:12], [NSNumber numberWithFloat:9],nil],
			/*burgetseq*/					[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.8], [NSNumber numberWithFloat:0.5], [NSNumber numberWithFloat:0.4], [NSNumber numberWithFloat:0.28],nil],
			/*3bo*/						[NSArray arrayWithObjects:[NSNumber numberWithFloat:28.0], [NSNumber numberWithFloat:18.0], [NSNumber numberWithFloat:13.5], [NSNumber numberWithFloat:12.0],nil],
			/*smallnumber*/				[NSArray arrayWithObjects:[NSNumber numberWithFloat:15.0], [NSNumber numberWithFloat:11.0], [NSNumber numberWithFloat:8.0], [NSNumber numberWithFloat:15.0],nil],
			/*bignumber*/				   [NSArray arrayWithObjects:[NSNumber numberWithFloat:4.0], [NSNumber numberWithFloat:3.0], [NSNumber numberWithFloat:2.3], [NSNumber numberWithFloat:2.1],nil],
			/*dancing*/				   [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.55], [NSNumber numberWithFloat:0.5], [NSNumber numberWithFloat:0.35], [NSNumber numberWithFloat:0.3],nil],
			/*bunhill*/				   [NSArray arrayWithObjects:[NSNumber numberWithFloat:12], [NSNumber numberWithFloat:12], [NSNumber numberWithFloat:12], [NSNumber numberWithFloat:12],nil],
			/*pencil*/				[NSArray arrayWithObjects:[NSNumber numberWithFloat:12], [NSNumber numberWithFloat:9], [NSNumber numberWithFloat:18], [NSNumber numberWithFloat:12],nil],
	//		/*heartnhand*/				   [NSArray arrayWithObjects:[NSNumber numberWithFloat:4], [NSNumber numberWithFloat:3], [NSNumber numberWithFloat:2], [NSNumber numberWithFloat:1],nil],
							   nil];

	self.gamePassingScoreArray = [NSArray arrayWithObjects:
						   /*eatbeans*/					[NSArray arrayWithObjects:[NSNumber numberWithInt:20], [NSNumber numberWithInt:30], [NSNumber numberWithInt:40], [NSNumber numberWithInt:50],nil],
						   /*3in1*/						[NSArray arrayWithObjects:[NSNumber numberWithInt:20], [NSNumber numberWithInt:30], [NSNumber numberWithInt:40], [NSNumber numberWithInt:50],nil],
						   /*burgerset*/					[NSArray arrayWithObjects:[NSNumber numberWithInt:20], [NSNumber numberWithInt:30], [NSNumber numberWithInt:40], [NSNumber numberWithInt:50],nil],
						   /*UFO*/						[NSArray arrayWithObjects:[NSNumber numberWithInt:20], [NSNumber numberWithInt:30], [NSNumber numberWithInt:40], [NSNumber numberWithInt:50],nil],
						   /*alarmclock*/				[NSArray arrayWithObjects:[NSNumber numberWithInt:20], [NSNumber numberWithInt:30], [NSNumber numberWithInt:40], [NSNumber numberWithInt:50],nil],
						   /*jumpinggirl*/				[NSArray arrayWithObjects:[NSNumber numberWithInt:20], [NSNumber numberWithInt:30], [NSNumber numberWithInt:40], [NSNumber numberWithInt:35],nil],
						   /*burgetseq*/					[NSArray arrayWithObjects:[NSNumber numberWithInt:20], [NSNumber numberWithInt:30], [NSNumber numberWithInt:40], [NSNumber numberWithInt:50],nil],
						   /*3bo*/						[NSArray arrayWithObjects:[NSNumber numberWithInt:20], [NSNumber numberWithInt:30], [NSNumber numberWithInt:40], [NSNumber numberWithInt:50],nil],
						   /*smallnumber*/				[NSArray arrayWithObjects:[NSNumber numberWithInt:20], [NSNumber numberWithInt:30], [NSNumber numberWithInt:40], [NSNumber numberWithInt:50],nil],
							/*bignumber*/				   [NSArray arrayWithObjects:[NSNumber numberWithInt:20], [NSNumber numberWithInt:30], [NSNumber numberWithInt:40], [NSNumber numberWithInt:50],nil],
							/*dancing*/				   [NSArray arrayWithObjects:[NSNumber numberWithInt:20], [NSNumber numberWithInt:30], [NSNumber numberWithInt:40], [NSNumber numberWithInt:50],nil],
							/*bunhill*/				   [NSArray arrayWithObjects:[NSNumber numberWithInt:20], [NSNumber numberWithInt:30], [NSNumber numberWithInt:40], [NSNumber numberWithInt:50],nil],
							/*pencil*/				[NSArray arrayWithObjects:[NSNumber numberWithInt:30], [NSNumber numberWithInt:50], [NSNumber numberWithInt:40], [NSNumber numberWithInt:35],nil],
	//						/*heartnhand*/				   [NSArray arrayWithObjects:[NSNumber numberWithInt:20], [NSNumber numberWithInt:30], [NSNumber numberWithInt:40], [NSNumber numberWithInt:50],nil],
								  nil];
	
	self.gamePinScoreArray = [NSArray arrayWithObjects:
								  /*eatbeans*/					[NSArray arrayWithObjects:[NSNumber numberWithInt:25], [NSNumber numberWithInt:72],nil],
								  /*3in1*/						[NSArray arrayWithObjects:[NSNumber numberWithInt:30], [NSNumber numberWithInt:68],nil],
								  /*burgerset*/					[NSArray arrayWithObjects:[NSNumber numberWithInt:25], [NSNumber numberWithInt:68],nil],
								  /*UFO*/						[NSArray arrayWithObjects:[NSNumber numberWithInt:20], [NSNumber numberWithInt:68],nil],
								  /*alarmclock*/				[NSArray arrayWithObjects:[NSNumber numberWithInt:30], [NSNumber numberWithInt:68],nil],
								  /*jumpinggirl*/				[NSArray arrayWithObjects:[NSNumber numberWithInt:35], [NSNumber numberWithInt:67],nil],
								  /*burgetseq*/					[NSArray arrayWithObjects:[NSNumber numberWithInt:30], [NSNumber numberWithInt:68],nil],
								  /*3bo*/						[NSArray arrayWithObjects:[NSNumber numberWithInt:25], [NSNumber numberWithInt:72],nil],
								  /*smallnumber*/				[NSArray arrayWithObjects:[NSNumber numberWithInt:25], [NSNumber numberWithInt:72],nil],
								  /*bignumber*/				   [NSArray arrayWithObjects:[NSNumber numberWithInt:25], [NSNumber numberWithInt:62],nil],
								  /*dancing*/				   [NSArray arrayWithObjects:[NSNumber numberWithInt:20], [NSNumber numberWithInt:60],nil],
								  /*bunhill*/				   [NSArray arrayWithObjects:[NSNumber numberWithInt:30], [NSNumber numberWithInt:78],nil],
									/*pencil*/				  [NSArray arrayWithObjects:[NSNumber numberWithInt:40], [NSNumber numberWithInt:70],nil],
	//								/*heartnhand*/				   [NSArray arrayWithObjects:[NSNumber numberWithInt:25], [NSNumber numberWithInt:72],nil],
								  nil];
	
	gameNamesDictionary = [[NSDictionary dictionaryWithObjects:gameNamesArray forKeys:keysArray] retain];
	gameInstructionsDictionary = [[NSDictionary dictionaryWithObjects:gameInstructionsArray forKeys:keysArray] retain];
	gameTransitionScreenDictionary = [[NSDictionary dictionaryWithObjects:self.gameScreensArray forKeys:keysArray] retain];
	gameLeaderBoardCategoryDictionary = [[NSDictionary dictionaryWithObjects:gameLeaderBoardCategoryArray forKeys:keysArray] retain];
	gameLeaderBoardLiteCategoryDictionary = [[NSDictionary dictionaryWithObjects:gameLeaderBoardLiteCategoryArray forKeys:keysArray] retain];

	NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSData * myEncodedObject = [userDefault objectForKey:GAMEUNLOCK];
	id obj = [NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
	if([obj class] == [NSNull class])
		self.gameUnLockedArray = [NSMutableArray arrayWithCapacity:self.noGames];
	else
		self.gameUnLockedArray = obj;
	
	myEncodedObject =  [userDefault objectForKey:PIN];
	obj = [NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
	if([obj class] == [NSNull class])
		[userDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSArray array]]  forKey:PIN];
	
	return self;
}


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

-(NSDictionary*)getGameLeaderboardCategoryDictionary{
	return gameLeaderBoardCategoryDictionary;
}

-(NSDictionary*)getGameLeaderboardLiteCategoryDictionary{
	return gameLeaderBoardLiteCategoryDictionary;
}

-(NSDictionary*)getGameNamesDictionary{
	return gameNamesDictionary;
}

-(NSDictionary*)getGameInstructionsDictionary{
	return gameInstructionsDictionary;
}

-(NSDictionary*)getGameTransitionScreenDictionary{
	return gameTransitionScreenDictionary;
}

-(void) clearAttributeScores{
	for (int i=0; i<[self.attributeScoresArray count]; i++)	{
		[self.attributeScoresArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:0.0]];
		[self.attributeTotalScoresArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:0.0]];
	}
}

-(void) updateAttributeScore:(int)score ForGame:(Game)game
{
	NSArray* ratio = [self.attributeRatiosArray objectAtIndex:game];
	for (int i=0; i<5; i++)	{
		float originalScore = [[self.attributeScoresArray objectAtIndex:i] floatValue];
		float originalTotal = [[self.attributeTotalScoresArray objectAtIndex:i] floatValue];
		
		[self.attributeScoresArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:originalScore + score*[[ratio objectAtIndex:i] floatValue]]];
		[self.attributeTotalScoresArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:originalTotal + [[ratio objectAtIndex:i] floatValue]]];
	}
}

-(void) logAttributeScores{
	int i=0;
	for (NSNumber* number in self.attributeScoresArray)	{
		i++;
	}
}	
@end
