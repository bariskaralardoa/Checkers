//
//  TileCoordinates.h
//  Chess_Plus
//
//  Created by Lexicon on 29/04/14.
//  Copyright (c) 2014 BarisKaralar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TileCoordinates : NSObject

- (instancetype)initWithX:(NSInteger)X withY:(NSInteger)Y;

@property(nonatomic) NSInteger x;
@property(nonatomic) NSInteger y;
@end
