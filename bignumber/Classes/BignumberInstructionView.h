//
//  BignumberInstructionView.h
//  bishibashi
//
//  Created by Eric on 20/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstructionView.h"
#import "Dice.h"

@interface BignumberInstructionView : InstructionView {
	Dice* _redDice;
	Dice* _greenDice;
	Dice* _blueDice;
	int _currentRound;
	
}
@property (nonatomic, retain) Dice* redDice;
@property (nonatomic, retain) Dice* greenDice;
@property (nonatomic, retain) Dice* blueDice;
@property (nonatomic, assign) int currentRound;
@end
