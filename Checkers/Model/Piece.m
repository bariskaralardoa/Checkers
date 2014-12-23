//
//  Piece.m
//  Checkers
//
//  Created by DOA Software Mac on 10/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import "Piece.h"
#import "Globals.h"

@implementation Piece


- (instancetype)initWithImageName:(NSString *)imageNameStr
                 currentPositionX:(NSInteger)currentPositionX
                 currentPositionY:(NSInteger)currentPositionY
                   playerSideType:(PlayerSideType)sideType
{
    self = [super init];
    if (self) {
        _imageNameStr = imageNameStr;
        _currentPositionX = currentPositionX;
        _currentPositionY = currentPositionY;
        _sideType = sideType;
        
    }
    return self;

}

- (NSMutableArray *) generateMoves
{
    
    return nil;
}


@end
