//
//  PictureMeController.h
//  PictureMe
//
//  Created by Jeremy Collins on 3/30/09.
//  Copyright 2009 Jeremy Collins. All rights reserved.
//
#if TARGET_OS_EMBEDDED
#import <UIKit/UIKit.h>
#import "UIImageAdditions.h"
#import "Baby.h"
#import "LocalStorageManager.h"
#import "Constants.h"
#import "MediaManager.h"
#import <AVFoundation/AVFoundation.h>
#import "CaptureManager.h"
@interface PhotoTakingViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	CaptureManager *_captureManager;
    UIView *_videoPreviewView;
    AVCaptureVideoPreviewLayer *_captureVideoPreviewLayer;

	
    UIDeviceOrientation orientation;
    UIImagePickerController *_camera;
	UIImageView *_imageViewCloth;
    UIImageView *_imageView;
    UIImage *_image;
    CGRect face;
	NSMutableArray* _facesArr;
	NSMutableArray* _facesView;
	UIImageView *_cloth;
	UIImageView* _baby;
	UIImageView* _gameFrame;
	
	UIButton*	_redBut;
	UIButton*	_blueBut;
	UIButton*	_greenBut;
	UIView*	_PIP;
	BOOL	_locked;
    
    CvHaarClassifierCascade *model;
    
    BOOL detecting;
	id _delegate;
	int _faceType;
	
	UILabel* _label;
}

@property (nonatomic,retain) CaptureManager *captureManager;
@property (nonatomic,retain) UIView *videoPreviewView;
@property (nonatomic,retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;


@property (nonatomic, retain) UIImageView* imageViewCloth;
@property (nonatomic, retain) UIView* PIP;
@property (nonatomic, retain) UIImageView* gameFrame;
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain) UIImageView* imageView;
@property (nonatomic, retain) UIImagePickerController *camera;
@property (nonatomic, retain) UIImageView* baby;
@property (nonatomic, assign) CvHaarClassifierCascade *model;
@property (nonatomic, retain) NSMutableArray *facesArr;
@property (nonatomic, retain) NSMutableArray *facesView;
@property (nonatomic, retain) UIImageView* cloth;
@property (assign) BOOL detecting;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) int faceType;
@property (nonatomic, retain) UILabel* label;

@property(nonatomic, retain) UIButton* redBut;
@property(nonatomic, retain) UIButton* greenBut;
@property(nonatomic, retain) UIButton* blueBut;

- (void)savedImage:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;

- (void)takePicture;

- (void)retakePicture;

- (void)usePicture;

- (void)startDetection;

- (void)stopDetection;


@end
#endif