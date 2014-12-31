//
//  IGameState.h
//  Checkers
//
//  Created by Lexicon on 19/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerInGame.h"

@protocol IGameState <NSObject>

- (void)startNewGameWithWhitePlayer:(PlayerInGame*)whitePlayer withBlackPlayer:(PlayerInGame*)blackPlayer withTileHeight:(float)tileHeight withPieceHeight:(float)pieceHeight;

- (void)nextTurn;

- (void)endGame;


@end
