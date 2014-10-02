//
//  GAWeatherLayer.m
//  Tappy Plane
//
//  Created by Diego Guajardo on 2/10/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

#import "GAWeatherLayer.h"

@interface GAWeatherLayer ()

@property (nonatomic) SKEmitterNode *rainEmitter;
@property (nonatomic) SKEmitterNode *snowEmitter;

@end

@implementation GAWeatherLayer

- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        _size = size;
        
        //Load rain effect
        NSString *rainEffectPath = [[NSBundle mainBundle] pathForResource:@"RainEffect" ofType:@"sks"];
        _rainEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:rainEffectPath];
        _rainEmitter.position = CGPointMake(size.width * 0.5 + 23, size.height + 5);
        
        //Load rain effect
        NSString *snowEffectPath = [[NSBundle mainBundle] pathForResource:@"SnowEffect" ofType:@"sks"];
        _snowEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:snowEffectPath];
        _snowEmitter.position = CGPointMake(size.width * 0.5, size.height + 5);
        
    }
    
    return self;
    
}

-(void)setConditions:(WeatherType)conditions {
    
    if (_conditions != conditions) {
        
        //Update weather property
        _conditions = conditions;
        
        //Remove existing weather conditions
        [self removeAllChildren];
        
        //Add weather conditions
        switch (conditions) {
            case WeatherRaining:
                [self addChild:self.rainEmitter];
                [self.rainEmitter advanceSimulationTime:5];     //We do this so it is already raining (rather than begining to rain) when the game starts
                break;
                
            case WeatherSnowing:
                [self addChild:self.snowEmitter];
                [self.snowEmitter advanceSimulationTime:5];     //We do this so it is already snowing (rather than begining to snow) when the game starts

                break;
                
            default:
                break;
                
        }
    }
    
}

@end
