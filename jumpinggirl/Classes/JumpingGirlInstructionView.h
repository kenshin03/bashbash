//
//  JumpingGirlInstructionView.h
//  bishibashi
//
//  Created by Eric on 19/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstructionView.h"
#import "JumpingGirl.h"

@interface JumpingGirlInstructionView : InstructionView{
	int _seq;
	JumpingGirl* _theGirl;
}
@property (nonatomic, assign) int seq; /* 1 (R->G) 2 (G->B) 3(B->G) 4(G->R) */
@property (nonatomic, retain) JumpingGirl* theGirl;

@end
