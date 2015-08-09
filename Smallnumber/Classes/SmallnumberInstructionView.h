//
//  SmallnumberInstructionView.h
//  bishibashi
//
//  Created by Eric on 19/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Number.h"
#import "InstructionView.h"

@interface SmallnumberInstructionView : InstructionView {
	NSMutableArray* _redSeq;
	NSMutableArray* _greenSeq;
	NSMutableArray* _blueSeq;
	int _curRedSeq;
	int _curGreenSeq;
	int _curBlueSeq;
}
@property (nonatomic, retain) NSMutableArray* redSeq;
@property (nonatomic, retain) NSMutableArray* greenSeq;
@property (nonatomic, retain) NSMutableArray* blueSeq;
@property (nonatomic, assign) int curRedSeq;
@property (nonatomic, assign) int curGreenSeq;
@property (nonatomic, assign) int curBlueSeq;

@end