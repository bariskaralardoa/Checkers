//
//  CheckersPieceView.m
//  Checkers
//
//  Created by DOA Software Mac on 10/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import "CheckersPieceView.h"

@interface CheckersPieceView ()

@property (nonatomic) UIImageView* pieceImageView;
@property (nonatomic) UIImage* currentImage;

@end

@implementation CheckersPieceView

- (void)setPieceInfoWithPiece:(Piece*)piece
{
    _pieceInfo = piece;
    [self setPieceWithImageName:piece.imageNameStr];
}

- (void)setPieceWithImageName:(NSString*)imageName
{
    _currentImage = [UIImage imageNamed:imageName];
    _pieceImageView = [[UIImageView alloc] initWithImage:_currentImage];
    _pieceImageView.frame = CGRectMake(0, 0, self.frame.size.height * 1.0, self.frame.size.height * 1.0);

    [self addSubview:_pieceImageView];
    
}
- (NSInteger)IndexX
{
    return _pieceInfo.currentPositionX;
}

- (NSInteger)IndexY
{
    return _pieceInfo.currentPositionY;
}
@end
