//
//  ISetupBoard.h
//  Checkers
//
//  Created by DOA Software Mac on 16/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ISetupBoard <NSObject>
- (NSArray*)getTiles;

- (NSArray*)getPieces;
@end
