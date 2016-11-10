//
//  BenchMark_LocalServer.h
//  WebViewBenchMark
//
//  Created by dequanzhu on 2016/11/9.
//  Copyright © 2016年 dequanzhu. All rights reserved.
//

#import "GCDWebServer.h"


#if TARGET_IPHONE_SIMULATOR
#define BenchMarkLocalServerPort 8080
#define BenchMarkLocalServerURL @"http://127.0.0.1:8080"
#else
#define BenchMarkLocalServerPort 80
#define BenchMarkLocalServerURL @"http://127.0.0.1"
#endif

#define BenchMarkLocalFileRegex @"LocalCSS"

@interface BenchMark_LocalServer : NSObject

+ (instancetype)sharedInstance;

@end
