//
//  DestinationView.m
//  Image
//
//  Created by liyb on 2019/5/7.
//  Copyright © 2019 qzc. All rights reserved.
//

#import "DestinationView.h"

@interface DestinationView ()
@property (nonatomic, strong) NSSet *acceptableTypes;
@end

@implementation DestinationView
- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self registerForDraggedTypes:@[NSFilenamesPboardType]];
    [self setWantsLayer:YES];
    self.layer.cornerRadius = 5.f;
    self.layer.borderColor = [NSColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1.f;
    self.layer.masksToBounds = YES;
}

/*
 当拖动数据进入view时会触发这个函数，我们可以在这个函数里面判断数据是什么类型，来确定要显示什么样的图标。比如接受到的数据是我们想要的NSFilenamesPboardType文件类型，我们就可以在鼠标的下方显示一个“＋”号，当然我们需要返回这个类型NSDragOperationCopy。如果接受到的文件不是我们想要的数据格式，可以返回NSDragOperationNone;这个时候拖动的图标不会有任何改变。
 */
- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    NSPasteboard *pboard = [sender draggingPasteboard];
    if ([[pboard types] containsObject:NSFilenamesPboardType]) {
        return NSDragOperationCopy;
    }
    NSLog(@"%@", [pboard types]);
    return NSDragOperationNone;
}
// 当在view中松开鼠标键时会触发以下函数，我们可以在这个函数里面处理接受到的数据
- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender {
    NSPasteboard *pboard = [sender draggingPasteboard];
    NSArray *list = [pboard propertyListForType:NSFilenamesPboardType];
    if ([self.delegate respondsToSelector:@selector(dragDropViewFileList:)]) {
        [self.delegate dragDropViewFileList:list];
    }
    return YES;
}

@end
