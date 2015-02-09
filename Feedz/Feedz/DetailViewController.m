//
//  DetailViewController.m
//  Feedz
//
//  Created by Morgan Collino on 11/18/14.
//  Copyright (c) 2014 Morgan Collino. All rights reserved.
//

#import "DetailViewController.h"
#import "Article.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface DetailViewController ()
//@property (strong, nonatomic) IBOutlet UIWebView *webView;


@property (strong, nonatomic) IBOutlet UIImageView *imageArticle;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextView *contentLabel;
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
		
		[self renderArticle: self.detailItem];
	}
}

- (void) renderArticle: (Article *) article
{
	HTMLDocument *document = article.parsedHTML;
	[self setTitle: article.title];
	
	UIFont* titleFont = [UIFont fontWithName:@"QuicksandBold-Regular" size:15];
	
	CGSize requestedTitleSize = [self.title sizeWithFont:titleFont];
	CGFloat titleWidth = MIN(500, requestedTitleSize.width);
	
	UILabel* tlabel= [[UILabel alloc] initWithFrame:CGRectMake(self.navigationItem.titleView.frame.origin.x	, self.navigationItem.titleView.frame.origin.y, titleWidth, 40)];
	tlabel.text = self.title;
	tlabel.textColor= [UIColor whiteColor];
	tlabel.backgroundColor =[UIColor clearColor];
	tlabel.adjustsFontSizeToFitWidth = YES;
	tlabel.font = titleFont;
	
	self.navigationItem.titleView = tlabel;
	
	NSLog(@"Summary: %@", article.summary);
	NSArray *a =  [document nodesMatchingSelector: @"p"];
	if (a.count == 0)
		return;
	
	HTMLElement *firstElement = a[0];
	NSArray *a_ = [document nodesMatchingSelector: @"img"];
	if (a_ && a_.count > 0)
	{
		HTMLElement *urlImage = a_[0];
		if (urlImage.attributes)
		{
			NSDictionary *attributes = urlImage.attributes;
			NSString *src = [attributes objectForKey: @"src"];
			
			NSURL *url = [NSURL URLWithString: src];
			NSURLRequest *request = [NSURLRequest requestWithURL: url];
			
			__weak DetailViewController *weakSelf = self;
			
			[_imageArticle setImageWithURLRequest: request placeholderImage: nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
				
				weakSelf.imageArticle.image = image;
				
			} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
				weakSelf.imageArticle.hidden = YES;
				weakSelf.imageArticle = nil;
				weakSelf.contentLabel.frame =CGRectMake(0, 50, weakSelf.contentLabel.frame.size.width,  weakSelf.contentLabel.frame.size.height);
			}];
		}
		else
		{
			_imageArticle.hidden = YES;
			_imageArticle = nil;
			_contentLabel.frame =CGRectMake(0, 50, _contentLabel.frame.size.width,  _contentLabel.frame.size.height);
		}
	}
	else
	{
		_imageArticle.hidden = YES;
		_imageArticle = nil;
		_contentLabel.frame =CGRectMake(0, 50, _contentLabel.frame.size.width,  _contentLabel.frame.size.height);
	}

	HTMLElement *secondElement = a[1];
	if (secondElement.childElementNodes.count > 0)
	{
		[_contentLabel setText: secondElement.textContent];
	}
	else
	{
		[_contentLabel setText: secondElement.textContent];
	}
	_contentLabel.selectable = NO;


}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	UITextView *tv = object;
	
	//Bottom vertical alignment
	CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height);
	topCorrect = (topCorrect <0.0 ? 0.0 : topCorrect);
	tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect/2};
}

- (void) viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear: animated];

	@try {
		[_contentLabel removeObserver: self forKeyPath: @"contentSize"];

	}
	@catch (NSException *exception) {
		
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

	[_contentLabel addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];

	// Do any additional setup after loading the view, typically from a nib.
	[self configureView];
    
    // View Attributes
    self.view.backgroundColor = [UIColor colorWithRed:(240/255.0) green:(240/255.0) blue:(240/255.0)  alpha:1];
    self.navigationItem.leftBarButtonItem.title = @" ";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
	CGSize sizeThatShouldFitTheContent = [_contentLabel sizeThatFits:_contentLabel.frame.size];
	
	NSLayoutConstraint *_descriptionHeightConstraint = [NSLayoutConstraint constraintWithItem: _contentLabel
																					attribute:NSLayoutAttributeHeight
																					relatedBy:NSLayoutRelationEqual
																					   toItem:nil
																					attribute:NSLayoutAttributeNotAnAttribute
																				   multiplier:0.f
																					 constant:100];
	
	[_contentLabel addConstraint:_descriptionHeightConstraint];
	
	[_descriptionHeightConstraint setConstant: sizeThatShouldFitTheContent.height + 40];
	[_contentLabel layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction) readMoreButtonPushed:(id)sender
{
	// URL VERS SAFARI
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:_detailItem.link]];

}

- (IBAction) shareButtonPushed:(id)sender
{
	
}

- (void)textViewDidChange:(UITextView *)textView
{
	CGFloat fixedWidth = textView.frame.size.width;
	CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
	CGRect newFrame = textView.frame;
	newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
	textView.frame = newFrame;
}

@end
