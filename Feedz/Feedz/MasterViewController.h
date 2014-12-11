//
//  MasterViewController.h
//  Feedz
//
//  Created by Morgan Collino on 11/18/14.
//  Copyright (c) 2014 Morgan Collino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end

