//
//  AVCamDemoCaptureManager.h
//  bishibashi
//
//  Created by Eric on 21/07/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//
#if TARGET_OS_EMBEDDED
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#include <CoreVideo/CVPixelBuffer.h>


@protocol CaptureManagerDelegate
@optional
- (void) captureStillImageFailedWithError:(NSError *)error;
- (void) acquiringDeviceLockFailedWithError:(NSError *)error;
- (void) cannotWriteToAssetLibrary;
- (void) assetLibraryError:(NSError *)error forURL:(NSURL *)assetURL;
- (void) someOtherError:(NSError *)error;
- (void) recordingBegan;
- (void) recordingFinished;
- (void) deviceCountChanged;
@end

@interface CaptureManager : NSObject {
@private
    AVCaptureSession *_session;
    AVCaptureDeviceInput *_videoInput;
    id <CaptureManagerDelegate> _delegate;
    
    AVCaptureStillImageOutput *_stillImageOutput;
//	AVCaptureVideoDataOutput *_videoDataOutput;
    id _deviceConnectedObserver;
    id _deviceDisconnectedObserver;
}

@property (nonatomic,retain) AVCaptureSession *session;
@property (nonatomic,retain) AVCaptureDeviceInput *videoInput;
@property (nonatomic,assign) id <CaptureManagerDelegate> delegate;
@property (nonatomic,retain) AVCaptureStillImageOutput *stillImageOutput;
//@property (nonatomic,retain) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic,retain) id deviceConnectedObserver;
@property (nonatomic,retain) id deviceDisconnectedObserver;

- (BOOL) setupSessionWithPreset:(NSString *)sessionPreset error:(NSError **)error;
- (NSData*) captureStillImage;
+ (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections;

@end
#endif
