//
//  ViewController.m
//  ThanosSnapFingers
//
//  Created by sidney on 2019/4/27.
//  Copyright © 2019 sidney. All rights reserved.
//

#import "ViewController.h"
#import "CellMightDisapper.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController {
    
    NSTimer *timer;
    int i;
    NSMutableArray *randomArray;
}

- (IBAction)snapFingers:(id)sender {
    randomArray = @[].mutableCopy;
    randomArray  = [self getRandom];
    
    i = 0;
    
    NSNumber *index = [randomArray objectAtIndex:i];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[index integerValue]inSection:0];

    CellMightDisapper *cell = [_tableView cellForRowAtIndexPath:indexPath];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [UIView animateWithDuration:1.0 animations:^{
        cell.labelmd.alpha = 0;
        cell.imagemd.alpha = 0;
//        cell.backgroundColor = [UIColor lightGrayColor];
    } completion:^(BOOL finished) {
        [cell.labelmd removeFromSuperview];
        [cell.imagemd removeFromSuperview];
//        timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextOne) userInfo:nil repeats:YES];
//        [[NSRunLoop mainRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
        i++;
//        [self nextOne];
    }];
    
}

- (void)nextOne {
    
    NSNumber *index = [randomArray objectAtIndex:i];
    NSLog(@"%d",[index integerValue]);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[index integerValue] inSection:0];
    
    CellMightDisapper *cell = [_tableView cellForRowAtIndexPath:indexPath];
      [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [UIView animateWithDuration:1.0 animations:^{
//        [self setupELayerWithCell:cell];
        cell.labelmd.alpha = 0;
        cell.imagemd.alpha = 0;
//        cell.backgroundColor = [UIColor lightGrayColor];

    } completion:^(BOOL finished) {
        [cell.labelmd removeFromSuperview];
        [cell.imagemd removeFromSuperview];
    }];
    
    i++;
    if (i > 9) {
        [timer invalidate];
        timer = nil;
    }
}



- (NSMutableArray *)getRandom {
    
    NSMutableArray *resultArr = @[].mutableCopy;
    
    for (int i = 0; i < 10000; i++) {
        NSInteger x = arc4random() % 20;
        if (![resultArr containsObject:@(x)]) {
            [resultArr addObject:@(x)];
            if (resultArr.count > 9) {
                break;
            }
        }
    }
    
    return resultArr;
}


- (void)setupELayerWithCell:(CellMightDisapper *)mCell {
    
    // 1.创建发射器
    CAEmitterLayer *emitter = [[CAEmitterLayer alloc]init];
    
    // 2.设置发射器的位置
    emitter.emitterPosition = CGPointMake(mCell.labelmd.center.x, mCell.labelmd.center.x);
    
    // 3.开启三维效果--可以关闭三维效果看看
    emitter.preservesDepth = YES;
    
    // 4.创建粒子, 并且设置粒子相关的属性
    // 4.1.创建粒子Cell
    CAEmitterCell *cell = [[CAEmitterCell alloc]init];
    
    // 4.2.设置粒子速度
    cell.velocity = 150;
    //速度范围波动50到250
    cell.velocityRange = 100;
    
    // 4.3.设置粒子的大小
    //一般我们的粒子大小就是图片大小， 我们一般做个缩放
    cell.scale = 0.7;
    
    //粒子大小范围: 0.4 - 1 倍大
    cell.scaleRange = 0.3;
    
    // 4.4.设置粒子方向
    //这个是设置经度，就是竖直方向 --具体看我们下面图片讲解
    //这个角度是逆时针的，所以我们的方向要么是 (2/3 π)， 要么是 (-π)
    cell.emissionLongitude = M_PI *2/3;
    cell.emissionRange = M_PI_2 / 4;
    
    // 4.5.设置粒子的存活时间
    cell.lifetime = 2;
    cell.lifetimeRange = 1.5;
    // 4.6.设置粒子旋转
    cell.spin = M_PI_2;
    cell.spinRange = M_PI_2 / 2;
    // 4.6.设置粒子每秒弹出的个数
    cell.birthRate = 20;
    // 4.7.设置粒子展示的图片 --这个必须要设置为CGImage
    cell.contents = (__bridge id _Nullable)([UIImage imageNamed:@"灰.png"].CGImage);
    // 5.将粒子设置到发射器中--这个是要放个数组进去
    emitter.emitterCells = @[cell];
    // 6.将发射器的layer添加到父layer中
    [mCell.labelmd.layer addSublayer:emitter];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"CellMightDisapper" bundle:nil] forCellReuseIdentifier:@"cellMightDisapper"];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 20;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellMightDisapper *cell = [tableView dequeueReusableCellWithIdentifier:@"cellMightDisapper"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 91;
}

@end
