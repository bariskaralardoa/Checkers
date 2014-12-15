//
//  GameEngne.m
//  Checkers
//
//  Created by DOA Software Mac on 15/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import "GameEngine.h"
#import "NSMutableArray+MultidimensionExtension.h"
#import "TileCoordinates.h"

@interface GameEngine()

@property(strong,nonatomic) NSMutableArray * boardTilesArr;


@end

@implementation GameEngine

//-(void) generateTiles
//{
//    int noOfTilesX = 8;
//    int noOfTilesY = 8;
//    
//    _boardTilesArr = [NSMutableArray arrayOfWidth:noOfTilesX andHeight:noOfTilesY];
//    
//    for(int i=0; i<noOfTilesX; i++)
//    {
//        for(int j=0; j<noOfTilesY; j++){
//            CheckersTileView * tileView = [[CheckersTileView alloc] initWithFrame:CGRectMake((i*37)+i, (j*37)+j, 37, 37)];
//            
//            if((i+j) % 2 == 1)
//            {
//                //                tileView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tile1.png"]];
//                tileView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"whiteBoardSquare"]];
//            }
//            
//            else
//            {
//                //                tileView.backgroundColor = [UIColor colorWithRed:218.0f/255.0f green:234.0f/255.0f blue:254.0f/255.0f alpha:1];
//                tileView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"brownBoardSquare"]];
//                
//            }
//            
//            [self addSubview:tileView];
//            
//            tileView.isClicked = NO;
//            tileView.indexX = i;
//            tileView.indexY = j;
//            tileView.tileCoordinates = [[TileCoordinates alloc] initWithX:i withY:j];
//            _boardTilesArr [i][j] = tileView;
//            
//        }
//    }
//}


@end
