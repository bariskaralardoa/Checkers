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

//- (void)createPieceOn:(TileCoordinates *) coord withHeight:(float)height;
- (void)possibleMoveIndicator:(TileCoordinates*)coord withHeight:(float)height;
- (void)calculatePossibleMovesWithMoveSuggestionIndicator:(TileCoordinates*)coord withHeight:(float)height isCheckingNextEdiblePossibleMoves:(BOOL)isChecking;
- (void)selectedPieceIndicator:(TileCoordinates*)coord withHeight:(float)height;

- (BOOL)isPossibleEatenArrayEmpty;
//- (void)placePossibleMoveImageOnTile:(TileCoordinates *)coord withHeight:(float)height;

- (NSArray*)getMoveSuggestion;
- (NSArray*)getSelectedPieceArr;

- (void)detectClickedCellStatus:(TileCoordinates*)coord;

- (BOOL)isLegalMove:(TileCoordinates*)coord;

- (void)handleMoveAndCapture:(TileCoordinates*)coord;

- (BOOL)isCellOccupied:(TileCoordinates*)coord;
/// Ekincan-2: Bu metodun adını değiştirsene, array almıyor
- (void)clearIndicatorsWithPossibleEatenAndPossibleMovesArrays:(TileCoordinates*)coord;
@end
