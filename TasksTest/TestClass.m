//
//  TestClass.m
//  TasksTest
//
//  Created by Andrey Manov on 12/07/16.
//  Copyright © 2016 Andrey Manov. All rights reserved.
//

#import "TestClass.h"

@implementation TestClass

@end

static char *binrep (NSInteger val, char *buff, int sz) {
    char *pbuff = buff;
    
    /* Must be able to store one character at least. */
    if (sz < 1) return NULL;
    
    /* Special case for zero to ensure some output. */
    if (val == 0) {
        *pbuff++ = '0';
        *pbuff = '\0';
        return buff;
    }
    
    /* Work from the end of the buffer back. */
    pbuff += sz;
    *pbuff-- = '\0';
    
    /* For each bit (going backwards) store character. */
    while (val != 0) {
        if (sz-- == 0) return NULL;
        *pbuff-- = ((val & 1) == 1) ? '1' : '0';
        
        /* Get next bit. */
        val >>= 1;
    }
    return pbuff+1;
}

char mostFrequentCharacter(char* str, int size) {
    
//    sleep(3);
    
    NSLog(@"UCHAR_MAX %d", UCHAR_MAX);
    int *charsMap = malloc(sizeof(int) * UCHAR_MAX);
    memset(charsMap, 0, sizeof(int) * UCHAR_MAX);
    
    for(int i = 0; i < size; i++) {
        char c =  str[i];
        charsMap[c] = charsMap[c] + 1;
        
        // opt 1
//        maxCount
    }
    
    int maxCount = 0;
    char maxIndex = 0;
    for (int i = 0; i < UCHAR_MAX; i++) {
        if (charsMap[i] > maxCount) {
            maxCount = charsMap[i];
            maxIndex = i;
        }
    }
    
    NSLog(@"%c %d, count %d", maxIndex, maxIndex, maxCount);
    
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
    
    NSLog(@" multiplier %d, modulo %d, fullWordsCount %d", multiplier, modulo, fullWordsCount);
    NSLog(@"int size %lu, min %d, max %d", sizeof(int), INT_MIN, INT_MAX);
    
    BOOL is32bit = modulo == 4;
    
    NSLog(@"UCHAR_MAX %d", UCHAR_MAX);
    int *charsMap = malloc(sizeof(int) * UCHAR_MAX);
    memset(charsMap, 0, sizeof(int) * UCHAR_MAX);
    
    for(int i = modulo; i > 0; i--) {
        char c =  str[i];
        charsMap[c] = charsMap[c] + 1;
    }
    
            char partToPrint[105];
    
    char c0;
    char c1;
    char c2;
    char c3;
    char c4;
    char c5;
    char c6;
    char c7;
    
    char buff[64+1];
    
    NSInteger n;
    
            for(int i = 0; i<104; i++) {
                n = words[i];
                
                c0 = (n >> 56) & 0xFF;
                partToPrint[i] = c0;
                
                c1 = (n >> 48) & 0xFF;
                partToPrint[i+1] = c1;
                
                c2 = (n >> 40) & 0xFF;
                partToPrint[i+2] = c2;
                
                c3 = (n >> 32) & 0xFF;
                partToPrint[i+3] = c3;
                
                c4 = (n >> 24) & 0xFF;
                partToPrint[i+4] = c4;
                
                c5 = (n >> 16) & 0xFF;
                partToPrint[i+5] = c5;
                
                c6 = (n >> 8) & 0xFF;
                partToPrint[i+6] = c6;
                
                c7 = n & 0xFF;
                partToPrint[i+7] = c7;
                
                NSLog(@"%s", binrep(n, buff, 64));
                NSLog(@"%x %x %x %x %x %x %x %x", c0, c1, c2, c3, c4, c5, c6, c7);
            }
            partToPrint[104] = '\0';
    
            NSLog(@"%s", partToPrint);
            NSLog(@"=====");
            NSLog(@"%@",[NSString stringWithCString:partToPrint encoding:NSWindowsCP1251StringEncoding]);
    
    char c;
//    NSInteger n;
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
    
    NSLog(@"%c %d, count %d", maxIndex, maxIndex, maxCount);
    
    free(charsMap);
    
    return maxIndex;
}
