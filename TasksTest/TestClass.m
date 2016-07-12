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