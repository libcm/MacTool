//
//  ColorPickerView.m
//  Test
//
//  Created by Oscar Del Ben on 8/20/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import "ColorPicker.h"

#define kWidth 28
#define kHeight 28

@implementation ColorPicker

#pragma mark -

+ (NSImage *)imageForLocation:(NSPoint)mouseLocation;
{
    CGRect imageRect = CGRectMake(mouseLocation.x - kWidth / 2, mouseLocation.y - kHeight / 2, kWidth, kHeight);
    
    CGImageRef imageRef = CGWindowListCreateImage(imageRect, kCGWindowListOptionOnScreenOnly, kCGNullWindowID, kCGWindowImageShouldBeOpaque);
        
    NSImage *image = [[NSImage alloc] initWithCGImage:imageRef size:NSMakeSize(kWidth, kHeight)];
    
    CGImageRelease(imageRef);
    
    return image;

}

+ (NSColor *)colorAtLocation:(NSPoint)mouseLocation
{   
    CGRect imageRect = CGRectMake(mouseLocation.x, mouseLocation.y, 1, 1);
    
    CGImageRef imageRef = CGWindowListCreateImage(imageRect, kCGWindowListOptionOnScreenOnly, kCGNullWindowID, kCGWindowImageDefault);
    
    NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc] initWithCGImage:imageRef];
    
    CGImageRelease(imageRef);

    return [bitmap colorAtX:0 y:0];
}

+ (NSString *)hexStringAtLocation:(NSPoint)mouseLocation {
    NSColor *color = [self colorAtLocation:mouseLocation];
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255)];
}

+ (NSString *)rgbStringAtLocation:(NSPoint)mouseLocation {
    NSColor *color = [self colorAtLocation:mouseLocation];
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    return [NSString stringWithFormat:@"RGB:(%.f,%.f,%.f)", r * 255, g * 255, b * 255];
}

@end
