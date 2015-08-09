//
//  GameRecord.h
//  bishibashi
//
//  Created by Eric on 04/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import <CoreLocation/CoreLocation.h>
#import <CommonCrypto/CommonDigest.h>
#import "UIDevice-Hardware.h"
#import "LocalStorageManager.h"
#import <GameKit/GameKit.h>

@interface GameRecord : NSObject <NSCoding>{
	NSString*	_name;
	NSDate*		_time;
	GameLevel	_gameLevel;
	NSString*	_fbuid;
	NSString*	_twusername;
	NSString*	_mbusername;
	Game		_game;
	NSString*	_country;
	BOOL		_hasGps;
	float		_gps_x;
	float		_gps_y;
	int			_score;
	GameMode	_gameMode;
	NSString*	_deviceType;
	NSString* _imei;
	NSString* _uuid;
	NSString* _imageStr;

	NSURLConnection*	_theConnection;
	
	CLLocationManager*	_locationManager;
	
	BOOL	_toSubmit;
	
	BOOL	_isShown;
	Constants *constantsInstance;
	NSOperationQueue* _operationQueue;
	
	id	_delegate;
}
@property (nonatomic, retain) NSURLConnection* theConnection;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* fbuid;
@property (nonatomic, retain) NSString* twusername;
@property (nonatomic, retain) NSString* mbusername;
@property (nonatomic, retain) NSString* country;
@property (nonatomic, retain) NSDate* time;
@property (nonatomic, assign) GameLevel gameLevel;
@property (nonatomic, assign) Game game;
@property (nonatomic, assign) BOOL hasGps;
@property (nonatomic, assign) float gps_x;
@property (nonatomic, assign) float gps_y;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) GameMode gameMode;
@property (nonatomic, retain) NSString* imei;
@property (nonatomic, retain) NSString* deviceType;
@property (nonatomic, retain) NSString* imageStr;
@property (nonatomic, retain) NSString* uuid;

@property (nonatomic, retain) CLLocationManager* locationManager;
@property (nonatomic, retain) NSOperationQueue* operationQueue;
@property (nonatomic, assign) BOOL toSubmit;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) BOOL isShown;
@end
