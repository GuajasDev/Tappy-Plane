//
//  GAButton.m
//  Tappy Plane
//
//  Created by Diego Guajardo on 30/09/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

#import "GAButton.h"
#import <objc/message.h>

@interface GAButton ()

@property (nonatomic) CGRect fullSizeFrame;

@end

@implementation GAButton

+(instancetype)spriteNodeWithTexture:(SKTexture *)texture {
    GAButton *instance = [super spriteNodeWithTexture:texture];
    instance.pressedScale = 0.9;
    instance.userInteractionEnabled = YES;
    return instance;
    
}

-(void)setPressedTarget:(id)pressedTarget withAction:(SEL)pressedAction {
    _pressedTarget = pressedTarget;
    _pressedAction = pressedAction;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Something");
    self.fullSizeFrame = self.frame;
    [self touchesMoved:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        if (CGRectContainsPoint(self.fullSizeFrame, [touch locationInNode:self.parent])) {
            //If the location of the touch in the button's parent node (the scene) is inside the button, then:
            [self setScale:self.pressedScale];
        } else {
            [self setScale:1.0];
        }
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self setScale:1.0];
    for (UITouch *touch in touches) {
        if (CGRectContainsPoint(self.fullSizeFrame, [touch locationInNode:self.parent])) {
            //Pressed button
            objc_msgSend(self.pressedTarget, self.pressedAction);
        }
    }
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self setScale:1.0];
    
}

@end
