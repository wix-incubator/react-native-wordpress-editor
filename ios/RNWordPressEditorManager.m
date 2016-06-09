//
//  RNWordPressEditorManager.m
//  example
//
//  Created by Artal Druk on 09/06/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "RNWordPressEditorManager.h"
#import "RNWordPressEditorViewController.h"
#import "RCTEventDispatcher.h"

@interface RNWordPressEditorManager()
@property (nonatomic, weak) RNWordPressEditorViewController *activeBlogEditorForPhotos;
@end

@implementation RNWordPressEditorManager

RCT_EXPORT_MODULE(RNWordPressEditorManager);

@synthesize bridge = _bridge;

-(instancetype)init
{
  self = [super init];
  if (self)
  {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEditorDidPressMedia:) name:EditorDidPressMediaNotification object:nil];
  }
  return self;
}

-(void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

+(NSError*)createErrorWithCode:(NSInteger)code description:(NSString*)description
{
  NSString *safeDescription = (description == nil) ? @"" : description;
  return [NSError errorWithDomain:@"BlogEditorManager" code:code userInfo:@{NSLocalizedDescriptionKey: safeDescription}];
}

+(void)performReject:(RCTPromiseRejectBlock)reject code:(NSInteger)code description:(NSString*)description
{
  NSError *error = [RNWordPressEditorManager createErrorWithCode:code description:description];
  reject([NSString stringWithFormat: @"%lu", (long)error.code], error.localizedDescription, error);
}

-(void)onEditorDidPressMedia:(NSNotification*)notification
{
  self.activeBlogEditorForPhotos = [RNWordPressEditorViewController getActiveInstance];
  [self.bridge.eventDispatcher sendAppEventWithName:@"EventEditorDidPressMedia" body:@{}];
}


RCT_EXPORT_METHOD(setEditingState:(BOOL)editing)
{
  RNWordPressEditorViewController *activeEditor = [RNWordPressEditorViewController getActiveInstance];
  if (activeEditor == nil)
  {
    return;
  }
  
  if (!editing && activeEditor.isEditing)
  {
    [activeEditor stopEditing];
  }
  else if (editing && !activeEditor.isEditing)
  {
    [activeEditor startEditing];
  }
}

RCT_EXPORT_METHOD(resetStateToInitial)
{
  RNWordPressEditorViewController *activeEditor = [RNWordPressEditorViewController getActiveInstance];
  if (activeEditor == nil)
  {
    return;
  }
  
  [activeEditor setInitialTitleAndBody];
}

RCT_EXPORT_METHOD(isPostChanged:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  RNWordPressEditorViewController *activeEditor = [RNWordPressEditorViewController getActiveInstance];
  if (activeEditor == nil)
  {
    [RNWordPressEditorManager performReject:reject code:1000 description:@"No Active Blog Editor"];
    return;
  }
  
  resolve(@([activeEditor initialPostChanged]));
}

RCT_EXPORT_METHOD(getPostData:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  RNWordPressEditorViewController *activeEditor = [RNWordPressEditorViewController getActiveInstance];
  if (activeEditor == nil)
  {
    [RNWordPressEditorManager performReject:reject code:1000 description:@"No Active Blog Editor"];
    return;
  }
  
  NSString *titleText = activeEditor.titleText;
  NSString *mediaText = activeEditor.bodyText;
  
  NSMutableDictionary *result = [@{@"titleText": titleText != nil ? titleText : @"",
                                   @"mediaText": mediaText != nil ? mediaText : @""} mutableCopy];
  
  
  NSDictionary *coverImageData = [activeEditor coverImageData];
  if (coverImageData != nil)
  {
    result[@"coverImage"] = coverImageData;
  }
  
  resolve(result);
}

RCT_EXPORT_METHOD(addImages:(NSArray*)imageURLs)
{
  /*
   IMPORTANT:
   If this method gets called when the modal image uploader is still showing, for some reason, the WixBlogEditorViewController will not be able to actually add and present the images (the UIWebView probably can't execute the JS)
   For now we'll mark the images as pending so we can add them as soon as the view appears again
   
   */
  
  //if the static reference exists the view is shown - add the images now
  RNWordPressEditorViewController *activeEditor = [RNWordPressEditorViewController getActiveInstance];
  if (activeEditor != nil)
  {
    [activeEditor addImages:imageURLs];
    return;
  }
  
  if (self.activeBlogEditorForPhotos == nil)
  {
    return;
  }
  
  self.activeBlogEditorForPhotos.pendingImagesToAdd = imageURLs;
}

@end
