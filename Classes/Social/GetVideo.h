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

@protocol GetVideoDelegate
- (void):finished:(NSMutableArray*) videos;
@end

@interface VideoData: NSObject{
	NSString*	_title;
	NSString*	_submitter;
	NSString*	_submitdate;
	NSString*	_thumbnailUrl;
	NSString*	_url;
}	
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* submitter;
@property (nonatomic, retain) NSString* submitdate;
@property (nonatomic, retain) NSString* thumbnailUrl;
@property (nonatomic, retain) NSString* url;
@end



@interface GetVideo : NSObject {
	NSMutableData*	_tmpData;
	NSString* _urlStr;
	NSXMLParser* _theParser;
	NSMutableArray*	_videos;
	NSString*	_elemString;
	VideoData*	_currentVideo;
	id	_delegate;
}
@property (nonatomic, retain) NSMutableData* tmpData;
@property (nonatomic, retain) NSString* urlStr;
@property (nonatomic, retain) NSXMLParser* theParser;
@property (nonatomic, retain) NSMutableArray* videos;
@property (nonatomic, retain) NSString* elemString;
@property (nonatomic, retain) VideoData* currentVideo;
@property (nonatomic, assign) id delegate;
@end



@end
