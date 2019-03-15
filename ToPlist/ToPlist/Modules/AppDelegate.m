//
//  AppDelegate.m
//  JsonToPlist
//
//  Created by lib on 2018/11/29.
//  Copyright © 2018 lib. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()<NSWindowDelegate>
@property (nonatomic, strong) NSWindowController *mainController;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.mainController.window.delegate = self;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)windowShouldClose:(id)sender //close box quits the app
{
    [NSApp terminate:self];
    return YES;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
    if (!flag){
        [[NSApplication sharedApplication].windows.firstObject makeKeyAndOrderFront:self];
        return YES;
    }
    return NO;
}

@end
