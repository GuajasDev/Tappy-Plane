//
//  GAObstacleLayer.m
//  Tappy Plane
//
//  Created by Diego Guajardo on 24/09/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

#import "GAObstacleLayer.h"
#import "GAConstants.h"

@interface GAObstacleLayer ()

@property (nonatomic) CGFloat marker;

@end

static const CGFloat kGAMarkerBuffer = 200.0;
static const CGFloat kGAVerticalGap = 90.0;
static const CGFloat kGASpaceBetweenObstacleSets = 180.0;

static NSString *const kGAKeyMountainUp = @"MountainUp";
static NSString *const kGAKeyMountainDown = @"MountainDown";

@implementation GAObstacleLayer

- (id)init
{
    self = [super init];
    if (self) {
        //Load initial objects. In case we want to load them all at the beginning instead of during the game
        for (int i = 0; i < 5; i++) {
            [self createObjectForKey:kGAKeyMountainUp].position = CGPointMake( - 1000, 0.0);
            [self createObjectForKey:kGAKeyMountainDown].position = CGPointMake( - 1000, 0.0);
        }
    }
    return self;
}

-(void)reset {
    
    //Loop through child nodes and reposition for reuse
    for (SKNode *node in self.children) {
        node.position = CGPointMake( - 1000, 0);
    }
    
    //Reposition marker
    if (self.scene) {
        self.marker = self.scene.size.width + kGAMarkerBuffer;
    }
    
}

-(void)updateWithTimeElapsed:(NSTimeInterval)timeElapsed {
    [super updateWithTimeElapsed:timeElapsed];
    
    if (self.scrolling && self.scene) {
        //Finnd the marker's location in the scene's coordinates
        CGPoint markerLocationInScene = [self convertPoint:CGPointMake(self.marker, 0.0) toNode:self.scene];
        
        //When marker comes onto screen, add new obstacles
        if ((markerLocationInScene.x - (self.scene.size.width * self.scene.anchorPoint.x)) < self.scene.size.width + kGAMarkerBuffer) {
            
            [self addObstacleSet];
            
        }
        
    }
    
}

-(void) addObstacleSet {
    
    //Get mountain nodes
    SKSpriteNode *mountainUp = [self getUnusedObjectForKey:kGAKeyMountainUp];
    SKSpriteNode *mountainDown = [self getUnusedObjectForKey:kGAKeyMountainDown];
    
    //Calculate maximum variation
    CGFloat maxVariation = (mountainUp.size.height + mountainDown.size.height + kGAVerticalGap) - (self.ceiling - self.floor);
    CGFloat yAdjustment = (CGFloat)arc4random_uniform(maxVariation);
    
    //Position the nodes
    //Positions mountainUp at the bottom of the screen and mountainDown at kGAVerticalGap points from mountainUp's top
    mountainUp.position = CGPointMake(self.marker, self.floor + (mountainUp.size.height * 0.5) - yAdjustment);
    mountainDown.position = CGPointMake(self.marker, mountainUp.position.y + mountainDown.size.height + kGAVerticalGap);
    
    //Reposition marker
    self.marker +=kGASpaceBetweenObstacleSets;
    
}

//If we have a node to the loft of the screen we re-use it by sending it back to addObstacle set, which repositions it to the right of the screen
-(SKSpriteNode*)getUnusedObjectForKey:(NSString*)key {
    
    if (self.scene) {
        //Get left edge of screen in local coordinates
        CGFloat leftEdgeInLocalCoords = [self.scene convertPoint:CGPointMake( - self.scene.size.width * self.scene.anchorPoint.x, 0.0) toNode:self].x;
        
        //Try find object for key to the left of the screen
        for (SKSpriteNode *node in self.children) {
            //If our node is to the left of the screen then re-use that one
            //Because we use node.frame.origin.x (ie we used frame) we dont have to worry about the anchor point
            if (node.name == key && node.frame.origin.x + node.frame.size.width < leftEdgeInLocalCoords) {
                //Return unused object
                return node;
            }
        }
        
    }
    
    //Couldnt find an unused node with key so create a new one
    return [self createObjectForKey:key];
    
}

//Creates a new node. Used when there are no un-used nodes to recycle
-(SKSpriteNode*)createObjectForKey:(NSString*)key {
    
    SKSpriteNode *object = nil;
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Graphics"];
    
    if (key == kGAKeyMountainUp) {
        
        //Setup Physics body with path
        object = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"MountainGrass"]];
        
        NSLog(@"Create Mountain Up");
        
        //---------- Obtained from dazchong.com/spritekit/ ----------
        CGFloat offsetX = object.frame.size.width * object.anchorPoint.x;
        CGFloat offsetY = object.frame.size.height * object.anchorPoint.y;
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 53 - offsetX, 198 - offsetY);
        CGPathAddLineToPoint(path, NULL, 1 - offsetX, 2 - offsetY);
        CGPathAddLineToPoint(path, NULL, 88 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 57 - offsetX, 198 - offsetY);
        CGPathCloseSubpath(path);
        
        object.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:path];
        //----------------------------------------------------------
        object.physicsBody.categoryBitMask = kGACategoryGround;
        
        [self addChild:object];
        
    } else if (key == kGAKeyMountainDown) {
        
        //Setup Physics body with path
        object = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"MountainGrassDown"]];
        
        NSLog(@"Create Mountain Down");
        
        //---------- Obtained from dazchong.com/spritekit/ ----------
        CGFloat offsetX = object.frame.size.width * object.anchorPoint.x;
        CGFloat offsetY = object.frame.size.height * object.anchorPoint.y;
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0 - offsetX, 198 - offsetY);
        CGPathAddLineToPoint(path, NULL, 51 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 57 - offsetX, 1 - offsetY);
        CGPathAddLineToPoint(path, NULL, 89 - offsetX, 198 - offsetY);
        CGPathCloseSubpath(path);
        
        object.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:path];
        //----------------------------------------------------------
        object.physicsBody.categoryBitMask = kGACategoryGround;
        
        [self addChild:object];
        
    }
    
    if (object) {
        object.name = key;
    }
    
    return object;
    
}

@end
