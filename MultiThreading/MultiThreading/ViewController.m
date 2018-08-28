//
//  ViewController.m
//  MultiThreading
//
//  Created by honglianglu on 26/03/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSThread *thread;

@end

@implementation ViewController

#pragma mark - GCD

#pragma mark - NSThread

- (void)threadWithStackSize
{
    int array[1024000];
    array[1] = 100;
}

- (void)startThreadWithRunLoop
{
    NSPort *workPort = [NSMachPort port];
    [[NSRunLoop currentRunLoop] addPort:workPort forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
}

- (void)NSObjectInstanceMethod
{
    [self performSelector:@selector(dispatched) withObject:nil];
}

- (void)dispatched
{
    NSLog(@"dispatched");
}

#pragma mark - lifeCycle

- (void)loadView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView reloadData];
    
    self.view = tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSArray *)dataSource
{
    return @[
             @"StackSize",
             @"Start With RunLoop",
             @"performSelector",
             ];
}

#pragma mark - tableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    NSString *result = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = result;
    
    return cell;
}

#pragma mark - tableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadWithStackSize) object:nil];
            // 如果不设置栈区内存大小限制，会有栈区内存溢出，初始为 512KB
            [self.thread setStackSize:2048000];
            [self.thread start];
            break;
        }
        case 1: {
            [self startThreadWithRunLoop];
            break;
        }
        case 2: {
            [self NSObjectInstanceMethod];
            break;
        }
        default:
            break;
    }
}

@end
