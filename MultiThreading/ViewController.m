//
//  ViewController.m
//  MultiThreading
//
//  Created by honglianglu on 26/03/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "ViewController.h"
#import "GCDDemoViewController.h"

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
//    int array[1024000];
    int array[724290];
    array[1] = 100;
}

- (void)startThreadWithRunLoop
{
    //应用场景:经常在后台进行耗时操作,如:监控联网状态,扫描沙盒等 不希望线程处理完事件就销毁,保持常驻状态
    
    //addPort:添加端口(就是source)  forMode:设置模式
    NSPort *workPort = [NSMachPort port];
    [[NSRunLoop currentRunLoop] addPort:workPort forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];

    /*
     //另外两种启动方式
     [NSDate distantFuture]:遥远的未来  这种写法跟上面的run是一个意思
     [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
     
     不设置模式
     [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
     */
}

- (void)stopThreadWithRunLoop
{
    [NSThread exit];
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
             @"Stop With RunLoop",
             @"performSelector",
             @"GCDDemo",
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
//            [self.thread setStackSize:2048000];
            [self.thread start];
            break;
        }
        case 1: {
            [self startThreadWithRunLoop];
            break;
        }
        case 2: {
            [self stopThreadWithRunLoop];
            break;
        }
        case 3: {
            [self NSObjectInstanceMethod];
            break;
        }
        case 4: {
            GCDDemoViewController *GCDViewContrller = [[GCDDemoViewController alloc] init];
            [self.navigationController pushViewController:GCDViewContrller animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
