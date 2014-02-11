//
//  SPACEAppDelegate.m
//  Space
//
//  Created by [pixelmonster] on 1/29/2014.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import "SPACEAppDelegate.h"
#import "SPACEMyScene.h"

@interface SPACEAppDelegate ()

@property SKScene *scene;

@end

@implementation SPACEAppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    /* Pick a size for the scene */
    CGSize size = [self.window contentRectForFrameRect:self.window.frame].size;
    self.scene = [SPACEMyScene sceneWithSize:size];

    /* Set the scale mode to scale to fit the window */
    self.scene.scaleMode = SKSceneScaleModeAspectFit;

    [self.skView presentScene:self.scene];

//    self.skView.showsFPS = YES;
//    self.skView.showsNodeCount = YES;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
