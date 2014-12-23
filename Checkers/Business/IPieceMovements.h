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

- (void) createPieceOn:(TileCoordinates *) coord withHeight:(float)height;
- (NSMutableArray *)whitePiecesCoordinates:(TileCoordinates *)coord;
- (void)possibleMoveIndicator:(TileCoordinates *) coord;

- (void)placePossibleMoveImageOnTile:(TileCoordinates *)coord withHeight:(float)height;


@end
