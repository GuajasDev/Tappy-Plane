//
//  GAGetReadyMenu.h
//  Tappy Plane
//
//  Created by Diego Guajardo on 1/10/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GAGetReadyMenu : SKNode

@property (nonatomic) CGSize size;

-(instancetype)initWithSize:(CGSize)size andPlanePosition:(CGPoint)planePosition;

-(void)show;
-(void)hide;

@end
