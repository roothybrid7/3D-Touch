//
//  PreviewViewController.m
//  3D Touch
//
//  Created by Jay Versluis on 21/09/2015.
//  Copyright © 2015 Pinkstone Pictures LLC. All rights reserved.
//

#import "PreviewViewController.h"

@interface PreviewViewController ()

@end

@implementation PreviewViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self check3DTouch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
    [self.view addSubview:button];
    NSLog(@"========= viewWillAppear %s ", __PRETTY_FUNCTION__);
}

- (void)dismissMe{
    
    // dismiss this view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)check3DTouch {
    
    // if 3D Touch is not available, add a tap gesture to dismiss this view
    if (self.traitCollection.forceTouchCapability != UIForceTouchCapabilityAvailable) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissMe)];
        [self.view addGestureRecognizer:tap];
    }
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    if (parent) {
        NSLog(@"========= addChildViewContrller %s ", __PRETTY_FUNCTION__);
    } else {
        NSLog(@"========= removeChildViewController %s ", __PRETTY_FUNCTION__);
    }
}

- (void)changeBGColor {
    self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255. green:arc4random_uniform(255)/255. blue:arc4random_uniform(255)/255. alpha:1];
}

- (void)hoge:(UIGestureRecognizer *)recognizer {
    NSLog(@"%s #####", __PRETTY_FUNCTION__);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}


#pragma mark - Preview Actions

/*
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
        
    // setup a list of preview actions
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"Action 1" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Action 1 triggered");
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"Destructive Action" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Destructive Action triggered");
    }];
    
    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"Selected Action" style:UIPreviewActionStyleSelected handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Selected Action triggered");
    }];
    
    // add them to an arrary
    NSArray *actions = @[action1, action2, action3];
    
    // add all actions to a group
    UIPreviewActionGroup *group1 = [UIPreviewActionGroup actionGroupWithTitle:@"Action Group" style:UIPreviewActionStyleDefault actions:actions];
    NSArray *group = @[group1];
    
    // and return them (return the array of actions instead to see all items ungrouped)
    return group;
}
*/


@end
