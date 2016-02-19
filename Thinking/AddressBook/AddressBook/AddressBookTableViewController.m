//
//  AddressBookTableViewController.m
//  AddressBook
//
//  Created by renzc on 1/27/16.
//  Copyright © 2016 renzc. All rights reserved.
//

#define ID @"addressBook"

#import "AddressBookTableViewController.h"
#import "AppDelegate.h"
#import "Person.h"
#import "AddSingerTableViewController.h"

@interface AddressBookTableViewController () <NSFetchedResultsControllerDelegate, UISearchBarDelegate>

@property (nonatomic) AppDelegate *appDelegate;

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation AddressBookTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //执行数据
    [self.fetchedResultsController performFetch:NULL];
    NSLog(@"%@",NSHomeDirectory());
}

//控制器跳转调用
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = sender;
    if (![segue.destinationViewController isKindOfClass:[AddSingerTableViewController class]]) {
        return;
    }
    if (indexPath) {
        AddSingerTableViewController *s = segue.destinationViewController;
        //想子类赋值
        s.person = [self.fetchedResultsController.sections[indexPath.section] objects][indexPath.row];
    }
}

#pragma mark - 点击事件

//添加按钮点击
- (IBAction)addSinger:(UIBarButtonItem *)sender {
    //控制器间跳转
    [self performSegueWithIdentifier:@"PersonSegue" sender:nil];
}

//删除数据
- (void)deleteSongsWithName:(NSString *)songName {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"songName = %@",songName];
    fetchRequest.predicate = pred;
    NSArray *tempArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    //遍历数组，找到数据删除。
    for (Person *array in tempArray) {
        [self.managedObjectContext deleteObject:array];
    }
    [self.appDelegate saveContext];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fetchedResultsController.sections[section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    Person *person = [self.fetchedResultsController.sections[indexPath.section] objects][indexPath.row];
    cell.textLabel.text = person.songName;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.fetchedResultsController.sections[section] name];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"PersonSegue" sender:indexPath];
}

//设置编辑模式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//执行编辑模式
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    Person *person = [self.fetchedResultsController.sections[indexPath.section] objects][indexPath.row];
    [self deleteSongsWithName:person.songName];
}

#pragma mark - FetchedResultsController代理

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //判断后给请求的谓词规定key
    if (searchText.length > 0) {
        self.fetchedResultsController.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"singer CONTAINS %@ OR songName CONTAINS %@",searchText,searchText];
    }else {
        self.fetchedResultsController.fetchRequest.predicate = nil;
    }
    [self.fetchedResultsController performFetch:NULL];
    [self.tableView reloadData];
}

#pragma mark - 懒加载

- (AppDelegate *)appDelegate {
    return [UIApplication sharedApplication].delegate;
}

- (NSManagedObjectContext *)managedObjectContext {
    return self.appDelegate.managedObjectContext;
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) return _fetchedResultsController;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    NSSortDescriptor *singerSort = [NSSortDescriptor sortDescriptorWithKey:@"singer" ascending:YES];
    NSSortDescriptor *songSort = [NSSortDescriptor sortDescriptorWithKey:@"songName" ascending:YES];
    fetchRequest.sortDescriptors = @[singerSort, songSort];
    _fetchedResultsController = [[NSFetchedResultsController alloc]
                                 initWithFetchRequest:fetchRequest
                                 managedObjectContext:self.managedObjectContext
                                 sectionNameKeyPath:@"singer"
                                 cacheName:nil];
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}
@end
