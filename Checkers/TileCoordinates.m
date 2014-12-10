//
//  TileCoordinates.m
//  Chess_Plus
//
//  Created by Lexicon on 29/04/14.
//  Copyright (c) 2014 BarisKaralar. All rights reserved.
//

#import "TileCoordinates.h"

@implementation TileCoordinates
- (instancetype)initWithX:(long)X withY:(long)Y {
    self = [super init];
    if (self) {
        self.x = X;
        self.y = Y;
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *) coder
{
    [coder encodeInt64:self.x forKey:@"X_Key"];
    [coder encodeInt64:self.y forKey:@"Y_Key"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.x = [decoder decodeIntForKey:@"X_Key"];
        self.y = [decoder decodeIntForKey:@"Y_Key"];
    }
    return self;
}

@end
