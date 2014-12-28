//
//  SelectedPieceView.m
//  Checkers
//
//  Created by DOA Software Mac on 28/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import "SelectedPieceView.h"

@interface SelectedPieceView ()

@property (nonatomic) UIImageView* pieceImageView;
@property (nonatomic) UIImage* currentImage;
@end


@implementation SelectedPieceView

- (void)setSelectedPieceInfoWithPiece:(SelectedPiece *) selectedPiece
{
    _selectedPieceInfo = selectedPiece;
    
    _currentImage = [UIImage imageNamed:selectedPiece.imageNameStr];
    _pieceImageView = [[UIImageView alloc] initWithImage:_currentImage];
    _pieceImageView.frame = CGRectMake(0, 0, self.frame.size.height * 1.0, self.frame.size.height * 1.0);
    
    [self addSubview:_pieceImageView];

}

- (NSInteger)indexX
{
    return _selectedPieceInfo.curX;
}

- (NSInteger)indexY
{
    return _selectedPieceInfo.curY;
}


@end
