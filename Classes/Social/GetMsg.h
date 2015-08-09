//
//  GetFBMsg.h
//  bishibashi
//
//  Created by Eric on 05/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "Msg.h"

@protocol GetMsgDelegate
- (void):finished:(NSMutableArray*) msgs;
@end

@interface GetMsg : NSObject {
	NSMutableData*	_tmpData;
	NSString* _urlStr;
	NSXMLParser* _theParser;
	NSMutableArray*	_msgs;
	NSString*	_elemString;
	Msg*	_currentMsg;
	id	_delegate;
}
@property (nonatomic, retain) NSMutableData* tmpData;
@property (nonatomic, retain) NSString* urlStr;
@property (nonatomic, retain) NSXMLParser* theParser;
@property (nonatomic, retain) NSMutableArray* msgs;
@property (nonatomic, retain) NSString* elemString;
@property (nonatomic, retain) Msg* currentMsg;
@property (nonatomic, assign) id delegate;
@end



@end
