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

@protocol GetTWUserDelegate
- (void):finished:(NSString*) twuserimageurl;
@end

@interface GetTWUser : NSObject {
	NSMutableData*	_tmpData;
	NSString* _urlStr;
	NSXMLParser* _theParser;
	NSString*	_elemString;
	id	_delegate;
	
	NSString* _twuserimageurl;
}
@property (nonatomic, retain) NSMutableData* tmpData;
@property (nonatomic, retain) NSString* urlStr;
@property (nonatomic, retain) NSXMLParser* theParser;
@property (nonatomic, retain) NSString* twuserimageurl;
@property (nonatomic, retain) NSString* elemString;
@property (nonatomic, assign) id delegate;
@end



@end
