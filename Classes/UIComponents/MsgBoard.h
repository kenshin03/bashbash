//
//  MsgBoard.h
//  bishibashi
//
//  Created by Eric on 06/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Msg.h"
#import "GetMsg.h"
#import "LocalStorageManager.h"
#import "Constants.h"

@interface MsgBoard : UIView {
	GetMsg*	_msgGetter;
	id _owner;
	float _startColor;
	float _endColor;
	UIImageView*	_arrow;
	UIControl*		_arrowControl;
	CGRect _theFrame;
	UITableView*	_tableView;
	NSArray*	_msgs;
}
@property (nonatomic, retain) GetMsg*	msgGetter;
@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, assign) id owner;
@property (nonatomic, retain) UIImageView* arrow;
@property (nonatomic, assign) CGRect theFrame;
@property (nonatomic, retain) UIControl* arrowControl;
@property (nonatomic, retain) NSArray* msgs;

-(id) initWithFrame:(CGRect)frame AndStartColor:(float)startColor AndEndColor:(float)endColor AndOwner:(id)owner;

@end
