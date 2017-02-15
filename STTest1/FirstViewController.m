//
//  FirstViewController.m
//  STTest1
//
//  Created by 孙涛 on 2017/2/7.
//  Copyright © 2017年 孙涛. All rights reserved.
//

#import "FirstViewController.h"
#import "CSScreenRecorder.h"
#import "IDFileManager.h"

#include <mach/mach_time.h>
#import <objc/message.h>
#import <dlfcn.h>
@interface FirstViewController ()
{
    BOOL bRecording;
    CSScreenRecorder *_screenRecorder;
    MPVolumeView *volumeView;
    id routerController;
    NSString *airplayName;
    
    BOOL shouldConnect;
}
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UISwitch *lupingSwitch;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)luping:(UISwitch*)sender {
    if(bRecording)
    {
        //[self stopRecord];
    }
    else
    {
        [self startRecord];
    }
    
}
- (void)startRecord
{
    
    shouldConnect = FALSE;
    airplayName = @"XBMC-GAMEBOX(XinDawn)";
    
    _screenRecorder.videoOutPath = [self generateMP4Name];
    
    [_screenRecorder startRecordingScreen];
    bRecording = YES;
    _tipLabel.text =NSLocalizedString(@"STR_CANCEL",nil);

    //[self.mpView setHidden:NO];
}
- (NSString*)generateMP4Name
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd-HHmmss"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    NSString *fname = [NSString stringWithFormat:@"%@", currentTime];
    
    return [IDFileManager inDocumentsDirectory:fname];
    
}
@end
