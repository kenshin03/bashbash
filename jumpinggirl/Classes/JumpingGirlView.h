//
//  JumingGirlView.h
//  bishibashi
//
//  Created by Eric on 14/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameView.h"
#import "JumpingGirl.h"

@interface JumpingGirlView : GameView {
	int _hits;
	int _seq;
	int	_opponentSeq;
	JumpingGirl* _theGirl;
	JumpingGirl*	_opponentGirl;
	float _duration;
}
@property (nonatomic, assign) int hits;
@property (nonatomic, assign) float duration;
@property (nonatomic, retain) NSTimer* theTimer;
@property (nonatomic, assign) int seq; /* 1 (R->G) 2 (G->B) 3(B->G) 4(G->R) */
@property (nonatomic, assign) int opponentSeq; /* 1 (R->G) 2 (G->B) 3(B->G) 4(G->R) */
@property (nonatomic, retain) JumpingGirl* theGirl;
@property (nonatomic, retain) JumpingGirl* opponentGirl;

@end
