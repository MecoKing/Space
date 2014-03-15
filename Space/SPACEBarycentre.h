//  Copyright (c) 2014 [pixelmonster]. All rights reserved.

#import <Foundation/Foundation.h>

@class SPACESystem;

@protocol SPACEBarycentre <NSObject>

/// Allows the receiver to perform physics calculations or other updates with a given root system and over a given time interval.
///
/// \param origin The root system that the receiver is contained within.
/// \param time The interval of time that has elapsed since the previous frame was rendered.
-(void)updateWithSystem:(SPACESystem *)origin overInterval:(CFTimeInterval)time;

@property (readonly) CGFloat radius;

@end
