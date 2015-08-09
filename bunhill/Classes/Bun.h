//
//  Bun.h
//  bishibashi
//
//  Created by Eric on 03/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface Bun : UIImageView {
	int _score;
	id _owner;
	int _pos;
	int _column;
	BOOL _isSpecial;
	UIInterfaceOrientation _orientation;
}
@property (nonatomic, assign) int score;
@property (nonatomic, assign) id owner;
@property (nonatomic, assign) int column;
@property (nonatomic, assign) int pos;
@property (nonatomic, assign) BOOL isSpecial;
@property (nonatomic, assign) UIInterfaceOrientation orientation;
@end
