//
//  SingleCase.h
//  单例的写法
//
//  Created by ●●●●○中国移动 4G on 15/9/23.
//  Copyright (c) 2015年 张猛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleCase : NSObject

@property (nonatomic, copy) NSString *str;

//声明类方法 获取单例的实例对象
+ (SingleCase *) sharedSingleCase;

@end
