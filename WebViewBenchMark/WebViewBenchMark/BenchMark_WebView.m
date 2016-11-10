//
//  BenchMark_WebView.m
//  WebViewBenchMark
//
//  Created by dequanzhu on 2016/11/9.
//  Copyright © 2016年 dequanzhu. All rights reserved.
//

#import "BenchMark_WebView.h"
#import <WebKit/WebKit.h>
#import "BenchMark_Utils.h"

@interface BenchMark_WebView ()<UIWebViewDelegate,WKNavigationDelegate>

@property(nonatomic,strong,readwrite)UIWebView *uiWebView;
@property(nonatomic,strong,readwrite)WKWebView *wkWebView;

@property(nonatomic,assign,readwrite)CFTimeInterval uiTime;
@property(nonatomic,assign,readwrite)CFTimeInterval wkTime;

@property(nonatomic,assign,readwrite)NSInteger testNum;
@property(nonatomic,assign,readwrite)BOOL finishUIWebView;
@property(nonatomic,assign,readwrite)BOOL finishWKWebView;

@end

@implementation BenchMark_WebView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildWebViews];
    
    _testNum = 0;
    _finishUIWebView = NO;
    _finishWKWebView = NO;
    
    [self benchMark:0];
}

-(void)benchMark:(NSInteger)num{
    
    switch (num) {
        case 0:
            NSLog(@"------ begin load html string------");
            [self loadHTMLString];
            break;
        case 1:
            NSLog(@"------ begin reload same html string------");
            [self resetFinishStatus];
            [self loadHTMLString];
            break;
        case 2:
            NSLog(@"------ begin new webView load last html string ------");
            [self resetFinishStatus];
            [self buildWebViews];
            [self loadHTMLString];
            break;
        case 3:
            NSLog(@"------ begin load new html string------");
            [self resetFinishStatus];
            [self loadOtherHTMLString];
            [self loadHTMLString];
            break;
        case 4:
            NSLog(@"------ begin new webView and new html string ------");
            [self resetFinishStatus];
            [self buildWebViews];
            [self loadHTMLString];
            break;
        case 5:
            NSLog(@"------ begin load baidu ------");
            [self resetFinishStatus];
            [self loadqq];
            break;
        case 6:
            NSLog(@"------ reload baidu ------");
            [self resetFinishStatus];
            [self loadqq];
            break;
        case 7:
            NSLog(@"------ reload baidu with new webview------");
            [self resetFinishStatus];
            [self buildWebViews];
            [self loadqq];
            break;
        default:
            break;
    }
}

-(void)buildWebViews{
    
    if (_uiWebView) {
        _uiWebView.delegate = nil;
        _uiWebView = nil;
    }
    
    if (_wkWebView) {
        _wkWebView.navigationDelegate = nil;
        _wkWebView = nil;
    }
    
    _uiWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, (SCREEN_HEIGHT - 20)/2)];
    _uiWebView.delegate = self;
    [self.view addSubview:_uiWebView];
    
    _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, _uiWebView.frame.origin.y +_uiWebView.frame.size.height + 5, SCREEN_WIDTH, (SCREEN_HEIGHT - 20)/2) configuration:[[WKWebViewConfiguration alloc]init]];
    _wkWebView.navigationDelegate = self;
    [self.view addSubview:_wkWebView];
}

-(void)loadHTMLString{
    NSString *string = [BenchMark_Utils pureHTMLString];
    
    _uiTime = CFAbsoluteTimeGetCurrent();
    [_uiWebView loadHTMLString:string baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    
    _wkTime = CFAbsoluteTimeGetCurrent();
    [_wkWebView loadHTMLString:string baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
//    [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:_cssHtmlPath]]];
}

-(void)loadOtherHTMLString{
    
    NSString *string = [BenchMark_Utils otherPureHTMLString];
    
    _uiTime = CFAbsoluteTimeGetCurrent();
    [_uiWebView loadHTMLString:string baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    
    _wkTime = CFAbsoluteTimeGetCurrent();
    [_wkWebView loadHTMLString:string baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    //    [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:_cssHtmlPath]]];
}

-(void)loadqq{
    
    NSURLRequest *req = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://www.apple.com"]];
    
    _uiTime = CFAbsoluteTimeGetCurrent();
    [_uiWebView loadRequest:req];
    
    _wkTime = CFAbsoluteTimeGetCurrent();
    [_wkWebView loadRequest:req];
}

-(void)resetFinishStatus{
    _finishUIWebView = NO;
    _finishWKWebView = NO;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"UIWebView:%@",@(CFAbsoluteTimeGetCurrent() - _uiTime).stringValue);
    _finishUIWebView = YES;
    if (_finishWKWebView) {
        [self benchMark:++_testNum];
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"WKWebView:%@",@(CFAbsoluteTimeGetCurrent() - _wkTime).stringValue);
    _finishWKWebView = YES;
    if (_finishUIWebView) {
        [self benchMark:++_testNum];
    }
}

@end
