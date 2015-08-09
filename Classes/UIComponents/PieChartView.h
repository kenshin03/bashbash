//
//  PieChartView.h
//  bishibashi
//
//  Created by Eric on 03/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PieChartView : UIView {
	float _maxVal;
	float _curVal;
}

@property (nonatomic, assign) float maxVal;
@property (nonatomic, assign) float curVal;

- (id) initWithFrame:(CGRect)frame AndMaxVal:(float)maxVal;
- (void) setCurVal:(float)curVal;

@end
