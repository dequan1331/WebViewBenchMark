//
//  BenchMark_Utils.h
//  WebViewBenchMark
//
//  Created by dequanzhu on 2016/11/9.
//  Copyright © 2016年 dequanzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BenchMark_Utils : NSObject


+(NSString *)pureHTMLString;
+(NSString *)otherPureHTMLString;
+(NSString *)cssString;


+(NSString *)WSCSSHTMLString;
+(NSString *)LSCSSHTMLString;
+(NSString *)TMPCSSHTMLString;


+(NSString *)pureHTMLStringPath;
+(NSString *)cssHTMLStringPath;
+(NSString *)cssStringPath;


#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

@end
