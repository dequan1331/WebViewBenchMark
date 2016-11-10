//
//  BenchMark_LoadLocalFile.m
//  WebViewBenchMark
//
//  Created by dequanzhu on 2016/11/9.
//  Copyright © 2016年 dequanzhu. All rights reserved.
//

#import "BenchMark_LoadLocalFile.h"
#import <WebKit/WebKit.h>
#import "BenchMark_Utils.h"
#import "BenchMark_LocalServer.h"

#define LocalStorageCssKey @"localStorageCssKey"

@interface BenchMark_LoadLocalFile ()<WKNavigationDelegate>


@property(nonatomic,strong,readwrite)UIButton *loadButton;

@property(nonatomic,strong,readwrite)WKWebView *webViewWS;
@property(nonatomic,strong,readwrite)WKWebView *webViewLS;
@property(nonatomic,strong,readwrite)WKWebView *webViewTMP;


@property(nonatomic,assign,readwrite)CFTimeInterval WSTime;
@property(nonatomic,assign,readwrite)CFTimeInterval LSTime;
@property(nonatomic,assign,readwrite)CFTimeInterval TMPTime;

@property(nonatomic,assign,readonly)BOOL firstTime;


@end

@implementation BenchMark_LoadLocalFile

-(void)viewDidLoad{
    [super viewDidLoad];
    
    _firstTime = YES;
    
    [self.view addSubview:({
        _loadButton =[[UIButton alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
        _loadButton.backgroundColor = [UIColor lightGrayColor];
        [_loadButton setTitle:@"点击加载" forState:UIControlStateNormal];
        [_loadButton addTarget:self action:@selector(loadHtmlWithCss) forControlEvents:UIControlEventTouchUpInside];
        _loadButton;
    })];
    
    [self.view addSubview:({
        WKWebViewConfiguration *configuration  = [[WKWebViewConfiguration alloc]init];
        [configuration.userContentController addUserScript:[[WKUserScript alloc] initWithSource:[NSString stringWithFormat:@"var css = localStorage.getItem('%@');var style = document.createElement('style');head = document.head || document.getElementsByTagName('head')[0];style.type = 'text/css';var textNode = document.createTextNode(css);style.appendChild(textNode);head.appendChild(style);",LocalStorageCssKey] injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO]];
        _webViewLS = [[WKWebView alloc]initWithFrame:CGRectMake(0, _loadButton.frame.size.height + _loadButton.frame.origin.y,  SCREEN_WIDTH, (SCREEN_HEIGHT - 104)/3) configuration:configuration];
        _webViewLS.navigationDelegate = self;
        _webViewLS;
    })];
    
    [self.view addSubview:({
        _webViewWS = [[WKWebView alloc]initWithFrame:CGRectMake(0, _webViewLS.frame.size.height + _webViewLS.frame.origin.y+5,  SCREEN_WIDTH , (SCREEN_HEIGHT - 104)/3)];
        _webViewWS.navigationDelegate = self;
        [BenchMark_LocalServer sharedInstance];
        _webViewWS;
    })];
    
    
    [self.view addSubview:({
        _webViewTMP = [[WKWebView alloc]initWithFrame:CGRectMake(0, _webViewWS.frame.size.height + _webViewWS.frame.origin.y+5,  SCREEN_WIDTH, (SCREEN_HEIGHT - 104)/3)];
        _webViewTMP.navigationDelegate = self;
        _webViewTMP;
    })];
}

-(void)loadHtmlWithCss{
    
    __unused NSString *TMPhtmlString =[BenchMark_Utils TMPCSSHTMLString];
    NSString *LShtmlString = [BenchMark_Utils LSCSSHTMLString];
    NSString *WShtmlString = [BenchMark_Utils WSCSSHTMLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[BenchMark_Utils cssHTMLStringPath]]];
    
    _LSTime = CFAbsoluteTimeGetCurrent();
    [_webViewLS loadHTMLString:LShtmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    
    if (_firstTime) {
        NSString *saveLSJs = [NSString stringWithFormat:@"window.localStorage.setItem('%@','%@')",LocalStorageCssKey,[BenchMark_Utils cssString]];
        [_webViewLS evaluateJavaScript:saveLSJs completionHandler:nil];
        _firstTime = NO;
    }
    
    _WSTime = CFAbsoluteTimeGetCurrent();
    [_webViewWS loadHTMLString:WShtmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    
    _TMPTime = CFAbsoluteTimeGetCurrent();
    [_webViewTMP loadRequest:request];
}

#pragma mark - delegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    if (webView == _webViewLS) {
         NSLog(@"webview (LocalStorage) cost ::%@",@(CFAbsoluteTimeGetCurrent() - _LSTime).stringValue );
    }else if (webView == _webViewWS) {
         NSLog(@"webview (WebServer) cost ::%@",@(CFAbsoluteTimeGetCurrent() - _WSTime).stringValue );
    }else{
         NSLog(@"webview (TMPFolder) cost ::%@",@(CFAbsoluteTimeGetCurrent() - _TMPTime).stringValue );
    }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    
    NSURLCredential * credential = [[NSURLCredential alloc] initWithTrust:[challenge protectionSpace].serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
}



@end
