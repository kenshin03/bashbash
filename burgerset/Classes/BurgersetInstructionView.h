//
//  BurgersetInstructionView.h
//  bishibashi
//
//  Created by Eric on 20/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstructionView.h"
#import "Burger.h"

@interface BurgersetInstructionView : InstructionView {
	NSMutableArray* _targetQueue;
	NSMutableArray* _currentQueue;
	
	NSMutableArray* _targetQueueBurger;
	NSMutableArray* _currentQueueBurger;
}
@property (nonatomic, retain) NSMutableArray* targetQueue;
@property (nonatomic, retain) NSMutableArray* currentQueue;
@property (nonatomic, retain) NSMutableArray* targetQueueBurger;
@property (nonatomic, retain) NSMutableArray* currentQueueBurger;


@end

