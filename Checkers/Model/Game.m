//
//  Game.m
//  Checkers
//
//  Created by DOA Software Mac on 19/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import "Game.h"
#import "NSMutableArray+MultidimensionExtension.h"
#import "Globals.h"

@implementation Game
{
    int turnCounter;
}
- (instancetype)initWithWhitePlayer:(PlayerInGame*)whitePlayer withBlackPlayer:(PlayerInGame*)blackPlayer
{
    self = [super init];
    if (self) {
        _whitePlayer = whitePlayer;
        _blackPlayer = blackPlayer;
        _tiles = [NSMutableArray arrayOfWidth:[Globals NumberOfTilesInXDirection] andHeight:[Globals NumberOfTilesInYDirection]];
        _pieces = [NSMutableArray new];
        _moveSuggestion = [NSMutableArray new];
        _selectedPieceArr = [NSMutableArray new];
        _currentPlayer = whitePlayer;
        
        turnCounter = 0;
    }
    return self;
}

- (int)nextTurn {
    turnCounter++;
    if (turnCounter % 2 == 0)
        _currentPlayer = _whitePlayer;
    else if (turnCounter % 2 == 1)
        _currentPlayer = _blackPlayer;
    
    return turnCounter;
}


@end
