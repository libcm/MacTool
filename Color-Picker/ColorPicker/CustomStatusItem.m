#import "CustomStatusItem.h"
#import "ColorPicker.h"

@implementation CustomStatusItem

@synthesize mouseLocation;
@synthesize delegate;
@synthesize menuBarImage;
@synthesize imageRect;
@synthesize colorRect;
@synthesize showPreview;

#define kPadding 3.0

- (NSTextField *)textField {
    if (!_textField) {
        _textField = [[NSTextField alloc] init];
        _textField.textColor = [NSColor blackColor];
        _textField.editable = NO;
        _textField.font = [NSFont systemFontOfSize:6.7];
        _textField.lineBreakMode = NSLineBreakByCharWrapping;
        _textField.alignment = NSTextAlignmentCenter;
    }
    return _textField;
}

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        showPreview = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsShowMenuBarPreview];
        [self addSubview:self.textField];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    if (!menuBarImage) {
        self.menuBarImage = [NSImage imageNamed:@"ColorPicker_menubar.png"];
        imageRect = NSMakeRect(0, 3, menuBarImage.size.width, menuBarImage.size.height);
//        colorRect = NSMakeRect(menuBarImage.size.width + kPadding, 6, 10, 10);
        self.textField.frame = NSMakeRect(menuBarImage.size.width + kPadding, 0, 80, dirtyRect.size.height);
    }
    
    if (mouseLocation.x) 
    {
        [menuBarImage drawInRect:imageRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];
        
        if (showPreview) {
            NSString *rgb = [ColorPicker rgbStringAtLocation:mouseLocation];
            NSString *hex = [ColorPicker hexStringAtLocation:mouseLocation];
            self.textField.stringValue = [NSString stringWithFormat:@"%@\n%@",rgb, hex];
            // 状态栏显示颜色
//            NSColor *currentColor = [ColorPicker colorAtLocation:mouseLocation];
//
//            [currentColor set];
//            NSRectFill(colorRect);
//            [self setFrameSize:NSMakeSize(menuBarImage.size.width + kPadding + colorRect.size.width + kPadding, self.frame.size.height)];
            // 状态栏显示文字
            [self setFrameSize:NSMakeSize(menuBarImage.size.width + kPadding + self.textField.frame.size.width + kPadding, self.frame.size.height)];
        } else
        {
            [self setFrameSize:NSMakeSize(menuBarImage.size.width + kPadding, self.frame.size.height)];
        }
    }
}

#pragma mark toggleWindow

- (NSPoint)getAnchorPoint
{	
	NSRect frame = [[self window] frame];
	NSRect screen = [[NSScreen mainScreen] frame];
	NSPoint point = NSMakePoint(NSMidX(frame), screen.size.height - [[NSStatusBar systemStatusBar] thickness]);
    
	return point;
}

- (void)toggleShowWindow
{
    if ([(NSObject *)delegate respondsToSelector:@selector(toggleShowWindowFromPoint:forceAnchoring:)]) 
    {
        [delegate toggleShowWindowFromPoint:[self getAnchorPoint] forceAnchoring:NO];
    }
}

#pragma mark Events

// The icon was clicked, we toggle the window
// 点击状态栏显示全部
- (void)mouseDown:(NSEvent *)event {
    [self toggleShowWindow];
}

@end
