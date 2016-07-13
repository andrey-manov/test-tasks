//
//  TestClass.m
//  TasksTest
//
//  Created by Andrey Manov on 12/07/16.
//  Copyright © 2016 Andrey Manov. All rights reserved.
//

#import "TestClass.h"

@implementation TestClass {
    NSOperationQueue* queue;
    NSData* data1;
    NSData* data2;
}

-(instancetype)init {
    self = [super init];
    
    if(self != nil) {
        queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)mostFrequentCharacter2ThreadsWithData:(char*)str ofSize:(int)size completion:(FreqTestCompletionBlock)completion {
    
    NSBlockOperation* op1 = [NSBlockOperation blockOperationWithBlock:^{
        
        int threadS = size/2;
        NSLog(@"thread size %d", threadS);
        char c;
        
        int *charsMap1 = malloc(sizeof(int) * UCHAR_MAX);
        memset(charsMap1, 0, sizeof(int) * UCHAR_MAX);
        
        for(int i = 0; i < threadS; i++) {
            c = str[i];
            charsMap1[c] = charsMap1[c] + 1;
        }
        
        data1 = [NSData dataWithBytes:charsMap1 length:sizeof(int) * UCHAR_MAX];
        free(charsMap1);
    }];
    
    NSBlockOperation* op2 = [NSBlockOperation blockOperationWithBlock:^{
        char c;
        NSLog(@"size/2 %d, size %d", size/2, size);
        
        int *charsMap2 = malloc(sizeof(int) * UCHAR_MAX);
        memset(charsMap2, 0, sizeof(int) * UCHAR_MAX);
        
        for(int i = size/2; i < size; i++) {
            c = str[i];
            charsMap2[c] = charsMap2[c] + 1;
        }
        
        data2 = [NSData dataWithBytes:charsMap2 length:sizeof(int) * UCHAR_MAX];
        free(charsMap2);
    }];
    
    NSBlockOperation* summarizeOp = [NSBlockOperation blockOperationWithBlock:^{
        
        int  maxCount = 0;
        char maxIndex = 0;
        char tempSum;
        
        NSUInteger size1 = [data1 length] / sizeof(unsigned char);
        char* charsMap1 = (char*) [data1 bytes];
        
        NSUInteger size2 = [data2 length] / sizeof(unsigned char);
        char* charsMap2 = (char*) [data2 bytes];
        
        for (int i = 0; i < UCHAR_MAX; i++) {
            tempSum = charsMap1[i] + charsMap2[i];
            if (tempSum > maxCount) {
                maxCount = tempSum;
                maxIndex = i;
            }
        }
        
        NSLog(@"char:\"%c\" %d, count %d", maxIndex, maxIndex, maxCount);
        
        data1 = nil;
        data2 = nil;
        
        completion(maxIndex);
    }];
    
    [summarizeOp addDependency:op1];
    [summarizeOp addDependency:op2];
    
    [queue addOperation:summarizeOp];
    [queue addOperation:op1];
    [queue addOperation:op2];
}

@end

static char *binrep (NSInteger val, char *buff, int sz) {
    char *pbuff = buff;
    
    /* Must be able to store one character at least. */
    if (sz < 1) return NULL;
    
    /* Special case for zero to ensure some output. */
//    if (val == 0) {
//        *pbuff++ = '0';
//        *pbuff = '\0';
//        return buff;
//    }
    
    /* Work from the end of the buffer back. */
    pbuff += sz;
    *pbuff-- = '\0';
    
    /* For each bit (going backwards) store character. */
    while (true) {
        if (sz-- == 0) {
            break;
        }
        if ((val & 1) == 1) {
            *pbuff-- = '1';
        }
        else {
            *pbuff-- = '0';
        }
        
        
        /* Get next bit. */
        val >>= 1;
    }
    
//    while (val != 0) {
//        if (sz-- == 0) {
//            return NULL;
//        }
//        if ((val & 1) == 1) {
//            *pbuff-- = '1';
//        }
//        else {
//            *pbuff-- = '0';
//        }
//        
//        
//        /* Get next bit. */
//        val >>= 1;
//    }
    
    return pbuff+1;
}

static char *ubinrep (NSUInteger val, char *buff, int sz) {
    char *pbuff = buff;
    
    /* Must be able to store one character at least. */
    if (sz < 1) return NULL;
    
    /* Work from the end of the buffer back. */
    pbuff += sz;
    *pbuff-- = '\0';
    
    /* For each bit (going backwards) store character. */
    while (true) {
        if (sz-- == 0) {
            break;
        }
        if ((val & 1) == 1) {
            *pbuff-- = '1';
        }
        else {
            *pbuff-- = '0';
        }
        
        /* Get next bit. */
        val >>= 1;
    }
    
    return pbuff+1;
}

char mostFrequentCharacter(char* str, int size) {
    
//    NSLog(@"UCHAR_MAX %d", UCHAR_MAX);
    int *charsMap = malloc(sizeof(int) * UCHAR_MAX);
    memset(charsMap, 0, sizeof(int) * UCHAR_MAX);
    
    for(int i = 0; i < size; i++) {
        char c =  str[i];
        charsMap[c] = charsMap[c] + 1;
    }
    
    int maxCount = 0;
    char maxIndex = 0;
    for (int i = 0; i < UCHAR_MAX; i++) {
        if (charsMap[i] > maxCount) {
            maxCount = charsMap[i];
            maxIndex = i;
        }
    }
    
    NSLog(@"char:\"%c\" %d, count %d", maxIndex, maxIndex, maxCount);
    
    free(charsMap);
    
    return maxIndex;
}

//Debug
//
//2016-07-12 17:17:55.265 TasksTest[431:157230] loadingStartDate 17 h 17 min 55 s Moscow Standard Time
//2016-07-12 17:17:55.336 TasksTest[431:157230] data length 147354700, sizeof u char 1, sizeof array 8
//2016-07-12 17:17:55.337 TasksTest[431:157230] size 147354700 147354700
//2016-07-12 17:17:55.337 TasksTest[431:157230] start 17 h 17 min 55 s Moscow Standard Time
//2016-07-12 17:17:55.337 TasksTest[431:157230] UCHAR_MAX 255
//2016-07-12 17:17:56.005 TasksTest[431:157230]   32, count 23276800
//2016-07-12 17:17:56.005 TasksTest[431:157230] end 17 h 17 min 56 s Moscow Standard Time
//2016-07-12 17:17:56.005 TasksTest[431:157230] duration 0.668224
//
//Release
//
//2016-07-12 17:34:21.798 TasksTest[447:159676] loadingStartDate 17 h 34 min 21 s Moscow Standard Time
//2016-07-12 17:34:21.852 TasksTest[447:159676] data length 147354700, sizeof u char 1, sizeof array 8
//2016-07-12 17:34:21.852 TasksTest[447:159676] size 147354700 147354700
//2016-07-12 17:34:21.853 TasksTest[447:159676] start 17 h 34 min 21 s Moscow Standard Time
//2016-07-12 17:34:21.853 TasksTest[447:159676] UCHAR_MAX 255
//2016-07-12 17:34:22.290 TasksTest[447:159676]   32, count 23276800
//2016-07-12 17:34:22.290 TasksTest[447:159676] end 17 h 34 min 22 s Moscow Standard Time
//2016-07-12 17:34:22.291 TasksTest[447:159676] duration 0.437683

char mostFrequentCharacterArch(char* str, int size) {
    
    NSInteger *words = (NSInteger*)str;
    int multiplier = sizeof(NSInteger) / sizeof(char);
    
    int modulo = size % multiplier;
    int fullWordsCount = size / multiplier;
    
    NSLog(@"multiplier %d, modulo %d, fullWordsCount %d", multiplier, modulo, fullWordsCount);
//    NSLog(@"int size %lu, min %d, max %d", sizeof(int), INT_MIN, INT_MAX);
    
    BOOL is32bit = multiplier == 4;
    
//    NSLog(@"UCHAR_MAX %d", UCHAR_MAX);
    int *charsMap = malloc(sizeof(int) * UCHAR_MAX);
    memset(charsMap, 0, sizeof(int) * UCHAR_MAX);
    
    char c;
    for(int i = modulo; i > 0; i--) {
        c =  str[size+i];
        charsMap[c] = charsMap[c] + 1;
    }
    
//    char partToPrint[105];
//    
//    char c0;
//    char c1;
//    char c2;
//    char c3;
//    char c4;
//    char c5;
//    char c6;
//    char c7;
//    
//    char buff[64+1];
//    
    NSInteger n;
//
//            for(int i = 0; i<104; i++) {
//                n = words[i];
//                
//                c0 = (n >> 56) & 0xFF;
//                partToPrint[i] = c0;
//                
//                c1 = (n >> 48) & 0xFF;
//                partToPrint[i+1] = c1;
//                
//                c2 = (n >> 40) & 0xFF;
//                partToPrint[i+2] = c2;
//                
//                c3 = (n >> 32) & 0xFF;
//                partToPrint[i+3] = c3;
//                
//                c4 = (n >> 24) & 0xFF;
//                partToPrint[i+4] = c4;
//                
//                c5 = (n >> 16) & 0xFF;
//                partToPrint[i+5] = c5;
//                
//                c6 = (n >> 8) & 0xFF;
//                partToPrint[i+6] = c6;
//                
//                c7 = n & 0xFF;
//                partToPrint[i+7] = c7;
//                
//                NSLog(@"%s", binrep(n, buff, 64));
//                NSLog(@"%x %x %x %x %x %x %x %x", c0, c1, c2, c3, c4, c5, c6, c7);
//            }
//            partToPrint[104] = '\0';
//    
//            NSLog(@"%s", partToPrint);
//            NSLog(@"=====");
//            NSLog(@"%@",[NSString stringWithCString:partToPrint encoding:NSWindowsCP1251StringEncoding]);
    
    if(is32bit) {
        for(int i = 0; i < fullWordsCount; i++) {
            n = words[i];
            
            c = (n >> 24) & 0xFF;
            charsMap[c] = charsMap[c] + 1;
            c = (n >> 16) & 0xFF;
            charsMap[c] = charsMap[c] + 1;
            c = (n >> 8) & 0xFF;
            charsMap[c] = charsMap[c] + 1;
            c = n & 0xFF;
            charsMap[c] = charsMap[c] + 1;
        }
    }
    else {
        for(int i = 0; i < fullWordsCount; i++) {
            n = words[i];
            
            c = (n >> 56) & 0xFF;
            charsMap[c] = charsMap[c] + 1;
            c = (n >> 48) & 0xFF;
            charsMap[c] = charsMap[c] + 1;
            c = (n >> 40) & 0xFF;
            charsMap[c] = charsMap[c] + 1;
            c = (n >> 32) & 0xFF;
            charsMap[c] = charsMap[c] + 1;
            c = (n >> 24) & 0xFF;
            charsMap[c] = charsMap[c] + 1;
            c = (n >> 16) & 0xFF;
            charsMap[c] = charsMap[c] + 1;
            c = (n >> 8) & 0xFF;
            charsMap[c] = charsMap[c] + 1;
            c = n & 0xFF;
            charsMap[c] = charsMap[c] + 1;
        }
    }
    
    int maxCount = 0;
    char maxIndex = 0;
    for (int i = 0; i < UCHAR_MAX; i++) {
        if (charsMap[i] > maxCount) {
            maxCount = charsMap[i];
            maxIndex = i;
        }
    }
    
    NSLog(@"char:\"%c\" %d, count %d", maxIndex, maxIndex, maxCount);
    
    free(charsMap);
    
    return maxIndex;
}

void testConverstionCharInt() {
    
    char test[] = "abcdefgh";
    test[1] = CHAR_MAX;
    test[2] = CHAR_MIN;
    
    NSString* log16 = @"";
    NSString* log2 = @"";
    
    char buff8[8+1];
    
    for(int i = 0; i<8; i++) {
        log16 = [log16 stringByAppendingString:[NSString stringWithFormat:@"%x ", test[i]]];
        
        log2 = [log2 stringByAppendingString:[NSString stringWithFormat:@"%s ", binrep(test[i], buff8, 8)]];
    }
    NSLog(@"%@", log16);
    NSLog(@"%@", log2);
    
    NSInteger* testI = (NSInteger*)test;
    char buff64[64+1];
    NSLog(@"%s", binrep(testI[0], buff64, 64));
    
    NSInteger n = testI[0];
    
    char testOut[9];
    log16 = @"";
    log2 = @"";
    for(int i = 0, shift = 0; i<8; i++) {
        
        shift+=8;
        testOut[i] = (n >> shift) & 0xFF;
        
        log16 = [log16 stringByAppendingString:[NSString stringWithFormat:@"%x ", testOut[i]]];
        log2 = [log2 stringByAppendingString:[NSString stringWithFormat:@"%s ", binrep(testOut[i], buff8, 8)]];
    }
    NSLog(@"%@", log16);
    NSLog(@"%@", log2);
}

void testExpression(int n) {
    BOOL b = (n & (n - 1)) != 0;
    
    char buff[32+1];
    memset(buff, 0, sizeof(char) * 33);
    NSLog(@"n = %d", n);
    NSLog(@"n \t\t%s", binrep(n, buff, 32));
    memset(buff, 0, sizeof(char) * 33);
    NSLog(@"(n-1) \t%s", binrep((n-1), buff, 32));
    memset(buff, 0, sizeof(char) * 33);
    NSLog(@"n&(n-1) \t%s", binrep((n&(n-1)), buff, 32));
    NSLog(@"RESULT %d\n\n", b);
}

void testUExpression(unsigned int n) {
    BOOL b = (n & (n - 1)) != 0;
    
    char buff[32+1];
    memset(buff, 0, sizeof(char) * 33);
    NSLog(@"n = %u", n);
    NSLog(@"n \t\t%s", ubinrep(n, buff, 32));
    memset(buff, 0, sizeof(char) * 33);
    NSLog(@"(n-1) \t%s", ubinrep((n-1), buff, 32));
    memset(buff, 0, sizeof(char) * 33);
    NSLog(@"n&(n-1) \t%s", ubinrep((n&(n-1)), buff, 32));
    NSLog(@"RESULT %d\n\n", b);
}
