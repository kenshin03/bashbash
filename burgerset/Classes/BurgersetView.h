//
//  burgersetView.h
//  bishibashi
//
//  Created by Eric on 10/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Burger.h"
#import "GameView.h"
@interface BurgersetView : GameView {
	NSMutableArray* _targetQueue;
	NSMutableArray* _currentQueue;

	NSMutableArray* _targetQueueBurger;
	NSMutableArray* _currentQueueBurger;
	NSInteger _currentRound;

}
@property (nonatomic, retain) NSMutableArray* targetQueue;
@property (nonatomic, retain) NSMutableArray* currentQueue;
@property (nonatomic, retain) NSMutableArray* targetQueueBurger;
@property (nonatomic, retain) NSMutableArray* currentQueueBurger;

@property (nonatomic, retain) NSTimer* theTimer;
@property (nonatomic) NSInteger currentRound;

@end


