//
//  ResourceUtils.h
//  TasksTest
//
//  Created by Andrey Manov on 12/07/16.
//  Copyright © 2016 Andrey Manov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResourceUtils : NSObject

+ (NSData *)loadResource:(NSString *)resourceName ofType:(NSString *)type;

@end
