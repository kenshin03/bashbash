//
//  BurgerseqInstructionView.h
//  bishibashi
//
//  Created by Eric on 18/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstructionView.h"
#import "Ingredient.h"

@interface BurgerseqInstructionView : InstructionView {

	
	NSMutableArray* _seq;
	NSMutableArray* _ingredients;
}
@property (nonatomic, retain) NSMutableArray* seq;
@property (nonatomic, retain) NSMutableArray* ingredients;


@end
