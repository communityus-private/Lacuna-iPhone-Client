//
//  LETableViewCellLabeledTextView.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewCellLabeledTextView.h"
#import <QuartzCore/QuartzCore.h>
#import "LEMacros.h"


@implementation LETableViewCellLabeledTextView


@synthesize label;
@synthesize textView;
@dynamic delegate;
@dynamic enabled;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}


- (void)dealloc {
	self.label = nil;
	self.textView = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark UITextInputTraits

- (UITextAutocapitalizationType)autocapitalizationType {
	return self.textView.autocapitalizationType;
}


- (void)setAutocapitalizationType:(UITextAutocapitalizationType) type {
	self.textView.autocapitalizationType = type;
}


- (UITextAutocorrectionType)autocorrectionType {
	return self.textView.autocorrectionType;
}


- (void)setAutocorrectionType:(UITextAutocorrectionType) type {
	self.textView.autocorrectionType = type;
}


- (BOOL)enablesReturnKeyAutomatically {
	return self.textView.enablesReturnKeyAutomatically;
}


- (void)setEnablesReturnKeyAutomatically:(BOOL) value {
	self.textView.enablesReturnKeyAutomatically = value;
}


- (UIKeyboardAppearance)keyboardAppearance {
	return self.textView.keyboardAppearance;
}


- (void)setKeyboardAppearance:(UIKeyboardAppearance) value {
	self.textView.keyboardAppearance = value;
}


- (UIKeyboardType)keyboardType {
	return self.textView.keyboardType;
}


- (void)setKeyboardType:(UIKeyboardType) value {
	self.textView.keyboardType = value;
}


- (UIReturnKeyType)returnKeyType {
	return self.textView.returnKeyType;
}


- (void)setReturnKeyType:(UIReturnKeyType) value {
	self.textView.returnKeyType = value;
}


- (BOOL)secureTextEntry {
	return self.textView.secureTextEntry;
}


- (void)setSecureTextEntry:(BOOL) value {
	self.textView.secureTextEntry = value;
}


#pragma mark -
#pragma mark Instance Methods

- (NSString *)value {
	return self.textView.text;
}


- (void)becomeFirstResponder {
	[self.textView becomeFirstResponder];
}


- (void)resignFirstResponder {
	[self.textView resignFirstResponder];
}


- (id<UITextViewDelegate>)delegate {
	return self.textView.delegate;
}


- (void)setDelegate:(id<UITextViewDelegate>)aDelegate {
	self.textView.delegate = aDelegate;
}


- (BOOL)enabled {
	return self.textView.editable;
}


- (void)setEnabled:(BOOL)inEnabled {
	if (inEnabled) {
		self.textView.backgroundColor = [UIColor whiteColor];
		self.textView.editable = YES;
	} else {
		self.textView.backgroundColor = [UIColor lightGrayColor];
		self.textView.editable = NO;
	}
}


- (void)dismissKeyboard {
	[self resignFirstResponder];
}


- (void)clearText {
	self.textView.text = @"";
}


#pragma mark -
#pragma mark Gesture Recognizer Methods

- (void)callTapped:(UIGestureRecognizer *)gestureRecognizer {
	[self.textView becomeFirstResponder];
}


#pragma mark -
#pragma mark Class Methods

+ (LETableViewCellLabeledTextView *)getCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"LabeledTextViewCell";
	
	LETableViewCellLabeledTextView *cell = (LETableViewCellLabeledTextView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[LETableViewCellLabeledTextView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.backgroundColor = CELL_BACKGROUND_COLOR;
		cell.autoresizesSubviews = YES;
		
		cell.label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 95, 20)] autorelease];
		cell.label.textAlignment = UITextAlignmentRight;
		cell.label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
		cell.label.font = LABEL_FONT;
		cell.label.textColor = LABEL_COLOR;
		cell.label.backgroundColor = [UIColor clearColor];
		[cell.contentView addSubview:cell.label];
		
		cell.textView = [[[UITextView alloc] initWithFrame:CGRectMake(5, 20, 310, 140)] autorelease];
		cell.textView.textAlignment = UITextAlignmentLeft;
		cell.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		cell.textView.font = TEXT_ENTRY_FONT;
		cell.textView.textColor = TEXT_ENTRY_COLOR;
		cell.textView.backgroundColor = [UIColor whiteColor];
		cell.textView.layer.borderWidth = 1;
		cell.textView.layer.borderColor = [[UIColor grayColor] CGColor];
		cell.textView.layer.cornerRadius = 8;
		[cell.contentView addSubview:cell.textView];
		
		UIToolbar *toolbar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)] autorelease];
		toolbar.center = CGPointMake(160.0f, 200.0f);
		UIBarButtonItem *clearItem = [[[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:cell action:@selector(clearText)] autorelease];
		UIBarButtonItem *spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
		UIBarButtonItem *dismissItem = [[[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStyleDone target:cell action:@selector(dismissKeyboard)] autorelease];
		toolbar.items = _array(clearItem, spacer, dismissItem);
		cell.textView.inputAccessoryView = toolbar;
		
		//Set text defaults
		cell.keyboardType = UIKeyboardTypeDefault;
		cell.autocorrectionType = UITextAutocorrectionTypeNo;
		cell.autocapitalizationType = UITextAutocapitalizationTypeNone;
		cell.enablesReturnKeyAutomatically = YES;
		cell.returnKeyType = UIReturnKeyNext;
		
		//Set Cell Defaults
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UITapGestureRecognizer *tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:cell action:@selector(callTapped:)] autorelease];
		[cell.contentView addGestureRecognizer:tapRecognizer];
	}
	
	return cell;
}


+ (CGFloat)getHeightForTableView:(UITableView *)tableView {
	return 166.0;
}


@end
