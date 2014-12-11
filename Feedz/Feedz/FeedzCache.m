//
//  FeedzCache.m
//  Feedz
//
//  Created by Morgan Collino on 12/7/14.
//  Copyright (c) 2014 Morgan Collino. All rights reserved.
//

#import "FeedzCache.h"
#import <CoreData/CoreData.h>
#import "Article.h"
#import "AppDelegate.h"

# define SIZE_CACHE 20

@interface FeedzCache () <NSFetchedResultsControllerDelegate>
{
	NSMutableArray *cache; // Containter of SIZE_CACHE nodes maximum
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation FeedzCache

- (NSArray *) cache
{
	@synchronized(cache)
	{
		return cache;
	}
}

- (instancetype) init
{
	if (self = [super init])
	{
		cache = [[NSMutableArray alloc] initWithCapacity: SIZE_CACHE];
		
		AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
		_managedObjectContext = appDelegate.managedObjectContext;
		Article *fakeArticle = [[Article alloc] init];

		/*fakeArticle.title = @"Fake Title";
		fakeArticle.lDescription = @"Petite description";
		fakeArticle.seederId = 0;
		fakeArticle.id_ = 0;
		fakeArticle.content = [NSData dataWithBytes: "toto" length:4];
		fakeArticle.title = @"Fake Title";
		fakeArticle.author = @"Morgan COLLINO";
		fakeArticle.littleImage = @"http://www.google.com/images/toto.jpg";
		fakeArticle.bigImage = @"http://www.google.com/images/toto.jpg";
		fakeArticle.user_id = @"StupidAssBitchId";*/
#warning LOOK INTO HERE ! :) NOt FINISHED ERASE IN PROD
		
		//[self saveArticle: fakeArticle];
		
		
		[self fetchedResultsController];
	}
	return  self;
}

+ (instancetype) sharedCache
{
	static FeedzCache *shared = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		shared = [[FeedzCache alloc] init];
	});
	
	return shared;
}


/**
 *  @brief  This class is made to get articles from the caches. The least 100 of articles are saved.
	We then have a stack which can only store 100 articles in it. To made this,
	we implemented a NSMutableArray (of SIZE_CACHE min of space).
 *  @since 1.0
 */



- (void) insertArticle: (Article *) article
{
	if ([cache containsObject: article])
		return;
	
	// if (cache.count == SIZE_CACHE)
	//	[cache removeObjectAtIndex: 0]; // Remove the first one to erase the oldest article
	[cache addObject: article];
}

- (void) removeArticle: (Article *) article
{
	if ([cache containsObject: article])
		[cache removeObject: article];
}


- (void) saveArticle: (Article *) article
{
	NSError *error;
	NSEntityDescription *newArticle = [NSEntityDescription insertNewObjectForEntityForName: @"Article" inManagedObjectContext: _managedObjectContext];
	
	[newArticle setValue: article.title forKey: @"title"];
	[newArticle setValue: article.lDescription forKey: @"lDescription"];
	[newArticle setValue: @(article.seederId) forKey: @"seeder"];
	[newArticle setValue: article.content forKey: @"content"];
	[newArticle setValue: article.author forKey: @"author"];
	[newArticle setValue: article.images forKey: @"images"];
	[newArticle setValue: article.littleImage forKey: @"littleImage"];
	[newArticle setValue: [NSDate date] forKey: @"timeStamp"];
	[newArticle setValue: @(article.id_) forKey: @"id"];
	[newArticle setValue: article.bigImage forKey: @"bigImage"];
	
	BOOL res = [_managedObjectContext save: &error];
	NSLog(@"DidSaveArticle: %d", res);
	
	[self insertArticle: article];
}

- (void) deleteArticle: (Article *) article
{
	NSError *error;
	[_managedObjectContext deleteObject: article.entity];
	BOOL res = [_managedObjectContext save: &error];
	NSLog(@"DidEraseArticle: %d", res);
	
	[self removeArticle: article];
}



#pragma mark - Fetched results controller

- (NSFetchedResultsController *) fetchResultsWithOffset: (NSInteger) offset
{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Article" inManagedObjectContext:_managedObjectContext];
	[fetchRequest setEntity:entity];
	// Set the batch size to a suitable number == Number of elements to retreive from the database
	[fetchRequest setFetchBatchSize: SIZE_CACHE];
	// Offset > Begin for eg at 20
	[fetchRequest setFetchOffset: offset];
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
	NSArray *sortDescriptors = @[sortDescriptor];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Edit the section name key path and cache name if appropriate.
	// nil for section name key path means "no sections".
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath: nil cacheName:@"Master"];
	aFetchedResultsController.delegate = self;
	self.fetchedResultsController = aFetchedResultsController;
	
	NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error])
	{
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		//abort();
		aFetchedResultsController = nil;
	}
	int i = 0;

	for (id obj in aFetchedResultsController.fetchedObjects)
	{
		NSLog(@"Object retreived(%d): %@ - %@", i++, obj, [obj class]);
		Article *article = [[Article alloc] initWithEntity: obj];
		[cache addObject: article];
	}
	
	return aFetchedResultsController;
}

- (NSFetchedResultsController *)fetchedResultsController
{
	if (_fetchedResultsController != nil) {
		return _fetchedResultsController;
	}
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Article" inManagedObjectContext:_managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Set the batch size to a suitable number == Number of elements to retreive from the database
	[fetchRequest setFetchBatchSize: SIZE_CACHE];
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
	NSArray *sortDescriptors = @[sortDescriptor];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Edit the section name key path and cache name if appropriate.
	// nil for section name key path means "no sections".
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath: nil cacheName:@"Master"];
	aFetchedResultsController.delegate = self;
	self.fetchedResultsController = aFetchedResultsController;
	
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error])
	{
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		//abort();
	}
	
	int i = 0;
	for (id obj in aFetchedResultsController.fetchedObjects)
	{
		NSLog(@"Object retreived(%d): %@", i++, obj);
		Article *article = [[Article alloc] initWithEntity: obj];
		[cache addObject: article];
	}
	NSLog(@"Cache : %@", cache);
	return _fetchedResultsController;
}


@end
