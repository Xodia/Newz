//
//  FeedzParser.m
//  Feedz
//
//  Created by Morgan Collino on 12/11/14.
//  Copyright (c) 2014 Morgan Collino. All rights reserved.
//

#import "FeedzParser.h"
#import <MWFeedParser/MWFeedParser.h>
#import "Article.h"
#import "FeedzCache.h"
#import "HTMLDocument.h"

#define GIZMODO_RSS @"http://feeds.gawker.com/gizmodo/full.rss"
#define ENGADGET_RSS @"http://podcasts.engadget.com/rss.xml"
#define CNET_RSS @"http://www.cnet.com/rss/news/"
#define VERGE_RSS @"http://www.theverge.com/rss/group/exclusive/index.xml"

@interface FeedzParser () <MWFeedParserDelegate>
{
	MWFeedParser *feedParser;
	MWFeedParser *efeedParser;
	MWFeedParser *cfeedParser;
	MWFeedParser *vfeedParser;
}
@end

@implementation FeedzParser

- (instancetype) init
{
	if (self = [super init])
	{
		NSURL *feedURL = [NSURL URLWithString:GIZMODO_RSS];
		NSURL *vfeedURL = [NSURL URLWithString:VERGE_RSS];
		
		feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
		feedParser.delegate = self;
		feedParser.connectionType = ConnectionTypeAsynchronously;
		[feedParser parse];
		
		
		vfeedParser = [[MWFeedParser alloc] initWithFeedURL:vfeedURL];
		vfeedParser.delegate = self;
		vfeedParser.connectionType = ConnectionTypeAsynchronously;
		[vfeedParser parse];

	}
	return  self;
}

+ (instancetype) sharedParser
{
	static FeedzParser *shared = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		shared = [[self alloc] init];
	});
	
	return shared;
}



// Called when data has downloaded and parsing has begun
- (void)feedParserDidStart:(MWFeedParser *)parser
{
	NSLog(@"ParsingDidStart");
}

// Provides info about the feed
- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info
{
	NSLog(@"ParsingDidParseFeedInfo: %@", info);
}

// Provides info about a feed item
- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item
{
	NSLog(@"ParsingDidParseFeedItem: %@", item);
	Article *a = [[Article alloc] init];
	a.title = item.title;
	a.content = item.content;
	a.summary = item.summary;
	a.identifier = item.identifier;
	a.link = item.link;
	a.author = item.author;
	a.date = item.date;
	a.updated = item.updated;
	a.parsedHTML = [HTMLDocument documentWithString: a.summary];

	[[FeedzCache sharedCache] insertArticle: a];
	NSLog(@"FeedzCache :%@", [FeedzCache sharedCache]);
}

// Parsing complete or stopped at any time by `stopParsing`
- (void)feedParserDidFinish:(MWFeedParser *)parser
{
	NSLog(@"feedParserDidFinish");
}

// Parsing failed
- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error
{
	NSLog(@"feedParserDidFail: %@", error);
}

@end
