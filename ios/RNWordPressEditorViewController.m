//
//  RNWordPressEditorViewController.m
//
//  Created by Artal Druk on 30/05/2016.
//  Copyright © 2016 artal. All rights reserved.
//

#import "RNWordPressEditorViewController.h"
#import "WPEditorView.h"
#import "RCTBridge.h"
#import "RCTRootView.h"
#import "RCCManager.h"
#import "RCTHelpers.h"
#import "RCTConvert.h"
#import "WPEditorField.h"

NSString* const EditorDidPressMediaNotification = @"EditorDidPressMedia";

@interface UILabelWithPadding : UILabel
@property (nonatomic) CGFloat leftRightPadding;
@end

@implementation UILabelWithPadding
- (void)drawTextInRect:(CGRect)rect
{
  UIEdgeInsets insets = {0, self.leftRightPadding, 0, self.leftRightPadding};
  [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}
@end

static RNWordPressEditorViewController *gActiveBlogEditorViewController = nil;

NSString *const DefaultDesktopEditOnlyText = @"Sorry! You can\'t edit this post from your mobile device as it may mess up your desktop design";
CGFloat   const DefaultDesktopEditOnlyTextFontSize = 13;
CGFloat   const DefaultDesktopEditOnlyPadding = 10;
CGFloat   const DefaultDesktopEditOnlyBgOpacity = 1;
NSString *const DefaultDesktopEditOnlyBlurBackground = @"none";

@interface RNWordPressEditorViewController () <WPEditorViewDelegate, UIToolbarDelegate>
@property(nonatomic, strong) NSMutableDictionary *mediaAddedProgress;
@property(nonatomic, strong) NSMutableArray *allMediaAdded;
@property(nonatomic, strong) NSDictionary *props;
@property (nonatomic, strong) NSString *initialTitleHtml;
@property (nonatomic, strong) NSString *initialBodyHtml;
@property (nonatomic) BOOL startEditingOnFirstAppear;
@property (nonatomic) BOOL isFirstAppear;
@property (nonatomic) BOOL isFirstLayout;
@property (nonatomic, strong) RCTRootView *bottomToolbarRCTView;
@property (nonatomic, strong) UILabelWithPadding *desktopEditOnlyLabel;
@end

@implementation RNWordPressEditorViewController

@synthesize controllerDelegate;

- (instancetype)init
{
  self = [self initWithMode:kWPEditorViewControllerModePreview];
  if (self)
  {
    self.delegate = self;
    
    self.startEditingOnFirstAppear = NO;
    self.isFirstAppear = YES;
    self.isFirstLayout = NO;
    self.mediaAddedProgress = [NSMutableDictionary dictionary];
    self.allMediaAdded = [NSMutableArray array];
    
    gActiveBlogEditorViewController = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRNReload) name:RCTReloadNotification object:nil];
  }
  return self;
}

+(RNWordPressEditorViewController*)getActiveInstance
{
  return gActiveBlogEditorViewController;
}

-(void)cleanup
{
  gActiveBlogEditorViewController = nil;
  
  if (self.bottomToolbarRCTView != nil)
  {
    [self.bottomToolbarRCTView.contentView.layer removeObserver:self forKeyPath:@"frame" context:nil];
    [self.bottomToolbarRCTView.contentView.layer removeObserver:self forKeyPath:@"bounds" context:NULL];
    self.bottomToolbarRCTView = nil;
  }
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dealloc
{
  [self cleanup];
}

-(void)onRNReload
{
  [self cleanup];
}

-(void)setProps:(nullable NSDictionary*)props
{
  _props = props;
  
  self.startEditingOnFirstAppear = [props[@"startEditingOnFirstAppear"] boolValue];
  self.initialTitleHtml = [props valueForKeyPath:@"post.title"];
  
  NSString *bodyHtml = [props valueForKeyPath:@"post.body"];
  if ([bodyHtml length] > 0)
  {
    //make sure image source has explicit http scheme (won't load with //)
    bodyHtml = [bodyHtml stringByReplacingOccurrencesOfString:@"src=\"//" withString:@"src=\"http://"];
  }
  
  self.initialBodyHtml = bodyHtml;
  
  if (props[@"BottomBarComponent"] != nil)
  {
    NSString *bottomComponentName = [props valueForKeyPath:@"BottomBarComponent.name"];
    if (bottomComponentName != nil)
    {
      NSDictionary *bottomComponentProps = [props valueForKeyPath:@"BottomBarComponent.props"];
      self.bottomToolbarRCTView = [[RCTRootView alloc] initWithBridge:[[RCCManager sharedInstance] getBridge] moduleName:bottomComponentName initialProperties:bottomComponentProps];
      self.bottomToolbarRCTView.autoresizingMask |= UIViewAutoresizingFlexibleTopMargin;
      self.bottomToolbarRCTView.backgroundColor = [UIColor clearColor];
      self.bottomToolbarRCTView.sizeFlexibility = RCTRootViewSizeFlexibilityWidthAndHeight;
      [self.view addSubview:self.bottomToolbarRCTView];
      
      [self.bottomToolbarRCTView.contentView.layer addObserver:self forKeyPath:@"frame" options:0 context:nil];
      [self.bottomToolbarRCTView.contentView.layer addObserver:self forKeyPath:@"bounds" options:0 context:NULL];
    }
    
    if ([[props valueForKeyPath:@"BottomBarComponent.initiallyHidden"] boolValue])
    {
      [self setBottomToolbarHidden:YES animated:NO];
    }
  }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  CGSize frameSize = CGSizeZero;
  if ([object isKindOfClass:[CALayer class]])
    frameSize = ((CALayer*)object).frame.size;
  if ([object isKindOfClass:[UIView class]])
    frameSize = ((UIView*)object).frame.size;
  
  CGSize prevFrameSize = self.bottomToolbarRCTView.frame.size;
  if (!CGSizeEqualToSize(frameSize, prevFrameSize))
  {
    CGFloat yOffset = frameSize.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    if (self.navigationController != nil)
    {
      yOffset += self.navigationController.navigationBar.frame.size.height;
    }
    
    self.bottomToolbarRCTView.frame = CGRectMake((self.view.frame.size.width - frameSize.width) * 0.5, self.view.frame.size.height - frameSize.height, frameSize.width, frameSize.height);
    self.editorView.additionalContentInset = UIEdgeInsetsMake(0, 0, frameSize.height - prevFrameSize.height, 0);
  }
}

-(WPEditorViewControllerElementTag)elementTagFromString:(NSString*)elementTypeString
{
  if ([elementTypeString isEqualToString:@"BlockQuoteBarButton"])
    return kWPEditorViewControllerElementTagBlockQuoteBarButton;
  
  if ([elementTypeString isEqualToString:@"BoldBarButton"])
    return kWPEditorViewControllerElementTagBoldBarButton;
    
  if ([elementTypeString isEqualToString:@"ImageBarButton"])
    return kWPEditorViewControllerElementTagInsertImageBarButton;
      
  if ([elementTypeString isEqualToString:@"InsertLinkBarButton"])
    return kWPEditorViewControllerElementTagInsertLinkBarButton;

  if ([elementTypeString isEqualToString:@"ItalicBarButton"])
    return kWPEditorViewControllerElementTagItalicBarButton;

  if ([elementTypeString isEqualToString:@"OrderedListBarButton"])
    return kWPEditorViewControllerElementOrderedListBarButton;

  if ([elementTypeString isEqualToString:@"ShowSourceBarButton"])
    return kWPEditorViewControllerElementShowSourceBarButton;

  if ([elementTypeString isEqualToString:@"iPhoneShowSourceBarButton"])
    return kWPEditorViewControllerElementiPhoneShowSourceBarButton;

  if ([elementTypeString isEqualToString:@"StrikeThroughBarButton"])
    return kWPEditorViewControllerElementStrikeThroughBarButton;

  if ([elementTypeString isEqualToString:@"UnorderedListBarButton"])
    return kWPEditorViewControllerElementUnorderedListBarButton;
  
  return kWPEditorViewControllerElementTagUnknown;
}

- (void)customizeAppearance
{
  [super customizeAppearance];
  
  NSString *titlePlaceholder = [self.props valueForKeyPath:@"placeHolders.title"];
  if (titlePlaceholder != nil)
  {
    self.titlePlaceholderText = titlePlaceholder;
  }
  
  NSString *bodyPlaceholder = [self.props valueForKeyPath:@"placeHolders.body"];
  if (bodyPlaceholder != nil)
  {
    self.bodyPlaceholderText = bodyPlaceholder;
  }
  
  self.view.backgroundColor = [UIColor whiteColor];
  
  if(self.props[@"removeToolbarButtons"])
  {
    for (NSString *element in self.props[@"removeToolbarButtons"])
    {
      [self.toolbarView removeToolBarItemWithTag:[self elementTagFromString:element]];
    }
  }
  
  if(self.props[@"hideToolbarButtons"])
  {
    for (NSString *element in self.props[@"hideToolbarButtons"])
    {
      [self.toolbarView toolBarItemWithTag:[self elementTagFromString:element] setVisible:NO];
    }
  }
  
  if ([self.props valueForKeyPath:@"toolbarStyle.iconTintColor"])
  {
    [self.toolbarView setItemTintColor:[RCTConvert UIColor:[self.props valueForKeyPath:@"toolbarStyle.iconTintColor"]]];
  }
  
  if ([self.props valueForKeyPath:@"toolbarStyle.disabledIconTintColor"])
  {
    [self.toolbarView setDisabledItemTintColor:[RCTConvert UIColor:[self.props valueForKeyPath:@"toolbarStyle.disabledIconTintColor"]]];
  }
  
  if ([self.props valueForKeyPath:@"toolbarStyle.selectedIconTintColor"])
  {
    [self.toolbarView setSelectedItemTintColor:[RCTConvert UIColor:[self.props valueForKeyPath:@"toolbarStyle.selectedIconTintColor"]]];
  }
  
  if ([self.props valueForKeyPath:@"toolbarStyle.topBorderColor"])
  {
    [self.toolbarView setBorderColor:[RCTConvert UIColor:[self.props valueForKeyPath:@"toolbarStyle.topBorderColor"]]];
  }
  
  if ([self.props valueForKeyPath:@"toolbarStyle.backgroundColor"])
  {
    [self.toolbarView setBackgroundColor:[RCTConvert UIColor:[self.props valueForKeyPath:@"toolbarStyle.backgroundColor"]]];
  }
  
  if ([self.props valueForKeyPath:@"placeholderColor"])
  {
    self.placeholderColor = [RCTConvert UIColor:[self.props valueForKeyPath:@"placeholderColor"]];
  }
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  gActiveBlogEditorViewController = self;
  
  [self.controllerDelegate setStyleOnAppearForViewController:self];
}

-(void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  
  gActiveBlogEditorViewController = nil;
}

-(void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  
  if(!self.isFirstLayout)
  {
    self.isFirstLayout = YES;
    
    [self addMobileCompatibleMessageView];
    
    [self adjustEditorViewAdditionalInsets];
  }
}

-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  if(self.startEditingOnFirstAppear)
  {
    self.startEditingOnFirstAppear = NO;
    [self startEditing];
  }
  
  if (self.pendingImagesToAdd)
  {
    NSArray *imageURLs = [NSArray arrayWithArray:self.pendingImagesToAdd];
    self.pendingImagesToAdd = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [self addImages:imageURLs];
    });
  }
  
  if(self.isFirstAppear)
  {
    self.isFirstAppear = NO;
    
    if (self.bottomToolbarRCTView != nil)
    {
      [RCTHelpers removeYellowBox:self.bottomToolbarRCTView];
    }
  }
}

-(void)adjustEditorViewAdditionalInsets
{
  //note: since bottomToolbarRCTView doesn't have a frame yet, it will add its own insets when it does
  
  UIEdgeInsets additionalInsets = UIEdgeInsetsZero;
  
  if (self.navigationController.navigationBar.translucent)
  {
    additionalInsets.top = 64;
  }
  
  if (self.desktopEditOnlyLabel != nil)
  {
    additionalInsets.top += self.desktopEditOnlyLabel.frame.size.height;
  }
  
  if (!UIEdgeInsetsEqualToEdgeInsets(additionalInsets, UIEdgeInsetsZero))
  {
    self.editorView.additionalContentInset = additionalInsets;
  }
}

-(void)addMobileCompatibleMessageView
{
  if (self.props[@"DesktopEditOnlyMessage"] != nil)
  {
    NSString *desktopEditOnlyText = [self.props valueForKeyPath:@"DesktopEditOnlyMessage.Text"];
    if (desktopEditOnlyText == nil)
    {
      desktopEditOnlyText = DefaultDesktopEditOnlyText;
    }
    
    CGFloat desktopEditOnlyFontSize = DefaultDesktopEditOnlyTextFontSize;
    if ([self.props valueForKeyPath:@"DesktopEditOnlyMessage.FontSize"] != nil)
    {
      desktopEditOnlyFontSize = [[self.props valueForKeyPath:@"DesktopEditOnlyMessage.FontSize"] floatValue];
    }
    
    CGFloat padding = DefaultDesktopEditOnlyPadding;
    if ([self.props valueForKeyPath:@"DesktopEditOnlyMessage.padding"] != nil)
    {
      padding = [[self.props valueForKeyPath:@"DesktopEditOnlyMessage.padding"] floatValue];
    }
    
    CGFloat bgOpacity = DefaultDesktopEditOnlyBgOpacity;
    if ([self.props valueForKeyPath:@"DesktopEditOnlyMessage.backgroundOpacity"] != nil)
    {
      bgOpacity = [[self.props valueForKeyPath:@"DesktopEditOnlyMessage.backgroundOpacity"] floatValue];
    }
    
    NSString *blurBackgroundStyle = [self.props valueForKeyPath:@"DesktopEditOnlyMessage.blurBackgroundStyle"];
    if (blurBackgroundStyle == nil)
    {
      blurBackgroundStyle = DefaultDesktopEditOnlyBlurBackground;
    }
    
    self.desktopEditOnlyLabel = [[UILabelWithPadding alloc] initWithFrame:CGRectZero];
    self.desktopEditOnlyLabel.leftRightPadding = padding;
    self.desktopEditOnlyLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:bgOpacity];
    self.desktopEditOnlyLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.desktopEditOnlyLabel.textAlignment = NSTextAlignmentCenter;
    self.desktopEditOnlyLabel.font = [UIFont systemFontOfSize:desktopEditOnlyFontSize];
    self.desktopEditOnlyLabel.numberOfLines = 0;
    self.desktopEditOnlyLabel.text = desktopEditOnlyText;
    
    
    CGFloat yPos = self.navigationController.navigationBar.translucent ? 64 : 0;
    CGSize size = [self.desktopEditOnlyLabel sizeThatFits:CGSizeMake(self.view.frame.size.width - padding * 2, CGFLOAT_MAX)];
    self.desktopEditOnlyLabel.frame = CGRectMake(0, yPos, self.view.frame.size.width, size.height + padding * 2);
    
    if ([[self.props valueForKeyPath:@"DesktopEditOnlyMessage.blurBackground"] boolValue])
    {
      UIToolbar *visualEffectView = [[UIToolbar alloc] init];
      visualEffectView.backgroundColor = [UIColor clearColor];
      visualEffectView.delegate = self;
      visualEffectView.frame = self.desktopEditOnlyLabel.frame;
      visualEffectView.translucent = YES;
      [self.view addSubview:visualEffectView];
      
      self.desktopEditOnlyLabel.frame = CGRectMake(0, 0, self.desktopEditOnlyLabel.frame.size.width, self.desktopEditOnlyLabel.frame.size.height);
      [visualEffectView addSubview:self.desktopEditOnlyLabel];
    }
    else
    {
      [self.view addSubview:self.desktopEditOnlyLabel];
    }
  }
}

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar
{
  return UIBarPositionTopAttached;
}

-(void)addImages:(NSArray*)images
{
  [self.allMediaAdded addObjectsFromArray:images];
  
  for (NSDictionary *imageURLData in images)
  {
    NSString *url = imageURLData[@"url"];
    __block NSString *localPlaceholderUrl = imageURLData[@"localPlaceholderUrl"];
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
      BOOL placeholderImageExists = NO;
      if (localPlaceholderUrl != nil && ![[NSFileManager defaultManager] fileExistsAtPath:localPlaceholderUrl])
      {
        NSBundle* editorBundle = [NSBundle bundleForClass:[self class]];
        localPlaceholderUrl = [editorBundle pathForResource:localPlaceholderUrl ofType:@""];
        if (localPlaceholderUrl != nil)
        {
          placeholderImageExists = YES;
        }
      }
      
      if (placeholderImageExists)
      {
        NSString *imageID = [[NSUUID UUID] UUIDString];
        [self.editorView insertLocalImage:localPlaceholderUrl uniqueId:imageID];
        [self.editorView replaceLocalImageWithRemoteImage:url uniqueId:imageID mediaId:[@(arc4random()) stringValue]];
      }
      else
      {
        [self.editorView insertImage:url alt:@""];
      }
    });
  }
}

#pragma mark - WPEditorViewControllerDelegate

- (void)editorDidBeginEditing:(WPEditorViewController *)editorController
{
}

- (void)editorDidEndEditing:(WPEditorViewController *)editorController
{
}

- (void)editorDidFinishLoadingDOM:(WPEditorViewController *)editorController
{
  [self setInitialTitleAndBody];
}

- (BOOL)editorShouldDisplaySourceView:(WPEditorViewController *)editorController
{
  [self.editorView pauseAllVideos];
  return YES;
}

- (void)editorDidPressMedia:(WPEditorViewController *)editorController
{
  [[NSNotificationCenter defaultCenter] postNotificationName:EditorDidPressMediaNotification object:nil];
}

- (void)editorTitleDidChange:(WPEditorViewController *)editorController
{
}

- (void)editorTextDidChange:(WPEditorViewController *)editorController
{
}

- (void)editorViewController:(WPEditorViewController *)editorViewController imageReplaced:(NSString *)imageId
{
  [self.mediaAddedProgress removeObjectForKey:imageId];
}

- (void)editorViewController:(WPEditorViewController *)editorViewController videoReplaced:(NSString *)videoId
{
  [self.mediaAddedProgress removeObjectForKey:videoId];
}

- (void)editorViewController:(WPEditorViewController *)editorViewController mediaRemoved:(NSString *)mediaID
{
  NSProgress * progress = self.mediaAddedProgress[mediaID];
  [progress cancel];
}

-(void)setInitialTitleAndBody
{
  [self setTitleText:self.initialTitleHtml];
  [self setBodyText:self.initialBodyHtml];
}

-(BOOL)initialPostChanged
{
  NSString *initialTitleHtmlText = (self.initialTitleHtml == nil) ? @"" : self.initialTitleHtml;
  NSString *initialBodyHtmlText = (self.initialBodyHtml == nil) ? @"" : self.initialBodyHtml;
  
  BOOL titleChanged = ![self.titleText isEqualToString:initialTitleHtmlText];
  BOOL bodyChanged = ![self.bodyText isEqualToString:initialBodyHtmlText];
  return (titleChanged || bodyChanged);
}

-(NSDictionary*)coverImageData
{
  NSString *mediaText = self.bodyText;
  
  NSMutableDictionary *coverImageData = nil;
  for (NSDictionary *imageInfo in gActiveBlogEditorViewController.allMediaAdded)
  {
    NSString *fileName = [imageInfo valueForKeyPath:@"data.file_name"];
    if ([fileName length] == 0)
    {
      fileName = [imageInfo valueForKeyPath:@"data.src"];
    }
    
    if ([mediaText rangeOfString:fileName].length > 0)
    {
      NSDictionary *coverImage = imageInfo[@"data"];
      if (coverImage != nil)
      {
        coverImageData = [NSMutableDictionary dictionaryWithDictionary:coverImage];
        if (coverImageData[@"file_name"]) coverImageData[@"src"] = coverImageData[@"file_name"];
      }
      break;
    }
  }
  
  if (coverImageData == nil)
  {
    coverImageData = [gActiveBlogEditorViewController.props valueForKeyPath:@"post.coverImageData"];
  }
  
  return coverImageData;
}

-(void)setBottomToolbarHidden:(BOOL)hidden animated:(BOOL)animated
{
  if (self.bottomToolbarRCTView != nil)
  {
    CGFloat alpha = hidden ? 0 : 1;
    CGAffineTransform transform = hidden ? CGAffineTransformMakeTranslation(0, self.bottomToolbarRCTView.frame.size.height) : CGAffineTransformIdentity;
    if (animated)
    {
      [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(){
        self.bottomToolbarRCTView.alpha = alpha;
        self.bottomToolbarRCTView.transform = transform;
      } completion: nil];
    }
    else
    {
      self.bottomToolbarRCTView.alpha = alpha;
      self.bottomToolbarRCTView.transform = transform;
    }
  }
}

-(void)dismissKeyboardIfEditing
{
  if (self.editing && self.editorView.focusedField != nil)
  {
    [self.editorView.focusedField blur];
  }
}

-(void)showKeyboardIfEditing
{
  if (self.editing && self.editorView.focusedField == nil)
  {
    [self.editorView.titleField focus];
  }
}

@end
