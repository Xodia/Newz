//
//  Article.h
//  Feedz
//
//  Created by Morgan Collino on 12/7/14.
//  Copyright (c) 2014 Morgan Collino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "HTMLReader.h"

@interface Article : NSObject

@property (nonatomic, strong) NSManagedObject *entity;
@property (nonatomic, copy) NSString *identifier; // Item identifier
@property (nonatomic, copy) NSString *title; // Item title
@property (nonatomic, copy) NSString *link; // Item URL
@property (nonatomic, strong) NSDate *date; // Date the item was published
@property (nonatomic, strong) NSDate *updated; // Date the item was updated if available
@property (nonatomic, copy) NSString *summary; // Description of item
@property (nonatomic, copy) NSString *content; // More detailed content (if available)
@property (nonatomic, copy) NSString *author; // Item author

@property (nonatomic, strong) HTMLDocument *parsedHTML;

- (instancetype) initWithEntity: (NSManagedObject *) object;

@end
