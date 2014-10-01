//
//  GAButton.h
//  Tappy Plane
//
//  Created by Diego Guajardo on 30/09/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GAButton : SKSpriteNode


//This lets us have different buttons each doing different things in this one class, without having to specify one class per button. ReadOnly because that ay we dont set one without the other. They are set in tandem
@property (nonatomic, readonly, weak) id pressedTarget;
@property (nonatomic, readonly) SEL pressedAction;
@property (nonatomic) CGFloat pressedScale;

-(void)setPressedTarget:(id)pressedTarget withAction:(SEL)pressedAction;

//We are overwiting this method. This is how you do that
+(instancetype)spriteNodeWithTexture:(SKTexture *)texture;

@end
