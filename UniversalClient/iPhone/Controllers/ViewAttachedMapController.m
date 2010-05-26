//
//  ViewAttachedMapController.m
//  UniversalClient
//
//  Created by Kevin Runde on 5/6/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewAttachedMapController.h"
#import "LEMacros.h"


@implementation ViewAttachedMapController


@synthesize scrollView;
@synthesize surface;
@synthesize buildings;


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	self.scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)] autorelease];
	self.scrollView.autoresizesSubviews = YES;
	self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.scrollView.bounces = NO;
	self.view = self.scrollView;
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.scrollView.contentSize = CGSizeMake(BODY_BUILDINGS_NUM_ROWS * BODY_BUILDINGS_CELL_WIDTH, BODY_BUILDINGS_NUM_COLS * BODY_BUILDINGS_CELL_HEIGHT);
	self.scrollView.contentOffset = CGPointMake(BODY_BUILDINGS_NUM_ROWS * BODY_BUILDINGS_CELL_WIDTH/2 - self.scrollView.center.x, BODY_BUILDINGS_NUM_COLS * BODY_BUILDINGS_CELL_HEIGHT/2 - self.scrollView.center.y);
	
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	self.navigationItem.title = [NSString stringWithFormat:@"Attached Map"];

	UIImage *surfaceImage = [UIImage imageNamed:[NSString stringWithFormat:@"assets/planet_side/%@.jpg", self.surface]];
	self.scrollView.backgroundColor = [UIColor colorWithPatternImage:surfaceImage];

	for (NSDictionary *building in self.buildings) {
		NSInteger mapX = intv_([building objectForKey:@"x"]);
		NSInteger mapY = intv_([building objectForKey:@"y"]);
		NSString *imageName = [building objectForKey:@"image"];
		UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"assets/planet_side/100/%@.png", imageName]];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		NSInteger viewX = (mapX - BODY_BUILDINGS_MIN_X) * BODY_BUILDINGS_CELL_WIDTH;
		NSInteger viewY = (mapY - BODY_BUILDINGS_MIN_Y) * BODY_BUILDINGS_CELL_HEIGHT;
		imageView.frame = CGRectMake(viewX, viewY, BODY_BUILDINGS_CELL_WIDTH, BODY_BUILDINGS_CELL_HEIGHT);
		[self.scrollView addSubview:imageView];
	}
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.scrollView = nil;
}


- (void)dealloc {
	self.surface = nil;
	self.buildings = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

-(void) setAttachedMap:(NSDictionary *)attachedMap {
	self.surface = [attachedMap objectForKey:@"surface"];
	self.buildings = [attachedMap objectForKey:@"buildings"];
}


@end
