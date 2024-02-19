//
//  ViewController.m
//  TestDemo
//
//  Created by mayao's Mac on 2024/2/19.
//

#import "ViewController.h"
#import <SDWebImage/SDWebImage.h>

@interface ViewController ()
@property (nonatomic, strong) UIImageView *testView1;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [SDImageCache.sharedImageCache.diskCache removeAllData];
    
    
    self.testView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 484, 272)];
    self.testView1.backgroundColor = [UIColor systemGrayColor];
    self.testView1.clipsToBounds = YES;
    [self.view addSubview:self.testView1];
    self.testView1.center = self.view.center;
    
    /// 先让 image2 进入 SDImageCache
    [[SDWebImageManager sharedManager] loadImageWithURL:[[NSBundle mainBundle] URLForResource:@"image2" withExtension:@"png"] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        NSLog(@"load image 2 complete: cacheType - %@", @(cacheType));
    }];
    /// 设置第一张图片，带渐变动画
    [self setFirstImageWithFade];
}

- (void)setFirstImageWithFade {
    self.testView1.sd_imageTransition = [SDWebImageTransition fadeTransitionWithDuration:5];
    [self.testView1 sd_setImageWithURL:[[NSBundle mainBundle] URLForResource:@"image1" withExtension:@"JPG"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        NSLog(@"set image 1 complete: cacheType - %@", @(cacheType));
        /// 设置第二张图片，但是已经在内存所以不带动画
        [self setSecondImageWithoutFade];
    }];
}

- (void)setSecondImageWithoutFade {
    [self.testView1 sd_setImageWithURL:[[NSBundle mainBundle] URLForResource:@"image2" withExtension:@"JPG"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        NSLog(@"set image 2 complete: cacheType - %@", @(cacheType));
    }];
}


@end
