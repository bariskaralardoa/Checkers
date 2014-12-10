//
//  NSMutableArray+MultidimensionExtension.m
//  Liqmo
//
//  Created by Ekincan Karalar on 9/12/12.
//  Copyright (c) 2012 Ekincan Karalar. All rights reserved.
//

#import "NSMutableArray+MultidimensionExtension.h"

@implementation NSMutableArray (MultidimensionExtension)
+ (NSMutableArray *) arrayOfWidth:(NSInteger) width andHeight:(NSInteger) height {
    return [[self alloc] initWithWidth:width andHeight:height];
}

- (id) initWithWidth:(NSInteger) width andHeight:(NSInteger) height {
    if((self = [self initWithCapacity:height])) {
        for(int i = 0; i < height; i++) {
            NSMutableArray *inner = [[NSMutableArray alloc] initWithCapacity:width];
            for(int j = 0; j < width; j++)
                [inner addObject:[NSNull null]];
            [self addObject:inner];
        }
    }
    return self;
}
@end
