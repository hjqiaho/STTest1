//
//  FirstViewController.m
//  STTest1
//
//  Created by 孙涛 on 2017/2/7.
//  Copyright © 2017年 孙涛. All rights reserved.
//

#import "FirstViewController.h"
#import <ReplayKit/ReplayKit.h>

@interface FirstViewController ()<RPBroadcastActivityViewControllerDelegate, RPBroadcastControllerDelegate>
{
}
@property (weak, nonatomic) IBOutlet UISwitch *lupingSwitch;
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (nonatomic, weak) RPBroadcastController *broadcastController;
@property (nonatomic, strong) NSURL *chatURL;
@property (nonatomic, weak)   UIView   *cameraPreview;
@property (nonatomic, strong) UIWebView* chatView;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//录屏开关
- (IBAction)luping:(UISwitch*)sender {
    __weak FirstViewController* bSelf = self;
    if (![RPScreenRecorder sharedRecorder].isRecording) {
        
        // We aren't currently broadcasting, bring up the share sheet.
        
        [RPBroadcastActivityViewController loadBroadcastActivityViewControllerWithHandler:^(RPBroadcastActivityViewController * _Nullable broadcastActivityViewController, NSError * _Nullable error) {
            
            
            // Here we are going to bring up the Broadcast share sheet where the user will be able to pick
            // a broadcast provider
            
            broadcastActivityViewController.delegate = bSelf;
            broadcastActivityViewController.modalPresentationStyle = UIModalPresentationPopover;
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                broadcastActivityViewController.popoverPresentationController.sourceRect = bSelf.lupingSwitch.frame;
                broadcastActivityViewController.popoverPresentationController.sourceView = bSelf.lupingSwitch;
            }
            
            
            [bSelf presentViewController:broadcastActivityViewController animated:YES completion:nil];
        }];
        
    } else {
        // We are currently broadcasting, disconnect.
        NSLog(@"Disconnecting");
        [self.broadcastController finishBroadcastWithHandler:^(NSError * _Nullable error) {
            bSelf.chatURL = nil;
            [bSelf tap:nil];
            [bSelf.lupingSwitch setOn:NO];

            [bSelf.cameraPreview removeFromSuperview];
            
        }];
    }
    
}

#pragma mark - Broadcasting
- (void)broadcastActivityViewController:(RPBroadcastActivityViewController *)broadcastActivityViewController
       didFinishWithBroadcastController:(RPBroadcastController *)broadcastController
                                  error:(NSError *)error
{
    
    NSLog(@"BAC: %@ didFinishWBC: %@, err: %@",
          broadcastActivityViewController,
          broadcastController,
          error);
    
    // User has selected a broadcast service, now we should start streaming.
    
    [broadcastActivityViewController dismissViewControllerAnimated:YES completion:nil];
    
    if([broadcastController.broadcastExtensionBundleID rangeOfString:@"com.mobcrush.Mobcrush"].location != NSNotFound)
    {
        // User has chosen Mobcrush. We can use the broadcast URL to generate the user's chat URL by
        // appending "/chat" to the end of it.
        self.chatURL = [NSURL URLWithString:[broadcastController.broadcastURL.absoluteString stringByAppendingString:@"/chat"]];
    }
    self.broadcastController = broadcastController;
    
    __weak FirstViewController* bSelf = self;
    if(!error)
    {
        [broadcastController startBroadcastWithHandler:^(NSError * _Nullable error) {
            
            NSLog(@"broadcastControllerHandler");
            if (!error) {
                
                // Broadcast has started
                bSelf.broadcastController.delegate = self;
                
                [bSelf.lupingSwitch setOn:YES];
                
                UIView* cameraView = [[RPScreenRecorder sharedRecorder] cameraPreviewView];
                bSelf.cameraPreview = cameraView;
                
                if(cameraView)
                {
                    // If the camera is enabled, create the camera preview and add it to the game's UIView
                    
                    cameraView.frame = CGRectMake(0, 0, 200, 200);
                    [bSelf.view addSubview:cameraView];
                    {
                        // Add a gesture recognizer so the user can drag the camera around the screen
                        UIPanGestureRecognizer* gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
                        [gr setMinimumNumberOfTouches:1];
                        [gr setMaximumNumberOfTouches:1];
                        [cameraView addGestureRecognizer:gr];
                    }
                    {
                        UITapGestureRecognizer* gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
                        [cameraView addGestureRecognizer:gr];
                    }
                }
                
            }
            else {
                // Some error has occurred starting the broadcast, surface it to the user.
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                         message:error.localizedDescription
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"Ok"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:nil]];
                
                [self presentViewController:alertController
                                   animated:YES
                                 completion:nil];
                
            }
        }];
    }
    else
    {
        NSLog(@"Error returning from Broadcast Activity: %@", error);
    }
    
}

// Watch for service info from broadcast service
- (void)broadcastController:(RPBroadcastController *)broadcastController
       didUpdateServiceInfo:(NSDictionary <NSString *, NSObject <NSCoding> *> *)serviceInfo
{
    NSLog(@"didUpdateServiceInfo: %@", serviceInfo);
}

// Broadcast service encountered an error
- (void)broadcastController:(RPBroadcastController *)broadcastController
         didFinishWithError:(NSError *)error
{
    NSLog(@"didFinishWithError: %@", error);
    
    __weak FirstViewController* bSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        bSelf.chatURL = nil;
        [bSelf tap:nil];
        [bSelf.lupingSwitch setOn:NO];
        [bSelf.cameraPreview removeFromSuperview];
    });
}

#pragma mark - Gesture Recognizers for Camera
- (void) pan: (UIPanGestureRecognizer*) sender
{
    // Move the Camera view around by dragging
    CGPoint translation = [sender translationInView:self.view];
    
    {
        CGRect recognizerFrame = sender.view.frame;
        recognizerFrame.origin.x += translation.x;
        recognizerFrame.origin.y += translation.y;
        
        sender.view.frame = recognizerFrame;
    }
    if(self.chatView)
    {
        CGRect recognizerFrame = self.chatView.frame;
        recognizerFrame.origin.x += translation.x;
        recognizerFrame.origin.y += translation.y;
        
        self.chatView.frame = recognizerFrame;
    }
    
    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (void) tap: (UITapGestureRecognizer*) sender
{
    // Load the chat view if we have a chat URL
    if(!self.chatView && self.chatURL)
    {
        self.chatView = [[UIWebView alloc] initWithFrame:CGRectMake(self.cameraPreview.frame.origin.x,
                                                                    CGRectGetMaxY(self.cameraPreview.frame),
                                                                    300,
                                                                    500)];
        
        NSURLRequest* request = [NSURLRequest requestWithURL:self.chatURL];
        [self.chatView loadRequest:request];
        [self.chatView setBackgroundColor:[UIColor clearColor]];
        [self.chatView setOpaque:NO];
        [self.view addSubview:self.chatView];
    }
    else if(self.chatView)
    {
        [self.chatView removeFromSuperview];
        self.chatView = nil;
    }
}

@end
