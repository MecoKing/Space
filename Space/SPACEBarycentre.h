//  Copyright (c) 2014 [pixelmonster]. All rights reserved.

#import <Foundation/Foundation.h>

@class SPACESystem;

@protocol SPACEBarycentre <NSObject>

-(void) updateWithSystem: (SPACESystem*) origin;

@property (readonly) CGFloat radius;

@end
