//
//  GABitmapFontLabel.h
//  Tappy Plane
//
//  Created by Diego Guajardo on 27/09/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSUInteger {
    BitmapFontAllignmentLeft,
    BitmapFontAllignmentCenter,
    BitmapFontAllignmentRight,
} BitmapFontAllignment;

@interface GABitmapFontLabel : SKNode

@property (nonatomic) NSString *fontName;
@property (nonatomic) NSString *text;
@property (nonatomic) CGFloat letterSpacing;
@property (nonatomic) BitmapFontAllignment allignment;

-(instancetype)initWithText:(NSString*)text andFontName:(NSString*)fontName;

@end
