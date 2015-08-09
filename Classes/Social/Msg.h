//
//  Msg.h
//  bishibashi
//
//  Created by Eric on 05/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "WebImageView.h"


@interface Msg : UIView <NSCoding>{
	NSString*	_fdname;
	NSString*	_text;
	NSString*	_fdimageurl;
	NSDate*		_time;
	GameLevel	_gameLevel;
	NSString*	_fbuid;
	NSString*	_twusername;
	NSString*	_mbusername;
	Game		_game;
	int			_score;
	GameMode	_gameMode;
	WebImageView*	_image;
	
	UILabel*	_nameLbl;
	UILabel*	_dateLbl;
	UILabel*	_textLbl;
	UILabel*	_scoreLbl;
}
@property (nonatomic, retain) NSString* fdimageurl;
@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) NSString* fdname;
@property (nonatomic, retain) NSString* fbuid;
@property (nonatomic, retain) NSString* twusername;
@property (nonatomic, retain) NSString* mbusername;
@property (nonatomic, retain) NSDate* time;
@property (nonatomic, assign) GameLevel gameLevel;
@property (nonatomic, assign) Game game;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) GameMode gameMode;
@property (nonatomic, retain) WebImageView* image;
@property (nonatomic, retain) UILabel* nameLbl;
@property (nonatomic, retain) UILabel* dateLbl;
@property (nonatomic, retain) UILabel* textLbl;
@property (nonatomic, retain) UILabel* scoreLbl;
@end