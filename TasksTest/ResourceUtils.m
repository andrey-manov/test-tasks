//
//  ResourceUtils.m
//  TasksTest
//
//  Created by Andrey Manov on 12/07/16.
//  Copyright © 2016 Andrey Manov. All rights reserved.
//

#import "ResourceUtils.h"

@implementation ResourceUtils

+ (NSData *)loadResource:(NSString *)resourceName ofType:(NSString *)type {

    NSString *filePath = [[NSBundle bundleForClass:[self class]]
                          pathForResource:resourceName ofType:type];
    NSData *resource = [NSData dataWithContentsOfFile:filePath];

    return resource;
}

@end
