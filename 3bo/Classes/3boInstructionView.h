//
//  3boInstructionView.h
//  bishibashi
//
//  Created by Eric on 19/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstructionView.h"
#import "Bo.h"

@interface the3boInstructionView : InstructionView {
	int _curSeq;
	UIImageView* _stickView;
	NSMutableArray* _seq;
	NSMutableArray* _finishedseq;
}
@property (nonatomic, assign) int curSeq;

@property (nonatomic, retain) UIImageView* stickView;
@property (nonatomic, retain) NSMutableArray* seq;
@property (nonatomic, retain) NSMutableArray* finishedseq;


@end
