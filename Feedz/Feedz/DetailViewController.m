//
//  DetailViewController.m
//  Feedz
//
//  Created by Morgan Collino on 11/18/14.
//  Copyright (c) 2014 Morgan Collino. All rights reserved.
//

#import "DetailViewController.h"
#import "Article.h"

@interface DetailViewController ()
//@property (strong, nonatomic) IBOutlet UIWebView *webView;


@property (strong, nonatomic) IBOutlet UIImageView *imageArticle;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIButton *readMoreButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
	if (_detailItem != newDetailItem) {
	    _detailItem = newDetailItem;
		
	    // Update the view.
	    [self configureView];
	}
}

- (void)configureView {
	// Update the user interface for the detail item.
	if (self.detailItem) {
	    self.detailDescriptionLabel.text = [self.detailItem title];
		//[_webView loadHTMLString: _detailItem.summary baseURL:nil];
		
		[self renderArticle: _detailItem];
	}
}

- (void) renderArticle: (Article *) article
{
	HTMLDocument *document = article.parsedHTML;
	
	[_titleLabel setText: article.title];
	NSArray *a =  [document nodesMatchingSelector: @"p"];

	HTMLElement *firstElement = a[0];
	NSArray *a_ = [firstElement nodesMatchingSelector: @"img"];
	NSLog(@"FirstElement.imgs: %@", a_);
	if (a_.count > 0)
	{
		HTMLElement *urlImage = a_[0];
		NSString *url = urlImage.textContent;
		NSLog(@"Attributes:  %@", urlImage.attributes);
		if (urlImage.attributes)
		{
			NSDictionary *attributes = urlImage.attributes;
			NSString *src = [attributes objectForKey: @"src"];
			NSLog(@"SRC: %@", src);
		}
		NSLog(@"Image.content:%@", url);
	}
	HTMLElement *secondElement = a[1];
	NSLog(@"Content(2):%@", secondElement);
	if (secondElement.childElementNodes.count > 0)
	{
		NSLog(@"Content: %@", article.summary);
		NSLog(@"Content(2).text:%@", secondElement.textContent);
		[_contentLabel setText: secondElement.textContent];
	}
	else
	{
		NSLog(@"Content Not here : %@", secondElement.childElementNodes);
		[_contentLabel setText: secondElement.textContent];
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self configureView];
} 

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction) readMoreButtonPushed:(id)sender
{
	// URL VERS SAFARI
}

- (IBAction) shareButtonPushed:(id)sender
{
	
}

@end
