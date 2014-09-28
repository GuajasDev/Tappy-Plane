//
//  GATilesetTextureProvider.h
//  Tappy Plane
//
//  Created by Diego Guajardo on 28/09/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface GATilesetTextureProvider : NSObject

//Singleton. When we call this method, if we do not have an instance then we will set one up, but once we have set one we will return that same one instance. So throughout the different classes in the project, we will be able to call this method against this class and always get back the same instance. Te plus symbol mmeans the method can be called on the class
+(instancetype)getProvider;

-(void)randomiseTileset;
-(SKTexture*)getTextureForKey:(NSString*)key;

@end
