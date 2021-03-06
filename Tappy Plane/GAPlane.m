//
//  GAPlane.m
//  Tappy Plane
//
//  Created by Diego Guajardo on 6/09/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

#import "GAPlane.h"
#import "GAConstants.h"
#import "GACollectable.h"
#import "SoundManager.h"

@interface GAPlane()

@property (nonatomic) NSMutableArray *planeAnimations;      //Holds animations actions
@property (nonatomic) SKEmitterNode *puffTrailEmitter;
@property (nonatomic) CGFloat puffTrailBirthRate;
@property (nonatomic) SKAction *crashTintAction;
@property (nonatomic) Sound *engineSound;

@end

static NSString* const kGAKeyPlaneAnimation = @"PlaneAnimation";  //Plane animation key, change the name and it will change all throughout the code
static const CGFloat kGAMaxAltitude = 300.0;

@implementation GAPlane

- (instancetype)init
{
    self = [super initWithImageNamed:@"planeBlue1"];
    if (self) {
        
        //Setup Physics body with path
        //---------- Obtained from dazchong.com/spritekit/ ----------
        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, 42 - offsetX, 11 - offsetY);
        CGPathAddLineToPoint(path, NULL, 42 - offsetX, 20 - offsetY);
        CGPathAddLineToPoint(path, NULL, 36 - offsetX, 27 - offsetY);
        CGPathAddLineToPoint(path, NULL, 36 - offsetX, 35 - offsetY);
        CGPathAddLineToPoint(path, NULL, 12 - offsetX, 35 - offsetY);
        CGPathAddLineToPoint(path, NULL, 7 - offsetX, 30 - offsetY);
        CGPathAddLineToPoint(path, NULL, 0 - offsetX, 28 - offsetY);
        CGPathAddLineToPoint(path, NULL, 1 - offsetX, 21 - offsetY);
        CGPathAddLineToPoint(path, NULL, 9 - offsetX, 9 - offsetY);
        CGPathAddLineToPoint(path, NULL, 14 - offsetX, 3 - offsetY);
        CGPathAddLineToPoint(path, NULL, 24 - offsetX, 3 - offsetY);
        CGPathAddLineToPoint(path, NULL, 33 - offsetX, 0 - offsetY);
        
        CGPathCloseSubpath(path);   //Close body because we are creating a loop (body) instead of an edge
        
        self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
        //-----------------------------------------------------------
        self.physicsBody.mass = 0.08;
        self.physicsBody.categoryBitMask = kGACategoryPlane;
        self.physicsBody.contactTestBitMask = kGACategoryGround | kGACategoryCollectable;
        self.physicsBody.collisionBitMask = kGACategoryGround;  //The plane will collide with the ground but not the collectables
        
        //---------- How to vizualise the edge path ----------
        /*SKShapeNode *bodyShape = [SKShapeNode node];
        bodyShape.path = path;
        bodyShape.strokeColor = [SKColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
        bodyShape.lineWidth = 1.0;
        [self addChild:bodyShape];*/
        //----------------------------------------------------
        
        //Init array to hold animation actions
        _planeAnimations = [[NSMutableArray alloc] init];
        
        //This is how to run the animations without the plist
        //--------------------------------------------------------------------
        /*NSArray *frames = @[[SKTexture textureWithImageNamed:@"planeBlue1"],
                            [SKTexture textureWithImageNamed:@"planeBlue2"],
                            [SKTexture textureWithImageNamed:@"planeBlue3"]];
        
        SKAction *animation = [SKAction animateWithTextures:frames timePerFrame:0.4/3 resize:NO restore:NO];
        [self runAction:[SKAction repeatActionForever:animation]];*/
        //--------------------------------------------------------------------
        
        //Load animation plist file
        NSString *animationPlistPath = [[NSBundle mainBundle] pathForResource:@"PlaneAnimations" ofType:@"plist"];
        NSDictionary *animations = [NSDictionary dictionaryWithContentsOfFile:animationPlistPath];    //Root dict containing plane colours
        for (NSString *key in animations) { //For a string'key', which is all the colours, in the root dict:
            //Add an action in the planeAnimations array for each colour of planes (ie 'key') in the plist file. Actions last 0.4s
            [self.planeAnimations addObject:[self animationFromArray:[animations objectForKey:key] withDuration:0.4]];
        }
        
        //Setup puff trail particle effect
        NSString *particleFile = [[NSBundle mainBundle] pathForResource:@"PlanePuffTrail" ofType:@"sks"];
        _puffTrailEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:particleFile];
        _puffTrailEmitter.position = CGPointMake( - self.size.width * 0.5, - 5);
        [self addChild:self.puffTrailEmitter];
        self.puffTrailBirthRate = self.puffTrailEmitter.particleBirthRate;
        self.puffTrailEmitter.particleBirthRate = 0;
        
        //Setup action to tint plane when it crashes
        SKAction *tint = [SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:0.8 duration:0.0];
        SKAction *removeTint = [SKAction colorizeWithColorBlendFactor:0.0 duration:0.3];
        _crashTintAction = [SKAction sequence:@[tint, removeTint]];
        
        //Setup engine sound
        _engineSound = [Sound soundNamed:@"Engine.caf"];
        _engineSound.looping = YES;
        
        [self setRandomColor];
        
    }
    return self;
}

-(void)reset {
    
    //Set plane's initial values
    self.crashed = NO;
    self.engineRunning = YES;
    self.physicsBody.velocity = CGVectorMake(0.0, 0.0);
    self.physicsBody.angularVelocity = 0.0;
    self.zRotation = 0.0;
    [self setRandomColor];
    
}

-(void)setEngineRunning:(BOOL)engineRunning {
    
    _engineRunning = engineRunning && !self.crashed;    //Both on the right have to be YES for _engineRunning to be Yes, if one is NO then it will be NO
    
    if (engineRunning) {
        [self.engineSound play];
        [self.engineSound fadeIn:1.0];
        self.puffTrailEmitter.targetNode = self.parent; //Makes the emitter act on the planes parent so it doesnt go up and down with it
        [self actionForKey:kGAKeyPlaneAnimation].speed = 1;
        self.puffTrailEmitter.particleBirthRate = self.puffTrailBirthRate;
    } else {
        [self.engineSound fadeOut:0.5];
        [self actionForKey:kGAKeyPlaneAnimation].speed = 0;
        self.puffTrailEmitter.particleBirthRate = 0;
    }
    
}

-(void)setAccelerating:(BOOL)accelerating {
    
    _accelerating = accelerating && !self.crashed;
    
}

-(void)setCrashed:(BOOL)crashed {
    
    _crashed = crashed;
    if (crashed) {
        self.engineRunning = NO;
        self.accelerating = NO;
    }
    
}

-(void)setRandomColor {
    [self removeActionForKey:kGAKeyPlaneAnimation];
    SKAction *animation = [self.planeAnimations objectAtIndex:arc4random_uniform((uint)self.planeAnimations.count)];
    [self runAction:animation withKey:kGAKeyPlaneAnimation];
    if (!self.engineRunning) {
        [self actionForKey:kGAKeyPlaneAnimation].speed = 0;
    }
}

-(void)collide:(SKPhysicsBody *)body {
    
    //Ignore more collisions if we already crashed
    if (!self.crashed) {
        
        //Groung and obstacles are both kGACategoryGround
        if (body.categoryBitMask == kGACategoryGround) {
            //We hit the ground
            self.crashed = YES;
            [self runAction:self.crashTintAction];
            [[SoundManager sharedManager] playSound:@"Crunch.caf"];
        }
        
        if (body.categoryBitMask == kGACategoryCollectable) {
            //We got a collectable
            if ([body.node respondsToSelector:@selector(collect)]) {
                [body.node performSelector:@selector(collect)];
            }
        }
        
    }
    
}

//Creates an action that animates with textures
-(SKAction*)animationFromArray:(NSArray*)textureNames withDuration:(CGFloat)duration {
    //Create array to hold textures
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    
    //Get planes atlas
    SKTextureAtlas *planesAtlas = [SKTextureAtlas atlasNamed:@"Graphics"];
    
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

-(void)update {
    
    if (self.accelerating && self.position.y < kGAMaxAltitude) {
        [self.physicsBody applyForce:CGVectorMake(0.0, 100.0)];
    }
    
    //For the zRotation, it gives a value of speed no less than -400 and no more than 400 which we divide by 400 to get between -1 and 1 radians (57.3 degrees) of rotation. So you never rotate more than 57.3 degrees, which you do at a speed of 400. For the engine sound, it gives a value between 0 and 300, which we then divide by 300 to get a value between 0 and 1, which we then multiply by 0.75 to get a value between 0 and 0.75 and then we add 0.25 to get a value between 0.25 and 1.0.
    if (!self.crashed) {
        self.zRotation = fmaxf(fminf(self.physicsBody.velocity.dy, 400), - 400) / 400.0;
        self.engineSound.volume = 0.25 + (fmaxf(fminf(self.physicsBody.velocity.dy, 300), 0) / 300.0) * 0.75;
    }
    
}

@end
