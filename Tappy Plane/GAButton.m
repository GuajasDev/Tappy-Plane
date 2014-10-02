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
@property (nonatomic) BOOL pressed;

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
    self.fullSizeFrame = self.frame;
    [self touchesMoved:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        
        if (self.pressed != CGRectContainsPoint(self.fullSizeFrame, [touch locationInNode:self.parent])) {
            
            self.pressed = !self.pressed;
            
            if (self.pressed) {
                //If the location of the touch in the button's parent node (the scene) is inside the button, then:
                [self setScale:self.pressedScale];
                [self.pressedSound play];
            } else {
                [self setScale:1.0];
            }
            
        }
        
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self setScale:1.0];
    self.pressed = NO;
    for (UITouch *touch in touches) {
        if (CGRectContainsPoint(self.fullSizeFrame, [touch locationInNode:self.parent])) {
            //Pressed button
            //Use this because we do not know which selector we are using, so we are sending a message to alert the object that the button had been pressed
            objc_msgSend(self.pressedTarget, self.pressedAction);
        }
    }
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self setScale:1.0];
    self.pressed = NO;
    
}

@end
