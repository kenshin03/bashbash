//
//  PictureMeController.m
//  PictureMe
//
//  Created by Jeremy Collins on 3/30/09.
//  Copyright 2009 Jeremy Collins. All rights reserved.
//

#if TARGET_OS_EMBEDDED
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioServices.h>
#import "UIImageAdditions.h"
//#import "UIDevice-Hardware.h"
#import "PhotoTakingViewController.h"


static CvMemStorage *storage = 0;


@implementation PhotoTakingViewController

@synthesize captureManager = _captureManager;
@synthesize videoPreviewView  = _videoPreviewView;
@synthesize captureVideoPreviewLayer = _captureVideoPreviewLayer;

@synthesize camera = _camera;
@synthesize model;
@synthesize detecting;
@synthesize facesArr = _facesArr;
@synthesize facesView = _facesView;
@synthesize cloth = _cloth;
@synthesize baby = _baby;
@synthesize delegate = _delegate;
@synthesize faceType = _faceType;
@synthesize imageView = _imageView;
@synthesize imageViewCloth = _imageViewCloth;
@synthesize label = _label;
@synthesize image = _image;
@synthesize gameFrame = _gameFrame;
@synthesize blueBut = _blueBut;
@synthesize greenBut = _greenBut;
@synthesize redBut = _redBut;
@synthesize PIP = _PIP;
static const CGRect redButRectP = {{20, 400}, {80, 80}};
static const CGRect greenButRectP = {{120, 400}, {80, 80}};
static const CGRect blueButRectP = {{220, 400}, {80, 80}};

- (void)dealloc {
	NSLog(@"dealloc PhotoTakingViewController");
	self.videoPreviewView = nil;
	self.captureVideoPreviewLayer = nil;
	self.captureManager = nil;
	self.imageViewCloth = nil;
	self.PIP = nil;
	self.imageView = nil;
	self.baby = nil;
	self.gameFrame = nil;
    self.camera = nil;
    self.facesArr = nil;
	self.facesView = nil;
	self.cloth = nil;
	self.label= nil;
	self.image = nil;
    [super dealloc];
}

- (void)viewDidLoad {
	//[super viewDidLoad];
	[self.navigationController setNavigationBarHidden:YES];
	
	NSError *error;
    
	CaptureManager *captureManager = [[CaptureManager alloc] init];
    if ([captureManager setupSessionWithPreset:AVCaptureSessionPresetMedium error:&error]) {
        self.captureManager=captureManager;
        
        AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:[captureManager session]];
		
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,480)];
		self.videoPreviewView = view;
		[view release];
		[self.view addSubview:self.videoPreviewView];
        [self.videoPreviewView.layer setMasksToBounds:YES];
        
        
        captureVideoPreviewLayer.frame = self.videoPreviewView.bounds;
        
        if ([captureVideoPreviewLayer isOrientationSupported]) {
            [captureVideoPreviewLayer setOrientation:AVCaptureVideoOrientationPortrait];
        }
        
        [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        
        self.captureVideoPreviewLayer=captureVideoPreviewLayer;
		[captureManager setDelegate:self];
		[self.videoPreviewView.layer addSublayer:captureVideoPreviewLayer];
		
		[captureVideoPreviewLayer release];
		
	}	
	[captureManager release];


	
	NSString* gameFrame = [LocalStorageManager objectForKey:GAMEFRAME];
	if (gameFrame)	{
		UIImageView* theView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"frame_%@2.png",gameFrame]]];
		self.gameFrame = theView;
		[self.view addSubview:self.gameFrame];
		[theView release];
	}
	
	UIImageView* cloth = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frog.png"]];
	self.cloth = cloth;
	[cloth release];
	[self.view addSubview:self.cloth];
	[self.cloth setHidden:YES];
	self.facesArr = [NSMutableArray arrayWithCapacity:2];
	/*
    UIImagePickerController* camera = [[UIImagePickerController alloc] init];
	self.camera = camera;
	[camera release];
    self.camera.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.camera.delegate = self;
    self.camera.showsCameraControls = NO;
    self.camera.cameraOverlayView = self.view;
    */
	
	
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];  
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange:)
                                                 name:@"UIDeviceOrientationDidChangeNotification"
                                               object:nil];    
}

-(void) initButtons
{
	UIImageView* baby;
	switch (self.faceType)	{
		case (1):
			baby = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"closemonthbaby.png"]];
			break;
		case (2):
			baby = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baby.png"]];
			break;
		case (3):
			baby = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cryingbaby.png"]];
			break;
	}
	baby.frame = greenButRectP;
	[self.view addSubview:baby];
	self.baby = baby;
	[baby release];
	UIButton* tmpBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[tmpBut setBackgroundImage:[UIImage imageNamed:@"bluebutton.png"] forState:UIControlStateNormal];
	[tmpBut setTitle:NSLocalizedString(@"返回",nil) forState:UIControlStateNormal];
	[tmpBut setFrame:blueButRectP];
	self.blueBut = tmpBut;
	tmpBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[tmpBut setBackgroundImage:[UIImage imageNamed:@"frog.png"] forState:UIControlStateNormal];
	[tmpBut setFrame:greenButRectP];
	self.greenBut = tmpBut;
	tmpBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[tmpBut setBackgroundImage:[UIImage imageNamed:@"redbutton.png"] forState:UIControlStateNormal];
	[tmpBut setTitle:NSLocalizedString(@"使用",nil) forState:UIControlStateNormal];
	[tmpBut setFrame:redButRectP];
	self.redBut = tmpBut;
	[self.blueBut addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchDown];
	[self.greenBut addTarget:self action:@selector(toggleLock) forControlEvents:UIControlEventTouchDown];
	[self.redBut addTarget:self action:@selector(usePicture) forControlEvents:UIControlEventTouchDown];
	[self.view addSubview:self.blueBut];
	[self.view addSubview:self.redBut];
	[self.view addSubview:self.greenBut];	
}

-(void) initPIP	{
	UIView* PIP = [[UIView alloc] initWithFrame:CGRectMake(200,20,100,100)];
	PIP.backgroundColor = [UIColor lightGrayColor];
	PIP.alpha = 0.5;
	[self.view addSubview:PIP];
	self.PIP = PIP;
	[PIP release];
	_locked = NO;
	
	UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(200,20,100,100)];
	self.imageView = imageView;
	[imageView setHidden:YES];
	[imageView release];	
	[self.view addSubview:self.imageView];
	
	UIImageView* tmp = [[UIImageView alloc] initWithFrame:CGRectMake(200,20,100,100)];
	tmp.image = [UIImage imageNamed:@"frog.png"];
	[self.view addSubview:tmp];
	self.imageViewCloth = tmp;
	[tmp release];	
}



- (void)viewDidAppear:(BOOL)animated {
	self.view.frame = CGRectMake(0,0,320,480);
//    [self presentModalViewController:self.camera animated:NO]; 
    [self startDetection];
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(15,15,155,40)];
	self.label = label;
	[label release];
	self.label.textColor = [UIColor greenColor];
	self.label.font = [UIFont systemFontOfSize:16];
	self.label.numberOfLines = 2;
	self.label.textAlignment = UITextAlignmentCenter;
	self.label.text = @"Initiating Face Detection Engine";
	self.label.backgroundColor = [UIColor clearColor];
	[self.view addSubview:self.label];
	[self initButtons];
	[self initPIP];
	
}





- (void)usePicture {	
	[self.delegate finishedSnapWithFaceType:self.faceType AndImage:self.imageView];
	[self stopDetection];
//	[self dismissModalViewControllerAnimated:NO];
	[self.navigationController setNavigationBarHidden:NO];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) cancel {
	[self stopDetection];
//	[self dismissModalViewControllerAnimated:NO];
	[self.navigationController setNavigationBarHidden:NO];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) toggleLock	{
	if (_locked)	{
		self.PIP.backgroundColor = [UIColor lightGrayColor];
		_locked = NO;
	}
	else {
		self.PIP.backgroundColor = [UIColor redColor];
		_locked = YES;
	}
}

#pragma mark Face Detection methods


- (void)deviceOrientationDidChange:(id)ignore {
    UIDevice *device = [UIDevice currentDevice];
    orientation = device.orientation;
}

-(void) show:(UIView*)obj	{
	[obj setHidden:NO];
}	

-(void) hide:(UIView*)obj	{
	[obj setHidden:YES];
}	


- (void)detectFaceThread {
	[self.captureManager performSelectorOnMainThread:@selector(captureStillImage) withObject:nil waitUntilDone:NO];

}

- (void) imageCaptured:(NSData*) imageData
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [self retain];

	UIImage *originalImage2 = [[UIImage alloc] initWithData:imageData]; 
	NSLog(@"size of image is %f %f", originalImage2.size.width, originalImage2.size.height);
	UIImage* originalImage = [originalImage2 scaleImage:CGRectMake(0,0,320,480)];
	UIImage *viewImage = [originalImage imageCroppedToRect:CGRectMake(0,20,320,480-20-80)];
	

    self.detecting = YES;
	[self.label performSelectorOnMainThread:@selector(setText:) withObject: @"Detecting Face, Hold Still" waitUntilDone:NO];

    if(self.model == nil) {
        NSString *file = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_alt2.xml" ofType:@"gz"];
        self.model = (CvHaarClassifierCascade *) cvLoad([file cStringUsingEncoding:NSASCIIStringEncoding], 0, 0, 0);
    }
    
    UIDevice *device = [UIDevice currentDevice];

    CGRect scaled;
    scaled.size = viewImage.size;
	scaled.size.width *= .5;
	scaled.size.height *= .5;
    

    viewImage = [viewImage scaleImage:scaled];


    // Convert to grayscale and equalize.  Helps face detection.
    IplImage *snapshot = [viewImage cvGrayscaleImage];
    IplImage *snapshotRotated = cvCloneImage(snapshot);
    cvEqualizeHist(snapshot, snapshot);
    
    // Rotate image if necessary.  In case phone is being held in 
    // landscape orientation.
    float angle = 0;
    if(orientation == UIDeviceOrientationLandscapeLeft) {
        angle = 90;
    } else if(orientation == UIDeviceOrientationLandscapeRight) {
        angle = -90;
    } 
    
    if(angle != 0) {
        CvPoint2D32f center;
        CvMat *translate = cvCreateMat(2, 3, CV_32FC1);
        cvSetZero(translate);
        center.x = viewImage.size.width / 2;
        center.y = viewImage.size.height / 2;
        cv2DRotationMatrix(center, angle, 1.0, translate);
        cvWarpAffine(snapshot, snapshotRotated, translate, CV_INTER_LINEAR + CV_WARP_FILL_OUTLIERS, cvScalarAll(0));
        cvReleaseMat(&translate);   
    }

    storage = cvCreateMemStorage(0);
    
    double t = (double)cvGetTickCount();
    CvSeq* faces = cvHaarDetectObjects(snapshotRotated, self.model, storage,
                                       1.1, 2, CV_HAAR_DO_CANNY_PRUNING,
                                       cvSize(30, 30));
    t = (double)cvGetTickCount() - t;
    
    NSLog(@"Face detection time %gms FOUND(%d)", t/((double)cvGetTickFrequency()*1000), faces->total);

		self.facesArr = [NSMutableArray arrayWithCapacity:2];
		if(faces->total > 0) {
			[self.label performSelectorOnMainThread:@selector(setText:) withObject: @"Face Detected" waitUntilDone:NO];
			[[MediaManager sharedInstance] playOctopusDoodSound];
			AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
			NSLog(@"total is %d", faces->total);
			
			for (int i=0; i<faces->total; i++)	{
				CvRect *r = (CvRect *) cvGetSeqElem(faces, i);
				
				face.origin.x = (float) r->x;
				face.origin.y = (float) r->y;
				face.size.width = (float) r->width;
				face.size.height = (float) r->height;
				float xratio = 320.0 / snapshotRotated->width;
				float yratio = (480.0-20.0-80.0) / snapshotRotated->height;
				face.origin.x = (float) r->x * xratio;
				face.origin.y = (float) r->y* yratio;
				face.size.width = (float) r->width* xratio;
				face.size.height = (float) r->height* yratio;
				face.origin.y += 20.0;
				if (!_locked)	{
					self.image = [originalImage imageCroppedToRect:face];
					self.imageView.image = [self.image scaleImage:CGRectMake(0,0,70,70) ToRect:CGRectMake(0,0,120,120) AtPoint:CGPointMake(22,17)];
			//		[self.PIP setHidden:NO];
					[self.imageView setHidden:NO];
			//		[self.imageViewCloth setHidden:NO];
				}
				

				[self.facesArr addObject:[NSValue valueWithCGRect:face]];
				
			}
			if (self.facesView)
				for (UIView* theView in self.facesView)
					[theView removeFromSuperview];
			self.facesView = [NSMutableArray arrayWithCapacity:2];
			for (NSValue* theFace in self.facesArr)	{
				CGRect theface = [theFace CGRectValue];
				if(theface.size.width > 0 && theface.size.height > 0) {
					self.cloth.frame = CGRectMake(theface.origin.x-0.26*theface.size.width,theface.origin.y-0.185*theface.size.height, theface.size.width*1.6,theface.size.height*1.65); 
					if (self.detecting)	{
						[self.view addSubview:self.cloth];
						[self.cloth setHidden:NO];
					}
				}
			}
		
		} else {
			[self.cloth setHidden:YES];
		}
    
    
    cvReleaseImage(&snapshot);
    cvReleaseImage(&snapshotRotated);
    cvReleaseMemStorage(&storage);
	[originalImage2 release];
    
    [pool release];
   
	if(self.detecting) {
		[self detectFaceThread];
	}
	[self release];
}

- (void) imageCapturedWithCGImage:(CGImageRef) imageData
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [self retain];
	
	UIImage *originalImage2 = [[UIImage alloc] initWithCGImage:imageData]; 
	NSLog(@"size of image is %f %f", originalImage2.size.width, originalImage2.size.height);
	UIImage* originalImage = [originalImage2 scaleImage:CGRectMake(0,0,320,480)];
	UIImage *viewImage = [originalImage imageCroppedToRect:CGRectMake(0,20,320,480-20-80)];
	
	
    self.detecting = YES;
	[self.label performSelectorOnMainThread:@selector(setText:) withObject: @"Detecting Face, Hold Still" waitUntilDone:NO];
	
    if(self.model == nil) {
        NSString *file = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_alt2.xml" ofType:@"gz"];
        self.model = (CvHaarClassifierCascade *) cvLoad([file cStringUsingEncoding:NSASCIIStringEncoding], 0, 0, 0);
    }
    
    UIDevice *device = [UIDevice currentDevice];
	
    CGRect scaled;
    scaled.size = viewImage.size;
	scaled.size.width *= .5;
	scaled.size.height *= .5;
    
	
    viewImage = [viewImage scaleImage:scaled];
	
	
    // Convert to grayscale and equalize.  Helps face detection.
    IplImage *snapshot = [viewImage cvGrayscaleImage];
    IplImage *snapshotRotated = cvCloneImage(snapshot);
    cvEqualizeHist(snapshot, snapshot);
    
    // Rotate image if necessary.  In case phone is being held in 
    // landscape orientation.
    float angle = 0;
    if(orientation == UIDeviceOrientationLandscapeLeft) {
        angle = 90;
    } else if(orientation == UIDeviceOrientationLandscapeRight) {
        angle = -90;
    } 
    
    if(angle != 0) {
        CvPoint2D32f center;
        CvMat *translate = cvCreateMat(2, 3, CV_32FC1);
        cvSetZero(translate);
        center.x = viewImage.size.width / 2;
        center.y = viewImage.size.height / 2;
        cv2DRotationMatrix(center, angle, 1.0, translate);
        cvWarpAffine(snapshot, snapshotRotated, translate, CV_INTER_LINEAR + CV_WARP_FILL_OUTLIERS, cvScalarAll(0));
        cvReleaseMat(&translate);   
    }
	
    storage = cvCreateMemStorage(0);
    
    double t = (double)cvGetTickCount();
    CvSeq* faces = cvHaarDetectObjects(snapshotRotated, self.model, storage,
                                       1.1, 2, CV_HAAR_DO_CANNY_PRUNING,
                                       cvSize(30, 30));
    t = (double)cvGetTickCount() - t;
    
    NSLog(@"Face detection time %gms FOUND(%d)", t/((double)cvGetTickFrequency()*1000), faces->total);
	
	self.facesArr = [NSMutableArray arrayWithCapacity:2];
	if(faces->total > 0) {
		[self.label performSelectorOnMainThread:@selector(setText:) withObject: @"Face Detected" waitUntilDone:NO];
		[[MediaManager sharedInstance] playOctopusDoodSound];
		AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
		NSLog(@"total is %d", faces->total);
		
		for (int i=0; i<faces->total; i++)	{
			CvRect *r = (CvRect *) cvGetSeqElem(faces, i);
			
			face.origin.x = (float) r->x;
			face.origin.y = (float) r->y;
			face.size.width = (float) r->width;
			face.size.height = (float) r->height;
			float xratio = 320.0 / snapshotRotated->width;
			float yratio = (480.0-20.0-80.0) / snapshotRotated->height;
			face.origin.x = (float) r->x * xratio;
			face.origin.y = (float) r->y* yratio;
			face.size.width = (float) r->width* xratio;
			face.size.height = (float) r->height* yratio;
			face.origin.y += 20.0;
			if (!_locked)	{
				self.image = [originalImage imageCroppedToRect:face];
				self.imageView.image = [self.image scaleImage:CGRectMake(0,0,70,70) ToRect:CGRectMake(0,0,120,120) AtPoint:CGPointMake(22,17)];
				//		[self.PIP setHidden:NO];
				[self.imageView setHidden:NO];
				//		[self.imageViewCloth setHidden:NO];
			}
			
			
			[self.facesArr addObject:[NSValue valueWithCGRect:face]];
			
		}
		if (self.facesView)
			for (UIView* theView in self.facesView)
				[theView removeFromSuperview];
		self.facesView = [NSMutableArray arrayWithCapacity:2];
		for (NSValue* theFace in self.facesArr)	{
			CGRect theface = [theFace CGRectValue];
			if(theface.size.width > 0 && theface.size.height > 0) {
				self.cloth.frame = CGRectMake(theface.origin.x-0.26*theface.size.width,theface.origin.y-0.185*theface.size.height, theface.size.width*1.6,theface.size.height*1.65); 
				if (self.detecting)	{
					[self.view addSubview:self.cloth];
					[self.cloth setHidden:NO];
				}
			}
		}
		
	} else {
		[self.cloth setHidden:YES];
	}
    
    
    cvReleaseImage(&snapshot);
    cvReleaseImage(&snapshotRotated);
    cvReleaseMemStorage(&storage);
	[originalImage2 release];
    
    [pool release];
	
	if(self.detecting) {
		[self detectFaceThread];
	}
	[self release];
}

- (void)startDetection {
    [self detectFaceThread];
}


- (void)stopDetection {
	[self.captureManager stopCapturing];

    self.detecting = NO;
}


#pragma mark UINavigationControllerDelegate Methods


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}


@end
#endif