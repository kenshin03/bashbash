//
//  BignumberView.h
//  bishibashi
//
//  Created by Eric on 25/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameView.h"
#import "Dice.h"


@interface BignumberView : GameView {
	Dice* _redDice;
	Dice* _greenDice;
	Dice* _blueDice;
	NSInteger _currentRound;
	
}
@property (nonatomic, retain) Dice* redDice;
@property (nonatomic, retain) Dice* greenDice;
@property (nonatomic, retain) Dice* blueDice;
@property (nonatomic) NSInteger currentRound;

@end
