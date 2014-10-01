//
//  GAGameOverMenu.h
//  Tappy Plane
//
//  Created by Diego Guajardo on 1/10/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSUInteger {
    MedalNone,
    MedalBronze,
    MedalSilver,
    MedalGold,
} MedalType;

@protocol GAGameOverMenuDelegate <NSObject>

-(void)pressedStartNewGameButton;

@end

@interface GAGameOverMenu : SKNode

@property (nonatomic) CGSize size;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger bestScore;
@property (nonatomic) MedalType medal;
@property (nonatomic, weak) id <GAGameOverMenuDelegate> delegate;

-(instancetype)initWithSize:(CGSize)size;
-(void)show;

@end
