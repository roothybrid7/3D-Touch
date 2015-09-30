//
//  ViewController.m
//  3D Touch
//
//  Created by Jay Versluis on 21/09/2015.
//  Copyright © 2015 Pinkstone Pictures LLC. All rights reserved.
//

#import "ViewController.h"
#import "PreviewViewController.h"

@interface ViewController () <UIViewControllerPreviewingDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (weak, nonatomic) id<UIViewControllerPreviewing> previewingContext;
@property (nonatomic) CGFloat angle;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:panGestureRecognizer];
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)recognizer {
    UIButton *button = (UIButton *)[[[UIApplication sharedApplication] keyWindow] viewWithTag:999];
    if ([self.presentedViewController isKindOfClass:[PreviewViewController class]]) {
        if (recognizer.state == UIGestureRecognizerStateChanged) {
            CGPoint location = [recognizer translationInView:self.view];
            CGPoint location2 = [recognizer translationInView:self.presentingViewController.view];
            CGPoint location3 = [recognizer translationInView:button];
            NSLog(@"%s %@", __PRETTY_FUNCTION__, NSStringFromCGPoint(location));
            NSLog(@"%s %@", __PRETTY_FUNCTION__, NSStringFromCGPoint(location2));
            NSLog(@"%s %@", __PRETTY_FUNCTION__, NSStringFromCGPoint(location3));
//            button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, arc4random_uniform(self.view.bounds.size.width/2), arc4random_uniform(self.view.bounds.size.height/4));

            // TODO: ボタンの座標とlocationの重なりをチェックする
            self.angle += 45 * M_PI_4;
            button.transform = CGAffineTransformMakeRotation(self.angle);
//            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//            view.backgroundColor = [UIColor greenColor];
        } else {
            NSLog(@"********* ============");
        }
        return;
    }
    button.transform = CGAffineTransformIdentity;
}

- (void)buttonTapped:(id)sender {
    NSLog(@"%s ###SSS", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self check3DTouch];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.previewingContext) {
        [self unregisterForPreviewingWithContext:self.previewingContext];
        self.previewingContext = nil;
    } else {
        NSAssert(NO, @"SSSS");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)check3DTouch {
    
    // register for 3D Touch (if available)
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        
        if (self.previewingContext) {
            [self unregisterForPreviewingWithContext:self.previewingContext];
            self.previewingContext = nil;
        }
        self.previewingContext = [self registerForPreviewingWithDelegate:(id)self sourceView:self.view];
//        [self.previewingContext previewingGestureRecognizerForFailureRelationship].delegate = self;
        NSLog(@"3D Touch is available! Hurra!");
        NSLog(@"%s recognizer: %@", __PRETTY_FUNCTION__, [self.previewingContext previewingGestureRecognizerForFailureRelationship]);
        NSLog(@"%s recognizer view: %@", __PRETTY_FUNCTION__, [self.previewingContext previewingGestureRecognizerForFailureRelationship].view);
        
        // no need for our alternative anymore
        self.longPress.enabled = NO;
        
    } else {
        
        NSLog(@"3D Touch is not available on this device. Sniff!");
        
        // handle a 3D Touch alternative (long gesture recognizer)
        self.longPress.enabled = YES;
        
        }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, gestureRecognizer);
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

    return YES;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    NSLog(@"%s %@ <=> %@", __PRETTY_FUNCTION__, gestureRecognizer, otherGestureRecognizer);
//    if ([self.previewingContext previewingGestureRecognizerForFailureRelationship] == gestureRecognizer) {
//        return NO;
//    }
//    return YES;
//}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    NSLog(@"%s %@ <=> %@", __PRETTY_FUNCTION__, gestureRecognizer, otherGestureRecognizer);
//    return YES;
//}
//
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    NSLog(@"%s %@ -----> %@", __PRETTY_FUNCTION__, gestureRecognizer, [touch view]);
    return YES;
}

- (UILongPressGestureRecognizer *)longPress {
    
    if (!_longPress) {
        _longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(showPeek)];
        [self.view addGestureRecognizer:_longPress];
    }
    return _longPress;
}


# pragma mark - 3D Touch Delegate

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {

    NSLog(@"%s %@", __PRETTY_FUNCTION__, [previewingContext previewingGestureRecognizerForFailureRelationship]);
    NSLog(@"%s recognizer view: %@", __PRETTY_FUNCTION__, [previewingContext previewingGestureRecognizerForFailureRelationship].view);
    // check if we're not already displaying a preview controller
    if ([self.presentedViewController isKindOfClass:[PreviewViewController class]]) {
        NSLog(@"DUP: %s %@", __PRETTY_FUNCTION__, [previewingContext previewingGestureRecognizerForFailureRelationship]);
        return nil;
    }

    // FIXME: Peekを途中でやめてPreviewが削除されたあとにボタンも削除
    UIButton *button = (UIButton *)[[[UIApplication sharedApplication] keyWindow] viewWithTag:999];
    [button removeFromSuperview];

    // shallow press: return the preview controller here (peek)
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *previewController = [storyboard instantiateViewControllerWithIdentifier:@"PreviewView"];

    button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat baseWidth = self.view.bounds.size.width / 8;
    button.frame = CGRectMake(100., 250., baseWidth, baseWidth);
    [button setTitle:@"Btn" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventAllEvents];
    button.tag = 999;
    button.layer.cornerRadius = baseWidth / 2;
    UIColor *color = [UIColor colorWithRed:arc4random_uniform(255)/255. green:arc4random_uniform(255)/255. blue:arc4random_uniform(255)/255. alpha:1];
    button.backgroundColor = color;
    // FIXME: child viewcontrollerの viewDidAppearが呼ばれたあとに表示する
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[[UIApplication sharedApplication] keyWindow] addSubview:button];
    });

    return previewController;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {

    NSLog(@"%s %@", __PRETTY_FUNCTION__, [previewingContext previewingGestureRecognizerForFailureRelationship]);

    // deep press: bring up the commit view controller (pop)
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *commitController = [storyboard instantiateViewControllerWithIdentifier:@"CommitView"];

    UIButton *button = (UIButton *)[[[UIApplication sharedApplication] keyWindow] viewWithTag:999];
    [button removeFromSuperview];
    
    [self showViewController:commitController sender:self];
    
    // alternatively, use the view controller that's being provided here (viewControllerToCommit)
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    
    // called when the interface environment changes
    // one of those occasions would be if the user enables/disables 3D Touch
    // so we'll simply check again at this point
    
    [self check3DTouch];
}


#pragma mark - 3D Touch Alternative

- (void)showPeek {
    
    // disable gesture so it's not called multiple times
    self.longPress.enabled = NO;
    
    // present the preview view controller (peek)
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PreviewViewController *preview = [storyboard instantiateViewControllerWithIdentifier:@"PreviewView"];
    
    UIViewController *presenter = [self grabTopViewController];
    [presenter showViewController:preview sender:self];
    
}

- (UIViewController *)grabTopViewController {
    
    // helper method to always give the top most view controller
    // avoids "view is not in the window hierarchy" error
    // http://stackoverflow.com/questions/26022756/warning-attempt-to-present-on-whose-view-is-not-in-the-window-hierarchy-sw
    
    UIViewController *top = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (top.presentedViewController) {
        top = top.presentedViewController;
    }
    
    return top;
}

@end
