//
//  ViewController.m
//  NSSessionNetWorking
//
//  Created by renzc on 2/19/16.
//  Copyright © 2016 renzc. All rights reserved.
//

#import "ViewController.h"
#import "NetWorkingTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"开始");
    //添加地址，可以测试。
    NSString *string = @"";

    [[NetWorkingTool shareNetWorking] GETREquestWithUrlString:string xmlSuccessBlock:^(NSXMLParser *xmlObject, NSDictionary<NSString *,NSString *> *attributeDict) {
        NSLog(@"%@",attributeDict);
    } fauseBlock:^(NSError *error) {
        NSLog(@"no");
    }];
    
}



@end
