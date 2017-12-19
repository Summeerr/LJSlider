//
//  LJControlSlider.m
//  LJSlider
//
//  Created by L~ing on 1/12/16.
//  Copyright © 2016 com.anjubao. All rights reserved.
//

#import "LJControlSlider.h"

#ifndef Screen_Width
#define Screen_Width    ([[UIScreen mianScreen] bounds].size.width)
#define Screen_Height   ([[UIScreen mainScreen] bounds].size.height)
#endif

#ifndef LJWidth
#define LJWidth   (self.bounds.size.width)
#endif

#define LJSliderProportion      0.7
#define LJTitleHeight   ((self.bounds.size.height)*(1-LJSliderProportion))
#define LJSliderHeight  ((self.bounds.size.height)*LJSliderProportion)

#ifndef Diameter_Block
#define Diameter_Block  LJSliderHeight
#define Radius_Block    (Diameter_Block/2)
#endif

#define LJLineWidth     (LJWidth - Diameter_Block)
#define LJLineHeight    (LJSliderHeight/16)
@interface LJControlSlider (){
    CGFloat point_x;
    UIImageView *imageView;
    NSMutableArray *titleLabelArray;
    NSInteger sectionIndex;
}
//@property (strong, nonatomic) UIImageView *beginTrackTintImageView;
//@property (strong, nonatomic) UIImageView *endTrackTintImageView;
@property (strong, nonatomic) UIImageView *thumbImageView;
@end
@implementation LJControlSlider

- (instancetype)initWithFrame:(CGRect)frame{
    if (frame.size.height > frame.size.width) {
        frame.size.width = frame.size.height;
    }
    if (self = [super initWithFrame:frame]) {
        // init varialbe
        point_x = 0;
        _section = 0;
        _isSection = NO;
        titleLabelArray = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor clearColor];
        //
        _thumbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Diameter_Block, Diameter_Block)];
        _thumbImageView.center = CGPointMake(point_x+Radius_Block, LJSliderHeight/2 +LJTitleHeight);
        _thumbImageView.layer.cornerRadius = Radius_Block;
        _thumbImageView.layer.masksToBounds = YES;
        _thumbImageView.backgroundColor = [UIColor colorWithRed:17/255.0 green:174/255.0 blue:234/255.0 alpha:1.000];
        [self addSubview:_thumbImageView];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
//    [[UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000] setStroke];
    [[UIColor lightGrayColor]setStroke];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, LJLineHeight);
    CGContextMoveToPoint(context, Radius_Block, LJSliderHeight/2 +LJTitleHeight);
    CGContextAddLineToPoint(context, LJWidth - Radius_Block, LJSliderHeight/2 +LJTitleHeight);
    CGContextStrokePath(context);
    for (NSInteger i = 0; i<_section; i++) {
        CGContextSetLineWidth(context, LJLineHeight);
        CGContextMoveToPoint(context, Radius_Block+i*(LJLineWidth/(_section-1)), LJSliderHeight/2 +LJTitleHeight-Radius_Block/2);
        CGContextAddLineToPoint(context, Radius_Block+i*(LJLineWidth/(_section-1)), LJSliderHeight/2 +LJTitleHeight);
        CGContextStrokePath(context);
    }
}
#pragma mark - get and set method 

- (void)setIsSection:(BOOL)isSection{
    _isSection = isSection;
}

- (void)setTitleArray:(NSArray<__kindof NSString *> *)titleArray{
    
    if (titleArray) {
        NSMutableArray *newTitleArray = [titleArray mutableCopy];
        if (titleArray.count < _section) {
            for (NSInteger i = _section-titleArray.count-1; i <  _section; i++) {
                [newTitleArray addObject:@""];
            }
        }
        _section = titleArray.count;
        UIView *titleBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LJWidth, LJTitleHeight)];
        //    titleBGView.backgroundColor = [UIColor redColor];
        //    NSArray *colorArray = @[[UIColor purpleColor],[UIColor grayColor],[UIColor greenColor],[UIColor brownColor]];
        for (NSInteger i = 0; i< _section; i++) {
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LJLineWidth/(_section-1), LJTitleHeight)];
            //        title.backgroundColor = colorArray[i];
            [titleLabelArray addObject:title];
            title.text = newTitleArray[i];
            title.textAlignment = NSTextAlignmentCenter;
            title.font = [UIFont systemFontOfSize:LJTitleHeight/1.f];
            title.center = CGPointMake(Radius_Block+i*(LJLineWidth/(_section-1)), LJTitleHeight/2);
            [titleBGView addSubview:title];
        }
        [self addSubview:titleBGView];
    }
}
- (void)setProgress:(CGFloat)progress{
    if (progress>1) {
        _progress = 1;
    }
    if (progress<0) {
        _progress = 0;
    }
    point_x =(LJWidth -Diameter_Block)*progress;
    sectionIndex = point_x/((LJWidth -Diameter_Block)/_section);
    [self refreshSlider];
}

#pragma mark - UIControl touch method
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [self calculatePointX:touch];
//    if (sectionIndex >= 4) {
//        return NO;
//    }
    point_x= (LJWidth -Diameter_Block)/(_section-1)*sectionIndex;
    [self refreshSlider];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [self calculatePointX:touch];
    [self refreshSlider];
//    if ((location.x<=(point_x+Diameter_Block)&&location.x>=point_x) && ((location.y<(LJTitleHeight))&&(location.y>(LJSliderHeight+LJTitleHeight)))) {
//    }else{
//        return NO;
//    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [self calculatePointX:touch];
    point_x= (LJWidth -Diameter_Block)/(_section-1)*sectionIndex;
    [self refreshSlider];
    if (self.selectIndex) {
        self.selectIndex(sectionIndex);
    }
}
#pragma mark - refreshSlider setAnimation calculatePointX
-(void)refreshSlider{
    _thumbImageView.center = CGPointMake(point_x+Radius_Block, LJSliderHeight/2 +LJTitleHeight);
    [self setAnimation];
}
-(void) setAnimation{
//    NSLog(@"sectionIndex:%ld",(long)sectionIndex);
    for (NSInteger i=0; i<_section; i++) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        if (i == sectionIndex) {
            [titleLabelArray[i] setCenter:CGPointMake(Radius_Block+i*(LJLineWidth/(_section-1)), LJTitleHeight/2-10)];
        }else{
            [titleLabelArray[i] setCenter:CGPointMake(Radius_Block+i*(LJLineWidth/(_section-1)), LJTitleHeight/2)];
        }
        [UIView commitAnimations];
    }
}
-(void) calculatePointX:(UITouch *)touch {
    CGPoint location = [touch locationInView:self];
    if (location.x<Diameter_Block/2) {
        point_x = 0;
    }else if(location.x > (LJWidth-Diameter_Block/2)){
        point_x = LJWidth -Diameter_Block;
    }else{
        point_x = location.x-Diameter_Block/2;
    }
    sectionIndex = point_x/((LJWidth -Diameter_Block)*1.0/_section);
    if (sectionIndex == _section) {
        sectionIndex = _section - 1;
    }
}
#pragma mark - dealloc method
- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

@end
