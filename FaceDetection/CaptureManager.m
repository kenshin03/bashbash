//
//  CaptureManager.m
//  bishibashi
//
//  Created by Eric on 21/07/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//
#if TARGET_OS_EMBEDDED
#import "CaptureManager.h"


@implementation CaptureManager
@synthesize delegate = _delegate;
@synthesize deviceConnectedObserver = _deviceConnectedObserver;
@synthesize deviceDisconnectedObserver = _deviceDisconnectedObserver;
@synthesize stillImageOutput = _stillImageOutput;
//@synthesize videoDataOutput  = _videoDataOutput;
@synthesize videoInput = _videoInput;
@synthesize session = _session;
- (id) init
{
    self = [super init];
    if (self != nil) {
        void (^deviceConnectedBlock)(NSNotification *) = ^(NSNotification *notification) {
            AVCaptureSession *session = [self session];
            AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backFacingCamera] error:nil];
            
            [session beginConfiguration];
            [session removeInput:[self videoInput]];
            if ([session canAddInput:newVideoInput]) {
                [session addInput:newVideoInput];
            }
            [session commitConfiguration];
            
			self.videoInput = newVideoInput;
            [newVideoInput release];
            
            id delegate = [self delegate];
            if ([delegate respondsToSelector:@selector(deviceCountChanged)]) {
                [delegate deviceCountChanged];
            }
            
            if (![session isRunning])
                [session startRunning];
        };
        void (^deviceDisconnectedBlock)(NSNotification *) = ^(NSNotification *notification) {
            AVCaptureSession *session = [self session];
            
            [session beginConfiguration];
            
            if (![[self.videoInput device] isConnected])
                [session removeInput:self.videoInput];
            
            [session commitConfiguration];
            
            
            id delegate = [self delegate];
            if ([delegate respondsToSelector:@selector(deviceCountChanged)]) {
                [delegate deviceCountChanged];
            }
            
            if (![session isRunning])
                [session startRunning];
        };
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [self setDeviceConnectedObserver:[notificationCenter addObserverForName:AVCaptureDeviceWasConnectedNotification object:nil queue:nil usingBlock:deviceConnectedBlock]];
        [self setDeviceDisconnectedObserver:[notificationCenter addObserverForName:AVCaptureDeviceWasDisconnectedNotification object:nil queue:nil usingBlock:deviceDisconnectedBlock]];            
    }
    return self;
}

- (void) stopCapturing
{
 	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self.deviceConnectedObserver];
    [notificationCenter removeObserver:self.deviceDisconnectedObserver];
	self.deviceConnectedObserver = nil;
	self.deviceDisconnectedObserver = nil;
	[self.session stopRunning];
}

- (void) dealloc
{
	NSLog(@"dealloc Capture Manager");
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self.deviceConnectedObserver];
    [notificationCenter removeObserver:self.deviceDisconnectedObserver];
    [[self session] stopRunning];
    [self setSession:nil];
    [self setVideoInput:nil];
    [self setStillImageOutput:nil];
	self.deviceConnectedObserver = nil;
	self.deviceDisconnectedObserver = nil;
    [super dealloc];
}

- (AVCaptureDevice *) backFacingCamera
{
	NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionBack) {
            return device;
        }
    }
    return nil;
}

- (BOOL) setupSessionWithPreset:(NSString *)sessionPreset error:(NSError **)error
{
    BOOL success = NO;
    

    // Init the device inputs
    AVCaptureDeviceInput *videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backFacingCamera] error:error];
    self.videoInput=videoInput; // stash this for later use if we need to switch cameras
    
    
    // Setup the default file outputs
    AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
	/*
	AVCaptureVideoDataOutput* videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
	[videoDataOutput setAlwaysDiscardsLateVideoFrames:YES]; // Probably want to set this to NO when we're recording
	[videoDataOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]]; // Necessary for manual preview
	
	// we want our dispatch to be on the main thread so OpenGL can do things with the data
	[videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
	*/
	
	
	NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    AVVideoCodecJPEG, AVVideoCodecKey,
                                    nil];
    [stillImageOutput setOutputSettings:outputSettings];
    [outputSettings release];
    self.stillImageOutput=stillImageOutput;
	//self.videoDataOutput = videoDataOutput;
    
    
    // Setup and start the capture session
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
	[session beginConfiguration];

	
	if ([session canAddInput:videoInput]) {
        [session addInput:videoInput];
    }
	
    if ([session canAddOutput:stillImageOutput]) {
        [session addOutput:stillImageOutput];
    }
/*    
	if ([session canAddOutput:videoDataOutput]) {
        [session addOutput:videoDataOutput];
    }
*/	
    [session setSessionPreset:sessionPreset];
	[session commitConfiguration];

    [session startRunning];
    
    [self setSession:session];
    
    [session release];
	[videoInput release];
	[stillImageOutput release];
	//[videoDataOutput release];
    
    success = YES;
    
    return success;
}

- (NSUInteger) cameraCount
{
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
}

- (void) captureStillImage
{
    AVCaptureConnection *videoConnection = [CaptureManager connectionWithMediaType:AVMediaTypeVideo fromConnections:[[self stillImageOutput] connections]];
    if ([videoConnection isVideoOrientationSupported]) {
        [videoConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
    [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:videoConnection
                                                         completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                                                             if (imageDataSampleBuffer != NULL) {
                                                                 NSData* imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
																 if ([self.delegate respondsToSelector:@selector(imageCaptured:)])	{
																	 [self.delegate performSelectorInBackground:@selector(imageCaptured:) withObject:imageData];
																 }
													         } else if (error) {
                                                                 id delegate = [self delegate];
                                                                 if ([delegate respondsToSelector:@selector(captureStillImageFailedWithError:)]) {
                                                                     [delegate captureStillImageFailedWithError:error];
                                                                 }
                                                             }
                                                         }];
}


+ (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections;
{
	for ( AVCaptureConnection *connection in connections ) {
		for ( AVCaptureInputPort *port in [connection inputPorts] ) {
			if ( [[port mediaType] isEqual:mediaType] ) {
				return [[connection retain] autorelease];
			}
		}
	}
	return nil;
}

/*
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
	
	CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
	CVPixelBufferLockBaseAddress(imageBuffer, 0);
	uint32_t* buf = (uint32_t*)CVPixelBufferGetBaseAddress(imageBuffer);
	size_t plbprow = CVPixelBufferGetBytesPerRow(imageBuffer);          
	size_t plwidth = CVPixelBufferGetWidth(imageBuffer);
	size_t plheight = CVPixelBufferGetHeight(imageBuffer);
	size_t currSize = plbprow*plheight*sizeof(char); 
	
	//BGRA (same as input)
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	
	CGContextRef new_context=CGBitmapContextCreate(buf, plwidth, plheight, 8, plbprow, colorSpace, kCGImageAlphaPremultipliedFirst);
	CGImageRef newimage_ref=CGBitmapContextCreateImage(new_context);
	
	// Release it
	CGContextRelease(new_context);
	CGColorSpaceRelease(colorSpace);
	

	if ([self.delegate respondsToSelector:@selector(imageCapturedWithCGImage:)])	
		[self.delegate performSelectorInBackground:@selector(imageCapturedWithCGImage:) withObject:newimage_ref];
	
	CGImageRelease(newimage_ref);            

}
*/
@end
#endif