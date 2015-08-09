//
//  GetGameRecord.h
//  bishibashi
//
//  Created by Eric on 08/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import <objc/runtime.h>
#import "GameRecord.h"

@protocol GetGameRecordDelegate
- (void):finished:(NSDictionary*) dict;
@end

@interface GetGameRecord : NSObject {
	NSMutableData*	_tmpData;
	NSString* _urlStr;
	NSXMLParser* _theParser;
	NSMutableDictionary*	_gameRecords;
	NSString*	_elemString;
	GameRecord*	_currentGameRecord;
	id	_delegate;
}
@property (nonatomic, retain) NSMutableData* tmpData;
@property (nonatomic, retain) NSString* urlStr;
@property (nonatomic, retain) NSXMLParser* theParser;
@property (nonatomic, retain) NSMutableDictionary* gameRecords;
@property (nonatomic, retain) NSString* elemString;
@property (nonatomic, retain) GameRecord* currentGameRecord;
@property (nonatomic, assign) id delegate;
@end
