//
//  GAObstacleLayer.h
//  Tappy Plane
//
//  Created by Diego Guajardo on 24/09/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

#import "GAScrollingNode.h"
#import "GACollectable.h"

@interface GAObstacleLayer : GAScrollingNode

//See GACollectible for explanation on what's below
@property (nonatomic, weak) id <GACollectableDelegate> collectableDelegate;

@property (nonatomic) CGFloat floor;
@property (nonatomic) CGFloat ceiling;

-(void)reset;

@end
