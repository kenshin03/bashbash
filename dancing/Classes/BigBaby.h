//
//  BigBaby.h
//  bishibashi
//
//  Created by Eric on 06/07/2010.
//  Copyright 2010 Red Soldier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalStorageManager.h"

@interface BigBaby : UIView {
	UIImageView*	_background;
	UIImageView*	_head;
	UIImageView*	_body;
	UIImageView*	_eyebrow;
	UIImageView*	_leftfoot;
	UIImageView*	_rightfoot;
	UIImageView*	_leftear;
	UIImageView*	_rightear;
	UIImageView*	_worm;
	UIImageView*	_face;
	UIImageView*	_face2;
}

@property (nonatomic, retain) UIImageView* background;
@property (nonatomic, retain) UIImageView* head;
@property (nonatomic, retain) UIImageView* body;
@property (nonatomic, retain) UIImageView* leftfoot;
@property (nonatomic, retain) UIImageView* rightfoot;
@property (nonatomic, retain) UIImageView* leftear;
@property (nonatomic, retain) UIImageView* rightear;
@property (nonatomic, retain) UIImageView* eyebrow;
@property (nonatomic, retain) UIImageView* worm;
@property (nonatomic, retain) UIImageView* face;
@property (nonatomic, retain) UIImageView* face2;
@end
