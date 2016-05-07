//
//  YHMacro.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/3/28.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#ifndef YHMacro_h
#define YHMacro_h

#define YHMainAppDelegate ((YHAppDelegate *)[UIApplication sharedApplication].delegate)

// 定义颜色
#define RGB(r, g, b) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define RGBAlpha(r, g, b, a) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HexRGBAlpha(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

// 获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

// 角度转弧度
#define DEGREE_TO_RADIAN(D) (D)/ 180.0 * M_PI
// 弧度转角度
#define RADIAN_TO_DEGREE(R) (R)/ M_PI * 180.0

#endif /* YHMacro_h */
