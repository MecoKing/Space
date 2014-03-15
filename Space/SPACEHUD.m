//
//  SPACEHUD.m
//  Space
//
//  Created by [pixelmonster] on 2014-03-15.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import "SPACEHUD.h"
#import "SPACEMyScene.h"
#import "SPACEFunction.h"

@implementation SPACEHUD

@dynamic scene;

+(instancetype) compassHUDAtPosition: (CGPoint) position {
    SPACEHUD *HUD = [SPACEHUD new];
    
    HUD.compass = [SKShapeNode new];
    CGPathRef path = CGPathCreateWithEllipseInRect(CGRectMake(position.x, position.y, 300, 300), NULL);
    HUD.compass.path = path;
    CGPathRelease(path);
    
    HUD.compass.strokeColor = SPACEInverseOfColour(HUD.scene.backgroundColor);
    HUD.compass.strokeColor = [SKColor colorWithRed:HUD.compass.strokeColor.redComponent green:HUD.compass.strokeColor.greenComponent blue:HUD.compass.strokeColor.blueComponent alpha:0.2];
    
    [HUD addChild:HUD.compass];
    
    return HUD;
}

@end
