//
//  GACollectable.h
//  Tappy Plane
//
//  Created by Diego Guajardo on 27/09/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SoundManager.h"

//Declare our class
@class GACollectable;

//Define the protocol for the delegate
@protocol GACollectableDelegate <NSObject>

//Define the protocol functions that can be used in any class using this delegate
-(void)wasCollected:(GACollectable*)collectable;

@end


@interface GACollectable : SKSpriteNode

//Define delegate property
//Property type id means it can be anything. But we need to make sure that id implements the protocol GACollectableDelegate. A protocol is just a description of some methods or properties (or whatever) that a type that implements it must include. So when we declare the id property we are saying "we need some type returned, we dont care what type, as long as this type has the methods inside the protocol". So if that's the case we can go ahead and use it, so we set that delegate (look down) to point to that object.
//Also, we declared the property as weak because we do not want to have a 'circular reference'. Circular reference is when you have two objects that both point to one another. So if we say addd a collectible to the scene, and then we tell the collectible that the delegate is the scene, then we will have the scene pointing to the collectible and the collectible pointing to the scene. So if we are increasing our reference count for any of these references, we will have the problem that neither can be deallocated all, because they're always gonna point to one another. So by declaring this property as weak, we are not going to increase our reference count to the scene when we set this property. That's why we need to make sure to setup the delegates as weak properties. Look at lecture 197 for review
@property (nonatomic, weak) id <GACollectableDelegate> delegate;

//Define public properties and functions
@property (nonatomic) NSInteger pointValue;
@property (nonatomic) Sound *collectionSound;

-(void)collect;

@end
