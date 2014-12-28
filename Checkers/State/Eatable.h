//
//  Eatable.h
//  Checkers
//
//  Created by DOA Software Mac on 28/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TileCoordinates.h"

@interface Eatable : NSObject

@property (nonatomic,strong) TileCoordinates * coordinatesOfCapturedPiece;
@property (nonatomic,strong) TileCoordinates * coordinateOfPossibleMove;

- (instancetype)initWithCapturedPiece:(TileCoordinates * )coordinatesOfCapturedPiece possibleMoves:(TileCoordinates * )coordinateOfPossibleMove;

@end
