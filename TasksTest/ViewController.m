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
    TestClass*  testClass;
    NSData*     dataForThreads;
}

@property (strong, atomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *charFrequencyTestBtn;
@property (weak, nonatomic) IBOutlet UIButton *charFrequencyArcOptimizedTestBtn;
@property (weak, nonatomic) IBOutlet UIButton *charFrequency2ThreadsTestBtn;

@end

//char mostFrequentCharacter(char* str, int size) {
//    
//    sleep(3);
//    
//    return 0;
//}

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterNoStyle;
    formatter.timeStyle = NSDateFormatterFullStyle;
    
    testClass = [[TestClass alloc] init];
}

- (void)dealloc
{
    self.activityIndicator = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI aux

- (void)setUIForFrequencyTestProceeding:(BOOL)bProceeding {
    if (bProceeding) {
        [self.activityIndicator startAnimating];
    }
    else {
        [self.activityIndicator stopAnimating];
    }
    
    self.charFrequencyTestBtn.enabled = !bProceeding;
    self.charFrequencyArcOptimizedTestBtn.enabled = !bProceeding;
    self.charFrequency2ThreadsTestBtn.enabled = !bProceeding;
}

#pragma mark - User actions

- (IBAction)testCharFrequencyBtnPressed:(id)sender {
    
    NSLog(@"Simple");
    
    [self setUIForFrequencyTestProceeding:YES];
    
    __weak typeof(self) wself = self;
    void (^backgroundBlock)(void) = ^{
        
        NSData*     data        = [self getTestData];
        NSUInteger  dataLength  = [data length];
        NSUInteger  size        =  dataLength / sizeof(unsigned char);
        char*       array       = (char*) [data bytes];
        
        NSDate* startDate = [NSDate date];
        //        NSLog(@"start %@", [formatter stringFromDate:startDate]);
        
        mostFrequentCharacter(array, (int)size);
        //        mostFrequentCharacter(string, strSize);
        
        NSDate* endDate = [NSDate date];
        //        NSLog(@"end %@", [formatter stringFromDate:endDate]);
        
        NSLog(@"duration %f\n\n", [endDate timeIntervalSince1970] - [startDate timeIntervalSince1970]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself setUIForFrequencyTestProceeding:NO];
        });
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), backgroundBlock);
}

- (IBAction)testCharFrequencyArcOptimizedBtnPressed:(id)sender {
    
    [self setUIForFrequencyTestProceeding:YES];
    
    __weak typeof(self) wself = self;
    void (^backgroundBlock)(void) = ^{
        
        NSLog(@"Architecture optimized");
        
        NSData*     data        = [self getTestData];
        NSUInteger  dataLength  = [data length];
        NSUInteger  size        =  dataLength / sizeof(unsigned char);
        char*       array       = (char*) [data bytes];
        
        NSDate* startDate = [NSDate date];
//        NSLog(@"start %@", [formatter stringFromDate:startDate]);
        
        mostFrequentCharacterArch(array, (int)size);
        
        NSDate* endDate = [NSDate date];
//        NSLog(@"end %@", [formatter stringFromDate:endDate]);
        
        NSLog(@"duration %f\n\n", [endDate timeIntervalSince1970] - [startDate timeIntervalSince1970]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself setUIForFrequencyTestProceeding:NO];
        });
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), backgroundBlock);
}

- (IBAction)testCharFrequency2ThreadsBtnPressed:(id)sender {
    
    NSLog(@"2 NSOperation threads");
    
    [self setUIForFrequencyTestProceeding:YES];
    
    __weak typeof(self) wself = self;
    void (^backgroundBlock)(void) = ^{
        
        dataForThreads          = [NSData dataWithData:[self getTestData]];
        NSData*     data        = dataForThreads;
        NSUInteger  dataLength  = [data length];
        NSUInteger  size        =  dataLength / sizeof(unsigned char);
        char*       array       = (char*) [data bytes];
        
        NSDate* startDate = [NSDate date];
        //        NSLog(@"start %@", [formatter stringFromDate:startDate]);
        
        FreqTestCompletionBlock completion = ^void(char c) {
            
            __strong typeof(wself) sself = wself;
            
            NSDate* endDate = [NSDate date];
            //        NSLog(@"end %@", [formatter stringFromDate:endDate]);
            
            NSLog(@"duration %f\n\n", [endDate timeIntervalSince1970] - [startDate timeIntervalSince1970]);
            
            sself->dataForThreads = nil;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [wself setUIForFrequencyTestProceeding:NO];
            });
        };
        
        [testClass mostFrequentCharacter2ThreadsWithData:array ofSize:(int)size completion:completion];
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), backgroundBlock);
}

- (IBAction)powOf2SignedBtnPressed:(id)sender {

    testExpression(INT_MIN);
    testExpression(-2);
    testExpression(-1);
    testExpression(0);
    testExpression(1);
    testExpression(2);
    testExpression(3);
    testExpression(4);
    testExpression(5);
    testExpression(6);
    testExpression(7);
    testExpression(8);
    testExpression(9);
    testExpression(10);
    testExpression(11);
    testExpression(15);
    testExpression(16);
    testExpression(17);
    testExpression(32);
    testExpression(50);
    testExpression(62);
    testExpression(64);
    testExpression(63);
    testExpression(INT_MAX-1);
    testExpression(INT_MAX);
    testExpression(INT_MAX+1);
    testExpression(UINT_MAX);
}

- (IBAction)powOf2UnsignedBtnPressed:(id)sender {

    testUExpression(INT_MIN);
    testUExpression(-2);
    testUExpression(-1);
    testUExpression(0);
    testUExpression(1);
    testUExpression(2);
    testUExpression(3);
    testUExpression(4);
    testUExpression(5);
    testUExpression(INT_MAX-1);
    testUExpression(INT_MAX);
    testUExpression(INT_MAX+1);
    testUExpression(UINT_MAX);
}

#pragma mark - Aux

- (NSData*)getTestData {
    NSData * rawData;
    
    NSString* resourceFileName = @"WaP1";
    
    rawData = [ResourceUtils loadResource:resourceFileName ofType:@"txt"];
    
    NSMutableData* data = [NSMutableData data];
    
    // Give me more data!
    for(int i = 0; i<100; i++) {
        [data appendData:rawData];
    }
    
//    NSLog(@"data length %lu, sizeof u char %lu, sizeof array %lu", (unsigned long)dataLength, sizeof(unsigned char), (sizeof array));
//    NSLog(@"size %lu %i", size, (int)size);
//    
//    char partToPrint[100];
//    for(int i = 0; i<99; i++) {
//        partToPrint[i] = array[i];
//        NSLog(@"i: %d %x", i, array[i]);
//    }
//    partToPrint[99] = '\0';
//    
//    NSLog(@"%s", partToPrint);
//    NSLog(@"=====");
//    NSLog(@"%@",[NSString stringWithCString:partToPrint encoding:NSWindowsCP1251StringEncoding]);
//    
//    NSString* d = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    LogDebug(@"Data::: %@", d);
    
//    char string[] = "october.october.october.october.october";
//    data = [NSMutableData dataWithBytes:string length:40];
    
    return data;
}

@end
