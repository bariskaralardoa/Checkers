//
//  Eatable.m
//  Checkers
//
//  Created by DOA Software Mac on 28/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import "Eatable.h"

@implementation Eatable

- (instancetype)initWithCapturedPiece:(TileCoordinates * )coordinatesOfCapturedPiece possibleMoves:(TileCoordinates * )coordinateOfPossibleMove {
    self = [super init];
    if (self) {
        _coordinateOfPossibleMove = [[TileCoordinates alloc] initWithX:coordinateOfPossibleMove.x withY:coordinateOfPossibleMove.y];;
        _coordinatesOfCapturedPiece = [[TileCoordinates alloc] initWithX:coordinatesOfCapturedPiece.x withY:coordinatesOfCapturedPiece.y];
    }
    return self;
}


@end
