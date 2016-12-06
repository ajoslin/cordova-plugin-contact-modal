#import "ContactModal.h"
@import ContactsUI;

@implementation ContactModal

- (void)openCreateContact:(CDVInvokedUrlCommand*)command
{
    self.command = command;

    NSDictionary* data = [command.arguments objectAtIndex:0];

    // -- Basic
    CNMutableContact *contact = [[CNMutableContact alloc] init];
    if ([data valueForKey:@"firstName"] != nil) {
        contact.givenName = [data valueForKey:@"firstName"];
    }
    if ([data valueForKey:@"lastName"] != nil) {
        contact.familyName = [data valueForKey:@"lastName"];
    }
    if ([data valueForKey:@"organization"] != nil) {
        contact.organizationName = [data valueForKey:@"organization"];
    }
    if ([data valueForKey:@"title"] != nil) {
        contact.jobTitle = [data valueForKey:@"title"];
    }

    // -- Photo
    NSString* photoUrl = [data valueForKeyPath:@"photo.url"];
    if (photoUrl != nil) {
        contact.imageData = [[NSData alloc] initWithBase64EncodedString:photoUrl options:0];
    }

    // -- Phone Numbers
    NSString* workPhoneValue = [data valueForKey:@"workPhone"];
    NSString* cellPhoneValue = [data valueForKey:@"cellPhone"];
    NSString* directPhoneValue = [data valueForKey:@"directPhone"];

    NSMutableArray* phoneNumbers = [NSMutableArray array];

    if (workPhoneValue != nil) {
        [phoneNumbers addObject:[CNLabeledValue labeledValueWithLabel:CNLabelWork value:[CNPhoneNumber phoneNumberWithStringValue:workPhoneValue]]];
    }
    if (cellPhoneValue != nil) {
        [phoneNumbers addObject:[CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile value:[CNPhoneNumber phoneNumberWithStringValue:cellPhoneValue]]];
    }
    if (directPhoneValue != nil) {
        [phoneNumbers addObject:[CNLabeledValue labeledValueWithLabel:@"direct dial" value:[CNPhoneNumber phoneNumberWithStringValue:directPhoneValue]]];
    }
    contact.phoneNumbers = phoneNumbers;

    // -- Emails
    NSString* workEmailValue = [data valueForKey:@"workEmail"];
    NSString* externalEmailValue = [data valueForKey:@"externalEmail"];
    NSMutableArray* emails = [NSMutableArray array];

    if (workEmailValue != nil) {
        [emails addObject:[CNLabeledValue labeledValueWithLabel:CNLabelWork value:workEmailValue]];
    }
    if (externalEmailValue != nil) {
       [emails addObject:[CNLabeledValue labeledValueWithLabel:@"external" value:externalEmailValue]];
    }
    contact.emailAddresses = emails;

    // -- Social
    NSString* facebookValue = [data valueForKeyPath:@"socialUrls.facebook"];
    NSString* instagramValue = [data valueForKeyPath:@"socialUrls.instagram"];
    NSString* twitterValue = [data valueForKeyPath:@"socialUrls.twitter"];
    NSString* linkedInValue = [data valueForKeyPath:@"socialUrls.linkedIn"];

    NSMutableArray* social = [NSMutableArray array];
    if (facebookValue != nil) {
        CNSocialProfile* facebookProfile = [[CNSocialProfile alloc] initWithUrlString:facebookValue username:facebookValue userIdentifier:nil service:CNSocialProfileServiceFacebook];
        [social addObject:[CNLabeledValue labeledValueWithLabel:CNSocialProfileServiceFacebook value:facebookProfile]];
    }
    if (instagramValue != nil) {
        CNSocialProfile* instagramProfile = [[CNSocialProfile alloc] initWithUrlString:instagramValue username:instagramValue userIdentifier:nil service:@"Instagram"];
        [social addObject:[CNLabeledValue labeledValueWithLabel:@"Instagram" value:instagramProfile]];
    }
    if (twitterValue != nil) {
        CNSocialProfile* twitterProfile = [[CNSocialProfile alloc] initWithUrlString:twitterValue username:twitterValue userIdentifier:nil service:
                                           CNSocialProfileServiceTwitter];
        [social addObject:[CNLabeledValue labeledValueWithLabel:CNSocialProfileServiceTwitter value:twitterProfile]];
    }
    if (linkedInValue != nil) {
        CNSocialProfile* linkedInProfile = [[CNSocialProfile alloc] initWithUrlString:linkedInValue username:linkedInValue userIdentifier:nil service:CNSocialProfileServiceLinkedIn];
        [social addObject:[CNLabeledValue labeledValueWithLabel:CNSocialProfileServiceLinkedIn value:linkedInProfile]];
    }
    contact.socialProfiles = social;

    CNContactViewController * controller = [CNContactViewController viewControllerForNewContact:contact];
    controller.delegate = self;
    controller.allowsEditing = YES;
    controller.allowsActions = YES;

    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:controller];


    // Display the view
    [self.viewController presentViewController:navController animated:YES completion:^{}];


}

-(void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(CNContact *)contact {
    [self.viewController dismissViewControllerAnimated:YES completion:nil];

    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsDictionary:nil
                               ];

    [self.commandDelegate sendPluginResult:result callbackId:self.command.callbackId];
}

@end
