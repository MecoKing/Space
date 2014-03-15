//
//  SPACEHUD.h
//  Space
//
//  Created by [pixelmonster] on 2014-03-15.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SPACEMyScene;

@interface SPACEHUD : SKNode

@property SKShapeNode *compass;

@property (SK_NONATOMIC_IOSONLY, readonly) SPACEMyScene *scene;


+(instancetype) compassHUDAtPosition: (CGPoint) position;
-(void) updateDotsOnCompass;

@end
