//
//  GameEngne.h
//  Checkers
//
//  Created by DOA Software Mac on 15/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISetupBoard.h"
#import "IGameState.h"
#import "IPieceMovements.h"

@interface GameEngine : NSObject <ISetupBoard, IGameState, IPieceMovements>
+ (GameEngine*)sharedInstance;
@end
