//
//  GAWeatherLayer.h
//  Tappy Plane
//
//  Created by Diego Guajardo on 2/10/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSUInteger {
    WeatherClear,
    WeatherRaining,
    WeatherSnowing,
} WeatherType;

@interface GAWeatherLayer : SKNode

@property (nonatomic) CGSize size;
@property (nonatomic) WeatherType conditions;

-(instancetype)initWithSize:(CGSize)size;

@end
