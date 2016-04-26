//
//  SingleCase.m
//  单例的写法
//
//  Created by ●●●●○中国移动 4G on 15/9/23.
//  Copyright (c) 2015年 张猛. All rights reserved.
//

#import "SingleCase.h"

/*
 单例的实现步骤：
    1、首先声明一个公有的类方法，这个类方法  以shared、current、default开头，后面跟上类名 返回当前类的对象
    2、用static关键字声明一个当前类的全局变量对象
    3、实现声明的公有类方法
*/

static SingleCase *singleCase = nil;


@implementation SingleCase

+ (SingleCase *)sharedSingleCase{
    if (singleCase == nil) {
        singleCase = [[SingleCase alloc] init];
    }
    return singleCase;

}

@end
