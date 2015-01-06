//
//  Piece.h
//  Checkers
//
//  Created by DOA Software Mac on 10/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PlayerSideType) { emptyCell, pieceSideBlack,
    pieceSideWhite };


@interface Piece : NSObject


@property(retain, nonatomic) NSString *imageNameStr;

@property(nonatomic) NSInteger currentPositionX;
@property(nonatomic) NSInteger currentPositionY;
@property(nonatomic) PlayerSideType sideType;

@property(strong, nonatomic) NSMutableArray *possibleMoves;

- (instancetype)initWithImageName:(NSString *)imageNameStr
       currentPositionX:(NSInteger)currentPositionX
       currentPositionY:(NSInteger)currentPositionY
         playerSideType:(PlayerSideType)sideType;


@end
