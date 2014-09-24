//
//  GAScrollingNode.m
//  Tappy Plane
//
//  Created by Diego Guajardo on 23/09/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

#import "GAScrollingNode.h"

@implementation GAScrollingNode

-(void)updateWithTimeElapsed:(NSTimeInterval)timeElapsed {
    
    if (self.scrolling) {
        //timeElapsed will be a fraction of a second, so by multiplying it by the horizontalScrollSpeed we ensure the horizontalScrollSpeed that we set is per second (and not per frame). This way, our scrolling speed is independent of the frame rate
        self.position = CGPointMake(self.position.x + (self.horizontalScrollSpeed * timeElapsed), self.position.y);
    }
    
}

@end
