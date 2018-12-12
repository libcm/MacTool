//
//  ViewController.m
//  JsonToPlist
//
//  Created by lib on 2018/11/29.
//  Copyright © 2018 lib. All rights reserved.
//

#import "ViewController.h"
#import "NSDictionary+Extension.h"
#import "NSArray+Extension.h"

@interface ViewController ()
@property (unsafe_unretained) IBOutlet NSTextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)clearAction:(id)sender {
    self.textView.string = @"";
}

- (IBAction)saveAction:(id)sender {
    NSString *jsonStr = self.textView.string;
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonError;
    id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
    
    if (jsonError) {
        self.textView.string = jsonError.localizedDescription;
        return;
    }
    
    NSSavePanel *panel = [NSSavePanel savePanel];
    panel.title = @"保存Plist文件";
    panel.message = @"设置保存路径";
    panel.allowsOtherFileTypes = YES;
    panel.allowedFileTypes = @[@"plist"];
    panel.extensionHidden = NO;
    panel.canCreateDirectories = YES;
    [panel beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK) {
            BOOL result;
            NSArray *jsonArr;
            NSDictionary *jsonDict;
            if ([jsonData isKindOfClass:[NSArray class]]) {
                jsonArr = jsonData;
                jsonArr = [jsonArr removeNull];
                result = [jsonArr writeToFile:[panel URL].path atomically:YES];
            }else {
                jsonDict = jsonData;
                jsonDict = [jsonDict removeNull];
                result = [jsonDict writeToFile:[panel URL].path atomically:YES];
            }
            if (!result) {
                self.textView.string = @"存储失败";
            }
        }
    }];
}


@end
