//
//  NetWorkingTool.m
//  NSSessionNetWorking
//
//  Created by renzc on 2/19/16.
//  Copyright © 2016 renzc. All rights reserved.
//

#import "NetWorkingTool.h"

@interface NetWorkingTool () <NSXMLParserDelegate>

@property (nonatomic)  NSDictionary<NSString *, NSString *> *attributeDict;

@end

@implementation NetWorkingTool

+ (instancetype)shareNetWorking {
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

//POST/GET请求
- (void)requestWithUrlString:(NSString *)urlString method:(requestMethod)method paramaters:(NSDictionary *)paramaters successBlock:(success)successBlock fause:(fause)fauseBlock{
    
    NSURL *url = [NSURL URLWithString:urlString];
    //控制默认超时的响应时间，默认是60秒,并且选择忽略本地缓存。
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    switch (method) {
        case POST:
            request.HTTPMethod = @"POST";
            break;
        case GET:
            request.HTTPMethod = @"GET";
        default:
            break;
    }
    //请求体
    NSData *body = [NSData data];
    //判断paramaters是否存在
    if (paramaters) {
        NSMutableString *paramater = [NSMutableString string];
        [paramaters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            //拼接字符串
            [paramater appendFormat:@"%@=%@&",key,obj];
        }];
        //注意最终地址要去掉多出来的一个&
        NSString *bodyString = [paramater substringToIndex:paramater.length - 1];
        body = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    }
    request.HTTPBody = body;
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //当网络请求成功
        if (data && !error) {
            
            if (successBlock) {
                successBlock(data, response);
            }
        }else {
            if (fauseBlock) {
                fauseBlock(error);
            }
        }
    }] resume];
}

//GET请求并直接做json处理。
- (void)GETRequestWithUrlString:(NSString *)urlString jsonSuccessBlock:(JSONSuccess)jsonSuccessBlock fauseBlock:(fause)fauseBlock {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data && !error) {
            //成功开始json解析
            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
            //回到主线程。
            dispatch_async(dispatch_get_main_queue(), ^{
                if (jsonSuccessBlock) {
                    jsonSuccessBlock(json, response);
                }
            });
        }else {
            if (fauseBlock) {
                fauseBlock(error);
            }
        }
    }] resume];
}

//GET请求并直接做json处理。
- (void)GETREquestWithUrlString:(NSString *)urlString xmlSuccessBlock:(XMLSuccess)xmlSuccessBlock fauseBlock:(fause)fauseBlock {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data && !error) {
            //成功开始json解析
            NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
            //调用代理
            parser.delegate = self;
            [parser parse];
            //回到主线程。
            dispatch_async(dispatch_get_main_queue(), ^{
                if (xmlSuccessBlock) {
                    xmlSuccessBlock(parser, self.attributeDict);
                }
            });
        }else {
            if (fauseBlock) {
                fauseBlock(error);
            }
        }
    }] resume];
}

#pragma mark - 代理

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    self.attributeDict = attributeDict;
}

#pragma mark - 懒加载

- (NSDictionary<NSString *,NSString *> *)attributeDict {
    if (_attributeDict == nil) {
        _attributeDict = [NSDictionary dictionary];
    }
    return _attributeDict;
}

@end
