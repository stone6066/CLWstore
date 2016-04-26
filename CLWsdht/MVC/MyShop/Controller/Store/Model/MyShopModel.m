//
//  MyShopModel.m
//  CLWsdht
//
//  Created by yang on 16/4/14.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "MyShopModel.h"

@implementation MyShopModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

@end
