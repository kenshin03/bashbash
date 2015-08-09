//
//  Pin.h
//  bishibashi
//
//  Created by Eric on 31/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

#define OTHERPINBOUNDARY  1000

typedef enum PinTypes {
	
	kPinTypeeatbeans = keatbeans,
	kPinType3in1 = k3in1,
	kPinTypeburgerset = kburgerset,
	kPinTypeufo = kufo,
	kPinTypealarmclock = kalarmclock,
	kPinTypejumpinggirl  = kjumpinggirl,
	kPinTypeburgerseq = kburgerseq,
	kPinType3bo = k3bo,
	kPinTypesmallnumber = ksmallnumber,
	kPinTypebignumber = kbignumber,
	kPinTypedancing = kdancing,
	kPinTypebunhill = kbunhill,
//	kPinTypeheartnhand = kheartnhand,
	kPinTypepencil  = kpencil,
	
	kPinTypeSpeed = OTHERPINBOUNDARY,
	kPinTypeReaction,
	kPinTypeBrain,
	kPinTypeCommander,
	kPinTypeBit,
	kPinTypeOverall,
} PinType;


@interface Pin : NSObject<NSCoding> {
	NSDate*	_time;
	Game	_game;
	PinLevel	_pinLevel;
}

@property (nonatomic, retain) NSDate* time;
@property (nonatomic, assign) Game game;
@property (nonatomic, assign) PinLevel pinLevel;

@end
