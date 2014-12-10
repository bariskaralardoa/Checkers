//
//  NSMutableArray+MultidimensionExtension.h
//  Liqmo
//
//  Created by Ekincan Karalar on 9/12/12.
//  Copyright (c) 2012 Ekincan Karalar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (MultidimensionExtension)
+ (NSMutableArray *) arrayOfWidth:(NSInteger) width andHeight:(NSInteger) height;

- (id) initWithWidth:(NSInteger) width andHeight:(NSInteger) height;
@end
