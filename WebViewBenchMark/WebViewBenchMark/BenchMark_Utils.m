//
//  BenchMark_Utils.m
//  WebViewBenchMark
//
//  Created by dequanzhu on 2016/11/9.
//  Copyright © 2016年 dequanzhu. All rights reserved.
//

#import "BenchMark_Utils.h"
#import "BenchMark_LocalServer.h"

#define htmlDomNum 500

@implementation BenchMark_Utils

+(NSString *)pureHTMLString{
    static NSString *string;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableString *htmlString = @"<!DOCTYPE html><html><body>".mutableCopy;
        for (int i = 0; i<htmlDomNum; i++) {
            [htmlString appendString:@"<p>testHTMLString</p>"];
            [htmlString appendString:[NSString stringWithFormat:@"<div>%@</div>",@(CFAbsoluteTimeGetCurrent()).stringValue]];
        }
        [htmlString appendString:@"</body></html>"];
        string = [htmlString copy];
        [string writeToFile:[[self class] pureHTMLStringPath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    });
    return string;
}

+(NSString *)otherPureHTMLString{
    static NSString *string;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableString *htmlString = @"<!DOCTYPE html><html><body>".mutableCopy;
        for (int i = 0; i<htmlDomNum; i++) {
            [htmlString appendString:@"<p>testHTMLString</p>"];
            [htmlString appendString:[NSString stringWithFormat:@"<div>%@</div>",@(CFAbsoluteTimeGetCurrent()).stringValue]];
        }
        [htmlString appendString:@"</body></html>"];
        string = [htmlString copy];
    });
    return string;
}

+(NSString *)WSCSSHTMLString{
    static NSString *string;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableString *htmlString = @"<!DOCTYPE html><html><body>".mutableCopy;
        [htmlString appendString:[NSString stringWithFormat:@"<link rel=\'stylesheet\' type=\'text/css\' href=\'%@\'>",BenchMarkLocalServerURL]];
        for (int i = 0; i<htmlDomNum; i++) {
            [htmlString appendString:@"<p>testHTMLString</p>"];
            [htmlString appendString:[NSString stringWithFormat:@"<div id =\'test_dom_%@\'>%@</div>",@(i).stringValue,@(CFAbsoluteTimeGetCurrent()).stringValue]];
        }
        [htmlString appendString:@"</body></html>"];
        string = [htmlString copy];
    });
    return string;


}
+(NSString *)LSCSSHTMLString{
    static NSString *string;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableString *htmlString = @"<!DOCTYPE html><html><body>".mutableCopy;
        for (int i = 0; i<htmlDomNum; i++) {
            [htmlString appendString:@"<p>testHTMLString</p>"];
            [htmlString appendString:[NSString stringWithFormat:@"<div id =\'test_dom_%@\'>%@</div>",@(i).stringValue,@(CFAbsoluteTimeGetCurrent()).stringValue]];
        }
        [htmlString appendString:@"</body></html>"];
        string = [htmlString copy];
    });
    return string;
}
+(NSString *)TMPCSSHTMLString{
    static NSString *string;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableString *htmlString = @"<!DOCTYPE html><html><body>".mutableCopy;
        [htmlString appendString:@"<link rel=\'stylesheet\' type=\'text/css\' href=\'./index.css\'>"];
        for (int i = 0; i<htmlDomNum; i++) {
            [htmlString appendString:@"<p>testHTMLString</p>"];
            [htmlString appendString:[NSString stringWithFormat:@"<div id =\'test_dom_%@\'>%@</div>",@(i).stringValue,@(CFAbsoluteTimeGetCurrent()).stringValue]];
        }
        [htmlString appendString:@"</body></html>"];
        string = [htmlString copy];
        [string writeToFile:[[self class] cssHTMLStringPath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    });
    return string;
}
+(NSString *)cssString{
    static NSString *string;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *colorArray = @[@"yellow",@"green",@"red",@"blue"];
        NSMutableString *cssString = @"".mutableCopy;
        for (int i = 0; i<htmlDomNum; i++) {
            [cssString appendString:[NSString stringWithFormat:@"#test_dom_%@ {background-color:%@;}",@(i).stringValue,[colorArray objectAtIndex:(i%4)]]];
        }
        string = [cssString copy];
        [string writeToFile:[[self class] cssStringPath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    });
    return string;
}

+(NSString *)pureHTMLStringPath{
    static NSString *string;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *folderPath =  [NSTemporaryDirectory() stringByAppendingPathComponent:@"www"];
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        string = [folderPath stringByAppendingString:@"/pure_index.html"];
    });
    return string;
}
+(NSString *)cssHTMLStringPath{
    static NSString *string;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *folderPath =  [NSTemporaryDirectory() stringByAppendingPathComponent:@"www"];
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        string = [folderPath stringByAppendingString:@"/css_index.html"];
    });
    return string;

}
+(NSString *)cssStringPath{
    static NSString *string;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *folderPath =  [NSTemporaryDirectory() stringByAppendingPathComponent:@"www"];
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        string = [folderPath stringByAppendingString:@"/index.css"];
    });
    return string;
}



@end
