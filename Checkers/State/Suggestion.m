//
//  Suggestion.m
//  Checkers
//
//  Created by DOA Software Mac on 24/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import "Suggestion.h"

@implementation Suggestion

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
