//
//  GABitmapFontLabel.h
//  Tappy Plane
//
//  Created by Diego Guajardo on 27/09/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GABitmapFontLabel : SKNode

@property (nonatomic) NSString *fontName;
@property (nonatomic) NSString *text;
@property (nonatomic) CGFloat letterSpacing;

-(instancetype)initWithText:(NSString*)text andFontName:(NSString*)fontName;

@end
