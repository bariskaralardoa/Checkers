//
//  Game.m
//  Checkers
//
//  Created by Lexicon on 19/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import "Game.h"
#import "NSMutableArray+MultidimensionExtension.h"
#import "Globals.h"

@implementation Game

- (instancetype)initWithWhitePlayer:(PlayerInGame*)whitePlayer withBlackPlayer:(PlayerInGame*)blackPlayer
{
    self = [super init];
    if (self) {
        _WhitePlayer = whitePlayer;
        _BlackPlayer = blackPlayer;
        _Tiles = [NSMutableArray arrayOfWidth:[Globals NumberOfTilesInXDirection] andHeight:[Globals NumberOfTilesInYDirection]];
        _Pieces = [NSMutableArray new];
    }
    return self;
}

@end
