                                                           //
//  CheckersBoardView.m
//  Checkers
//
//  Created by DOA Software Mac on 09/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import "CheckersBoardView.h"
#import "BoardSquareView.h"


@implementation CheckersBoardView

-(instancetype) initWithFrame:(CGRect)frame andBoard: (CheckersBoard *) board;
{
    if (self = [super initWithFrame:frame])
    {
        float rowHeight = frame.size.height/8.0;
        float columnWidth = frame.size.height/8.0;
        
        for (int row = 0; row < 8; row++)
        {
            for (int col = 0; col < 8; col++)
            {
                BoardSquareView * square = [[BoardSquareView alloc] initWithFrame:CGRectMake(col*columnWidth, row*rowHeight, columnWidth, rowHeight) column:col row:row board:board];
                
                [self addSubview:square];
                
            }
        }
        
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}
@end
