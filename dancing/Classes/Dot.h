//
//  dot.h
//  bishibashi
//
//  Created by Eric on 08/07/2010.
//  Copyright 2010 Red Soldier. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Dot : UIImageView {
	float _height;
	float _x1;
	float _x2;
	float _duration;
}
@property (nonatomic, assign) float height;
@property (nonatomic, assign) float x1;
@property (nonatomic, assign) float x2;
@property (nonatomic, assign) float duration;
- (void) jumpWithContext:(NSArray*)arr;
@end
