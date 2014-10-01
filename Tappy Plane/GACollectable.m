//
//  GACollectable.m
//  Tappy Plane
//
//  Created by Diego Guajardo on 27/09/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

#import "GACollectable.h"

@implementation GACollectable

-(void)collect {
    
    if (self.delegate) {
        //If we were assigned a delegate, call the wasCollected and pass self as an instance
        [self.delegate wasCollected:self];
    }
    
    [self removeFromParent];   //We were just collected, so remove
    
}

@end
