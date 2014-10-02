//
//  GAGameScene.m
//  Tappy Plane
//
//  Created by Diego Guajardo on 5/09/2014.
//  Copyright (c) 2014 Guajas Apps. All rights reserved.
//

#import "GAGameScene.h"
#import "GAPlane.h"
#import "GAScrollingLayer.h"
#import "GAConstants.h"
#import "GAObstacleLayer.h"
#import "GABitmapFontLabel.h"
#import "GATilesetTextureProvider.h"
#import "GAGetReadyMenu.h"

typedef enum : NSUInteger {
    GameReady,
    GameRunning,
    GameOver,
} GameState;

@interface GAGameScene ()   //Created so we can add properties to the GAGameScene

@property (nonatomic) GAPlane *player;
@property (nonatomic) GAScrollingLayer *background;
@property (nonatomic) GAScrollingLayer *foreground;
@property (nonatomic) GAObstacleLayer *obstacles;
@property (nonatomic) GABitmapFontLabel *scoreLabel;
@property (nonatomic) GAGameOverMenu *gameOverMenu;
@property (nonatomic) GAGetReadyMenu *getReadyMenu;

@property (nonatomic) SKNode *world;

@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger bestScore;

@property (nonatomic) GameState gameState;

@end

static const CGFloat kMinFPS = 10.0 / 60.0;     //When scrolling dont ever drop bellow 10 frames per second. Check update method
static NSString *const kGAKeyBestScore = @"BestScore";

@implementation GAGameScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //Used this when setting up to make sure that the size is 568x320 intead of 320x568
        //NSLog(@"Size: %f %f", size.width, size.height);
        
        //Setup background colour to sky blue
        self.backgroundColor = [SKColor colorWithRed:213/255.0 green:237/255.0 blue:247/255.0 alpha:1.0];
        
        //Get atlas
        SKTextureAtlas *graphics = [SKTextureAtlas atlasNamed:@"Graphics"];
        
        //Setup physics
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.5);
        self.physicsWorld.contactDelegate = self;
        
        //Setup world
        _world = [SKNode node];
        [self addChild:_world];
        
        //Setup background (before player so it is behind it)
        NSMutableArray *backgroundTiles = [[NSMutableArray alloc] init];
        for (int i = 0; i < 3; i ++) {  //i < 3 because we only need 3 tiles
            [backgroundTiles addObject:[SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"background"]]];
        }
        _background = [[GAScrollingLayer alloc] initWithTiles:backgroundTiles];
        _background.horizontalScrollSpeed = - 60.0;
        _background.scrolling = YES;
        [_world addChild:_background];
        
        //Setup obstacle layer
        _obstacles = [[GAObstacleLayer alloc] init];
        _obstacles.collectableDelegate = self;
        _obstacles.horizontalScrollSpeed = - 80.0;
        _obstacles.scrolling = YES;
        _obstacles.floor = 0.0;
        _obstacles.ceiling = self.size.height;
        [_world addChild:_obstacles];
        
        //Setup foreground
        _foreground = [[GAScrollingLayer alloc] initWithTiles:@[[self generateGroundTile],
                                                               [self generateGroundTile],
                                                               [self generateGroundTile]]];
        _foreground.horizontalScrollSpeed = - 80.0;
        _foreground.scrolling = YES;
        [_world addChild:_foreground];
        
        //Setup Player
        _player = [[GAPlane alloc] init];
        _player.physicsBody.affectedByGravity = NO;
        [_world addChild:_player];
        
        //Setup score label
        _scoreLabel = [[GABitmapFontLabel alloc] initWithText:@"0" andFontName:@"number"];
        _scoreLabel.position = CGPointMake(self.size.width * 0.5, self.size.height - 100.0);
        _scoreLabel.allignment = BitmapFontAllignmentCenter;
        [self addChild:_scoreLabel];
        
        //Loading up the best score
        self.bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:kGAKeyBestScore]; //Default is 0
        
        //Setup game over menu. It is added as a child to the scene in the Update method
        _gameOverMenu = [[GAGameOverMenu alloc] initWithSize:size];
        _gameOverMenu.delegate = self;
        
        //Setup get ready menu
        _getReadyMenu = [[GAGetReadyMenu alloc] initWithSize:size andPlanePosition:CGPointMake(self.size.width * 0.3, self.size.height * 0.5)];
        [self addChild:_getReadyMenu];
        
        //Start a new game
        [self newGame];

    }
    
    return self;
}

-(SKSpriteNode*)generateGroundTile {
    
    SKTextureAtlas *graphics = [SKTextureAtlas atlasNamed:@"Graphics"];
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"groundGrass"]];
    sprite.anchorPoint = CGPointZero;
    
    //---------- Obtained from dazchong.com/spritekit/ ----------
    // Setup path on the foreground
    CGFloat offsetX = sprite.frame.size.width * sprite.anchorPoint.x;
    CGFloat offsetY = sprite.frame.size.height * sprite.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 402 - offsetX, 17 - offsetY);
    CGPathAddLineToPoint(path, NULL, 372 - offsetX, 35 - offsetY);
    CGPathAddLineToPoint(path, NULL, 329 - offsetX, 33 - offsetY);
    CGPathAddLineToPoint(path, NULL, 287 - offsetX, 10 - offsetY);
    CGPathAddLineToPoint(path, NULL, 236 - offsetX, 13 - offsetY);
    CGPathAddLineToPoint(path, NULL, 217 - offsetX, 29 - offsetY);
    CGPathAddLineToPoint(path, NULL, 184 - offsetX, 29 - offsetY);
    CGPathAddLineToPoint(path, NULL, 154 - offsetX, 22 - offsetY);
    CGPathAddLineToPoint(path, NULL, 124 - offsetX, 32 - offsetY);
    CGPathAddLineToPoint(path, NULL, 78 - offsetX, 30 - offsetY);
    CGPathAddLineToPoint(path, NULL, 45 - offsetX, 14 - offsetY);
    CGPathAddLineToPoint(path, NULL, 2 - offsetX, 17 - offsetY);
    
    sprite.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:path];
    //-----------------------------------------------------------
    sprite.physicsBody.categoryBitMask = kGACategoryGround;
    
    //---------- How to vizualise the edge path ----------
    /*SKShapeNode *bodyShape = [SKShapeNode node];
    bodyShape.path = path;
    bodyShape.strokeColor = [SKColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    bodyShape.lineWidth = 1.0;
    [sprite addChild:bodyShape];*/
    //----------------------------------------------------
    
    return sprite;
    
}

-(void)pressedStartNewGameButton {
    
    SKSpriteNode *blackRectangle = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:self.size];
    blackRectangle.anchorPoint = CGPointZero;
    blackRectangle.alpha = 0;
    [self addChild:blackRectangle];
    
    SKAction *startNewGame = [SKAction runBlock:^{
        [self newGame];
        [self.gameOverMenu removeFromParent];
        [self.getReadyMenu show];
    }];
    
    SKAction *fadeTransition = [SKAction sequence:@[[SKAction fadeInWithDuration:0.4],
                                                    startNewGame,
                                                    [SKAction fadeOutWithDuration:0.6],
                                                    [SKAction removeFromParent]]];
    [blackRectangle runAction:fadeTransition];
    
}

-(void)newGame {
    //Randomise tileset
    [[GATilesetTextureProvider getProvider] randomiseTileset];
    
    //Reset layers
    self.foreground.position = CGPointZero;
    for (SKSpriteNode *node in self.foreground.children) {
        node.texture = [[GATilesetTextureProvider getProvider] getTextureForKey:@"ground"];
    }
    [self.foreground layoutTiles];
    self.obstacles.position = CGPointZero;
    [self.obstacles reset];
    self.obstacles.scrolling = NO;
    self.background.position = CGPointZero;
    [self.background layoutTiles];
    
    //Reset score
    self.score = 0;
    self.scoreLabel.alpha = 1.0;
    
    //Reset plane
    self.player.position = CGPointMake(self.size.width * 0.3, self.size.height * 0.5);
    self.player.physicsBody.affectedByGravity = NO;
    [self.player reset];
    
    //Set game ready state
    self.gameState = GameReady;
    
}

-(void)gameOver {
    
    //Update game state
    self.gameState = GameOver;
    
    //Fade out score display
    [self.scoreLabel runAction:[SKAction fadeOutWithDuration:0.4]];
    
    //Set properties on game menu
    self.gameOverMenu.score = self.score;
    self.gameOverMenu.medal = [self getMedalForCurrentScore];
    
    //Uopdate best score
    if (self.score > self.bestScore) {
        self.bestScore = self.score;
        [[NSUserDefaults standardUserDefaults] setInteger:self.bestScore forKey:kGAKeyBestScore];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    self.gameOverMenu.bestScore = self.bestScore;
    
    //Show game over menu
    [self addChild:self.gameOverMenu];
    [self.gameOverMenu show];
    
}

-(void)wasCollected:(GACollectable *)collectable {
    
    self.score += collectable.pointValue;

}

-(void)setScore:(NSInteger)score {
    
    _score = score;
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)score];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (self.gameState == GameReady) {
        [self.getReadyMenu hide];
        self.player.physicsBody.affectedByGravity = YES;
        self.obstacles.scrolling = YES;
        self.gameState = GameRunning;
    }
    
    //Note that it is not an 'else if'. If it was, we wouldnt accelerate until a second touch event
    if (self.gameState == GameRunning) {
        self.player.accelerating = YES;
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (self.gameState == GameRunning) {
        self.player.accelerating = NO;
    }
    
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    
    //When the plance collides with the ground we pass the responsability of handling the collision to GAPlane (self.player)
    if (contact.bodyA.categoryBitMask == kGACategoryPlane) {
        [self.player collide:contact.bodyB];
    } else if (contact.bodyB.categoryBitMask == kGACategoryPlane) {
        [self.player collide:contact.bodyA];
    }
    
}

-(void)bump {
    
    SKAction *bump = [SKAction sequence:@[[SKAction moveBy:CGVectorMake( - 5,  - 4) duration:0.1],
                                          [SKAction moveTo:CGPointZero duration:0.1]]];
    [self.world runAction:[SKAction sequence:@[bump, bump]]];
    
}

-(void)update:(NSTimeInterval)currentTime {
    
    static NSTimeInterval lastCallTime;
    NSTimeInterval timeElapsed = currentTime - lastCallTime;
    if (timeElapsed > kMinFPS) {
        timeElapsed = kMinFPS;
    }
    lastCallTime = currentTime;
    
    [self.player update];
    
    if (self.gameState == GameRunning && self.player.crashed) {
        
        //Player JUST crashed on the last frame
        [self bump];
        [self gameOver];
    }
    
    if (self.gameState != GameOver) {
        [self.background updateWithTimeElapsed:timeElapsed];
        [self.foreground updateWithTimeElapsed:timeElapsed];
        [self.obstacles updateWithTimeElapsed:timeElapsed];
    }
    
}

-(MedalType)getMedalForCurrentScore {
    
    NSInteger adjustedScore = self.score - (self.bestScore / 5.0);
    
    if (adjustedScore >= 45) {
        return MedalGold;
    } else if (adjustedScore >= 25) {
        return MedalSilver;
    } else if (adjustedScore >= 10) {
        return MedalBronze;
    }
    
    return MedalNone;
    
}

@end
