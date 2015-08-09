//
//  MediaManager.m
//  bishibashi
//
//  Created by Kenny Tang on 4/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MediaManager.h"
#import "Constants.h"


static MediaManager *sharedInstance = nil;

@implementation MediaManager
@synthesize crossWalkSound = _crossWalkSound;
@synthesize harbourSound = _harbourSound;
@synthesize mahjongNoise = _mahjongNoise;
@synthesize clockTicking = _clockTicking;
@synthesize electricBeep = _electricBeep;
@synthesize titleScreenBGM = _titleScreenBGM;
@synthesize breakBeatLongBGM = _breakBeatLongBGM;
@synthesize sideManStrutLongBGM = _sideManStrutLongBGM;
@synthesize galleriaLongBGM = _galleriaLongBGM;
@synthesize greasyWheelsShortBGM = _greasyWheelsShortBGM;
@synthesize headspinShortBGM = _headspinShortBGM;
@synthesize offRoadShortBGM = _offRoadShortBGM;
@synthesize tornJeansMediumBGM = _tornJeansMediumBGM;
@synthesize versusTransitionBGM = _versusTransitionBGM;
@synthesize yearbookMediumBGM = _yearbookMediumBGM;

-(id)init{
	self = [super init];
	NSLog(@"device is %@", [[UIDevice currentDevice] platformString]);
	if ([[[UIDevice currentDevice] platformString] isEqualToString:IPHONE_1G_NAMESTRING] || [[[UIDevice currentDevice] platformString] isEqualToString:IPHONE_3G_NAMESTRING])
		_supportMT=NO;
	else
		_supportMT=YES;
//	if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)])
//		_supportMT = [[UIDevice currentDevice] isMultitaskingSupported];
//	else
//		_supportMT = NO;
	// Initializes Audio Session, opens OpenAL device.
	soundEngine = [[Finch alloc] init];

	star = [[SoundEffect alloc] initWithFileName:@"star" andExt:@"wav"];
	pencilPress = [[SoundEffect alloc] initWithFileName:@"pencil_press" andExt:@"aiff"];
	pencilLeadFall = [[SoundEffect alloc] initWithFileName:@"cartoon_fall" andExt:@"aiff"];

	countDownThree = [[SoundEffect alloc] initWithFileName:@"countdown_three" andExt:@"wav"];
	countDownTwo = [[SoundEffect alloc] initWithFileName:@"countdown_two" andExt:@"wav"];
	countDownOne = [[SoundEffect alloc] initWithFileName:@"countdown_one" andExt:@"wav"];
	
	fail = [[Sound alloc] initWithFile:[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"fail.wav"]];		
	coin = [[Sound alloc] initWithFile:[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"pulsing_accent.wav"]];		
	integrate = [[Sound alloc] initWithFile:[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"integrate.wav"]];		
	yeah = [[Sound alloc] initWithFile:[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"yeah.wav"]];	
	mouthPop = [[Sound alloc] initWithFile:[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"MouthPop.wav"]];	
	finish = [[Sound alloc] initWithFile:[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"finish.wav"]];	

	tap = [[SoundEffect alloc] initWithFileName:@"tap" andExt:@"aif"];
	//drip = [[SoundEffect alloc] initWithFileName:@"drip" andExt:@"wav"];
	//drop = [[SoundEffect alloc] initWithFileName:@"drop" andExt:@"wav"];
	
	warp = [[SoundEffect alloc] initWithFileName:@"warp_engineering" andExt:@"wav"];
	transitionInstruction = [[SoundEffect alloc] initWithFileName:@"instruction" andExt:@"wav"];
	transitionLevelOne = [[SoundEffect alloc] initWithFileName:@"eatbeansgamescript" andExt:@"wav"];
	transitionLevelTwo = [[SoundEffect alloc] initWithFileName:@"3in1gamescript" andExt:@"wav"];
	transitionLevelThree = [[SoundEffect alloc] initWithFileName:@"burgersetgamescript" andExt:@"wav"];
	transitionLevelFour = [[SoundEffect alloc] initWithFileName:@"ufogamescript" andExt:@"wav"];
	transitionLevelFive = [[SoundEffect alloc] initWithFileName:@"alarmclockgamescript" andExt:@"wav"];
	transitionLevelSix = [[SoundEffect alloc] initWithFileName:@"jumpinggirlgamescript" andExt:@"wav"];
	transitionLevelSeven = [[SoundEffect alloc] initWithFileName:@"burgerseqgamescript" andExt:@"wav"];
	transitionLevelEight = [[SoundEffect alloc] initWithFileName:@"3bogamescript" andExt:@"wav"];
	transitionLevelNine = [[SoundEffect alloc] initWithFileName:@"smallnumbergamescript" andExt:@"wav"];
	transitionLevelTen = [[SoundEffect alloc] initWithFileName:@"bignumbergamescript" andExt:@"wav"];	
	transitionLevelEleven = [[SoundEffect alloc] initWithFileName:@"dancinggamescript" andExt:@"wav"];	
	transitionLevelTwlve = [[SoundEffect alloc] initWithFileName:@"bunhillgamescript" andExt:@"wav"];	
	dramaticAccent1 = [[SoundEffect alloc] initWithFileName:@"dramatic_accent_01" andExt:@"mp3"];
	slamMetal = [[SoundEffect alloc] initWithFileName:@"slam_metal" andExt:@"wav"];	
	
	ufoFlyPass = [[SoundEffect alloc] initWithFileName:@"ufo_fly_pass" andExt:@"aiff"];
	jetFlyBy = [[SoundEffect alloc] initWithFileName:@"jet_fly" andExt:@"mp3"];
	clap = [[SoundEffect alloc] initWithFileName:@"clap" andExt:@"wav"];
	
	goodTake = [[SoundEffect alloc] initWithFileName:@"goodtake" andExt:@"aiff"];
	action = [[SoundEffect alloc] initWithFileName:@"action" andExt:@"wav"];
	cut = [[SoundEffect alloc] initWithFileName:@"cut" andExt:@"aiff"];
	octopusDood = [[SoundEffect alloc] initWithFileName:@"octopus_dood_loud2" andExt:@"wav"];
	
	drip = [[Sound alloc] initWithFile:[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"drip.wav"]];	
	drop = [[Sound alloc] initWithFile:[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"drop.wav"]];

	
	flightTerminalBoardSound = [[Sound alloc] initWithFile:[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"ftb.wav"]];	
	
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

-(void)startPlayingBGM:(Game)theGame{
	if (_supportMT)	{
	if (theGame == keatbeans){
		[self stopBreakBeatLongBGM];
		[self playBreakBeatLongBGM];
	}
	if (theGame == k3in1){
		[self stopSideManStrutLongBGM];
		[self playSideManStrutLongBGM];
	}
	if (theGame == kburgerset){
		[self stopGalleriaLongBGM];
		[self playGalleriaLongBGM];
	}
	if (theGame == kufo){
		[self stopBreakBeatLongBGM];
		[self playBreakBeatLongBGM];
	}
	if (theGame == kalarmclock){
		[self stopGreasyWheelsShortBGM];
		[self playGreasyWheelsShortBGM];
	}
	if (theGame == kbignumber){
		[self stopGreasyWheelsShortBGM];
		[self playGreasyWheelsShortBGM];
	}
	if (theGame == kjumpinggirl){
		[self stopHeadspinShortBGM];
		[self playHeadspinShortBGM];
	}
	if (theGame == kburgerseq){
		[self stopOffRoadShortBGM];
		[self playOffRoadShortBGM];
	}
	if (theGame == k3bo){
		[self stopGalleriaLongBGM];
		[self playGalleriaLongBGM];
	}
	if (theGame == ksmallnumber){
		[self stopBreakBeatLongBGM];
		[self playBreakBeatLongBGM];
	}
	if (theGame == kbunhill){
		[self stopGalleriaLongBGM];
		[self playGalleriaLongBGM];
	}
	if (theGame == kpencil){
		[self stopYearbookMediumBGM];
		[self playYearbookMediumBGM];
		
	}
	
	}
}


-(void)stopPlayingBGM:(Game)theGame{
	if (_supportMT)	{
	if (theGame == keatbeans){
		[self stopBreakBeatLongBGM];
	}
	if (theGame == k3in1){
		[self stopSideManStrutLongBGM];
	}
	if (theGame == kburgerset){
		[self stopGalleriaLongBGM];
	}
	if (theGame == kufo){
		[self stopBreakBeatLongBGM];
	}
	if (theGame == kalarmclock){
		[self stopGreasyWheelsShortBGM];
	}
	if (theGame == kbignumber){
		[self stopGreasyWheelsShortBGM];
	}
	if (theGame == kjumpinggirl){
		[self stopHeadspinShortBGM];
	}
	if (theGame == kburgerseq){
		[self stopOffRoadShortBGM];
	}
	if (theGame == k3bo){
		[self stopGalleriaLongBGM];
	}
	if (theGame == ksmallnumber){
		[self stopBreakBeatLongBGM];
	}
	if (theGame == kbunhill){
		[self stopGalleriaLongBGM];
	}
	if (theGame == kpencil){
		[self stopYearbookMediumBGM];
	}
	}
}

-(void)playYearbookMediumBGM{
	if (!self.yearbookMediumBGM)	{
		SoundFile* sound = [[SoundFile alloc] initWithFileName:@"yearbook_medium" andExt:@"mp3"];
		self.yearbookMediumBGM = sound;
		[sound release];
	}
	[self.yearbookMediumBGM playSoundOnLoop];
	[self.yearbookMediumBGM.avAudioPlayer setNumberOfLoops:1];
	
}

-(void)pauseYearbookMediumBGM{
	[self.yearbookMediumBGM pauseSound];
}

-(void)stopYearbookMediumBGM{
	[self.yearbookMediumBGM stopSound];
	self.yearbookMediumBGM = nil;
}



-(void)playVersusTransitionBGM{
	if (!self.versusTransitionBGM)	{
		SoundFile* sound = [[SoundFile alloc] initWithFileName:@"sf4_versus" andExt:@"mp3"];
		self.versusTransitionBGM = sound;
		[sound release];
	}
	[self.versusTransitionBGM playSoundOnLoop];
	[self.versusTransitionBGM.avAudioPlayer setNumberOfLoops:1];

}

-(void)pauseVersusTransitionBGM{
	[self.versusTransitionBGM pauseSound];
}

-(void)stopVersusTransitionBGM{
	[self.versusTransitionBGM stopSound];
	self.versusTransitionBGM = nil;
}


-(void)playTornJeansMediumBGM{
	if (!self.tornJeansMediumBGM)	{
		SoundFile* sound = [[SoundFile alloc] initWithFileName:@"torn_jeans_medium" andExt:@"mp3"];
		self.tornJeansMediumBGM = sound;
		[sound release];
	}
	[self.tornJeansMediumBGM playSoundOnLoop];
}

-(void)pauseTornJeansMediumBGM{
	[self.tornJeansMediumBGM pauseSound];
}

-(void)stopTornJeansMediumBGM{
	[self.tornJeansMediumBGM stopSound];
	self.tornJeansMediumBGM = nil;
}


-(void)playOffRoadShortBGM{
	if (!self.offRoadShortBGM)	{
		SoundFile* sound = [[SoundFile alloc] initWithFileName:@"offroad_medium" andExt:@"mp3"];
		self.offRoadShortBGM = sound;
		[sound release];
	}
	[self.offRoadShortBGM playSoundOnLoop];
}

-(void)pauseOffRoadShortBGM{
	[self.offRoadShortBGM pauseSound];
}

-(void)stopOffRoadShortBGM{
	[self.offRoadShortBGM stopSound];
	self.offRoadShortBGM = nil;
}


-(void)playHeadspinShortBGM{
	if (!self.headspinShortBGM)	{
		SoundFile* sound = [[SoundFile alloc] initWithFileName:@"headspin_short" andExt:@"mp3"];
		self.headspinShortBGM = sound;
		[sound release];
	}
	[self.headspinShortBGM playSoundOnLoop];
}

-(void)pauseHeadspinShortBGM{
	[self.headspinShortBGM pauseSound];
}

-(void)stopHeadspinShortBGM{
	[self.headspinShortBGM stopSound];
	self.headspinShortBGM = nil;
}


-(void)playGalleriaLongBGM{
	if (!self.greasyWheelsShortBGM)	{
		SoundFile* sound = [[SoundFile alloc] initWithFileName:@"galleria_long" andExt:@"mp3"];
		self.greasyWheelsShortBGM = sound;
		[sound release];
	}
	[self.greasyWheelsShortBGM playSoundOnLoop];
}

-(void)pauseGalleriaLongBGM{
	[self.greasyWheelsShortBGM pauseSound];
}

-(void)stopGalleriaLongBGM{
	[self.greasyWheelsShortBGM stopSound];
	self.greasyWheelsShortBGM = nil;
}

-(void)playGreasyWheelsShortBGM{
	if (!self.sideManStrutLongBGM)	{
		SoundFile* sound = [[SoundFile alloc] initWithFileName:@"greasy_wheels_short" andExt:@"mp3"];
		self.sideManStrutLongBGM = sound;
		[sound release];
	}
	[self.sideManStrutLongBGM playSoundOnLoop];
}

-(void)pauseGreasyWheelsShortBGM{
	[self.sideManStrutLongBGM pauseSound];
}

-(void)stopGreasyWheelsShortBGM{
	[self.sideManStrutLongBGM stopSound];
	self.sideManStrutLongBGM = nil;
}



-(void)playSideManStrutLongBGM{
	if (!self.sideManStrutLongBGM)	{
		SoundFile* sound = [[SoundFile alloc] initWithFileName:@"galleria_long" andExt:@"mp3"];
		self.sideManStrutLongBGM = sound;
		[sound release];
	}
	[self.sideManStrutLongBGM playSoundOnLoop];
}

-(void)pauseSideManStrutLongBGM{
	[self.sideManStrutLongBGM pauseSound];
}

-(void)stopSideManStrutLongBGM{
	[self.sideManStrutLongBGM stopSound];
	self.sideManStrutLongBGM = nil;
}



-(void)playBreakBeatLongBGM{
	if (!self.breakBeatLongBGM)	{
		SoundFile* sound = [[SoundFile alloc] initWithFileName:@"breakbeat_long" andExt:@"mp3"];
		self.breakBeatLongBGM = sound;
		[sound release];
	}
	[self.breakBeatLongBGM playSoundOnLoop];
}

-(void)pauseBreakBeatLongBGM{
	[self.breakBeatLongBGM pauseSound];
}

-(void)stopBreakBeatLongBGM{
	[self.breakBeatLongBGM stopSound];
	self.breakBeatLongBGM = nil;
}



-(void)playTitleScreenBGM{
	if (!self.titleScreenBGM)	{
		SoundFile* sound = [[SoundFile alloc] initWithFileName:@"half_dome_medium" andExt:@"mp3"];
		self.titleScreenBGM = sound;
		[sound release];
	}
	[self.titleScreenBGM playSoundOnLoop];
	[self.titleScreenBGM.avAudioPlayer setNumberOfLoops:1];
}

-(void)pauseTitleScreenBGM{
	[self.titleScreenBGM pauseSound];
}

-(void)stopTitleScreenBGM{
	[self.titleScreenBGM stopSound];
	self.titleScreenBGM = nil;
}

-(void)playCrossWalkSound{
	if (!self.crossWalkSound)	{
		SoundFile* sound = [[SoundFile alloc] initWithFileName:@"crosswalk" andExt:@"mp3"];
		self.crossWalkSound = sound;
		[sound release];
	}
	[self.crossWalkSound playSoundOnLoop];
}

-(void)pauseCrossWalkSound{
	[self.crossWalkSound pauseSound];
}

-(void)stopCrossWalkSound{
	[self.crossWalkSound stopSound];
	self.crossWalkSound = nil;
}


-(void)stopMahjongNoiseSound{
	[self.mahjongNoise stopSound];
	self.mahjongNoise =nil;
}

-(void)pauseMahjongNoiseSound{
	[self.mahjongNoise pauseSound];
}

-(void)playMahjongNoiseSound{
	if (!self.mahjongNoise)	{
		SoundFile* sound = [[SoundFile alloc] initWithFileName:@"mahjong" andExt:@"mp3"];
		self.mahjongNoise = sound;
		[sound release];
	}
	[self.mahjongNoise playSoundOnLoop];
}

-(void)stopHarbourSound{
	[self.harbourSound stopSound];
	self.harbourSound = nil;
}

-(void)pauseHarbourSound{
	[self.harbourSound pauseSound];
}

-(void)playHarbourSound{
	if (!self.harbourSound)	{
		SoundFile* sound = [[SoundFile alloc] initWithFileName:@"harbour" andExt:@"mp3"];
		self.harbourSound = sound;
		[sound release];
	}
	[self.harbourSound playSoundOnLoop];
}


-(void)stopAlarmClockTickingSound{
	[self.clockTicking stopSound];
	self.clockTicking = nil;
}

-(void)pauseAlarmClockTickingSound{
	[self.clockTicking pauseSound];
}

-(void)playElectricBeepSound{
	if (!self.electricBeep)	{
		SoundFile* sound = [[SoundFile alloc] initWithFileName:@"electro_beep" andExt:@"aiff"];
		self.electricBeep = sound;
		[sound release];
	}
	[self.electricBeep playSound];
}

-(void)playAlarmClockTickingSound{
	if (!self.clockTicking)	{
		SoundFile* sound = [[SoundFile alloc] initWithFileName:@"alarm_clock_ticking_sound" andExt:@"aiff"];
		self.clockTicking = sound;
		[sound release];
	}
	[self.clockTicking playSoundOnLoop];
}

-(void)playDramaticAccentSound{
	[dramaticAccent1 play];
}

-(void)playJetFlyBySound{
	[jetFlyBy play];
}

-(void)playUFOFlyPassSound{
//	[ufoFlyPass playSound];
	[ufoFlyPass play];
}

-(void)playOctopusDoodSound{
	[octopusDood play];
}


-(void)playCountDownThreeSound{
//	[countDownThree playSound];
	[countDownThree play];
}

-(void)playCountDownTwoSound{
//	[countDownTwo playSound];
	[countDownTwo play];
}

-(void)playCountDownOneSound{
//	[countDownOne playSound];
	[countDownOne play];
}

-(void)playSlamMetalSound{
    [slamMetal play];
}

-(void)playStarSound{
	[star play];
}

-(void)playPencilPressSound{
	[pencilPress play];
}

-(void)playPencilLeadFallSound{
	[pencilLeadFall play];
}

-(void)playCoinSound{
	//	[fail playSound];
	[coin play];
}


-(void)playFailSound{
//	[fail playSound];
	[fail play];
}

-(void)playIntegrateSound{
//	[integrate playSound];
	[integrate play];
}

-(void)playYeahSound{
//	[yeah playSound];
	[yeah play];
}

-(void)playMouthPopSound{
//	[mouthPop playSound];
	[mouthPop play];
}

-(void)playTapSound{
//	[tap playSound];
	[tap play];
}

-(void)playFinishSound{
//	[finish playSound];
	[finish play];
}

-(void)playDropSound{
//	[drop play];
	[drop play];
}

-(void)playDripSound{
//	[drip playSound];
	[drip play];
}

-(void)playFlightTerminalBoardSound{
	[flightTerminalBoardSound setLoop:YES];
	[flightTerminalBoardSound play];
}

-(void)stopFlightTerminalBoardSound{
	[flightTerminalBoardSound stop];
}

-(void)pauseFlightTerminalBoardSound{
	[flightTerminalBoardSound stop];
}

-(void)playTransitionInstruction{
	
	if ([[[Constants sharedInstance]language] isEqualToString:@"zh-hk"]) {
		[transitionInstruction play];
	}
	else if ([[[Constants sharedInstance]language] isEqualToString:@"zh-Hans"]) {
		[transitionInstruction play];
	}
	else if ([[[Constants sharedInstance]language] isEqualToString:@"zh_TW"]) {
		[transitionInstruction play];
	}else{
		[self playUFOFlyPassSound];
	}
	
	
}

-(void)playTransitionEatBeansGameNameSound{
	if ([[[Constants sharedInstance]language] isEqualToString:@"zh-hk"]) {
		[transitionEatBeansGameName play];
	}
	else if ([[[Constants sharedInstance]language] isEqualToString:@"zh-Hans"]) {
		[transitionEatBeansGameName play];
	}
	else if ([[[Constants sharedInstance]language] isEqualToString:@"zh_TW"]) {
		[transitionEatBeansGameName play];
	}
}

-(void)playTransitionThreeInOneGameNameSound{
//	[transitionThreeInOneGameName playSound];
	[transitionThreeInOneGameName play];
}

-(void)playTransitionBurgerSetGameNameSound{
//	[transitionBurgerSetGameName playSound];
	[transitionBurgerSetGameName play];
}

-(void)playTransitionUFOGameNameSound{
//	[transitionUFOGameName playSound];
	[transitionUFOGameName play];
}

-(void)playTransitionAlarmClockGameNameSound{
//	[transitionAlarmClockGameName playSound];
	[transitionAlarmClockGameName play];
}

-(void)playTransitionJumpingGirlGameNameSound{
//	[transitionJumpingGirlGameName playSound];
	[transitionJumpingGirlGameName play];
}

-(void)playTransitionBurgerSequenceGameNameSound{
//	[transitionBurgerSequenceGameName playSound];
	[transitionBurgerSequenceGameName play];
}

-(void)playTransitionThreeBOGameNameSound{
//	[transitionThreeBOGameName playSound];
	[transitionThreeBOGameName play];
}

-(void)playTransitionSmallNumberGameNameSound{
//	[transitionSmallNumberGameName playSound];
	[transitionSmallNumberGameName play];
}

-(void)playTransitionBigNumberGameNameSound{
//	[transitionBigNumberGameName playSound];
	[transitionBigNumberGameName play];
}

-(void)playTransitionLevelOneSound{
	if ([[[Constants sharedInstance]language] isEqualToString:@"zh-hk"]) {
		[transitionLevelOne play];
	}
	else if ([[[Constants sharedInstance]language] isEqualToString:@"zh-Hans"]) {
		[transitionLevelOne play];
	}
	else if ([[[Constants sharedInstance]language] isEqualToString:@"zh_TW"]) {
		[transitionLevelOne play];
	}else{
		[self playUFOFlyPassSound];
	}
}


-(void)playTransitionLevelTwoSound{
	if ([[[Constants sharedInstance]language] isEqualToString:@"zh-hk"]) {
		[transitionLevelTwo play];
	}
	else if ([[[Constants sharedInstance]language] isEqualToString:@"zh-Hans"]) {
		[transitionLevelTwo play];
	}
	else if ([[[Constants sharedInstance]language] isEqualToString:@"zh_TW"]) {
		[transitionLevelTwo play];
	}else{
		[self playUFOFlyPassSound];
	}
}


-(void)playTransitionLevelThreeSound{
	if ([[[Constants sharedInstance]language] isEqualToString:@"zh-hk"]) {
		[transitionLevelThree play];
	}
	else if ([[[Constants sharedInstance]language] isEqualToString:@"zh-Hans"]) {
		[transitionLevelThree play];
	}
	else if ([[[Constants sharedInstance]language] isEqualToString:@"zh_TW"]) {
		[transitionLevelThree play];
	}else{
		[self playUFOFlyPassSound];
	}
}

-(void)playTransitionLevelFourSound{
	if ([[[Constants sharedInstance]language] isEqualToString:@"zh-hk"]) {
		[transitionLevelFour play];
	}
	else if ([[[Constants sharedInstance]language] isEqualToString:@"zh-Hans"]) {
		[transitionLevelFour play];
	}
	else if ([[[Constants sharedInstance]language] isEqualToString:@"zh_TW"]) {
		[transitionLevelFour play];
	}else{
		[self playUFOFlyPassSound];
	}
}


-(void)playTransitionLevelFiveSound{
	if ([[[Constants sharedInstance]language] isEqualToString:@"zh-hk"]) {
		[transitionLevelFive play];
	}
	else if ([[[Constants sharedInstance]language] isEqualToString:@"zh-Hans"]) {
		[transitionLevelFive play];
	}
	else if ([[[Constants sharedInstance]language] isEqualToString:@"zh_TW"]) {
		[transitionLevelFive play];
	}else{
		[self playUFOFlyPassSound];
	}
}


-(void)playTransitionLevelSixSound{
	if ([[[Constants sharedInstance]language] isEqualToString:@"zh-hk"]) {
		[transitionLevelSix play];
	}
	else if ([[[Constants sharedInstance]language] isEqualToString:@"zh-Hans"]) {
		[transitionLevelSix play];
	}
	else if ([[[Constants sharedInstance]language] isEqualToString:@"zh_TW"]) {
		[transitionLevelSix play];
	}else{
		[self playUFOFlyPassSound];
	}
}


-(void)playTransitionLevelSevenSound{
	if ([[[Constants sharedInstance]language] isEqualToString:@"zh-hk"]) {
		[transitionLevelSeven play];
	}
	else if ([[[Constants sharedInstance]language] isEqualToString:@"zh-Hans"]) {
		[transitionLevelSeven play];
	}
	else if ([[[Constants sharedInstance]language] isEqualToString:@"zh_TW"]) {
		[transitionLevelSeven play];
	}else{
		[self playUFOFlyPassSound];
	}
}


-(void)playTransitionLevelEightSound{
	if ([[[Constants sharedInstance]language] isEqualToString:@"zh-hk"]) {
		[transitionLevelEight play];
	}
	else if ([[[Constants sharedInstance]language] isEqualToString:@"zh-Hans"]) {
		[transitionLevelEight play];
	}
	else if ([[[Constants sharedInstance]language] isEqualToString:@"zh_TW"]) {
		[transitionLevelEight play];
	}else{
		[self playUFOFlyPassSound];
	}
}


-(void)playTransitionLevelNineSound{
	if ([[[Constants sharedInstance]language] isEqualToString:@"zh-hk"]) {
		[transitionLevelNine play];
	}
	else if ([[[Constants sharedInstance]language] isEqualToString:@"zh-Hans"]) {
		[transitionLevelNine play];
	}
	else if ([[[Constants sharedInstance]language] isEqualToString:@"zh_TW"]) {
		[transitionLevelNine play];
	}else{
		[self playUFOFlyPassSound];
	}
}


-(void)playTransitionLevelTenSound{
	if ([[[Constants sharedInstance]language] isEqualToString:@"zh-hk"]) {
		[transitionLevelTen play];
	}
	else if ([[[Constants sharedInstance]language] isEqualToString:@"zh-Hans"]) {
		[transitionLevelTen play];
	}
	else if ([[[Constants sharedInstance]language] isEqualToString:@"zh_TW"]) {
		[transitionLevelTen play];
	}else{
		[self playUFOFlyPassSound];
	}
}

-(void)playTransitionLevelElevenSound{
	if ([[[Constants sharedInstance]language] isEqualToString:@"zh-hk"]) {
		[transitionLevelEleven play];
	}
	else if ([[[Constants sharedInstance]language] isEqualToString:@"zh-Hans"]) {
		[transitionLevelEleven play];
	}
	else if ([[[Constants sharedInstance]language] isEqualToString:@"zh_TW"]) {
		[transitionLevelEleven play];
	}else{
		[self playUFOFlyPassSound];
	}
}

-(void)playTransitionLevelTwlveSound{
	if ([[[Constants sharedInstance]language] isEqualToString:@"zh-hk"]) {
		[transitionLevelTwlve play];
	}
	else if ([[[Constants sharedInstance]language] isEqualToString:@"zh-Hans"]) {
		[transitionLevelTwlve play];
	}
	else if ([[[Constants sharedInstance]language] isEqualToString:@"zh_TW"]) {
		[transitionLevelTwlve play];
	}else{
		[self playUFOFlyPassSound];
	}
}

- (void) playGoodTakeSound	{
//	[goodTake playSound];
	[goodTake play];
}

- (void) playActionSound {
//	[action playSound];
	[action play];
}
   
- (void) playCutSound	{
//	[cut playSound];
	[cut play];
}
   

- (void) playClapSound{
	[clap play];
}

- (void) playWarpSound{
	[warp play];
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX; //denotes an object that cannot be released
}


- (void)release {
    // never release
}


- (void)dealloc {
	[countDownThree release];
	[countDownTwo release];
	[countDownOne release];
	
	[goodTake release];
	[action release];
	[cut release];
	[clap release];
	// todo:all the other files, add later
	[soundEngine release];
	[super dealloc];
}



@end
