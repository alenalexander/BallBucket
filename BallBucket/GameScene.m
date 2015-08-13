//
//  GameScene.m
//  BallBucket
//
//  Created by QAgate iMac4 on 13/08/15.
//  Copyright (c) 2015 QAgate. All rights reserved.
//

#import "GameScene.h"

@interface GameScene()
@property(nonatomic) SKSpriteNode *bucketnode;
@property(nonatomic) SKSpriteNode *ballnode;
@end

static const uint32_t ballcatgry = 0x1;         // ballcategory = 00000000000000000000000000000001
static const uint32_t bucketctgry = 0x1 << 1;   // bucketcategory = 00000000000000000000000000000010(  '<<' represents left shifted value of ball category)

@implementation GameScene


-(id)initWithSize:(CGSize)size
{
    if(self=[super initWithSize:size])
    {
        self.backgroundColor = [SKColor whiteColor];
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsWorld.contactDelegate = self;
        
        self.bucketnode = [SKSpriteNode spriteNodeWithImageNamed:@"bucketwhite"];
        self.bucketnode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.bucketnode.frame.size];
        self.bucketnode.position = CGPointMake(self.size.width/2 - 100, 10);
        self.bucketnode.xScale = 0.3;
        self.bucketnode.yScale = 0.3;
        self.bucketnode.physicsBody.categoryBitMask = bucketctgry;  // setting category of bucket
        self.bucketnode.physicsBody.contactTestBitMask  = ballcatgry; // registering an interest for notification when the ball touches bucket
        [self addChild:self.bucketnode];
        
        self.ballnode = [SKSpriteNode spriteNodeWithImageNamed:@"ballred"];
        self.ballnode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:15];
        self.ballnode.position = CGPointMake(self.size.width-50 , 50);
        self.ballnode.xScale = 0.2;
        self.ballnode.yScale = 0.2;
        [self addChild:self.ballnode];
        self.ballnode.physicsBody.categoryBitMask = ballcatgry;  // setting category of ball
    }
    return self;
}






//  TOUCH HANDLING METHODS

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    for (UITouch *touch in touches) {
        [super touchesBegan: touches withEvent: event];
        CGPoint location = [touch locationInNode:self];
        CGPoint newpoint = location;
        self.ballnode.physicsBody.affectedByGravity = NO;  // to make the ball alone to remain in air until we release the touch on the ball
        self.ballnode.position = newpoint;
    }
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.ballnode.physicsBody.affectedByGravity = YES;    // applying normal gravity property to ball.So when we release the touch on the ball,it falls down due to gravity
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}



-(void)didBeginContact:(SKPhysicsContact *)contact      // gets invoked when the nodes in the scene get each other in contact
{
    SKPhysicsBody *notball;
   if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
   {
       notball = contact.bodyB;
   }
    else
    {
        notball = contact.bodyA;
    }
    
    if(notball.categoryBitMask == bucketctgry)    // when the ball touches the bucket
    {
        [self.ballnode removeFromParent];         // removing ball from scene
    }
}






@end
