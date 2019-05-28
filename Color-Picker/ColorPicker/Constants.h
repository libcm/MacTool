
#define kUserDefaultsFrameOriginX @"kUserDefaultsFrameOriginX"
#define kUserDefaultsFrameOriginY @"kUserDefaultsFrameOriginY"

#define kUserDefaultsKeyStartAtLogin @"kUserDefaultsKeyStartAtLogin"
#define kUserDefaultsKeyTimesRun @"kUserDefaultsKeyTimesRun"
#define kUserDefaultsColorsHistory @"kUserDefaultsColorsHistory"

#define kUserDefaultsDefaultFormat @"kUserDefaultsDefaultFormat"
#define kUserDefaultsShowMenuBarPreview @"kUserDefaultsShowMenuBarPreview"

#define kUserDefaultsKeyCode @"kUserDefaultsKeyCode"
#define kUserDefaultsModifierKeys @"kUserDefaultsModifierKeys"

typedef enum {
    kFormatHEX,
    kFormatRGB,
    kFormatHexWithoutHash,
    kFormatCMYK,
    kFormatUIColor,
    kFormatNSColor,
    kFormatMonoTouch
} kFormats;

#define kNumberOfColorsHistory 5

#define kAlertTitleStartupItem @"开机自启?"
#define kAlertTextStartupItem @"如果您想开机自启，请单击“是”。"

#define kInstructions @"Color Picker Pro可以轻松地从屏幕获取颜色信息。\n\n要捕获颜色，只需按cmd + shift + p（您可以更改首选项中的快捷方式）。 您可以随时直接在窗口或菜单栏中查看颜色预览。\n\n您可以通过单击其菜单栏图标隐藏和显示主界面，或者在应用程序处于活动状态时按ESC键。 您可以调整许多首选项来自定义拾色器的行为。"
