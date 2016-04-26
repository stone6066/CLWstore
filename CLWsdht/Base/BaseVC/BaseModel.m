//
//  BaseModel.m
//  ceshi1
//
//  Created by mfwl on 16/1/26.
//  Copyright © 2016年 mfwl. All rights reserved.
//

#import "BaseModel.h"
#import "BaseHeader.h"
#import "UserInfo.h"

@implementation BaseModel


- (void)setModel:(BaseModel *)model {
    
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+ (id)modelWithDictionary:(NSDictionary *)dic {
    __strong Class model = [[[self class] alloc] init];
    NSString *mob = dic[@"Mobile"];
    if (mob.length == 0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dic];
        [dict setValue:ApplicationDelegate.userInfo.Mobile forKey:@"Mobile"];
        [model setValuesForKeysWithDictionary:dict];
    } else {
        [model setValuesForKeysWithDictionary:dic];
    }

    return model;
}

@end
