//
//  XXAboutTableViewController.m
//  XXTouchApp
//
//  Created by Zheng on 8/29/16.
//  Copyright © 2016 Zheng. All rights reserved.
//

#import "XXWebViewController.h"
#import <MessageUI/MessageUI.h>
#import "XXAboutTableViewController.h"

enum {
    kInformationSection = 0,
    kOptionSection      = 1,
    kFeedbackSection    = 2,
};

// Index - kInformationSection
enum {
    kInformationIndex = 0,
};

// Index - kOptionSection
enum {
    kOptionOfficialSiteIndex   = 0,
    kOptionUserAgreementIndex  = 1,
    kOptionThirdPartyIndex     = 2,
};

enum {
    kOptionMailFeedbackIndex   = 0,
    kOptionOnlineUpdateIndex   = 1,
    kOptionAddQQGroupIndex     = 2,
};

@interface XXAboutTableViewController () <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *appLabel;

@end

@implementation XXAboutTableViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"About", nil);
    if (daemonInstalled()) {
        _appLabel.text = [NSString stringWithFormat:@"%@\nV%@", NSLocalizedString(@"XXTouch Pro", nil), extendDict()[@"DAEMON_VERSION"]];
    } else {
        _appLabel.text = [NSString stringWithFormat:@"%@\nV%@ (%@)", NSLocalizedString(@"XXTouch", nil), VERSION_STRING, VERSION_BUILD];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationItem.rightBarButtonItem = nil;
}

// Action - kOptionMailFeedbackIndex

- (void)displayComposerSheet {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    if (!picker) return;
    picker.mailComposeDelegate = self;
    if (daemonInstalled()) {
        [picker setSubject:[NSString stringWithFormat:@"[%@] %@\nV%@", NSLocalizedString(@"Feedback", nil), NSLocalizedString(@"XXTouch Pro", nil), extendDict()[@"DAEMON_VERSION"]]];
    } else {
        [picker setSubject:[NSString stringWithFormat:@"[%@] %@\nV%@ (%@)", NSLocalizedString(@"Feedback", nil), NSLocalizedString(@"XXTouch", nil), VERSION_STRING, VERSION_BUILD]];
    }
    NSArray *toRecipients = [NSArray arrayWithObject:extendDict()[@"SERVICE_EMAIL"]];
    [picker setToRecipients:toRecipients];
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case kInformationSection:
            return 1;
            break;
        case kOptionSection:
            return 3;
            break;
        case kFeedbackSection:
            if (daemonInstalled()) {
                return 3;
            } else {
                return 1;
            }
            break;
        default:
            break;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case kOptionSection:
            switch (indexPath.row) {
                case kOptionOfficialSiteIndex:
                    [self openOfficialSite];
                    break;
                case kOptionUserAgreementIndex:
                    [self openUserAgreement];
                    break;
                case kOptionThirdPartyIndex:
                    [self openThirdParty];
                    break;
                default:
                    break;
            }
            break;
        case kFeedbackSection:
            switch (indexPath.row) {
                case kOptionMailFeedbackIndex:
                    [self displayComposerSheet];
                    break;
                case kOptionOnlineUpdateIndex:
                    [self openCydia];
                    break;
                case kOptionAddQQGroupIndex:
                    [self openQQGroup];
                    break;
                default:
                    break;
            }
        default:
            break;
    }
}

- (void)openOfficialSite {
    XXWebViewController *viewController = [[XXWebViewController alloc] init];
    viewController.title = NSLocalizedString(@"Official Site", nil);
    viewController.url = [NSURL URLWithString:extendDict()[@"OFFICIAL_SITE"]];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)openUserAgreement {
    XXWebViewController *viewController = [[XXWebViewController alloc] init];
    viewController.title = NSLocalizedString(@"User Agreement", nil);
    viewController.url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"XXTReferences.bundle/tos" ofType:@"html"]];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)openThirdParty {
    XXWebViewController *viewController = [[XXWebViewController alloc] init];
    viewController.title = NSLocalizedString(@"Third Party Credits", nil);
    viewController.url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"XXTReferences.bundle/open" ofType:@"html"]];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)openCydia {
    NSString *cydiaStr = extendDict()[@"CYDIA_URL"];
    if (cydiaStr) {
        NSURL *cydiaURL = [NSURL URLWithString:cydiaStr];
        if ([[UIApplication sharedApplication] canOpenURL:cydiaURL]) {
            [[UIApplication sharedApplication] openURL:cydiaURL];
        } else {
            [self.navigationController.view makeToast:NSLocalizedString(@"Cannot open Cydia", nil)];
        }
    }
}

- (void)openQQGroup {
    NSString *contactStr = extendDict()[@"CONTACT_URL"];
    if (contactStr) {
        NSURL *qqURL = [NSURL URLWithString:contactStr];
        if ([[UIApplication sharedApplication] canOpenURL:qqURL]) {
            [[UIApplication sharedApplication] openURL:qqURL];
        } else {
            [self.navigationController.view makeToast:NSLocalizedString(@"Cannot open Mobile QQ", nil)];
        }
    }
}

- (void)dealloc {
    XXLog(@"");
}

@end
