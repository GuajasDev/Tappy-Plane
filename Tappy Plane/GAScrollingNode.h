//
//  GAScrollingNode.h
//  Tappy Plane
//
//  Created by Diego Guajardo on 23/09/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GAScrollingNode : SKNode

@property (nonatomic) CGFloat horizontalScrollSpeed;    //How far should the background scroll per second
@property (nonatomic) BOOL scrolling;   //used to know if we want to scroll or not

-(void)updateWithTimeElapsed:(NSTimeInterval)timeElapsed;

@end
