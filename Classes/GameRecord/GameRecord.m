//
//  GameRecord.m
//  bishibashi
//
//  Created by Eric on 04/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameRecord.h"
#import "SinaMicroBlogUpdater.h"
#import "TwitterRequest.h"
#import "Constants.h"
#import "FBDataSource.h"
#import "LocalStorageManager.h"

@implementation GameRecord
@synthesize theConnection = _theConnection;
@synthesize gameLevel = _gameLevel;
@synthesize fbuid = _fbuid;
@synthesize twusername = _twusername;
@synthesize mbusername = _mbusername;
@synthesize game = _game;
@synthesize country = _country;
@synthesize gps_x = _gps_x;
@synthesize gps_y = _gps_y;
@synthesize score = _score;
@synthesize gameMode = _gameMode;
@synthesize time = _time;
@synthesize name = _name;
@synthesize hasGps = _hasGps;
@synthesize deviceType = _deviceType;
@synthesize imageStr = _imageStr;
@synthesize uuid = _uuid;
@synthesize imei = _imei;
@synthesize locationManager = _locationManager;
@synthesize operationQueue = _operationQueue;
@synthesize toSubmit = _toSubmit;
@synthesize isShown = _isShown;
@synthesize delegate = _delegate;

- (void) dealloc
{
//	NSLog(@"dealloc GameRecord");
	self.fbuid = nil;
	self.mbusername = nil;
	self.twusername = nil;
	self.name = nil;
	self.time = nil;
	self.country = nil;
	self.deviceType = nil;
	self.imei = nil;
	self.locationManager = nil;
	self.uuid = nil;
	self.imageStr = nil;
	self.theConnection = nil;
	[super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.name forKey:@"name"];
	[encoder encodeObject:self.time forKey:@"time"];
	[encoder encodeInt:self.gameLevel forKey:@"gamelevel"];
	[encoder encodeObject:self.fbuid forKey:@"fbuid"];
	[encoder encodeObject:self.twusername forKey:@"twusername"];
	[encoder encodeInt:self.game forKey:@"game"];
	[encoder encodeInt:self.gameLevel forKey:@"gameLevel"];
	[encoder encodeObject:self.country forKey:@"country"];
	[encoder encodeBool:self.hasGps forKey:@"hasgps"];
	[encoder encodeFloat:self.gps_x forKey:@"gps_x"];
	[encoder encodeFloat:self.gps_y forKey:@"gps_y"];
	[encoder encodeInt:self.score forKey:@"score"];
	[encoder encodeInt:self.gameMode forKey:@"gamemode"];
	[encoder encodeObject:self.deviceType forKey:@"devicetype"];
	
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if (self = [super init]) {
		self.name = [decoder decodeObjectForKey:@"name"];
		self.time = [decoder decodeObjectForKey:@"time"];
		self.gameLevel = [decoder decodeIntForKey:@"gamelevel"];
		self.fbuid = [decoder decodeObjectForKey:@"fbuid"];
		self.twusername = [decoder decodeObjectForKey:@"twusername"];
		self.game = [decoder decodeIntForKey:@"game"];
		self.gameLevel = [decoder decodeIntForKey:@"gameLevel"];
		self.country = [decoder decodeObjectForKey:@"country"];
		self.hasGps = [decoder decodeBoolForKey:@"hasgps"];
		self.gps_x = [decoder decodeFloatForKey:@"gps_x"];
		self.gps_y = [decoder decodeFloatForKey:@"gps_y"];
		self.score = [decoder decodeIntForKey:@"score"];
		self.gameMode = [decoder decodeIntForKey:@"gamemode"];
		self.deviceType = [decoder decodeObjectForKey:@"devicetype"];
		
		self.isShown = NO;
		constantsInstance = [Constants sharedInstance];
    }
    return self;
}

- (NSComparisonResult)compare:(GameRecord *)aRecord
{
	if (self.score < aRecord.score)
		return NSOrderedAscending;
	else if (self.score == aRecord.score)
		return NSOrderedSame;
	else
		return NSOrderedDescending;
}

- (NSComparisonResult)inversecompare:(GameRecord *)aRecord
{
	if (self.score > aRecord.score)
		return NSOrderedAscending;
	else if (self.score == aRecord.score)
		return NSOrderedSame;
	else
		return NSOrderedDescending;
}

- (NSString*) toUrlString
{
	NSMutableString* str = [[NSMutableString alloc] initWithCapacity:100];
	if (self.name)
		[str appendFormat:@"&name=%@",self.name];
//	if (self.time)	{
//		NSString *timestamp = [NSString stringWithFormat:@"%lld", (long long int)[self.time timeIntervalSince1970]*1000];
//		[str appendFormat:@"&time=%@",timestamp];
//	}
	[str appendFormat:@"&gameLevel=%d",self.gameLevel];
	if ([LocalStorageManager stringForKey:FACEBOOK_USER_ID] != nil)
		[str appendFormat:@"&fbuid=%@",[LocalStorageManager stringForKey:FACEBOOK_USER_ID]];
	if ([LocalStorageManager stringForKey:SINA_USER] != nil)
		[str appendFormat:@"&mbusername=%@",[[LocalStorageManager stringForKey:SINA_USER] lowercaseString]];
	if ([LocalStorageManager stringForKey:TWITTER_USER] != nil)
		[str appendFormat:@"&twusername=%@",[LocalStorageManager stringForKey:TWITTER_USER]];
	[str appendFormat:@"&game=%d",self.game];
	if (self.country)
		[str appendFormat:@"&country=%@",self.country];
	if (self.hasGps)	{
		[str appendFormat:@"&gps_x=%f",self.gps_x];
		[str appendFormat:@"&gps_y=%f",self.gps_y];
	}
	
//	[[Constants sharedInstance] setGameCenterEnabled:YES];

	// for posting scores with game centere player id
	if ([[Constants sharedInstance] gameCenterEnabled]) 
		[str appendFormat:@"&gcuid=%@", [[GKLocalPlayer localPlayer] playerID]];
	
#ifdef LITE_VERSION
	[str appendFormat:@"&isLite=1"];
#else
	[str appendFormat:@"&isLite=0"];
#endif
	[str appendFormat:@"&score=%d",self.score];
	[str appendFormat:@"&gameMode=%d",self.gameMode];
	[str appendFormat:@"&deviceType=%@", [[UIDevice currentDevice] platformString]];
	[str appendFormat:@"&osVersion=%@", [[UIDevice currentDevice] systemVersion]];
	[str appendFormat:@"&numPlay=%d", 	[[LocalStorageManager objectForKey:NUMGAMEPLAY] intValue]];
	if ([LocalStorageManager boolForKey:USEINGAMEIMAGES])
		[str appendFormat:@"&specialFeature=1"];
	[str appendFormat:@"&imei=%@", [[UIDevice currentDevice] uniqueIdentifier]];
	
	NSMutableString *shared_secret = [[NSMutableString alloc] init];
	[shared_secret appendString:str];
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
	[str appendFormat:@"&code=%@", codeString];
	[shared_secret release];
	[signedData release];
	return str;
	
}

- (NSString*) signImage
{
	NSMutableString *shared_secret = [[NSMutableString alloc] init];
	[shared_secret appendString:self.uuid];
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
	[shared_secret release];
	[signedData release];

	return codeString;
	
}

- (void) submitGameRecord
{
	self.toSubmit=YES;
	[self initLocationManager];
}

- (void) submitGameRecord2
{
	NSString* contentURL = [self toUrlString];
	NSString* urlStr = [NSString stringWithFormat:@"%@%@%@", HOSTURL,ADDGAMERECORDREQ,contentURL];
	[contentURL release];
	NSString* escapedUrl = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSLog(escapedUrl);
	NSURL* url = [NSURL URLWithString:escapedUrl];
	NSURLRequest* req = [NSURLRequest requestWithURL:url];
	[NSURLConnection connectionWithRequest:req delegate:self];
	
	if (self.uuid && self.imageStr)	{
		NSString* code = [self signImage];
		urlStr = [NSString stringWithFormat:@"%@%@uuid=%@&code=%@", HOSTURL,UPLOADIMAGEREQ, self.uuid, code];
		escapedUrl = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		url = [NSURL URLWithString:escapedUrl];
		req = [NSMutableURLRequest requestWithURL:url];
		[req setHTTPMethod:@"POST"];
		[req setHTTPBody:[[NSString stringWithFormat:@"img=%@",self.imageStr] dataUsingEncoding:NSUTF8StringEncoding]];
		self.theConnection = [NSURLConnection connectionWithRequest:req delegate:self];
	}
	
	self.toSubmit=NO;
	
//	[self.operationQueue cancelAllOperations];
//	self.operationQueue = [NSOperationQueue new];
	
//	NSInvocationOperation *operation1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(postTweetToSinaMicroBlog) object:nil];
//	NSInvocationOperation *operation2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(postTweetToTwitter) object:nil];
/*	[self.operationQueue addOperation:operation1];
	[self.operationQueue addOperation:operation2];
	[operation1 release];
	[operation2 release];
*/
	
	[self postTweetToSinaMicroBlog];
	[self postTweetToTwitter];
	[self postUpdateToFacebook];
	if ([[Constants sharedInstance] gameCenterEnabled]) 
		[self postUpdateToGameCenter];
}

- (void) postUpdateToGameCenter
{
	NSLog(@"postUpdateToGameCenter");
	GKScore *scoreReporter = nil;
	NSString* gameCategoryString = nil;
	if (self.gameMode == 0) {
		gameCategoryString = kGamekitArcadeModeLeaderboardCategory;
#ifdef LITE_VERSION
		gameCategoryString = kGamekitArcadeModeLeaderboardLiteCategory;
#endif
		
	}else{
		constantsInstance = [Constants sharedInstance];
		gameCategoryString = [[constantsInstance getGameLeaderboardCategoryDictionary] objectForKey:[NSNumber numberWithInt:self.game]];
#ifdef LITE_VERSION
		gameCategoryString = [[constantsInstance getGameLeaderboardLiteCategoryDictionary] objectForKey:[NSNumber numberWithInt:self.game]];
#endif
		
	}
	scoreReporter = [[[GKScore alloc] initWithCategory:gameCategoryString] autorelease];
	scoreReporter.value = self.score;
	[scoreReporter reportScoreWithCompletionHandler: ^(NSError *error) 
	 {
		 if (error != nil)
		 {
			 NSLog(@"error submitting score to server: %@", [error localizedDescription]);
			 // store the high score for later submission
			 [LocalStorageManager setBool:YES forKey:LEADERBOARD_UPLOAD_FAILED];
			 [LocalStorageManager setObject:gameCategoryString forKey:LEADERBOARD_UPLOAD_FAILED_CATEGORY];
			 [LocalStorageManager setInteger:self.score forKey:LEADERBOARD_UPLOAD_FAILED_SCORE];
		 }		 
	 }];
	
	
}

- (void) postUpdateToFacebook
{
	FBDataSource *fbDataSource = [FBDataSource sharedInstance];
	if ([fbDataSource.fbSession isConnected])	{
		constantsInstance = [Constants sharedInstance];
		NSString *postGameName = nil;
		if (self.gameMode == 0) {
			postGameName = NSLocalizedString(@"街機模式",nil);
		}else{
			postGameName = [[constantsInstance getGameNamesDictionary] objectForKey:[NSNumber numberWithInt:self.game]];
		}
		
		NSString *postGameDifficulties = nil;
		if (self.gameLevel == kEasy){
			postGameDifficulties = NSLocalizedString(@"好易",nil);
		}else if (self.gameLevel == kNormal){
			postGameDifficulties = NSLocalizedString(@"正常",nil);
		}else if (self.gameLevel == kHard){
			postGameDifficulties = NSLocalizedString(@"難爆",nil);
		}else if (self.gameLevel == kWorldClass){
			postGameDifficulties = NSLocalizedString(@"大師",nil);
		}
		
		NSString* tweetString=[NSString stringWithFormat:@"%@ (%@): %d%@", postGameName, postGameDifficulties, self.score, NSLocalizedString(@"分", nil)];
		
		NSString* tweetPic = @"";
		
		if (self.uuid && self.imageStr){
			tweetPic = [NSString stringWithFormat:@"%@serveImage?uuid=%@", HOSTURL,self.uuid];
		}
		tweetString = [NSString stringWithFormat:@"%@ (%@): %d%@", postGameName, postGameDifficulties, self.score, NSLocalizedString(@"分", nil)];
		NSLog(@"tweet string %@:", tweetString);

		NSString* tweetStringFull;
		if ([[[Constants sharedInstance] APPVERSION] isEqualToString:@"version1"])
			tweetStringFull = [NSString stringWithFormat:@"{\"name\":\"%@\","
										 "\"href\":\"http://www.facebook.com/pages/Hong-Kong/Red-Soldier/104123529642835\","
										 "\"caption\":\"%@\",\"description\":\"%@\","
										 "\"media\":[{\"type\":\"image\","
										 "\"src\":\"%@\","
										 "\"href\":\"%@\"}],"
										 "\"properties\":{\"%@\":{\"text\":\"%@\",\"href\":\"http://itunes.com/apps/redsoldier/拍拍機bashbashlite\"}}}", 
							   NSLocalizedString(@"iPhone App 拍拍機 BashBash! Lite v1.5",nil),
							   NSLocalizedString(@"全新玩法，全新設計的拍拍機BashBash已於iPhone App上登場!! 最親切嘅場景聲效，最緊張刺激嘅遊戲，加上最新加入的大師級，隨時隨地挑戰你!!",nil),
							   tweetString, tweetPic, tweetPic,
							   NSLocalizedString(@"透過iTune下載", nil),
							   NSLocalizedString(@"iPhone App 拍拍機 BashBash! Lite 1.2",nil)];
		else if ([[[Constants sharedInstance] APPVERSION] isEqualToString:@"version2"])
			tweetStringFull = [NSString stringWithFormat:@"{\"name\":\"%@\","
											 "\"href\":\"http://www.facebook.com/pages/Hong-Kong/Red-Soldier/104123529642835\","
											 "\"caption\":\"%@\",\"description\":\"%@\","
											 "\"media\":[{\"type\":\"image\","
											 "\"src\":\"%@\","
											 "\"href\":\"%@\"}],"
											 "\"properties\":{\"%@\":{\"text\":\"%@\",\"href\":\"http://itunes.com/apps/redsoldier/拍拍機bashbash\"}}}", 
							   NSLocalizedString(@"iPhone App 拍拍機 BashBash! v1.5",nil),
							   NSLocalizedString(@"全新玩法，全新設計的拍拍機BashBash已於iPhone App上登場!! 最親切嘅場景聲效，最緊張刺激嘅遊戲，加上最新加入的大師級，隨時隨地挑戰你!!",nil),
							   tweetString, tweetPic, tweetPic,
							   NSLocalizedString(@"透過iTune下載", nil),
							   NSLocalizedString(@"iPhone App 拍拍機 BashBash! 1.5",nil)];


		
		NSLog(@"tweet tweetStringFull %@:", tweetStringFull);
		[fbDataSource postMessageToFacebook:tweetStringFull];
	}
}

- (void) postTweetToTwitter
{
	NSLog(@"postTweetToTwitter");
	if ([LocalStorageManager stringForKey:TWITTER_USER] != nil){
		constantsInstance = [Constants sharedInstance];
		NSString *postGameName = nil;
		if (self.gameMode == 0) {
			postGameName =NSLocalizedString(@"街機模式",nil);
		}else{
			postGameName = [[constantsInstance getGameNamesDictionary] objectForKey:[NSNumber numberWithInt:self.game]];
		}
		
		
		NSString *postGameDifficulties = nil;
		if (self.gameLevel == kEasy){
			postGameDifficulties = NSLocalizedString(@"好易",nil);
		}else if (self.gameLevel == kNormal){
			postGameDifficulties = NSLocalizedString(@"正常",nil);
		}else if (self.gameLevel == kHard){
			postGameDifficulties = NSLocalizedString(@"難爆",nil);
		}else if (self.gameLevel == kWorldClass){
			postGameDifficulties = NSLocalizedString(@"大師",nil);
		}

		NSString* tweetString;
		if (self.uuid && self.imageStr)
			tweetString = [NSString stringWithFormat:@"%@ (%@): %d%@ %@serveImage?uuid=%@", postGameName, postGameDifficulties, self.score, NSLocalizedString(@"分", nil),HOSTURL, self.uuid];
		else
			tweetString = [NSString stringWithFormat:@"%@ (%@): %d%@", postGameName, postGameDifficulties, self.score,NSLocalizedString(@"分", nil)];
		NSLog(@"tweet string %@:", tweetString);
		
		TwitterRequest *twitterUpdater = [[TwitterRequest alloc] init];
		twitterUpdater.username = [LocalStorageManager stringForKey:TWITTER_USER];
		twitterUpdater.password = [LocalStorageManager stringForKey:TWITTER_PASSWORD];
		[twitterUpdater statuses_update:tweetString delegate:self requestSelector:nil];
		[twitterUpdater release];
	}
}


- (void) postTweetToSinaMicroBlog
{
	NSLog(@"postTweetToSinaMicroBlog");
	if ([LocalStorageManager stringForKey:SINAUSER] != nil){
		
		constantsInstance = [Constants sharedInstance];
		
		SinaMicroBlogUpdater *sinaMicroBlogUpdater = [[SinaMicroBlogUpdater alloc]init];
		NSString *postGameName = nil;
		if (self.gameMode == 0) {
			postGameName = NSLocalizedString(@"街機模式",nil);
		}else{
			postGameName = [[constantsInstance getGameNamesDictionary] objectForKey:[NSNumber numberWithInt:self.game]];
		}
		NSLog(@"self.game:%d", self.game);
		NSLog(@"self.game postGameName:%d", postGameName);
		
		NSString *postGameDifficulties = nil;
		if (self.gameLevel == kEasy){
			postGameDifficulties = NSLocalizedString(@"好易",nil);
		}else if (self.gameLevel == kNormal){
			postGameDifficulties = NSLocalizedString(@"正常",nil);
		}else if (self.gameLevel == kHard){
			postGameDifficulties = NSLocalizedString(@"難爆",nil);
		}else if (self.gameLevel == kWorldClass){
			postGameDifficulties = NSLocalizedString(@"大師",nil);
		}
		
		NSString* tweetString;
		if (self.uuid && self.imageStr)
			tweetString = [NSString stringWithFormat:@"%@ (%@): %d%@ %@serveImage?uuid=%@", postGameName, postGameDifficulties, self.score, NSLocalizedString(@"分", nil),HOSTURL, self.uuid];
		else
			tweetString = [NSString stringWithFormat:@"%@ (%@): %d%@", postGameName, postGameDifficulties, self.score,NSLocalizedString(@"分", nil)];
		NSLog(@"tweet string %@:", tweetString);
		[sinaMicroBlogUpdater postTweetToSinaMicroBlog:tweetString];
		[sinaMicroBlogUpdater release];
	}
}


- (void) connection: (NSURLConnection*)connection didReceiveData: (NSData*)data
{
}


- (void) initLocationManager
{
	if (!self.locationManager)	{
		CLLocationManager * manager = [[CLLocationManager alloc] init];	
		self.locationManager = manager;
		self.locationManager.delegate = self;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		self.locationManager.distanceFilter = 10.0;
		[manager release];
	}
	
	[self.locationManager startUpdatingLocation];
	
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{
	if(newLocation)
	{
		NSDate * today = [NSDate date];
		if([today timeIntervalSinceDate:newLocation.timestamp] < 60)
		{
			self.gps_x = newLocation.coordinate.latitude;
			self.gps_y = newLocation.coordinate.longitude;
			self.hasGps = YES;
			[self.locationManager stopUpdatingLocation];
		}
		//TODO if locatiion is not updated, should continue the submission?
		if (self.toSubmit)
			[self submitGameRecord2];
		
	}
} 

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error 
{
	// ToDo dunno why sometimes this error Error Domain=kCLErrorDomain Code=0 "Operation could not be completed. (kCLErrorDomain error 0.)" would happen 
	//if (error.code != kCLErrorLocationUnknown)	{
		[self.locationManager stopUpdatingLocation];
		self.hasGps = NO;
		if (self.toSubmit)
			[self submitGameRecord2];
	//}
} 

#pragma mark NSUrlConnection Delegate
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	if (connection == self.theConnection)	{
		if (self.delegate)	{
			[self.delegate finishedSubmitting];
		}
	}
}

@end

