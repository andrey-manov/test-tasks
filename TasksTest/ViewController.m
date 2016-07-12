//
//  ViewController.m
//  TasksTest
//
//  Created by Andrey Manov on 12/07/16.
//  Copyright © 2016 Andrey Manov. All rights reserved.
//

#import "ViewController.h"
#import "TestClass.h"
#import "ResourceUtils.h"

@interface ViewController () {
    NSDateFormatter* formatter;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

//char mostFrequentCharacter(char* str, int size) {
//    
//    sleep(3);
//    
//    return 0;
//}

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterNoStyle;
    formatter.timeStyle = NSDateFormatterFullStyle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender {
    
    [self.activityIndicator startAnimating];
    self.button.enabled = NO;
    
    __weak typeof(self) wself = self;
    void (^backgroundBlock)(void) = ^{
        
        NSDate* loadingStartDate = [NSDate date];
        NSLog(@"loadingStartDate %@", [formatter stringFromDate:loadingStartDate]);
        
        NSData * rawData;
        
        NSString* resourceFileName = @"WaP1";
        
        rawData = [ResourceUtils loadResource:resourceFileName ofType:@"txt"];
        
        NSMutableData* data = [NSMutableData data];
        
        // make more data
        for(int i = 0; i<100; i++) {
            [data appendData:rawData];
        }
        
        NSUInteger dataLength = [data length];
        
        NSUInteger size =  dataLength / sizeof(unsigned char);
        char* array = (char*) [data bytes];
        
        NSLog(@"data length %lu, sizeof u char %lu, sizeof array %lu", (unsigned long)dataLength, sizeof(unsigned char), (sizeof array));
        NSLog(@"size %lu %i", size, (int)size);
        
        char partToPrint[100];
        for(int i = 0; i<99; i++) {
            partToPrint[i] = array[i];
            NSLog(@"i: %d %x", i, array[i]);
        }
        partToPrint[99] = '\0';
        
        NSLog(@"%s", partToPrint);
        NSLog(@"=====");
        NSLog(@"%@",[NSString stringWithCString:partToPrint encoding:NSWindowsCP1251StringEncoding]);
        
        //    NSString* d = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //    LogDebug(@"Data::: %@", d);
        
        
        NSDate* startDate = [NSDate date];
        NSLog(@"start %@", [formatter stringFromDate:startDate]);
        
//        char string[] = "october";
//        int strSize = 8;
        
//        char c = mostFrequentCharacter(array, (int)size);
//        char c = mostFrequentCharacter(string, strSize);
        
        mostFrequentCharacterArch(array, (int)size);
        
        NSDate* endDate = [NSDate date];
        NSLog(@"end %@", [formatter stringFromDate:endDate]);
        
        NSLog(@"duration %f", [endDate timeIntervalSince1970] - [startDate timeIntervalSince1970]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.activityIndicator stopAnimating];
            wself.button.enabled = YES;
        });
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), backgroundBlock);
}

@end
