//
//  SoundEffectsManager.h
//  bishibashi
//
//  Created by Kenny Tang on 4/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SoundEffect.h"
#import "SoundFile.h"
#import "Finch.h"
#import "Sound.h"
#import "RevolverSound.h"
#import "UIDevice-Hardware.h"

@interface MediaManager : NSObject {
	BOOL _supportMT;
	SoundEffect *countDownThree;
	SoundEffect *countDownTwo;
	SoundEffect *countDownOne;
	
	SoundEffect *star;
	SoundEffect *pencilPress;
	SoundEffect *pencilLeadFall;
	Sound *coin;
	Sound *fail;
	Sound *integrate;
	Sound *yeah;
	Sound *mouthPop;
	SoundEffect *tap;
	Sound *finish;
	Sound *drop;
	SoundEffect *drip;
	SoundEffect *octopusDood;
	SoundEffect *jetFlyBy;
	SoundEffect *dramaticAccent1;
	
	SoundEffect *flightTerminalBoardSound;
	
	SoundEffect *slamMetal;
	SoundEffect *warp;
	SoundEffect *transitionInstruction;
	SoundEffect *transitionEatBeansGameName;
	SoundEffect *transitionThreeInOneGameName;
	SoundEffect *transitionBurgerSetGameName;
	SoundEffect *transitionUFOGameName;
	SoundEffect *transitionAlarmClockGameName;
	SoundEffect *transitionJumpingGirlGameName;
	SoundEffect *transitionBurgerSequenceGameName;
	SoundEffect *transitionThreeBOGameName;
	SoundEffect *transitionSmallNumberGameName;
	SoundEffect *transitionBigNumberGameName;
	
	SoundEffect *transitionLevelOne;
	SoundEffect *transitionLevelTwo;
	SoundEffect *transitionLevelThree;
	SoundEffect *transitionLevelFour;
	SoundEffect *transitionLevelFive;
	SoundEffect *transitionLevelSix;
	SoundEffect *transitionLevelSeven;
	SoundEffect *transitionLevelEight;
	SoundEffect *transitionLevelNine;
	SoundEffect *transitionLevelTen;
	SoundEffect *transitionLevelEleven;
	SoundEffect *transitionLevelTwlve;
	
	SoundEffect *ufoFlyPass;
	
	SoundEffect *action;
	SoundEffect *cut;
	SoundEffect *goodTake;
	
	SoundEffect *clap;
	
	SoundFile *_clockTicking;
	SoundFile *_electricBeep;
	SoundFile *_mahjongNoise;
	SoundFile *_harbourSound;
	SoundFile *_crossWalkSound;
	SoundFile *_titleScreenBGM;
	SoundFile *_breakBeatLongBGM;
	SoundFile *_sideManStrutLongBGM;
	SoundFile *_galleriaLongBGM;
	SoundFile *_greasyWheelsShortBGM;
	SoundFile *_headspinShortBGM;
	SoundFile *_offRoadShortBGM;
	SoundFile *_tornJeansMediumBGM;
	SoundFile *_versusTransitionBGM;
	SoundFile *_yearbookMediumBGM;
	
	Finch* soundEngine;
}

@property (nonatomic, retain) SoundFile *clockTicking;
@property (nonatomic, retain) SoundFile *electricBeep;
@property (nonatomic, retain) SoundFile *mahjongNoise;
@property (nonatomic, retain) SoundFile *harbourSound;
@property (nonatomic, retain) SoundFile *crossWalkSound;
@property (nonatomic, retain) SoundFile *titleScreenBGM;
@property (nonatomic, retain) SoundFile *breakBeatLongBGM;
@property (nonatomic, retain) SoundFile *sideManStrutLongBGM;
@property (nonatomic, retain) SoundFile *galleriaLongBGM;
@property (nonatomic, retain) SoundFile *greasyWheelsShortBGM;
@property (nonatomic, retain) SoundFile *headspinShortBGM;
@property (nonatomic, retain) SoundFile *offRoadShortBGM;
@property (nonatomic, retain) SoundFile *tornJeansMediumBGM;
@property (nonatomic, retain) SoundFile *versusTransitionBGM;
@property (nonatomic, retain) SoundFile *yearbookMediumBGM;



+ (id)sharedInstance;

-(void)playDramaticAccentSound;
-(void)playCountDownThreeSound;
-(void)playCountDownTwoSound;
-(void)playCountDownOneSound;
-(void)playCountDownStartSound;
-(void)playPencilPressSound;
-(void)playPencilLeadFallSound;

-(void)playStarSound;
-(void)playCoinSound;
-(void)playFailSound;
-(void)playIntegrateSound;
-(void)playYeahSound;
-(void)playMouthPopSound;
-(void)playTapSound;
-(void)playFinishSound;
-(void)playDropSound;
-(void)playDripSound;
-(void)playOctopusDoodSound;
-(void)playJetFlyBySound;
-(void)playSlamMetalSound;
-(void)playClapSound;
-(void)playWarpSound;

-(void)playFlightTerminalBoardSound;

-(void)playTransitionInstruction;
-(void)playTransitionEatBeansGameNameSound;
-(void)playTransitionThreeInOneGameNameSound;
-(void)playTransitionBurgerSetGameNameSound;
-(void)playTransitionUFOGameNameSound;
-(void)playTransitionAlarmClockGameNameSound;
-(void)playTransitionJumpingGirlGameNameSound;
-(void)playTransitionBurgerSequenceGameNameSound;
-(void)playTransitionThreeBOGameNameSound;
-(void)playTransitionSmallNumberGameNameSound;
-(void)playTransitionBigNumberGameNameSound;

-(void)playTransitionLevelOneSound;
-(void)playTransitionLevelTwoSound;
-(void)playTransitionLevelThreeSound;
-(void)playTransitionLevelFourSound;
-(void)playTransitionLevelFiveSound;
-(void)playTransitionLevelSixSound;
-(void)playTransitionLevelSevenSound;
-(void)playTransitionLevelEightSound;
-(void)playTransitionLevelNineSound;
-(void)playTransitionLevelTenSound;
-(void)playTransitionLevelElevenSound;
-(void)playTransitionLevelTwlveSound;

-(void)playUFOFlyPassSound;
-(void)playAlarmClockTickingSound;
-(void)playElectricBeepSound;
-(void)pauseAlarmClockTickingSound; 
-(void)stopAlarmClockTickingSound;

-(void)playHarbourSound;
-(void)pauseHarbourSound;
-(void)stopHarbourSound;

-(void)playBreakBeatLongBGM;
-(void)pauseBreakBeatLongBGM;
-(void)stopBreakBeatLongBGM;

-(void)playSideManStrutLongBGM;
-(void)pauseSideManStrutLongBGM;
-(void)stopSideManStrutLongBGM;

-(void)playGalleriaLongBGM;
-(void)pauseGalleriaLongBGM;
-(void)stopGalleriaLongBGM;

-(void)playOffRoadShortBGM;
-(void)pauseOffRoadShortBGM;
-(void)stopOffRoadShortBGM;


-(void)playTornJeansMediumBGM;
-(void)pauseTornJeansMediumBGM;
-(void)stopTornJeansMediumBGM;

-(void)playTitleScreenBGM;
-(void)pauseTitleScreenBGM;
-(void)stopTitleScreenBGM;

-(void)playYearbookMediumBGM;
-(void)pauseYearbookMediumBGM;
-(void)stopYearbookMediumBGM;


-(void)playCrossWalkSound;
-(void)pauseCrossWalkSound;
-(void)stopCrossWalkSound;


- (void) playActionSound;
- (void) playGoodTakeSound;
- (void) playCutSound;

@end
