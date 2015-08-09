//
//  BurgetseqView.h
//  bishibashi
//
//  Created by Eric on 21/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameView.h"
#import "Ingredient.h"

@interface BurgerseqView : GameView {
	UIImageView* _redButSample;
	UIImageView* _greenButSample;
	UIImageView* _blueButSample;
	
	NSMutableArray* _seq;
	NSMutableArray* _ingredients;
	int _curSeq;
	int _noSeq;
	NSInteger _currentRound;
}
@property (nonatomic, retain) NSMutableArray* seq;
@property (nonatomic, assign) int curSeq;
@property (nonatomic, retain) NSMutableArray* ingredients;
@property (nonatomic, assign) int noSeq;
@property (nonatomic, retain) UIImageView* redButSample;
@property (nonatomic, retain) UIImageView* greenButSample;
@property (nonatomic, retain) UIImageView* blueButSample;
@property (nonatomic) NSInteger currentRound;

@end