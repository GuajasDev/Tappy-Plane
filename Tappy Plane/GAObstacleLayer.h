//
//  GAObstacleLayer.h
//  Tappy Plane
//
//  Created by Diego Guajardo on 24/09/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

#import "GAScrollingNode.h"

@interface GAObstacleLayer : GAScrollingNode

@property (nonatomic) CGFloat floor;
@property (nonatomic) CGFloat ceiling;

-(void)reset;

@end
