//
//  GAGameScene.m
//  Tappy Plane
//
//  Created by Diego Guajardo on 5/09/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

#import "GAGameScene.h"
#import "GAPlane.h"

@interface GAGameScene ()   //Created so we can add propertie to the GAGameScene

@property (nonatomic) GAPlane *player;
@property (nonatomic) SKNode *world;

@end

@implementation GAGameScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //Used this when setting up to make sure that the size is 568x320 intead of 320x568
        //NSLog(@"Size: %f %f", size.width, size.height);
        
        //Setup world
        _world = [SKNode node];
        [self addChild:_world];
        
        //Setup Player
        _player = [[GAPlane alloc] init];
        _player.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
        [_world addChild:_player];

    }
    
    return self;
}

@end
