//
//  AddSingerTableViewController.m
//  AddressBook
//
//  Created by renzc 1/28/16.
//  Copyright © 2016 renzc. All rights reserved.
//

#import "AddSingerTableViewController.h"
#import "Person.h"
#import "AppDelegate.h"

@interface AddSingerTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *singer;

@property (weak, nonatomic) IBOutlet UITextField *songName;

@property (nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;

@end

@implementation AddSingerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - 调用方法

- (IBAction)saveBtn:(UIBarButtonItem *)sender {
    Person *person;
    if (self.person == nil) {
        person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.appDelegate.managedObjectContext];
    }else{
        person = self.person;
    }
    person.singer = self.singer.text;
    person.songName = self.songName.text;
    
    [self.appDelegate saveContext];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 懒加载

- (AppDelegate *)appDelegate {
    return [UIApplication sharedApplication].delegate;
}
@end
