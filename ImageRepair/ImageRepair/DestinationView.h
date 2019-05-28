//
//  DestinationView.h
//  Image
//
//  Created by liyb on 2019/5/7.
//  Copyright © 2019 qzc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DestinationViewDelegate <NSObject>

-(void)dragDropViewFileList:(NSArray*)fileList;
@end

@interface DestinationView : NSView
@property (nonatomic, weak) id<DestinationViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
