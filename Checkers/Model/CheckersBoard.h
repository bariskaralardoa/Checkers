//
//  CheckersBoard.h
//  Checkers
//
//  Created by DOA Software Mac on 03/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import "Board.h"

@interface CheckersBoard : Board

@property (nonatomic) NSInteger whiteScore;
@property (nonatomic) NSInteger blackScore;

//set the board to initial positions
- (void) setToInitialState;


@end
