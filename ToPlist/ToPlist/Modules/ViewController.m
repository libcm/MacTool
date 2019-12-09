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
#import "XMLReader.h"


@interface ViewController ()<NSAnimationDelegate>
@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (nonatomic, strong) NSMutableDictionary *xmlDict;
@property (nonatomic, strong) NSString *contentStr;
@property (weak) IBOutlet NSTextField *tipLabel;
@end

@implementation ViewController

- (NSMutableDictionary *)xmlDict {
    if (!_xmlDict) {
        _xmlDict = [[NSMutableDictionary alloc] init];
    }
    return _xmlDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tipLabel.layer.cornerRadius = 10.f;
    self.tipLabel.layer.masksToBounds = YES;
}

- (IBAction)clearAction:(id)sender {
    self.textView.string = @"";
}

- (IBAction)saveAction:(id)sender {
    NSString *text = self.textView.string;
    if (text.length <= 0) {return;}
    NSError *error;
    NSData *data;
    id content;
    if ([[NSFileManager defaultManager] fileExistsAtPath:text]) {    // 检测是否是文件路径
        data = [[NSData alloc] initWithContentsOfFile:text];
    }else {
        data = [text dataUsingEncoding:NSUTF8StringEncoding];
    }
    if ([self isXML:data]) {    // xml
        content = [XMLReader dictionaryForXMLData:data error:&error];
    }else { // json
        content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    }
    if (error) {
        self.textView.string = error.localizedDescription;
        return;
    }
    [self save:content];
    
}

- (void)save:(id)data {
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
            if ([data isKindOfClass:[NSArray class]]) {
                jsonArr = data;
                jsonArr = [jsonArr removeNull];
                result = [jsonArr writeToFile:[panel URL].path atomically:YES];
            }else {
                jsonDict = data;
                jsonDict = [jsonDict removeNull];
                result = [jsonDict writeToFile:[panel URL].path atomically:YES];
            }
            if (result) {
                [self showTipWithMessage:@"存储成功"];
            } else {
                [self showTipWithMessage:@"存储失败"];
            }
        }
    }];
}

- (BOOL)isXML:(NSData *)data {
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *temp = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *text = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    NSString *prefix = [text substringToIndex:1];
    NSString *suffix = [text substringFromIndex:[text length]-1];
    if ([prefix isEqualToString:@"<"] && [suffix isEqualToString:@">"]) {
        return YES;
    }else {
        return NO;
    }
}

- (void)showTipWithMessage:(NSString *)message {
    self.tipLabel.stringValue = message;
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys: self.view,NSViewAnimationTargetKey,NSViewAnimationFadeInEffect,NSViewAnimationEffectKey, nil];
    NSViewAnimation *animation = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObject:dictionary]];
    animation.delegate = self;
    animation.duration = 2;
    //NSAnimationBlocking阻塞
    //NSAnimationNonblocking异步不阻塞
    //NSAnimationNonblockingThreaded线程不阻塞
    [animation setAnimationBlockingMode:NSAnimationNonblockingThreaded];
    [animation startAnimation];
    
}

- (BOOL)animationShouldStart:(NSAnimation *)animation {
    self.tipLabel.hidden = NO;
    return YES;
}

- (void)animationDidEnd:(NSAnimation *)animation {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tipLabel.hidden = YES;
        self.textView.string = @"";
    });
}

@end
