//
//  SelectedPiece.m
//  Checkers
//
//  Created by DOA Software Mac on 28/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import "SelectedPiece.h"

@implementation SelectedPiece

- (instancetype)initWithCurrentX:(NSInteger)curX
                        currentY:(NSInteger)curY
                       imageName:(NSString *)imageNameStr
{
    
    self = [super init];
    if (self) {
        _curX = curX;
        _curY = curY;
        _imageNameStr = imageNameStr;
    }
    return self;
}


@end
