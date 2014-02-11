//
//  SPACEAppDelegate.m
//  Space
//
//  Created by [pixelmonster] on 1/29/2014.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import "SPACEAppDelegate.h"
#import "SPACEMyScene.h"

@implementation SPACEAppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    /* Pick a size for the scene */
    CGSize size = [self.window contentRectForFrameRect:self.window.frame].size;
    SKScene *scene = [SPACEMyScene sceneWithSize:size];

    /* Set the scale mode to scale to fit the window */
    scene.scaleMode = SKSceneScaleModeAspectFit;

    [self.skView presentScene:scene];

//    self.skView.showsFPS = YES;
//    self.skView.showsNodeCount = YES;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
