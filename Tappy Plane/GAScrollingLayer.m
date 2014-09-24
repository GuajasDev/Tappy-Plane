//
//  GAScrollingLayer.m
//  Tappy Plane
//
//  Created by Diego Guajardo on 23/09/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

#import "GAScrollingLayer.h"

@interface GAScrollingLayer ()

@property (nonatomic) SKSpriteNode *rightmostTile;

@end

@implementation GAScrollingLayer

-(id)initWithTiles:(NSArray*)tileSpriteNodes {
    
    if (self = [super init]) {
        for (SKSpriteNode *tile in tileSpriteNodes) {
            tile.anchorPoint = CGPointZero;
            tile.name = @"Tile";
            [self addChild:tile];
        }
        
        [self layoutTiles];
        
    }
    
    return self;
    
}

-(void)layoutTiles {
    //Lays out the tiles when we load the screen
    
    self.rightmostTile = nil;   //Before entering the loop there is no rightmost tile, so the x pos of the first one is 0.0
    [self enumerateChildNodesWithName:@"Tile" usingBlock:^(SKNode *node, BOOL *stop) {
        //Once in the loop, the next node with the name "Tile" will be set up to the right of the rightmost tile
        node.position = CGPointMake(self.rightmostTile.position.x + self.rightmostTile.size.width,
                                    node.position.y);
        //After the tile is set, it becomes the new rightmost tile. And we loop again...
        self.rightmostTile = (SKSpriteNode*)node;
    }];
    
}

-(void)updateWithTimeElapsed:(NSTimeInterval)timeElapsed {  //Inherited from the GAScrollingNode
    //Super is like self but starts looking in the superclass's (GAScrollingNode in this case) methods.
    [super updateWithTimeElapsed:timeElapsed];
    
    //---------- Recycles tiles as the background scrolls ----------
    //If we were scrolling to the right we would need to add an else statement and track the leftmost tile... Check lectures 154 and 156 from the course if you want to do this...
    //If we are scrolling and scrolling to the left and if we have a scene (a check to ensure the code doesnt crash)
    if (self.scrolling && self.horizontalScrollSpeed < 0 && self.scene) {
        
        [self enumerateChildNodesWithName:@"Tile" usingBlock:^(SKNode *node, BOOL *stop) {
            //Take a position (in this case from our node, which is every tile) that is in the coordinate system of self and give it back to us as if it was a position in the scene's coordinate system
            CGPoint nodePositionOnScreen = [self convertPoint:node.position toNode:self.scene];
            
            if ((nodePositionOnScreen.x + node.frame.size.width) < - (self.scene.size.width * self.scene.anchorPoint.x)) {
                //Once in the loop, the next node with the name "Tile" will be set up to the right of the rightmost tile
                node.position = CGPointMake(self.rightmostTile.position.x + self.rightmostTile.size.width,
                                            node.position.y);
                //After the tile is set, it becomes the new rightmost tile. And we loop again...
                self.rightmostTile = (SKSpriteNode*)node;
            }
        }];
        
    }
    //--------------------------------------------------------------
    
}

@end
