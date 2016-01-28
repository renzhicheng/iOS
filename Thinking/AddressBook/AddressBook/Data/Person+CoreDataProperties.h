//
//  Person+CoreDataProperties.h
//  AddressBook
//
//  Created by renzc on 1/28/16.
//  Copyright © 2016 renzc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *singer;
@property (nullable, nonatomic, retain) NSString *songName;
@property (nullable, nonatomic, retain) NSString *photo;

@end

NS_ASSUME_NONNULL_END
