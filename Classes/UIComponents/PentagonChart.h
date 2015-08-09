//
//  PentagonChart.h
//  bishibashi
//
//  Created by Eric on 22/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PentagonChart : UIView {
	float _step;
	NSMutableArray* _scores;
	NSMutableArray* _scoreLabels;
	NSArray* _scoreStrings;
	CGPoint _center;
	float _fulllength;
	NSTimer* _theTimer;
	BOOL	_showRank;
}
@property (nonatomic, assign) BOOL showRank;
@property(nonatomic, retain) NSArray* scoreStrings;
@property(nonatomic, retain) NSMutableArray* scoreLabels;
@property(nonatomic, retain) NSMutableArray* scores;
@property(nonatomic, assign) CGPoint center;
@property(nonatomic, assign) float fulllength;
@property(nonatomic, retain) NSTimer* theTimer;
-(id) initWithFrame:(CGRect)frame AndScores:(NSArray*)scores AndTotalScores:(NSArray*)totalscores AndScoreLabels:(NSArray*)scoreLabels AndShowRank:(BOOL)showRank;
@end
