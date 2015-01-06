//
//  Globals.h
//  Checkers
//
//  Created by DOA Software Mac on 19/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Globals : NSObject

+ (int)NumberOfTilesInXDirection;
+ (int)NumberOfTilesInYDirection;
+ (double)pieceHeightToTileHeightProportion;
//Piece images
+ (NSString *) whiteRegular;
+ (NSString *) whiteChecker;
+ (NSString *) blackRegular;
+ (NSString *) blackChecker;

//Tile images
+ (NSString *) whiteBoardSquare;
+ (NSString *) brownBoardSquare;

//In game images
+ (NSString *) suggest;
+ (NSString *) selectedPiece;
//Documents directory
+ (NSString *)documentsDirectory;
+ (NSString *)dataFilePath;

@end
