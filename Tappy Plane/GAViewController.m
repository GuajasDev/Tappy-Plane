//
//  GAViewController.m
//  Tappy Plane
//
//  Created by Diego Guajardo on 5/09/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

#import "GAViewController.h"
#import "GAGameScene.h"

@implementation GAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    //This was moved here (from viewDidLoad) because the scene was being setup in the view did load method, but at that point the view hasnt really been setup correctly, it hasnt finished with its setup process. So the code gets moved into later in the process, because the scene is getting its bounds from the view, so we need to make sure the view is finished setting up properly. We were getting a width of 320 and height of 568 in landscame mode and this fixes that problem. Also, this method will happen for each view, but we dont want to create the scene twice, so we put in that 'if' statement
    //--------------------------------------------------------------------------------
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        skView.showsDrawCount = YES;
        
        // Create and configure the scene.
        SKScene * scene = [GAGameScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }
    //--------------------------------------------------------------------------------
}

- (BOOL)shouldAutorotate
{
    return YES;
}

-(BOOL)prefersStatusBarHidden {     //Hides the bar with the time at the top of the screen
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
