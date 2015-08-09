//
//  QuickPencilOpponent.h
//  bishibashi
//
//  Created by Eric on 14/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameView.h"

@interface QuickPencilOpponent : UIImageView {
	UIImageView*	_pencilHoldingHandImageView;
	id			_owner;
}
@property (nonatomic, retain) UIImageView* pencilHoldingHandImageView;
@property (nonatomic, assign) id owner;
@end
