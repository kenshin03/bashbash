//
//  GameView.h
//  bishibashi
//
//  Created by Eric on 13/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>
#import <GameKit/GameKit.h>
#import "ConfigView.h"
#import "OCProgress.h"
#import "GamePacket.h"
#import "ScoreView.h"
#import "PieChartView.h"
#import "Constants.h"
#import "MediaManager.h"
#import "CreditView.h"
#import "ScoreBox.h"
#import "LocalStorageManager.h"
#import "SocialPanel.h"
#import "PinPopUp.h"
#import "Pin.h"
#import "AdMobDelegateProtocol.h"
#import "GKPacket.h"
#import "VSResult.h"
#import "AdMobView.h"
#import "FBDataSource.h"
#import "StampCollectionViewController.h"
#import "PolaroidFilm.h"
#import "GameRecord.h"
#import "VideoTableViewController.h"
#import "AroundTheWorldViewController.h"

@interface GameView : UIView <AdMobDelegate>{
	// for statistics
	CGFloat _statTotalSum;
	NSInteger _statTotalNum;
	
	// for after game panels
	UIImageView* _submitPanel;
	UIImageView* _replayPanel;
	UIButton*	_gcBut;
	UIButton*	_submitScoreBut;
	UIButton*	_readScoreBut;
	UIButton*	_replayBut;
	UIButton*	_homeBut;
	
	// for after game screens
	UIView*	_whiteScreen;
	NSMutableArray*	_films;
	
	// for VS mode
	id _gkMatch;
	id _gkSession;
	GKPacket*	_gamePacket;
	UILabel*	_vsMsg;
	UIActivityIndicatorView*	_vsAiView;
	
	
	CGRect	_scoreFrame;
	BOOL	_toQuit;
	
	// for ad
	BOOL	_bannerServed;	
	UIView* _iAdBannerView;
	
	int _lifes;
	Game _game;

	MediaManager *sharedSoundEffectsManager;
	
	NSMutableArray* _scenarios;
	NSMutableArray* _scenarios2;
	
	UIImageView*	_gameFrame;
	ScoreView* _scoreView;
	
	UILabel*	_scoreLabel;
	SocialPanel* _socialPanel;
	OCProgress*	_timeBar;
	OCProgress*	_opponentTimeBar;
	WebImageView*	_myPhoto;
	WebImageView*	_opponentPhoto;
	
	PieChartView* _timePie;
	
	float _opponentTimeUsed;
	float _myTimeUsed;
	
	/* 3 buttons */
	UIButton*	_redBut;
	UIButton*	_blueBut;
	UIButton*	_greenBut;	
	UIImageView*	_pinImg;
	UIImageView*	_replayImg;
	UIImageView*	_submitImg;
	
	/* 4 icons */
	UIButton*		_infoBut;
	UIButton*		_exitBut;
	UIButton*		_soundBut;	
	UIButton*	_socialBut;
	UIButton*	_globeBut;
	UIButton*	_videoBut;
		
	UIImageView*		_backgroundView;
	UIImageView*		_OKView;
	UIImageView*		_crossView;
	
	VSResult*	_myOKView;
	VSResult*	_opponentOKView;
	
	UILabel*		_countDownThreeLabel;
	UILabel*		_countDownTwoLabel;
	UILabel*		_countDownOneLabel;
	UILabel*		_gameStartLabel;
	
	id _owner;
	int _noRun;
	
	float _roundTime;
	float _overheadTime;
	float _remainedTime;
	NSDate* _roundStartTime;
	float _difficultFactor;
	
	int _score;
	NSTimer* _theTimer;
	GameLevel	_difficultiesLevel;
	
	id *navigationController;
	
	UIInterfaceOrientation _orientation;
	BOOL			_isRemoteView;
	GameView*		_remoteView;
	
	// multi-player
    GKSession   *_session;
	currrentGameType	_gameType;

	NSInteger roundTime;
	NSInteger roundResult;
	
	UIImageView*	_youWinImage;
	
	PinPopUp*	_thePinPopUP;
	
	UIView*	_waitingScreenUp;
	UIView*	_waitingScreenDown;
	
	BOOL _VSModeIsRoundBased;
	UIActivityIndicatorView* _submitAi;

}
@property (nonatomic, retain) UIButton* gcBut;
@property (nonatomic, retain) UIButton* submitScoreBut;
@property (nonatomic, retain) UIButton* readScoreBut;
@property (nonatomic, retain) UIButton* replayBut;
@property (nonatomic, retain) UIButton* homeBut;

@property (nonatomic, retain) UIActivityIndicatorView* submitAi;

@property (nonatomic, assign) NSInteger statTotalNum;
@property (nonatomic, assign) CGFloat statTotalSum;

@property (nonatomic, retain) UIImageView* replayPanel;
@property (nonatomic, retain) UIImageView* submitPanel;
@property (nonatomic, retain) UIView* whiteScreen;
@property (nonatomic, retain) NSMutableArray* films;

@property (nonatomic, assign) id gkMatch;
@property (nonatomic, assign) id gkSession;
@property (nonatomic, retain) GKPacket* gamePacket;
@property (nonatomic, retain) UILabel* vsMsg;
@property (nonatomic, retain) UIActivityIndicatorView*	vsAiView;

@property (nonatomic, assign) CGRect scoreFrame;
@property (nonatomic, retain) UIView* iAdBannerView;
@property (nonatomic, assign) BOOL bannerServed;


@property (nonatomic, assign) int lifes;
@property (nonatomic, assign) Game game;
@property(nonatomic, retain) NSMutableArray* scenarios;
@property(nonatomic, retain) NSMutableArray* scenarios2;
@property (nonatomic, retain) UIImageView* gameFrame;
@property(nonatomic, retain) ScoreView* scoreView;
@property(nonatomic, retain) UIButton* infoBut;
@property(nonatomic, retain) UIButton* exitBut;
@property(nonatomic, retain) UIButton* soundBut;
@property(nonatomic, retain) UIButton* globeBut;
@property(nonatomic, retain) UIButton* videoBut;


@property(nonatomic, retain) OCProgress* timeBar;
@property(nonatomic, retain) OCProgress* opponentTimeBar;
@property(nonatomic, retain) WebImageView* myPhoto;
@property(nonatomic, retain) WebImageView* opponentPhoto;
@property (nonatomic, assign) float opponentTimeUsed;
@property (nonatomic, assign) float myTimeUsed;


@property(nonatomic, retain) SocialPanel* socialPanel;
@property(nonatomic, retain) UILabel* scoreLabel;
@property(nonatomic, retain) PieChartView* timePie;

@property(nonatomic, retain) UIImageView* OKView;
@property(nonatomic, retain) UIImageView* crossView;
@property(nonatomic, retain) VSResult* myOKView;
@property(nonatomic, retain) VSResult* opponentOKView;
@property(nonatomic, retain) UIImageView* backgroundView;

@property(nonatomic, retain) UILabel* countDownThreeLabel;
@property(nonatomic, retain) UILabel* countDownTwoLabel;
@property(nonatomic, retain) UILabel* countDownOneLabel;
@property(nonatomic, retain) UILabel* gameStartLabel;

@property (nonatomic, retain) UIImageView* submitImg;
@property (nonatomic, retain) UIImageView* pinImg;
@property (nonatomic, retain) UIImageView* replayImg;

@property(nonatomic, retain) UIButton* redBut;
@property(nonatomic, retain) UIButton* greenBut;
@property(nonatomic, retain) UIButton* blueBut;
@property(nonatomic, retain) UIButton* socialBut;


@property (nonatomic, assign) id owner;
@property (nonatomic, assign) int noRun;
@property (nonatomic, assign) float roundTime;
@property (nonatomic, assign) float remainedTime;
@property (nonatomic, assign) float overheadTime;
@property (nonatomic, retain) NSDate* roundStartTime;
@property (nonatomic, assign) float difficultFactor;


@property (nonatomic, retain) NSTimer* theTimer;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) GameLevel difficultiesLevel;	


@property (nonatomic, assign) UIInterfaceOrientation orientation;
@property (nonatomic, assign) id *navigationController;

@property (nonatomic assign) BOOL isRemoteView;
@property (nonatomic, assign) GameView* remoteView;

@property (nonatomic) currrentGameType gameType;
@property (nonatomic) NSInteger roundResult;
@property (nonatomic, retain) UIImageView* youWinImage;
@property (nonatomic, retain) PinPopUp *thePinPopUp;

@property (nonatomic, retain) UIView* waitingScreenUp;
@property (nonatomic, retain) UIView* waitingScreenDown;

@property (nonatomic, assign) BOOL VSModeIsRoundBased;

- (id)initWithFrame:(CGRect)frameRect;
-(void) startGame;
-(void) initImages;
-(void) initBackground;
-(void) initButtons;
- (void) initSlider;
-(float) getLevel;
- (void) hidePlayAgain;
- (void) showPlayAgain;
- (void) redButClicked;
- (void) blueButClicked;
- (void) greenButClicked;
- (void) playAgainButClicked;
- (void) disableButtons;
- (void) enableButtons;

- (void) setTimer:(float)duration;
- (int) calScore;

- (void) showCountDownThreeMessage;
- (void) showCountDownTwoMessage;
- (void) showCountDownOneMessage;
- (void) showGameStartMessage;
- (void) showGameScoresPage;


@end
