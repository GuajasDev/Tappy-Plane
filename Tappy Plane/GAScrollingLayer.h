//
//  GAScrollingLayer.h
//  Tappy Plane
//
//  Created by Diego Guajardo on 23/09/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

//----------- Subclass of GAScrollingNode ---------------

#import "GAScrollingNode.h"

@interface GAScrollingLayer : GAScrollingNode

-(id)initWithTiles:(NSArray*)tileSpriteNodes;
-(void)layoutTiles;

@end
