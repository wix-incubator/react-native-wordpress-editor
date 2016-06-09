//
//  RNWordPressEditorManager.h
//  example
//
//  Created by Artal Druk on 09/06/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"

/*
 RNWordPressEditorManager
 
 Singleton RN native manager accessible via JavaScript and controls all communications with the native editor
 */

@interface RNWordPressEditorManager : NSObject <RCTBridgeModule>
@end
