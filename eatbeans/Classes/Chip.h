//
//  chip.h
//  bishibashi
//
//  Created by Eric on 19/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameView.h"
#import "LocalStorageManager.h"

@interface Chip : UIView {
	ButState		_state;
	UIImageView*	_leftImg;
	UIImageView*	_centerImg;
	UIImageView*	_rightImg;
	
	UIImageView*	_leftHeadImg;
	UIImageView*	_centerHeadImg;
	UIImageView*	_rightHeadImg;
	
	
	UIImageView*	_leftHandUpImg;
	UIImageView*	_leftHandDownImg;
	UIImageView*	_rightHandUpImg;
	UIImageView*	_rightHandDownImg;
	
	CFURLRef		soundFileURLRef;
	SystemSoundID	soundFileObject;
	
	CFURLRef		mouthPopSoundRef;
	SystemSoundID	mouthPopSoundFileObject;
	UIInterfaceOrientation _orientation;	
	
}
@property(nonatomic, retain) UIImageView* leftImg;
@property(nonatomic, retain) UIImageView* centerImg;
@property(nonatomic, retain) UIImageView* rightImg;

@property(nonatomic, retain) UIImageView* leftHeadImg;
@property(nonatomic, retain) UIImageView* centerHeadImg;
@property(nonatomic, retain) UIImageView* rightHeadImg;

@property(nonatomic, retain) UIImageView* leftHandUpImg;
@property(nonatomic, retain) UIImageView* leftHandDownImg;
@property(nonatomic, retain) UIImageView* rightHandUpImg;
@property(nonatomic, retain) UIImageView* rightHandDownImg;
@property(nonatomic, assign) ButState state;

@property (readwrite)	CFURLRef		soundFileURLRef;
@property (readonly)	SystemSoundID	soundFileObject;
@property (readwrite)	CFURLRef		mouthPopSoundRef;
@property (readonly)	SystemSoundID	mouthPopSoundFileObject;
@property (nonatomic, assign) UIInterfaceOrientation orientation;

@end
