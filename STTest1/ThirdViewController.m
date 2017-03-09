//
//  ThirdViewController.m
//  STTest1
//
//  Created by 孙涛 on 2017/2/9.
//  Copyright © 2017年 孙涛. All rights reserved.
//

#import "ThirdViewController.h"
#import <IOMobileFrameBuffer.h>
#import <CoreVideo/CVPixelBuffer.h>
#import <QuartzCore/QuartzCore.h>

#import <IOSurface/IOSurface.h>
#include <sys/time.h>
#import <IOKit/IOKitLib.h>


@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    


}
//UIImage* snapshot() {  // 这个是抓屏的主函数，通过调用此函数，就可以获取全局屏幕的一帧图像
//    io_service_t framebufferService = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("AppleH1CLCD"));
//    if(!framebufferService)
//    {
//        framebufferService = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("AppleM2CLCD"));
//    }
//    if(!framebufferService)
//    {
//        framebufferService = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("AppleCLCD"));
//    }
//    
//    kern_return_t result;
//    IOMobileFramebufferConnection connect;
//    CoreSurfaceBufferRef screenSurface = NULL;
//    
//    result = IOMobileFramebufferOpen(framebufferService, mach_task_self(), 0, &connect);
//    result = IOMobileFramebufferGetLayerDefaultSurface(connect, 0, &screenSurface);
//    
//    uint32_t aseed;
//    IOSurfaceLock((IOSurfaceRef)screenSurface, kIOSurfaceLockReadOnly, &aseed);
//    size_t width = IOSurfaceGetWidth((IOSurfaceRef)screenSurface);
//    size_t height = IOSurfaceGetHeight((IOSurfaceRef)screenSurface);
//    int bytes = 4;
//    size_t pitch = width * bytes, size = width * height * bytes;
//    
//    char pixelFormat[4] = {'A','R','G','B'};
//    
//    CFMutableDictionaryRef dict = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
//    CFDictionarySetValue(dict, kIOSurfaceIsGlobal,        kCFBooleanTrue);
//    CFDictionarySetValue(dict, kIOSurfaceBytesPerRow,     CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &pitch));
//    CFDictionarySetValue(dict, kIOSurfaceBytesPerElement, CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &bytes));
//    CFDictionarySetValue(dict, kIOSurfaceWidth,           CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &width));
//    CFDictionarySetValue(dict, kIOSurfaceHeight,          CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &height));
//    CFDictionarySetValue(dict, kIOSurfacePixelFormat,     CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, pixelFormat));
//    CFDictionarySetValue(dict, kIOSurfaceAllocSize,       CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &size));
//    
//    IOSurfaceAcceleratorRef outAcc;
//    IOSurfaceRef destSurf = IOSurfaceCreate(dict);
//    IOSurfaceAcceleratorCreate(NULL, 0, &outAcc);
//    IOSurfaceAcceleratorTransferSurface(outAcc, screenSurface, destSurf, dict, NULL);
//    IOSurfaceUnlock((IOSurfaceRef)screenSurface, kIOSurfaceLockReadOnly, &aseed);
//    CFRelease(outAcc);
//    
//    CGDataProviderRef provider =  CGDataProviderCreateWithData(NULL,  IOSurfaceGetBaseAddress(destSurf), size, NULL);
//    CGImageRef cgImage = CGImageCreate(width, height, 8, 8 * bytes, IOSurfaceGetBytesPerRow(destSurf), CGColorSpaceCreateDeviceRGB(),
//                                       kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little, provider, NULL, YES, kCGRenderingIntentDefault);
//    UIImage *image = [UIImage imageWithCGImage:cgImage];
//    
//    CGImageRelease(cgImage);
//    CFDictionaryRemoveAllValues(dict);
//    CGDataProviderRelease(provider);
//    return image;
//}

//UIImage* rotation(UIImage *image, UIImageOrientation orientation) {  // 因为抓取出来的图像是横着的，对于移动设备来说，需要旋转一下，所以添加了这个函数（来自互联网）
//    long double rotate = 0.0;
//    CGRect rect;
//    
//    float translateX = 0, translateY = 0, scaleX = 1.0, scaleY = 1.0;
//    
//    switch (orientation)
//    {
//        case UIImageOrientationLeft:
//            rotate     = M_PI_2;
//            rect       = CGRectMake(0, 0, image.size.height, image.size.width);
//            translateX = 0;
//            translateY = -rect.size.width;
//            scaleY     = rect.size.width / rect.size.height;
//            scaleX     = rect.size.height / rect.size.width;
//            break;
//            
//        case UIImageOrientationRight:
//            rotate     = 3 * M_PI_2;
//            rect       = CGRectMake(0, 0, image.size.height, image.size.width);
//            translateX = -rect.size.height;
//            translateY = 0;
//            scaleY     = rect.size.width / rect.size.height;
//            scaleX     = rect.size.height / rect.size.width;
//            break;
//            
//        case UIImageOrientationDown:
//            rotate     = M_PI;
//            rect       = CGRectMake(0, 0, image.size.width, image.size.height);
//            translateX = -rect.size.width;
//            translateY = -rect.size.height;
//            break;
//            
//        default:
//            rotate     = 0.0;
//            rect       = CGRectMake(0, 0, image.size.width, image.size.height);
//            translateX = 0;
//            translateY = 0;
//            break;
//    }
//    
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    // ctm transform
//    CGContextTranslateCTM(context, 0.0, rect.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
//    CGContextRotateCTM(context, rotate);
//    CGContextTranslateCTM(context, translateX, translateY);
//    
//    CGContextScaleCTM(context, scaleX, scaleY);
//    
//    // draw image
//    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
//    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return newImg;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
