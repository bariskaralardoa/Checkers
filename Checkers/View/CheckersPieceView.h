//
//  CheckersPieceView.h
//  Checkers
//
//  Created by DOA Software Mac on 10/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Piece.h"

@interface CheckersPieceView : UIView

@property (nonatomic, retain) Piece* pieceInfo;
@property (nonatomic, assign) NSInteger IndexX;
@property (nonatomic, assign) NSInteger IndexY;

- (void)setPieceInfoWithPiece:(Piece*)piece;
- (void) refreshImage;
@end
