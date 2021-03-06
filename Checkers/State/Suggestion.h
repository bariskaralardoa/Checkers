//
//  Suggestion.h
//  Checkers
//
//  Created by DOA Software Mac on 24/12/14.
//  Copyright (c) 2014 Baro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Suggestion : NSObject

@property(nonatomic) NSInteger curX;
@property(nonatomic) NSInteger curY;
@property(nonatomic, retain) NSString *imageNameStr;

- (instancetype)initWithCurrentX:(NSInteger)curX
                        currentY:(NSInteger)curY
                       imageName:(NSString *)imageNameStr;

@end
