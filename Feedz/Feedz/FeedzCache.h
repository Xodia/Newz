//
//  FeedzCache.h
//  Feedz
//
//  Created by Morgan Collino on 12/7/14.
//  Copyright (c) 2014 Morgan Collino. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Article;

@interface FeedzCache : NSObject


+ (instancetype) sharedCache;


// Utiliser ces methodes pour save dans le cache + BDD
- (void) saveArticle: (Article *) article;
- (void) deleteArticle: (Article *) article;


// Utiliser ces methodes pour save only dans le cache
- (void) insertArticle: (Article *) article;
- (void) removeArticle: (Article *) article;


- (NSArray *) cache; // Array of Article's
@end
