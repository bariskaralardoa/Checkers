//
//  BoardSquareView.m
//  Checkers
//
//  Created by DOA Software Mac on 03/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import "BoardSquareView.h"

@implementation BoardSquareView
{
    
    NSInteger _row;
    NSInteger _column;
    CheckersBoard * _board;
    
    UIImageView * blackView;
    UIImageView * blackCheckView;
    
    UIImageView * whiteView;
    UIImageView * whiteCheckView;

}



- (instancetype) initWithFrame:(CGRect)frame column:(NSInteger)column row:(NSInteger)row board:(CheckersBoard *)board
{
    self = [super initWithFrame:frame];
    if (self) {
        _row = row;
        _column = column;
        _board = board;
        
        UIImage * blackImage = [UIImage imageNamed:@"siyah-tas.png"];
        blackView = [[UIImageView alloc] initWithImage:blackImage];
        blackView.alpha = 0.0;
        [self addSubview:blackView];
        
        UIImage * blackCheckImage = [UIImage imageNamed:@"siyah-dama.png"];
        blackCheckView = [[UIImageView alloc] initWithImage:blackCheckImage];
        blackCheckView.alpha = 0.0;
        [self addSubview:blackCheckView];
        
        UIImage * whiteImage = [UIImage imageNamed:@"beyaz-tas.png"];
        whiteView = [[UIImageView alloc] initWithImage:whiteImage];
        whiteView.alpha = 0.0;
        [self addSubview:whiteView];
        
        UIImage * whiteCheckImage = [UIImage imageNamed:@"beyaz-dama.png"];
        whiteCheckView = [[UIImageView alloc] initWithImage:whiteCheckImage];
        whiteCheckView.alpha = 0.0;
        [self addSubview:whiteCheckView];
        
        self.backgroundColor = [UIColor clearColor];
        
        [self update];
        
    }
    return self;


}

- (void) update
{
    // show or hide images based on cell state
    BoardCellState state = [_board cellStateAtColumn:_column andRow:_row];
    
    whiteView.alpha = state == BoardCellStateWhitePiece ? 1.0 : 0.0;
    whiteCheckView.alpha = state == BoardCellStateWhiteCheckPiece ? 1.0 : 0.0;
    
    blackView.alpha = state == BoardCellStateBlackPiece ? 1.0 : 0.0;
    blackCheckView.alpha = state == BoardCellStateBlackCheckPiece ? 1.0 : 0.0;
    
}

@end
