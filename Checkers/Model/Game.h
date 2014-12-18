//
//  Game.h
//  Checkers
//
//  Created by Lexicon on 19/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerInGame.h"

@interface Game : NSObject

@property (nonatomic) NSMutableArray* Tiles;
@property (nonatomic) NSMutableArray* Pieces;
@property (nonatomic) PlayerInGame* WhitePlayer;
@property (nonatomic) PlayerInGame* BlackPlayer;

- (instancetype)initWithWhitePlayer:(PlayerInGame*)whitePlayer withBlackPlayer:(PlayerInGame*)blackPlayer;

@end
