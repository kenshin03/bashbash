//
//  InstructionView.h
//  bishibashi
//
//  Created by Eric on 18/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediaManager.h"

@interface InstructionView : UIView {
	MediaManager *sharedSoundEffectsManager;
	UIButton*	_redBut;
	UIButton*	_blueBut;
	UIButton*	_greenBut;
	
	UIImageView*		_backgroundView;
	UIImageView*		_OKView;
	UIImageView*		_crossView;
	UIImageView*		_handView;
	
	NSMutableArray* _scenarios;
}
@property(nonatomic, retain) NSMutableArray* scenarios;
@property(nonatomic, retain) UIImageView* OKView;
@property(nonatomic, retain) UIImageView* crossView;
@property(nonatomic, retain) UIImageView* backgroundView;

@property(nonatomic, retain) UIButton* redBut;
@property(nonatomic, retain) UIButton* greenBut;
@property(nonatomic, retain) UIButton* blueBut;

@property(nonatomic, retain) UIImageView* handView;

@end
