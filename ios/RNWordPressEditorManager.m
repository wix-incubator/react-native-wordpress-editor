/*
 * This file is part of the react-native-wordpress-editor project.
 *
 * Copyright (C) 2016 Wix.com Ltd
 *
 * react-native-wordpress-editor is free software: you can redistribute it
 * and/or modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation, either version 2 of the License.
 *
 * react-native-wordpress-editor is distributed in the hope that it will be
 * useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
 * Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with react-native-wordpress-editor. If not, see <http://www.gnu.org/licenses/>
 */

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

RCT_EXPORT_METHOD(dismissKeyboardIfEditing)
{
  RNWordPressEditorViewController *activeEditor = [RNWordPressEditorViewController getActiveInstance];
  if (activeEditor == nil)
  {
    return;
  }
  
  [activeEditor dismissKeyboardIfEditing];
}

RCT_EXPORT_METHOD(showKeyboardIfEditing)
{
  RNWordPressEditorViewController *activeEditor = [RNWordPressEditorViewController getActiveInstance];
  if (activeEditor == nil)
  {
    return;
  }
  
  [activeEditor showKeyboardIfEditing];
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
  
  NSString *title = activeEditor.titleText;
  NSString *body = activeEditor.bodyText;
  
  NSMutableDictionary *result = [@{@"title": title != nil ? title : @"",
                                   @"body": body != nil ? body : @""} mutableCopy];
  
  
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

RCT_EXPORT_METHOD(setBottomToolbarHidden:(BOOL)hidden animated:(BOOL)animated)
{
  RNWordPressEditorViewController *activeEditor = [RNWordPressEditorViewController getActiveInstance];
  if (activeEditor == nil)
  {
    return;
  }
  
  [activeEditor setBottomToolbarHidden:hidden animated:animated];
}

@end
