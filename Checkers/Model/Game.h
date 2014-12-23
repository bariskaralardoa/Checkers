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

@property (nonatomic) NSMutableArray* tiles;
@property (nonatomic) NSMutableArray* pieces;
@property (nonatomic) NSMutableArray* moveSuggestion;

@property (nonatomic) PlayerInGame* whitePlayer;
@property (nonatomic) PlayerInGame* blackPlayer;

- (instancetype)initWithWhitePlayer:(PlayerInGame*)whitePlayer withBlackPlayer:(PlayerInGame*)blackPlayer;

@end
