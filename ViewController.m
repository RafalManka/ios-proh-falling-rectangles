//
//  ViewController.m
//  proh_cw_ios
//
//  Created by Rafał Mańka on 19/10/14.
//  Copyright (c) 2014 Rafał Mańka. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UICollisionBehaviorDelegate>

@end

@implementation ViewController

UIDynamicAnimator* _animator;
UIGravityBehavior* _gravity;
UICollisionBehavior* _collision;
int _elementCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *sq = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    sq.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:sq];
    
    UIView *barrier = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 130, 20)];
    barrier.backgroundColor = [UIColor magentaColor];
    [self.view addSubview:barrier];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    _gravity = [[UIGravityBehavior alloc] initWithItems:@[sq]];
    [_animator addBehavior:_gravity];
    
    CGPoint rightEdge = CGPointMake( barrier.frame.origin.x + barrier.frame.size.width, barrier.frame.origin.y );
    
    _collision = [[UICollisionBehavior alloc] initWithItems:@[sq]];
    _collision.translatesReferenceBoundsIntoBoundary = YES;
    _collision.collisionDelegate = self;
    
    [_collision addBoundaryWithIdentifier:@"barrier" fromPoint:barrier.frame.origin toPoint:rightEdge];
    _collision.action = ^{
        NSLog(@"%@, %@",NSStringFromCGAffineTransform(sq.transform),NSStringFromCGPoint(sq.center));
    };
    [_animator addBehavior:_collision];
    
    UIDynamicItemBehavior* itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[sq]];
    itemBehavior.elasticity = 0.9;
    [_animator addBehavior:itemBehavior];
    
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(id <NSCopying>)identifier atPoint:(CGPoint)p{
    NSLog(@"collBeh %@:", identifier);
    
    UIView* view = (UIView*)item;
    view.backgroundColor = [UIColor yellowColor];
    [UIView animateWithDuration:0.3 animations:^{
        view.backgroundColor = [UIColor grayColor];
    }];
    
    if(_elementCount<=10){
        _elementCount++;
        UIView *sq = [[UIView alloc] initWithFrame:CGRectMake(30, 0, 30, 30)];
        sq.backgroundColor = [UIColor orangeColor];
        
        UIDynamicItemBehavior* itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[sq]];
        itemBehavior.elasticity = 0.9;
        [_animator addBehavior:itemBehavior];
        
        
        [self.view addSubview:sq];
        [_collision addItem:sq];
        [_gravity addItem:sq];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
