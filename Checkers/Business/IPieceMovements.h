//
//  IPieceMovements.h
//  Checkers
//
//  Created by DOA Software Mac on 22/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TileCoordinates.h"

@protocol IPieceMovements <NSObject>

- (NSArray*)getMoveSuggestion;
- (NSArray*)getSelectedPieceArr;

- (void)calculatePossibleMovesWithMoveSuggestionIndicator:(TileCoordinates*)coord withHeight:(float)height isCheckingNextEdiblePossibleMoves:(BOOL)isChecking;
- (void)setSelectedPieceIndicator:(TileCoordinates*)coord withHeight:(float)height;
- (void)detectClickedCellStatus:(TileCoordinates*)coord;
- (void)handleMoveAndCapture:(TileCoordinates*)coord;
- (void)clearIndicatorsAndArrays;

- (BOOL)isLegalMove:(TileCoordinates*)coord;
- (BOOL)isPossibleEatenArrayEmpty;
- (BOOL)isCellOccupied:(TileCoordinates*)coord;

@end
