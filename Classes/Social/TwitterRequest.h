//
//  TwitterRequest.h
//
//
#import <objc/runtime.h>
#import "LocalStorageManager.h"
#import "TWStatus.h"

@protocol GetFeedDelegate
- (void):finishedGetFeedForModule:(NSNumber*) src WithResult:(NSArray*) statuss;
- (void):failedGetFeed:(NSString*) reason;
- (void) finishedStatusUpdate:(NSNumber*) src;
@end

@interface TwitterRequest : NSObject {
	NSMutableData		*_receivedData;
	NSMutableURLRequest	*_theRequest;
	NSURLConnection		*_theConnection;
	id					_delegate;
	
	BOOL				isPost;
	NSString			*requestBody;
	
	NSString*			_currentStringValue;
	NSMutableArray		*_twStatuss;
	TWStatus			*_currentStatus;
	NSString			*_elmString;
	NSXMLParser* _theParser;

}
@property (nonatomic, retain) NSMutableURLRequest *theRequest;
@property (nonatomic, retain) NSURLConnection *theConnection;
@property(nonatomic, retain) NSMutableData *receivedData;
@property(nonatomic, assign) id			    delegate;
@property (nonatomic, retain) TWStatus	*currentStatus;
@property (nonatomic, retain) NSMutableArray *twStatuss;
@property (nonatomic, retain) NSString	*elmString;
@property (nonatomic, retain) NSString	*currentStringValue;
@property (nonatomic, retain) NSXMLParser* theParser;


-(void)friends_timeline;
-(void)statuses_update:(NSString *)tweetString delegate:(id)requestDelegate requestSelector:(SEL)requestSelector;

@end
