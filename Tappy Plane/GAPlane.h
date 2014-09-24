//
//  GAPlane.h
//  Tappy Plane
//
//  Created by Diego Guajardo on 6/09/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GAPlane : SKSpriteNode

@property (nonatomic) BOOL engineRunning;
@property (nonatomic) BOOL accelerating;
@property (nonatomic) BOOL crashed;

-(void)setRandomColor;
-(void)update;
-(void)collide:(SKPhysicsBody*)body;
-(void)reset;

@end
