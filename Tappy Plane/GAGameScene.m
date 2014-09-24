//
//  GAGameScene.m
//  Tappy Plane
//
//  Created by Diego Guajardo on 5/09/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

#import "GAGameScene.h"
#import "GAPlane.h"
#import "GAScrollingLayer.h"
#import "GAConstants.h"
#import "GAObstacleLayer.h"

@interface GAGameScene ()   //Created so we can add propertie to the GAGameScene

@property (nonatomic) GAPlane *player;
@property (nonatomic) GAScrollingLayer *background;
@property (nonatomic) GAScrollingLayer *foreground;
@property (nonatomic) GAObstacleLayer *obstacles;

@property (nonatomic) SKNode *world;

@end

static const CGFloat kMinFPS = 10.0 / 60.0;     //When scrolling dont ever drop bellow 10 frames per second. Check update method

@implementation GAGameScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //Used this when setting up to make sure that the size is 568x320 intead of 320x568
        //NSLog(@"Size: %f %f", size.width, size.height);
        
        //Setup background colour to sky blue
        self.backgroundColor = [SKColor colorWithRed:213/255.0 green:237/255.0 blue:247/255.0 alpha:1.0];
        
        //Get atlas
        SKTextureAtlas *graphics = [SKTextureAtlas atlasNamed:@"Graphics"];
        
        //Setup physics
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.5);
        self.physicsWorld.contactDelegate = self;
        
        //Setup world
        _world = [SKNode node];
        [self addChild:_world];
        
        //Setup background (before player so it is behind it)
        NSMutableArray *backgroundTiles = [[NSMutableArray alloc] init];
        for (int i = 0; i < 3; i ++) {  //i < 3 because we only need 3 tiles
            [backgroundTiles addObject:[SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"background"]]];
        }
        _background = [[GAScrollingLayer alloc] initWithTiles:backgroundTiles];
        _background.horizontalScrollSpeed = - 60.0;
        _background.scrolling = YES;
        [_world addChild:_background];
        
        //Setup obstacle layer
        _obstacles = [[GAObstacleLayer alloc] init];
        _obstacles.horizontalScrollSpeed = - 80.0;
        _obstacles.scrolling = YES;
        _obstacles.floor = 0.0;
        _obstacles.ceiling = self.size.height;
        [_world addChild:_obstacles];
        
        //Setup foreground
        _foreground = [[GAScrollingLayer alloc] initWithTiles:@[[self generateGroundTile],
                                                               [self generateGroundTile],
                                                               [self generateGroundTile]]];
        _foreground.horizontalScrollSpeed = - 80.0;
        _foreground.scrolling = YES;
        [_world addChild:_foreground];
        
        //Setup Player
        _player = [[GAPlane alloc] init];
        _player.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
        _player.physicsBody.affectedByGravity = NO;
        [_world addChild:_player];
        
        //Start a new game
        [self newGame];

    }
    
    return self;
}

-(SKSpriteNode*)generateGroundTile {
    
    SKTextureAtlas *graphics = [SKTextureAtlas atlasNamed:@"Graphics"];
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"groundGrass"]];
    sprite.anchorPoint = CGPointZero;
    
    //---------- Obtained from dazchong.com/spritekit/ ----------
    // Setup path on the foreground
    CGFloat offsetX = sprite.frame.size.width * sprite.anchorPoint.x;
    CGFloat offsetY = sprite.frame.size.height * sprite.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 402 - offsetX, 17 - offsetY);
    CGPathAddLineToPoint(path, NULL, 372 - offsetX, 35 - offsetY);
    CGPathAddLineToPoint(path, NULL, 329 - offsetX, 33 - offsetY);
    CGPathAddLineToPoint(path, NULL, 287 - offsetX, 10 - offsetY);
    CGPathAddLineToPoint(path, NULL, 236 - offsetX, 13 - offsetY);
    CGPathAddLineToPoint(path, NULL, 217 - offsetX, 29 - offsetY);
    CGPathAddLineToPoint(path, NULL, 184 - offsetX, 29 - offsetY);
    CGPathAddLineToPoint(path, NULL, 154 - offsetX, 22 - offsetY);
    CGPathAddLineToPoint(path, NULL, 124 - offsetX, 32 - offsetY);
    CGPathAddLineToPoint(path, NULL, 78 - offsetX, 30 - offsetY);
    CGPathAddLineToPoint(path, NULL, 45 - offsetX, 14 - offsetY);
    CGPathAddLineToPoint(path, NULL, 2 - offsetX, 17 - offsetY);
    
    sprite.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:path];
    //-----------------------------------------------------------
    sprite.physicsBody.categoryBitMask = kGACategoryGround;
    
    //---------- How to vizualise the edge path ----------
    /*SKShapeNode *bodyShape = [SKShapeNode node];
    bodyShape.path = path;
    bodyShape.strokeColor = [SKColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    bodyShape.lineWidth = 1.0;
    [sprite addChild:bodyShape];*/
    //----------------------------------------------------
    
    return sprite;
    
}

-(void)newGame {
    //Reset layers
    self.foreground.position = CGPointZero;
    [self.foreground layoutTiles];
    self.obstacles.position = CGPointZero;
    [self.obstacles reset];
    self.obstacles.scrolling = NO;
    self.background.position = CGPointMake(0.0, 30);
    [self.background layoutTiles];
    
    //Reset plane
    self.player.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
    self.player.physicsBody.affectedByGravity = NO;
    [self.player reset];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        if (self.player.crashed) {
            //Reset the game
            [self newGame];
        } else {
            //Have not crashed, so accelerate
            self.player.accelerating = YES;
            self.player.physicsBody.affectedByGravity = YES;
            self.obstacles.scrolling = YES;
        }
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        self.player.accelerating = NO;
    }
    
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    
    //When the plance collides with the ground we pass the responsability of handling the collision to GAPlane (self.player)
    if (contact.bodyA.categoryBitMask == kGACategoryPlane) {
        [self.player collide:contact.bodyB];
    } else if (contact.bodyB.categoryBitMask == kGACategoryPlane) {
        [self.player collide:contact.bodyA];
    }
    
}

-(void)update:(NSTimeInterval)currentTime {
    
    static NSTimeInterval lastCallTime;
    NSTimeInterval timeElapsed = currentTime - lastCallTime;
    if (timeElapsed > kMinFPS) {
        timeElapsed = kMinFPS;
    }
    lastCallTime = currentTime;
    
    [self.player update];
    if (!self.player.crashed) {
        [self.background updateWithTimeElapsed:timeElapsed];
        [self.foreground updateWithTimeElapsed:timeElapsed];
        [self.obstacles updateWithTimeElapsed:timeElapsed];
    }
    
}

@end
