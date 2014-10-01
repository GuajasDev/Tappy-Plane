//
//  GAGameOverMenu.m
//  Tappy Plane
//
//  Created by Diego Guajardo on 1/10/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

#import "GAGameOverMenu.h"
#import "GABitmapFontLabel.h"
#import "GAButton.h"

@interface GAGameOverMenu ()

@property (nonatomic) GABitmapFontLabel *scoreText;
@property (nonatomic) GABitmapFontLabel *bestScoreText;

@property (nonatomic) SKSpriteNode *medalDisplay;
@property (nonatomic) SKSpriteNode *gameOverTitle;
@property (nonatomic) SKNode *panelGroup;

@property (nonatomic) GAButton *playButton;

@end

@implementation GAGameOverMenu

-(instancetype)initWithSize:(CGSize)size {
    
    if (self = [super init]) {
        _size = size;
        
        //Get texture atlas
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Graphics"];
        
        //Setup game over title
        _gameOverTitle = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"textGameOver"]];
        _gameOverTitle.position = CGPointMake(size.width * 0.5, size.height - 70);
        [self addChild:_gameOverTitle];
        
        //Setup node to act as group (parent) for panel elements
        _panelGroup = [SKNode node];
        [self addChild:_panelGroup];
        
        //Setup background panel
        SKSpriteNode *panelBackground = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"UIbg"]];
        panelBackground.position = CGPointMake(size.width * 0.5, size.height - 150.0);
        //------- This is setup so the panel does not look stretched out. Comment out and run to see the difference ------
        panelBackground.centerRect = CGRectMake(10 / panelBackground.size.width,    //We need proportions (so bet 0.0 and 1.0)
                                                10 / panelBackground.size.height,
                                                (panelBackground.size.width - 20) / panelBackground.size.width,
                                                (panelBackground.size.height - 20) / panelBackground.size.height);
        //----------------------------------------------------------------------------------------------------------------
        panelBackground.xScale = 175.0 / panelBackground.size.width;
        panelBackground.yScale = 115.0 / panelBackground.size.height;
        [self.panelGroup addChild:panelBackground];
        
        //Setup score title
        SKSpriteNode *scoreTitle = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"textScore"]];
        scoreTitle.anchorPoint = CGPointMake(1.0, 1.0);
        scoreTitle.position = CGPointMake(CGRectGetMaxX(panelBackground.frame) - 20, CGRectGetMaxY(panelBackground.frame) - 10);
        [self.panelGroup addChild:scoreTitle];
        
        //Setup score text label
        _scoreText = [[GABitmapFontLabel alloc] initWithText:@"0" andFontName:@"number"];
        _scoreText.allignment = BitmapFontAllignmentRight;
        _scoreText.position = CGPointMake(CGRectGetMaxX(scoreTitle.frame), CGRectGetMinY(scoreTitle.frame) - 15);
        [_scoreText setScale:0.5];
        [self.panelGroup addChild:_scoreText];
        
        //Setup best score title
        SKSpriteNode *bestTitle = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"textBest"]];
        bestTitle.anchorPoint = CGPointMake(1.0, 1.0);
        bestTitle.position = CGPointMake(CGRectGetMaxX(panelBackground.frame) - 20, CGRectGetMaxY(panelBackground.frame) - 60);
        [self.panelGroup addChild:bestTitle];
        
        //Setup best score text label
        _bestScoreText = [[GABitmapFontLabel alloc] initWithText:@"0" andFontName:@"number"];
        _bestScoreText.allignment = BitmapFontAllignmentRight;
        _bestScoreText.position = CGPointMake(CGRectGetMaxX(bestTitle.frame), CGRectGetMinY(bestTitle.frame) - 15);
        [_bestScoreText setScale:0.5];
        [self.panelGroup addChild:_bestScoreText];
        
        //Setup medal title
        SKSpriteNode *medalTitle = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"textMedal"]];
        medalTitle.anchorPoint = CGPointMake(0.0, 1.0);     //Note anchor point is (0.0, 1.0)
        medalTitle.position = CGPointMake(CGRectGetMinX(panelBackground.frame) + 20, CGRectGetMaxY(panelBackground.frame) - 10);
        [self.panelGroup addChild:medalTitle];
        
        //Setup medal display
        _medalDisplay = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"medalBlank"]];
        _medalDisplay.anchorPoint = CGPointMake(0.5, 1.0);
        _medalDisplay.position = CGPointMake(CGRectGetMidX(medalTitle.frame), CGRectGetMinY(medalTitle.frame) - 15);
        [self.panelGroup addChild:_medalDisplay];
        
        //Setup play button
        _playButton = [GAButton spriteNodeWithTexture:[atlas textureNamed:@"buttonPlay"]];
        _playButton.position = CGPointMake(CGRectGetMidX(panelBackground.frame), CGRectGetMinY(panelBackground.frame) - 25);
        [_playButton setPressedTarget:self withAction:@selector(pressedPlayButton)];
        [self addChild:_playButton];
        
        //Set initial values
        self.medal = MedalNone;
        self.score = 0;
        self.bestScore = 0;
        
    }
    
    return self;
}

-(void)pressedPlayButton {
    
    if (self.delegate) {
        [self.delegate pressedStartNewGameButton];
    }
    
}

-(void)setScore:(NSInteger)score {
    
    _score = score;
    self.scoreText.text = [NSString stringWithFormat:@"%ld", (long)score];
    
}

-(void)setBestScore:(NSInteger)bestScore {
    
    _bestScore = bestScore;
    self.bestScoreText.text = [NSString stringWithFormat:@"%ld", (long)bestScore];
    
}

-(void)setMedal:(MedalType)medal {
    
    _medal = medal;
    switch (medal) {
        case MedalBronze:
            self.medalDisplay.texture = [[SKTextureAtlas atlasNamed: @"Graphics"] textureNamed:@"medalBronze"];
            break;
        case MedalSilver:
            self.medalDisplay.texture = [[SKTextureAtlas atlasNamed: @"Graphics"] textureNamed:@"medalSilver"];
            break;
        case MedalGold:
            self.medalDisplay.texture = [[SKTextureAtlas atlasNamed: @"Graphics"] textureNamed:@"medalGold"];
            break;
        default:
            self.medalDisplay.texture = [[SKTextureAtlas atlasNamed: @"Graphics"] textureNamed:@"medalBlank"];
            break;
    }
    
}

-(void)show {
    
    //Animate game over text
    SKAction *dropGameOverText = [SKAction moveByX:0.0 y: - 100.0 duration:0.5];
    dropGameOverText.timingMode = SKActionTimingEaseOut;
    self.gameOverTitle.position = CGPointMake(self.gameOverTitle.position.x, self.gameOverTitle.position.y + 100);
    [self.gameOverTitle runAction:dropGameOverText];
    
    
    //Animate main menu panel
    SKAction *raisePanel = [SKAction group:@[[SKAction fadeInWithDuration:0.4], //Group performs actions at the same time
                                             [SKAction moveByX:0.0 y:100 duration:0.4]]];
    raisePanel.timingMode = SKActionTimingEaseOut;
    self.panelGroup.alpha = 0.0;
    self.panelGroup.position = CGPointMake(self.panelGroup.position.x, self.panelGroup.position.y - 100);
    //Sequence performs actions one after the other
    [self.panelGroup runAction:[SKAction sequence:@[[SKAction waitForDuration:0.7],raisePanel]]];
    
    //Animate play button
    SKAction *fadeInPlayButton = [SKAction sequence:@[[SKAction waitForDuration:1.2],
                                                      [SKAction fadeInWithDuration:0.4]]];
    self.playButton.alpha = 0.0;
    self.playButton.userInteractionEnabled = NO;
    [self.playButton runAction:fadeInPlayButton completion:^{
        self.playButton.userInteractionEnabled = YES;
    }];
    
}

@end
