//
//  ScoreView.h
//  bishibashi
//
//  Created by Eric on 02/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "LocalStorageManager.h"
#import "GameRecordTableViewController.h"
#import "GameRecordMenuViewController.h"
#import "PentagonChartViewController.h"
#import "Base64Coder.h"
#import "Baby.h"
typedef enum _scoreViewType
{
	kScoreViewType_beforeGame = 0,
	kScoreViewType_afterGameArcade,
	kScoreViewType_afterGameNonArcade,
	kScoreViewType_beforeGameMultiplay,
	kScoreViewType_afterGameMultiplayArcade,
	kScoreViewType_afterGameMultiplayNonArcade,
	
} scoreViewType;

@interface ScoreView : UIView {
	MediaManager *sharedSoundEffectsManager;	
	currrentGameType _currentGameType;
	BOOL _peerHosted;
	
	scoreViewType _type; 
	BOOL _isPass;
	CGRect _theFrame;
	int _score;
	int _totalScore;
	int _lives;
	Game _game;
	GameLevel _level;
	GameRecord* _theGameRecord;
	
	UIInterfaceOrientation _orientation;
	UIColor				*_filledColor;
	UIColor				*_borderColor;
	float				_strokeWidth;	
	
	NSMutableArray*	_livesImgs;
	
	UIButton*	_submitScoreBut;
	UIButton*	_readScoreBut;

	UIButton*	_playAgainBut;
	UIButton*	_menuBut;

	UIImageView*	_directorBoardView;
	UILabel*	_levelLbl;
	UILabel*	_gameLbl;
	UILabel*	_scoreLbl;
	
	UILabel*	_mePlayAgainLbl;
	UILabel*	_opponentPlayAgainLbl;
	
	UIActivityIndicatorView*	_aiView;
	id	_owner;
	id _gameView;
//	id	_navigationController;
}
@property (nonatomic, assign) scoreViewType type;
@property (nonatomic, assign) currrentGameType currentGameType;
@property (nonatomic, assign) BOOL peerHosted;

@property (nonatomic, assign) BOOL isPass;
@property (nonatomic, retain) GameRecord* theGameRecord;
@property (nonatomic, assign) Game game;
@property (nonatomic, assign) GameLevel level;
@property (nonatomic, assign) CGRect theFrame;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) int totalScore;
@property (nonatomic, assign) int lives;
@property (nonatomic, assign) UIInterfaceOrientation orientation;


@property (nonatomic, retain) UILabel* levelLbl;
@property (nonatomic, retain) UILabel* gameLbl;
@property (nonatomic, retain) UILabel* scoreLbl;
@property (nonatomic, retain) UIActivityIndicatorView* aiView;

@property (nonatomic, retain) NSMutableArray* livesImgs;

@property (nonatomic, retain) UIButton* submitScoreBut;
@property (nonatomic, retain) UIButton* readScoreBut;

@property (nonatomic, retain) UIButton* menuBut;
@property (nonatomic, retain) UIButton* playAgainBut;

@property (nonatomic, retain) UILabel* mePlayAgainLbl;
@property (nonatomic, retain) UILabel* opponentPlayAgainLbl;

@property (nonatomic, retain) UIImageView* directorBoardView;

@property (nonatomic, assign) id owner;
@property (nonatomic, assign) id gameView;

- (id) initWithOrientation:(UIInterfaceOrientation)orientation  AndScore:(int)score AndLives:(int)lives AndGame:(Game)game AndGameLevel:(GameLevel)level AndType:(scoreViewType) type;
- (id) initWithOrientation:(UIInterfaceOrientation)orientation  AndScore:(int)score AndLives:(int)lives AndType:(scoreViewType) type;

@end
