//
//  GAPlane.m
//  Tappy Plane
//
//  Created by Diego Guajardo on 6/09/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

#import "GAPlane.h"

@interface GAPlane()

@property (nonatomic) NSMutableArray *planeAnimations;      //Holds animations actions

@end

static NSString* const kKeyPlaneAnimation = @"PlaneAnimation";

@implementation GAPlane

- (instancetype)init
{
    self = [super initWithImageNamed:@"planeBlue1"];
    if (self) {
        
        
        //Init array to hold animation actions
        _planeAnimations = [[NSMutableArray alloc] init];
        
        //Load animation plist file
        NSString *path = [[NSBundle mainBundle] pathForResource:@"PlaneAnimations" ofType:@"plist"];
        NSDictionary *animations = [NSDictionary dictionaryWithContentsOfFile:path];    //Root dict containing plane colours
        for (NSString *key in animations) { //For a string'key', which is all the colours, in the root dict:
            //Add an action in the planeAnimations array for each colour of planes (ie 'key') in the plist file. Actions last 0.4s
            [self.planeAnimations addObject:[self animationFromArray:[animations objectForKey:key] withDuration:0.4]];
        }
        
        [self setRandomColor];
        
    }
    return self;
}

-(void)setengineRunning:(BOOL)engineRunning {
    
    _engineRunning = engineRunning;
    
    if (engineRunning) {
        [self actionForKey:kKeyPlaneAnimation].speed = 1;
    } else {
        [self actionForKey:kKeyPlaneAnimation].speed = 0;
    }
    
}

-(void)setRandomColor {
    [self removeActionForKey:kKeyPlaneAnimation];
    SKAction *animation = [self.planeAnimations objectAtIndex:arc4random_uniform((int)self.planeAnimations.count)];
    [self runAction:animation withKey:kKeyPlaneAnimation];
    if (!self.engineRunning) {
        [self actionForKey:kKeyPlaneAnimation].speed = 0;
    }
}

//Creates an action that animates with textures
-(SKAction*)animationFromArray:(NSArray*)textureNames withDuration:(CGFloat)duration {
    //Create array to hold textures
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    
    //Get planes atlas
    SKTextureAtlas *planesAtlas = [SKTextureAtlas atlasNamed:@"Planes"];
    
    //Loop through texture names array and load textures
    for (NSString *textureName in textureNames) {
        [frames addObject:[planesAtlas textureNamed:textureName]];
    }
    
    //Calculate time per frame
    CGFloat frameTime = duration / (CGFloat)frames.count;
    
    //Create and return an animation action
    return [SKAction repeatActionForever:[SKAction animateWithTextures:frames
                                                          timePerFrame:frameTime
                                                                resize:NO
                                                               restore:NO]];
    
}

@end
