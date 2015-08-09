//
//  3boView.h
//  bishibashi
//
//  Created by Eric on 23/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameView.h"
#import "Bo.h"
@interface the3BoView : GameView {
	UIImageView* _redButSample;
	UIImageView* _greenButSample;
	UIImageView* _blueButSample;
	
	NSMutableArray* _seq;
	NSMutableArray* _opponentSeq;
	NSMutableArray* _finishedseq;
	int _curSeq;
	UIImageView* _stickView;

}
@property (nonatomic, retain) UIImageView* redButSample;
@property (nonatomic, retain) UIImageView* greenButSample;
@property (nonatomic, retain) UIImageView* blueButSample;

@property (nonatomic, retain) NSMutableArray* seq;
@property (nonatomic, retain) NSMutableArray* opponentSeq;
@property (nonatomic, retain) NSMutableArray* finishedseq;
@property (nonatomic, assign) int curSeq;

@property (nonatomic, retain) UIImageView* stickView;


@end
