//
//  MacroNotification.h
//  Maria
//
//  Created by majinyu on 15/6/1.
//  Copyright (c) 2015年 com.majinyu. All rights reserved.
//




//更新地址_注册
#define k_Notification_UpdateUserAddressInfo_Register  @"k_Notification_UpdateUserAddressInfo_Register"
//更新地址_首页
#define k_Notification_UpdateUserAddressInfo_Home      @"k_Notification_UpdateUserAddressInfo_Home"
//更新用户选择的照片_配件添加页面
#define k_Notification_UpdateUserSeletedPhotos_MyShop  @"k_Notification_UpdateUserSeletedPhotos_MyShop"

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self
#define kScreen_Height      ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width       ([UIScreen mainScreen].bounds.size.width)
#define kScreen_Frame       (CGRectMake(0, 0 ,kScreen_Width,kScreen_Height))
#define kNotiCenter [NSNotificationCenter defaultCenter]









