//
//  GATilesetTextureProvider.m
//  Tappy Plane
//
//  Created by Diego Guajardo on 28/09/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

#import "GATilesetTextureProvider.h"

@interface GATilesetTextureProvider ()

@property (nonatomic) NSMutableDictionary *tilesets;
@property (nonatomic) NSDictionary *currentTileset;

@end

@implementation GATilesetTextureProvider

//We end up having the mutable dictionary '_tilesets' that contains dictionaries ("dirt", "ground", "ice", "snow") which each contain textures ("ground", "mountainUp", "mountainDown")

+(instancetype)getProvider {
    
    static GATilesetTextureProvider *provider = nil;
    @synchronized(self) {
        //Everything here is protected from running multiple tims on different threads. We couldnt create two different types of providers if we happen to run this at the same time on different threads, one thread will have to wait
        if (!provider) {
            provider = [[GATilesetTextureProvider alloc] init];
        }
        return provider;
    }
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadTileSets];
        [self randomiseTileset];
    }
    return self;
}

-(void)loadTileSets {
    
    self.tilesets = [[NSMutableDictionary alloc] init];
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Graphics"];
    
    //Get path to property list
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"TileSetGraphics" ofType:@"plist"];
    //Load contents of file
    NSDictionary *tilesetList = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    //Loop through tileset list. Because we have a dictionary containing dictionaries, we have to do two loops.
    for (NSString *tilesetKey in tilesetList) {
        //Get dictionary of texture names
        NSDictionary *textureList = [tilesetList objectForKey:tilesetKey];
        //Create dictionary to hold actual textures (not just texture names)
        NSMutableDictionary *textures = [[NSMutableDictionary alloc] init];
        
        for (NSString *textureKey in textureList) {
            //Get texture for key
            SKTexture *texture = [atlas textureNamed:[textureList objectForKey:textureKey]];
            //Insert texture to textures dictionary
            [textures setObject:texture forKey:textureKey];
        }
        
        //Add textures dictionary to tilesets
        [self.tilesets setObject:textures forKey:tilesetKey];
    }
    
}

-(void)randomiseTileset {
    
    NSArray *tilesetKeys = [self.tilesets allKeys];
    self.currentTilesetName = [tilesetKeys objectAtIndex:arc4random_uniform((uint)[tilesetKeys count])];
    self.currentTileset = [self.tilesets objectForKey:self.currentTilesetName];
    
}

-(SKTexture*)getTextureForKey:(NSString *)key {
    
    return [self.currentTileset objectForKey:key];
    
}

@end
