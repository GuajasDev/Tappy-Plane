//
//  GAGameScene.h
//  Tappy Plane
//
//  Created by Diego Guajardo on 5/09/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GACollectable.h"

//GACollectable delegate created in GACollectable. See that class for explanation
@interface GAGameScene : SKScene <SKPhysicsContactDelegate, GACollectableDelegate>

@end
