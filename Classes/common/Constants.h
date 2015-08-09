//
//  Constants.h
//  bishibashi
//
//  Created by Eric on 05/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#define HOSTURL @"http://red-soldier.appspot.com/"
#define ANONYMOUSPHOTOURL @"images/bubblegum_soldier_small.png"
#define ADDGAMERECORDREQ @"addGameRecord?"
#define UPLOADIMAGEREQ @"uploadImage?"
#define GETGAMERECORDREQ @"getGameRecord?"
#define GETMSGDREQ @"getMsg?"
#define GETVIDEOREQ @"getVideo?"
#define GETMAPREQ @"getMap?"
#define GETTWUSERREQ @"getTWUser?"
#define ADDFBUSERREQ @"addFBUser?"
#define ADDGCUSERREQ @"addGCUser?"
#define USER_NAME @"username"
#define COUNTRY @"country"
#define GAMEFRAME @"gameframe"

#define GAMEFRAME @"gameframe"

#define FACEBOOK_USER_NAME @"facebookUserName"
#define FACEBOOK_IMAGE_URL @"fbimageurl"
#define FACEBOOK_USER_ID @"fbuserid"
#define USE_FACEBOOK_NAME_AND_IMAGE @"useFacebookNameAndImage"
#define UPLOAD_PHOTO_TO_FACEBOOK @"uploadPhotoToFacebook"
#define POST_SCORE_TO_FACEBOOK @"postScoreToFacebook"

#define USER_NAME @"username"
#define USER_IMAGE @"userImage"

#define TWITTER_USER_NAME @"twitterName"
#define TWITTER_USER_IMAGE @"twitterProfileImageUrl"
#define TWITTER_USER @"twitteruser"
#define TWITTER_PASSWORD @"twitterpass"
#define TWITTER_STATUS @"twitterStatus"
#define POST_SCORE_TO_TWITTER @"postScoreToTwitter"
#define UPLOAD_PHOTO_TO_TWITTER @"uploadPhotoToTwitter"
#define USE_TWITTER_NAME_AND_IMAGE @"useTwitterNameAndImage"

#define SINA_USER_NAME @"sinaUserName"
#define SINA_USER_IMAGE @"sinaimage"
#define SINA_USER @"sinauser"
#define SINA_PASSWORD @"sinapass"
#define POST_SCORE_TO_SINA @"postScoreToSina"
#define UPLOAD_PHOTO_TO_SINA @"uploadPhotoToTSina"
#define USE_SINA_NAME_AND_IMAGE @"useSinaName"


#define PIN @"pin"
#define OTHERPIN @"otherpin"

#define VSNUMGAMES @"vsnumgames"
#define VSNUMARCADELITEGAMES @"vsnumarcadelitegames"
#define VSNUMARCADEGAMES @"vsnumarcadegames"
#define VSNUMFREESELECTGAMES @"vsnumfreeselectgames"

#define VSNUMWINS @"vsnumwins"
#define VSNUMARCADELITEWINS @"vsnumarcadelitewins"
#define VSNUMARCADEWINS @"vsnumarcadewins"
#define VSNUMFREESELECTWINS @"vsnumfreeselectwins"

#define VSNUMLOSES @"vsnumloses"
#define VSNUMARCADELITELOSES @"vsnumarcadeliteloses"
#define VSNUMARCADELOSES @"vsnumarcadeloses"
#define VSNUMFREESELECTLOSES @"vsnumfreeselectloses"

#define VSNUMDRAWS @"vsnumdraws"
#define VSNUMARCADELITEDRAWS @"vsnumarcadelitedraws"
#define VSNUMARCADEDRAWS @"vsnumarcadedraws"
#define VSNUMFREESELECTDRAWS @"vsnumfreeselectdraws"

#define	FBUSERIMAGE @"fbuserimage"
#define TWITTERUSERIMAGE @"twitteruserimage"
#define SOUNDOFF @"soundOff"
#define MUSIC_OFF @"musicOff"

#define SINAUSER @"sinauser"
#define SINAPASSWORD @"sinapass"
#define POSTSCORETOSINA @"postScoreToSina"
#define UPLOADPHOTOTOSINA @"uploadPhotoToTSina"
#define SOUNDOFF @"soundOff"

#define USEINGAMEIMAGES @"useingameimages"
#define kBashBashSessionID @"com.bashbash.session"
#define kBashBashArchiveKey @"com.bashbash"
#define kBashBashPlayerProfile @"com.bashbash.playerprofile"

#define STORED_INGAME_IMAGE_LIST @"ingameimagelist"
#define STORED_IMAGE_LIST @"imagelist"
#define INGAMEIMAGESKEY @"ingameimageskey"
#define LIFEICON @"lifeicon"

#define GAMELEVEL @"gamelevel"
#define UILANGUAGE @"uilanguage"
#define LOCALRECORD @"localrecord"
#define LOCALHIGHESTRECORD @"localhighestrecord"

#define SHAREDSECRET @"adelenekakakenny"

#define NICKNAME @"nicknameicons"
#define	GAMEUNLOCK @"gameunlock"

#define NUMGAMEPLAY @"numgameplay"

#define kGamekitArcadeModeLeaderboardLiteCategory @"bashbashlite.arcade"
#define kGamekitArcadeModeLeaderboardCategory @"bashbash.arcade"

#define kGamekitVSLeaderboardLiteCategory @"bashbashlite.vs"
#define kGamekitVSLeaderboardCategory @"bashbash.vs"

#define LEADERBOARD_UPLOAD_FAILED @"leaderboardUploadFailed"
#define LEADERBOARD_UPLOAD_FAILED_CATEGORY @"leaderboardUploadFailedCategory"
#define LEADERBOARD_UPLOAD_FAILED_SCORE @"leaderboardUploadFailedScore"

#define TW_FONT_NAME @"wt005.ttf"
#define TW_FONT_MENU_SIZE 16.0f
#define ASCII_FONT_NAME @"BADABB.TTF"
#define ASCII_FONT_MENU_SIZE 20.0f

typedef enum GKGameStates {
	kGKGameStateMatchNotFound,
	kGKGameStateMatchFound,
	kGKGameStateAllConnected,
	kGKGameStateReadyToStart,
	kGKGameStateStarted,
	kGKGameStateEnded,
} GKGameState;


typedef enum _ButState
{
	kRed,
	kGreen,
	kBlue,
}ButState;

typedef enum {
	kStateStartGame,
	kStateMultiplayer,
	kGameStateInterrupted,
	kStateMultiplayerDone,
} GameState;

typedef enum _GameLevel {
	kEasy,
	kNormal,
	kHard,
	kWorldClass
} GameLevel;

typedef enum _PinLevel{
	kBeginner,
	kIntermediate,
	kMaster
} PinLevel;

typedef enum _GameMode {
	kArcade = 0,
	kSingle = 1,
	kVSArcade=2,
	kVSSingle=3,
	kArcadeLite=4,
	kVSArcadeLite=5,
	kGCVSSingle=6
} GameMode;

typedef enum _Game
{
	kcreditsview = -10,
	karcadelite=-2,
	karcade=-1,
	keatbeans = 0,
	k3in1 = 1,
	kburgerset = 2,
	kufo = 3,
	kalarmclock = 4,
	kjumpinggirl = 5,
	kburgerseq = 6,
	k3bo = 7,
	ksmallnumber=8,
	kbignumber=9,
	kdancing=10,
	kbunhill=11,
	kpencil=12,
//	kheartnhand=13,
}Game;

typedef enum _locality
{
	klocal=0,
	knearby=1,
	kcountry=2,
	kworld=3
} Locality;

typedef enum _currrentGameType
{
	none = 0,
	one_player_arcade = 1,
	one_player_level_select = 2,
	multi_players_arcade = 3,
	multi_players_level_select = 4,
	
}currrentGameType;

typedef enum _currrentMenuScreen
{
	start_screen = 0,
	one_player_menu = 1,
	one_player_difficulty_menu = 2,
	one_player_level_select_menu = 3,
	multi_players_menu = 4,
	localmp_mode_select_menu = 5,
	localmp_level_select_menu = 6,
	gc_mode_select_menu = 7,
	gc_level_select_menu = 8,
	extra_menu = 9,
	no_change=10,
}currrentMenuScreen;


typedef enum _roundResults
{
	round_won = 0,
	round_failed = 1,
}roundResults;

static inline double radians (double degrees) {return degrees * M_PI/180;}

@interface Constants : NSObject {
	NSString* _APPVERSION;
	int _noGames;
	int _noOtherPins;
	int* _noAvailableGames;
	int* _availableGames;
	
	int _totalNoGames;
	NSDictionary* gameNamesDictionary;
	NSDictionary* gameInstructionsDictionary;
	NSDictionary* gameTransitionScreenDictionary;
	NSDictionary* gameLeaderBoardLiteCategoryDictionary;
	NSDictionary* gameLeaderBoardCategoryDictionary;
	NSMutableArray* _availableGameScreensArray;
	NSArray* _gameScreensArray;
	NSArray* _gamePinsArray;
	NSArray* _gameGreyPinsArray;
	NSArray* _otherPinsArray;

	NSArray* _gameTimerArray;
	NSArray* _gamePassingScoreArray;
	NSArray* _attributesArray;
	NSArray* _gameScriptsArray;
	NSArray* _attributeRatiosArray;
	NSArray* _nickNamesArray;
	NSMutableArray* _attributeScoresArray;
	NSMutableArray* _attributeTotalScoresArray;
	
	NSString*	_language;
	BOOL	_gameCenterEnabled;
	
	NSMutableArray*	_gameUnLockedArray;
	NSArray* _gamePinScoreArray;
	
	NSArray*	_gameAchievementsArray;
	NSArray*	_arcadeAchievementsArray;
	NSArray*	_gameLeaderboardsArray;
	
	NSString*	_appVersionPrefix;
}

+ (id)sharedInstance;
-(NSDictionary*)getGameNamesDictionary;
-(NSDictionary*)getGameLeaderboardCategoryDictionary;
-(NSDictionary*)getGameLeaderboardLiteCategoryDictionary;
-(NSDictionary*)getGameInstructionsDictionary;
-(NSDictionary*)getGameTransitionScreenDictionary;

- (int) getNoAvailableGamesForMode:(GameMode)mode;
- (int) getOffsetForMode:(GameMode)mode;


@property (nonatomic, retain) NSString* language;
@property (nonatomic, retain) NSString* APPVERSION;
@property (nonatomic, assign) int noGames;
@property (nonatomic, assign) int noOtherPins;
@property (nonatomic, assign) int* noAvailableGames;
@property (nonatomic, assign) int* availableGames;
@property (nonatomic, assign) int totalNoGames;
@property (nonatomic, retain) NSArray* nickNamesArray;
@property (nonatomic, retain) NSArray* gameScreensArray;
@property (nonatomic, retain) NSArray* gamePinsArray;
@property (nonatomic, retain) NSArray* gameGreyPinsArray;
@property (nonatomic, retain) NSArray* otherPinsArray;
@property (nonatomic, retain) NSArray* availableGameScreensArray;
@property (nonatomic, retain) NSArray* gameScriptsArray;
@property (nonatomic, retain) NSArray* gameTimerArray;
@property (nonatomic, retain) NSArray* gamePassingScoreArray;
@property (nonatomic, retain) NSArray* attributesArray;
@property (nonatomic, retain) NSMutableArray* attributeScoresArray;
@property (nonatomic, retain) NSMutableArray* attributeTotalScoresArray;
@property (nonatomic, retain) NSArray* attributeRatiosArray;
@property (nonatomic, retain) NSMutableArray* gameUnLockedArray;
@property (nonatomic, retain) NSArray* gamePinScoreArray;
@property (nonatomic, retain) NSArray* gameAchievementsArray;
@property (nonatomic, retain) NSArray* arcadeAchievementsArray;
@property (nonatomic, retain) NSArray* gameLeaderboardsArray;
@property (nonatomic, retain) NSString* appVersionPrefix;
@property (nonatomic, assign) BOOL gameCenterEnabled;

-(void) updateAttributeScore:(int)score ForGame:(Game)game;
- (Game) firstGameForMode:(GameMode)mode;

@end
