//
//  MainVC.h
//  bishibashi
//
//  Created by Eric on 26/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "EatbeansView.h"
#import "3in1View.h"
#import "BurgersetView.h"
#import "UFOView.h"
#import "AlarmClockView.h"
#import "JumpingGirlView.h"
#import "BurgerseqView.h"
#import "3BoView.h"
#import "SmallnumberView.h"
#import "BignumberView.h"
#import "DancingView.h"
#import "BunHillView.h"
#import "HeartnHandView.h"
#import "QuickPencilView.h"
#import "GameView.h"
#import "Constants.h"
#import "TransitionView.h"
#import "GamePacket.h"
#import "ScoreView.h"
#import "VersusTransitionView.h"
@interface GameViewController : UIViewController <GKSessionDelegate, TransitionViewDelegate>{
	GKMatch* _gkMatch;
	GKSession*	_gkSession;
	
	NSString*	_alias;
	NSString*	_opponentAlias;
	NSString*	_imageUrl;
	NSString*	_opponentImageUrl;
	NSString*	_opponentCountry;
	NSString*	_myCountry;
	
	VersusTransitionView*	_versusTransitionView;
	
	int	_totalScore;
	int _lifes;
	NSMutableArray*	_gameViews;
	Game	_theGame;
	BOOL	_mustLandscape;
	BOOL	_lockedOrientation;
	
	BOOL	_isLite;
	GameView*	_theMainView;
	GameView*	_theRemoteView;
	
	UIImageView* _gameFrame;
	UIImageView* _gameScreenFrame;
	id *_navigationController;
	NSInteger	_gameType;
	TransitionView *_transitionView;
	
	GameLevel	_difficultiesLevel;
	BOOL _isShowingGameView;
	
	// multi-player
	NSInteger	_roundNo;
    GKSession   *_session;
    NSString    *_peerID;
    GameState   _gamestate;
	NSInteger _numRoundWin;
	NSInteger _numRoundLose;
	
	NSInteger _oppponentNumMatches;
	NSInteger _oppponentNumWins;
	NSInteger _myNumMatches;
	NSInteger _myNumWins;
	
	MediaManager *_sharedSoundEffectsManager;
	
}
@property (nonatomic, assign) NSInteger roundNo;
@property (nonatomic, retain) NSString* alias;
@property (nonatomic, retain) NSString* opponentAlias;
@property (nonatomic, retain) NSString* imageUrl;
@property (nonatomic, retain) NSString* opponentImageUrl;
@property (nonatomic, retain) NSString* opponentCountry;
@property (nonatomic, retain) NSString* myCountry;

@property (nonatomic, retain) VersusTransitionView* versusTransitionView;

@property (nonatomic, assign) GKMatch* gkMatch;
@property (nonatomic, assign) GKSession* gkSession;
@property(nonatomic, retain) TransitionView *transitionView;
@property (nonatomic, assign) int totalScore;
@property (nonatomic, assign) int lifes;
@property (nonatomic, retain) UIImageView* gameFrame;
@property (nonatomic, retain) UIImageView* gameScreenFrame;
@property (nonatomic, retain) NSMutableArray* gameViews;
@property (nonatomic, assign) Game theGame;
@property (nonatomic, assign) BOOL mustLandscape;
@property (nonatomic, assign) BOOL lockedOrientation;
@property (nonatomic, retain) GameView* theMainView;
@property (nonatomic, retain) GameView* theRemoteView;
@property (nonatomic, assign) id *navigationController;
@property (nonatomic) NSInteger gameType;	
@property (nonatomic, assign) GameLevel difficultiesLevel;	
@property (nonatomic) BOOL isShowingGameView;	
@property (nonatomic, assign) BOOL isLite;
@property(nonatomic, assign) GKSession *session;
@property(nonatomic, assign) NSString *peerID;
@property (nonatomic) GameState gamestate;
@property(nonatomic, assign) MediaManager* sharedSoundEffectsManager;
@property(nonatomic, assign) NSInteger numRoundWin;
@property(nonatomic, assign) NSInteger numRoundLose;
@property(nonatomic, assign) NSInteger opponentNumMatches;
@property(nonatomic, assign) NSInteger opponentNumWins;
@property(nonatomic, assign) NSInteger myNumMatches;
@property(nonatomic, assign) NSInteger myNumWins;

@end
