//
//  PLAnalyseViewController.m
//  Move
//
//  Created by PhelanGeek on 2016/10/19.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLAnalyseViewController.h"
#import "PLXAnalyseCollectionViewCell.h"
#import "PLXStepViewController.h"
#import "PLXWeightViewController.h"
#import "PLXCalorieViewController.h"

static NSString *const cellIdentifier = @"collectionViewCell";


@interface PLAnalyseViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UIScrollViewDelegate
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) PLXStepViewController *stepVC;
@property (nonatomic, strong) PLXWeightViewController *weightVC;
@property (nonatomic, strong) PLXCalorieViewController *calorieVC;

@property (nonatomic, strong) PLXAnalyseCollectionViewCell *lastCell;

@end

@implementation PLAnalyseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = @[@"步数", @"大卡", @"体重"];
    
    [self createScrollView];
    [self createCollectionView];
    

}

- (void)createScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 109)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * _dataArray.count, _scrollView.frame.size.height);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    self.calorieVC = [[PLXCalorieViewController alloc] init];
    [self addChildViewController:_calorieVC];
    [_scrollView addSubview:_calorieVC.view];
    
    self.stepVC = [[PLXStepViewController alloc] init];
    [self addChildViewController:_stepVC];
    [_scrollView addSubview:_stepVC.view];
    

    
    self.weightVC = [[PLXWeightViewController alloc] init];
    [self addChildViewController:_weightVC];
    [_scrollView addSubview:_weightVC.view];
}

- (void)createCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.itemSize = CGSizeMake(50, 34);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 160, 44) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[PLXAnalyseCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    self.navigationItem.titleView = _collectionView;
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PLXAnalyseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.text = _dataArray[indexPath.item];
    if (indexPath.item == 0) {
        cell.textFont = 17;
        cell.textColor = [UIColor colorWithRed:0.9 green:0.7 blue:0.1 alpha:1];
        self.lastCell = cell;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _scrollView.contentOffset = CGPointMake(WIDTH * indexPath.item, 0);
    _lastCell.textFont = 15;
    _lastCell.textColor = [UIColor lightGrayColor];
    PLXAnalyseCollectionViewCell *cell = (PLXAnalyseCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.textFont = 17;
    cell.textColor = [UIColor colorWithRed:0.9 green:0.7 blue:0.1 alpha:1];
    _lastCell = cell;
}

// 滑动翻页
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_scrollView]) {
        NSInteger currentPage = scrollView.contentOffset.x / self.view.frame.size.width;
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
        _lastCell.textFont = 15;
        _lastCell.textColor = [UIColor lightGrayColor];
        PLXAnalyseCollectionViewCell *cell = (PLXAnalyseCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:currentPage inSection:0]];
        cell.textFont = 17;
        cell.textColor = [UIColor colorWithRed:0.9 green:0.7 blue:0.1 alpha:1];
        _lastCell = cell;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
