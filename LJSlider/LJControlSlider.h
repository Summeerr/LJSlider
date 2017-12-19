//
//  LJControlSlider.h
//  LJSlider
//
//  Created by L~ing on 1/12/16.
//  Copyright © 2016 com.anjubao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^selectIndexblock)(NSInteger index);
@interface LJControlSlider : UIControl

@property (nonatomic, readonly ) NSInteger section;  //default section = 1;
@property (nullable, nonatomic, strong) UIColor *trackTintColor; //default black
@property (nullable, nonatomic, strong) UIColor *thumbColor;
@property (nullable, nonatomic, strong) UIImage *thumbImage;
@property (nullable, nonatomic, strong) NSArray <__kindof NSString *> *titleArray;  // default @"";
@property (nonatomic ) BOOL isSection; //default isSection  = NO;
@property (nonatomic ) CGFloat progress;
//block回调
@property (nonatomic, copy) selectIndexblock selectIndex;
@end
