//
//  NetWorkingTool.h
//  NSSessionNetWorking
//
//  Created by rezc on 2/19/16.
//  Copyright © 2016 renzc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^success)(NSData *data, NSURLResponse *response);
typedef void(^fause)(NSError *error);
typedef void(^JSONSuccess)(id jsonObject, NSURLResponse *response);
typedef void(^XMLSuccess)(NSXMLParser *xmlObject, NSDictionary<NSString *, NSString *> *attributeDict);

typedef NS_ENUM(NSInteger, requestMethod) {
    POST = 1000,
    GET = 1001
};

@interface NetWorkingTool : NSObject 

//单例
+ (instancetype)shareNetWorking;

//GET和POST请求方法，成功回调success，失败回调fause。
- (void)requestWithUrlString:(NSString *)urlString method:(requestMethod)method paramaters:(NSDictionary *)paramaters successBlock:(success)successBlock fause:(fause)fauseBlock;

//网络请求，默认将数据当做json处理。
- (void)GETRequestWithUrlString:(NSString *)urlString jsonSuccessBlock:(JSONSuccess)jsonSuccessBlock fauseBlock:(fause)fauseBlock;

//网络请求，默认将数据当做xml处理。
- (void)GETREquestWithUrlString:(NSString *)urlString xmlSuccessBlock:(XMLSuccess)xmlSuccessBlock fauseBlock:(fause)fauseBlock;

@end
