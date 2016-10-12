#import <Cordova/CDV.h>
#import <UIKit/UIKit.h>
#import <ContactsUI/ContactsUI.h>

@interface ContactModal : CDVPlugin <CNContactViewControllerDelegate, UINavigationControllerDelegate>

  @property CDVInvokedUrlCommand* command;

- (void) openCreateContact:(CDVInvokedUrlCommand*)command;

@end
