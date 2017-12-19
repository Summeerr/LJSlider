//
//  ViewController.m
//  LJSlider
//
//  Created by L~ing on 1/12/16.
//  Copyright © 2016 com.anjubao. All rights reserved.
//

#import "ViewController.h"
#import "LJControlSlider.h"

@interface ViewController (){
    UIButton *btn;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    LJControlSlider * slider = [[LJControlSlider alloc] initWithFrame:CGRectMake(10, 50, 355, 40)];
    [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    slider.titleArray = @[@"3",@"10",@"30",@"60"];
    slider.progress = 0.333;
    [self.view addSubview:slider];
    
//    UISlider *testSlider = [[UISlider alloc] initWithFrame:CGRectMake(50, 300, 200, 40)];
//    [self.view addSubview:testSlider];
//
//    UIProgressView *testProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(50, 400, 200, 40)];
//    testProgress.progress = 0.5;
//    [self.view addSubview:testProgress];
    
    
    NSLog(@"view did load");
}

-(void) sliderAction:(LJControlSlider *)slider{
    slider.selectIndex = ^(NSInteger index) {
        NSLog(@"%ld",index);
    };
//    NSLog(@" slider addTarget !!!!\n slider.section:%ld",(long)slider.section);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
