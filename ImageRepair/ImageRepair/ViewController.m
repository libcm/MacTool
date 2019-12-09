//
//  ViewController.m
//  Image
//
//  Created by liyb on 2019/5/7.
//  Copyright © 2019 qzc. All rights reserved.
//

#import "ViewController.h"
#import "DestinationView.h"
#import "NSImage+Extension.h"

@interface ViewController ()<DestinationViewDelegate>
@property (weak) IBOutlet NSComboBox *comboBox;
@property (weak) IBOutlet DestinationView *customView;
@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet NSTextField *sizeLabel;
@property (nonatomic, strong) NSImage *oldImage;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customView.delegate = self;
    self.customView.layer.backgroundColor = [NSColor clearColor].CGColor;
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

- (IBAction)clipAction:(id)sender {
    CGFloat radius = [self.comboBox.stringValue doubleValue];
    self.imageView.image = [self.imageView.image roundCornersImageCornerRadius:radius];
}

- (IBAction)saveAction:(id)sender {
    NSImage *image = self.imageView.image;
    NSSavePanel *panel = [NSSavePanel savePanel];
    panel.title = @"保存圆角图片文件";
    panel.message = @"设置保存路径";
    panel.allowsOtherFileTypes = YES;
    panel.allowedFileTypes = @[@"png"];
    panel.extensionHidden = NO;
    panel.canCreateDirectories = YES;
    [panel beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK) {
            [image lockFocus];
            //先设置 下面一个实例
            NSBitmapImageRep *bits = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0, 0, image.size.width, image.size.height)];
            [image unlockFocus];
            //再设置后面要用到得 props属性
            NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:0] forKey:NSImageCompressionFactor];
            
            //之后 转化为NSData 以便存到文件中
            NSData *imageData = [bits representationUsingType:NSPNGFileType properties:imageProps];
            
            //设定好文件路径后进行存储就ok了
            BOOL y = [imageData writeToFile:[[NSString stringWithString:panel.URL.path] stringByExpandingTildeInPath]atomically:YES];    //保存的文件路径一定要是绝对路径，相对路径不行
            NSLog(@"Save Image: %d", y);
        }
    }];
}

- (void)dragDropViewFileList:(NSArray *)fileList {
    NSString *path = fileList.firstObject;
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:path];
    self.oldImage = image;
    self.imageView.image = image;
    // 获取图片文件大小
    CGFloat fileSize = [self getImageFileSizeWithPath:path] / 1024.0;
    // 获取图片尺寸大小
    CGSize size = [self getImageSizeWithPath:path];
    NSString *text = [NSString stringWithFormat:@"文件大小:%.2fkb   尺寸大小:(%zd,%zd)", fileSize, (NSInteger)size.width, (NSInteger)size.height];
    self.sizeLabel.stringValue = text;
}

- (IBAction)compareAction:(id)sender {
    CGFloat radius = [self.comboBox.stringValue doubleValue];
    NSImage *image = [self.imageView.image compressWithRate:radius / 100];
    self.imageView.image = image;
}

- (IBAction)resetAction:(id)sender {
    self.imageView.image = self.oldImage;
}

- (IBAction)tipAction:(id)sender {
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = @"裁剪圆角时按数值进行裁剪，压缩时按百分比进行压缩";
    alert.icon = [NSImage imageNamed:@"提示"];
    [alert addButtonWithTitle:@"知道了"];
    [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSModalResponse returnCode) {
        
    }];
}

// 获取图片文件大小
- (CGFloat)getImageFileSizeWithPath:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    CGFloat fileSize = 0;
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    if (imageSourceRef) {
        CFDictionaryRef imageProperties = CGImageSourceCopyProperties(imageSourceRef, NULL);
        if (imageProperties != NULL) {
            CFNumberRef fileSizeNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyFileSize);
            if (fileSizeNumberRef != NULL) {
                CFNumberGetValue(fileSizeNumberRef, kCFNumberFloat64Type, &fileSize);
            }
            CFRelease(imageProperties);
        }
        CFRelease(imageSourceRef);
    }
    return fileSize;
}

// 获取图片尺寸
- (CGSize)getImageSizeWithPath:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    CGFloat width = 0, height = 0;
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    if (imageSourceRef) {
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
        if (imageProperties != NULL) {
            CFNumberRef widthNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat64Type, &width);
            }
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat64Type, &height);
            }
            CFRelease(imageProperties);
        }
        CFRelease(imageSourceRef);
    }
    return CGSizeMake(width, height);
}

@end
