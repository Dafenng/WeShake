//
//  WTCaptureViewController.m
//  WeShake
//
//  Created by Dafeng Jin on 13-10-3.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTCaptureViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "AFNetworking.h"
#import "WTDataDef.h"
#import "WTUser.h"

@interface WTCaptureViewController ()

@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureDevice *device;
@property (strong, nonatomic) AVCaptureDeviceInput *input;
@property (strong, nonatomic) AVCaptureStillImageOutput *output;
@property (weak, nonatomic) IBOutlet UIButton *flashButton;
@property (weak, nonatomic) IBOutlet UIView *capturePreviewView;
@property (weak, nonatomic) IBOutlet UIView *sharingView;
@property (weak, nonatomic) IBOutlet UIImageView *sharingImage;

@end

@implementation WTCaptureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.sharingView.hidden = YES;
    [self setupCamera];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupCamera
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        // Has camera
        //Create an AVCaptureSession
        self.session = [[AVCaptureSession alloc] init];
        self.session.sessionPreset = AVCaptureSessionPresetPhoto;
        
        //Find a suitable AVCaptureDevice
        self.device = [AVCaptureDevice
                       defaultDeviceWithMediaType:AVMediaTypeVideo];
        //Create and add an AVCaptureDeviceInput
        NSError *error;
        self.input = [AVCaptureDeviceInput
                      deviceInputWithDevice:self.device error:&error];
        [self.session addInput:self.input];
        
        //Create and add an AVCaptureStillImageOutput
        self.output = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
        [self.output setOutputSettings:outputSettings];
        [self.session addOutput:self.output];
        
        AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        preview.frame = self.capturePreviewView.bounds;
        preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.capturePreviewView.layer addSublayer:preview];
        
    } else {
        // No camera
        NSLog(@"No camera");
    }
    
    [self switchToCamera];
}

- (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections
{
	for ( AVCaptureConnection *connection in connections ) {
		for ( AVCaptureInputPort *port in [connection inputPorts] ) {
			if ( [[port mediaType] isEqual:mediaType] ) {
				return connection;
			}
		}
	}
	return nil;
}

- (void)capture
{
    AVCaptureConnection *stillImageConnection = [self connectionWithMediaType:AVMediaTypeVideo fromConnections:[self.output connections]];
    if ([stillImageConnection isVideoOrientationSupported]) {
        [stillImageConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
    
    [self.output captureStillImageAsynchronouslyFromConnection:stillImageConnection
                                             completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                                                 if (imageDataSampleBuffer != NULL) {
                                                     NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                                                     ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                                                     
                                                     UIImage *image = [[UIImage alloc] initWithData:imageData];
                                                     self.sharingView.hidden = NO;
                                                     self.sharingImage.image = image;
                                                     
                                                     //暂时关闭保存
//                                                     [library writeImageToSavedPhotosAlbum:[image CGImage]
//                                                                               orientation:(ALAssetOrientation)[image imageOrientation]
//                                                                           completionBlock:nil];
                                                 }
                                                 
                                             }];
}

- (IBAction)captureImage:(id)sender {
    [self.device lockForConfiguration:nil];
    if (self.flashButton.selected && [self.device hasTorch]){
        [self.device setTorchMode:AVCaptureTorchModeOn];
        [self performSelector:@selector(capture)
                   withObject:nil
                   afterDelay:0.25];
    } else {
        [self capture];
    }
    
    [self.device unlockForConfiguration];
    [self.session stopRunning];
}

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)switchToLibrary:(id)sender {
    [self.session stopRunning];
    
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}

- (void)switchToCamera
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        //设置闪光灯
        if ([self.device hasFlash] && [self.device hasTorch]) {
            [self.flashButton setEnabled:YES];
        } else {
            [self.flashButton setEnabled:NO];
        }
        
        //Configure your output, and start the session
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.session startRunning];
        });
    }
}

- (IBAction)changeFlashMode:(id)sender {
    self.flashButton.selected = !self.flashButton.selected;
}

- (IBAction)retakeImage:(id)sender {
    self.sharingView.hidden = YES;
    [self switchToCamera];
}

- (IBAction)shareImage:(id)sender {
    [self postWithMessage:@"This shop is excellent" photo:self.sharingImage.image progress:^(CGFloat progress) {
        ;
    } completion:^(BOOL success, NSError *error) {
        ;
    }];
}

- (void)postWithMessage:(NSString *)message photo:(UIImage *)image progress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL success, NSError *error))completionBlock {
    
    NSURL *url = [NSURL URLWithString:BaseURL];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSString *endUrl = [NSString stringWithFormat:@"/api/v1/posts.json?"];
    NSDictionary *params = @{
                             @"post[message]" : message,
                             @"userId"      : [[WTUser sharedInstance] userId]
                             };
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:endUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"post[photo]" fileName:@"photo.jpg" mimeType:@"image/jpg"];
    }];
    
    
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        //        CGFloat progress = ((CGFloat)totalBytesWritten) / totalBytesExpectedToWrite;
        //        progressBlock(progress);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200 || operation.response.statusCode == 201) {
            NSLog(@"Created, %@", responseObject);
//            NSDictionary *dict = (NSDictionary *)responseObject;
            
            //            [self updateFromJSON:updatedLatte];
            //            [self notifyCreated];
            //            completionBlock(YES, nil);
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            //            completionBlock(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        completionBlock(NO, error);
    }];
    
    [operation start];
    //    [[BLAPIClient sharedClient] enqueueHTTPRequestOperation:operation];
}

- (void)dealloc
{
    [self.session stopRunning];
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage* outputImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.sharingView.hidden = NO;
    self.sharingImage.image = outputImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [self dismissViewControllerAnimated:YES completion:nil];
    [self switchToCamera];
}

@end
