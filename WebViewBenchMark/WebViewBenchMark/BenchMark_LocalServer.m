//
//  BenchMark_LocalServer.m
//  WebViewBenchMark
//
//  Created by dequanzhu on 2016/11/9.
//  Copyright © 2016年 dequanzhu. All rights reserved.
//

#import "BenchMark_LocalServer.h"
#import "BenchMark_Utils.h"
#import "GCDWebServerDataResponse.h"


@interface BenchMark_LocalServer ()

@property(nonatomic,strong,readwrite)GCDWebServer *server;

@end

@implementation BenchMark_LocalServer

+ (instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        _server = [[GCDWebServer alloc]init];
        
        [_server addDefaultHandlerForMethod:@"GET" requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse *(__kindof GCDWebServerRequest *request) {
                NSData *cssString = [[NSFileManager defaultManager] contentsAtPath:[BenchMark_Utils cssStringPath]];
                GCDWebServerDataResponse *response = [GCDWebServerDataResponse responseWithData:cssString contentType:@"text/css"];
                response.cacheControlMaxAge = 60*60*100;
                response.eTag = @"BenchMarkTestCss";
                return response;
        }];
        __unused BOOL startState =[_server startWithPort:BenchMarkLocalServerPort bonjourName:nil];
    }
    return self;
}

@end
