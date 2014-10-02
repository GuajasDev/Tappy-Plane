//
//  GAGetReadyMenu.m
//  Tappy Plane
//
//  Created by Diego Guajardo on 1/10/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

#import "GAGetReadyMenu.h"

@interface GAGetReadyMenu ()

@property (nonatomic) SKSpriteNode *getReadyTitle;
@property (nonatomic) SKNode *tapGroup;

@end

@implementation GAGetReadyMenu

-(instancetype)initWithSize:(CGSize)size andPlanePosition:(CGPoint)planePosition {
    
    if (self = [super init]) {
        _size = size;
        
        //Get graphics atlas
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Graphics"];
        
        //Setup get ready text
        _getReadyTitle = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"textGetReady"]];
        _getReadyTitle.position = CGPointMake(size.width * 0.75, planePosition.y);
        [self addChild:_getReadyTitle];
        
        //Setup group for tap related notes
        _tapGroup = [SKNode node];
        _tapGroup.position = planePosition;
        [self addChild:_tapGroup];
        
        //Setup right tap tag
        SKSpriteNode *rightTapTag = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"tapLeft"]];
        rightTapTag.position = CGPointMake(55, 0);
        [self.tapGroup addChild:rightTapTag];
        
        //Setup left tap tag
        SKSpriteNode *leftTapTag = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"tapRight"]];
        leftTapTag.position = CGPointMake( - 55, 0);
        [self.tapGroup addChild:leftTapTag];
        
        //Create an array of frames for tap animation
        NSArray *tapAnimationFrames = @[[atlas textureNamed:@"tap"],
                                        [atlas textureNamed:@"tapTick"],
                                        [atlas textureNamed:@"tapTick"]];
        
        //Create animation for tap animation
        SKAction *tapAnimation = [SKAction animateWithTextures:tapAnimationFrames timePerFrame:0.5 resize:YES restore:NO];
        
        //Setup tap hand
        SKSpriteNode *tapHand = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"tap"]];
        tapHand.position = CGPointMake(0.0, - 40);
        [self.tapGroup addChild:tapHand];
        [tapHand runAction:[SKAction repeatActionForever:tapAnimation]];
    }
    
    return self;
    
}

-(void)show {
    
    //Reset nodes
    self.tapGroup.alpha = 1.0;
    self.getReadyTitle.position = CGPointMake(self.size.width * 0.75, self.getReadyTitle.position.y);
    
}

-(void)hide {
    
    //Create action to fade tapGroup out
    SKAction *fadeTapGroup = [SKAction fadeOutWithDuration:0.5];
    [self.tapGroup runAction:fadeTapGroup];
    
    //Create actions to slide getReadyText
    SKAction *slideLeft = [SKAction moveByX: - 30 y:0 duration:0.2];
    slideLeft.timingMode = SKActionTimingEaseInEaseOut;
    
    SKAction *slideRight = [SKAction moveToX:self.size.width + (self.getReadyTitle.size.width * 0.5) duration:0.6];
    slideRight.timingMode = SKActionTimingEaseIn;
    
    //Slide get ready text
    [self.getReadyTitle runAction:[SKAction sequence:@[slideLeft, slideRight]]];
    
}

@end
