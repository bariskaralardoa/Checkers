//
//  Globals.m
//  Checkers
//
//  Created by Lexicon on 19/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import "Globals.h"

@implementation Globals
static int _NumberOfTilesInXDirection;
static int _NumberOfTilesInYDirection;
+ (void)initialize
{
    _NumberOfTilesInXDirection = 8;
    _NumberOfTilesInYDirection = 8;
}

+ (int)NumberOfTilesInXDirection
{
    return _NumberOfTilesInXDirection;
}

+ (int)NumberOfTilesInYDirection
{
    return _NumberOfTilesInYDirection;
}


@end
