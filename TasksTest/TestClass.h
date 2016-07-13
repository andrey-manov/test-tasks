//
//  TestClass.h
//  TasksTest
//
//  Created by Andrey Manov on 12/07/16.
//  Copyright © 2016 Andrey Manov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ FreqTestCompletionBlock)(char);

@interface TestClass : NSObject

- (void)mostFrequentCharacter2ThreadsWithData:(char*)str ofSize:(int)size completion:(FreqTestCompletionBlock)completion;

@end

char mostFrequentCharacter(char* str, int size);
char mostFrequentCharacterArch(char* str, int size);
void mostFrequentCharacter2Threads(char* str, int size, NSOperationQueue* queue, FreqTestCompletionBlock completion);
void testConverstionCharInt();
void testExpression(int n);
void testUExpression(unsigned int n);