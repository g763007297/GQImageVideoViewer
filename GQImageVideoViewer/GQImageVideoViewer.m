//
//  GQImageVideoViewer.m
//  GQImageVideoViewerDemo
//
//  Created by 高旗 on 16/9/12.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQImageVideoViewer.h"

#import "GQImageVideoViewer.h"
#import "GQImageVideoTableView.h"
#import "GQImageVideoViewerConst.h"

static NSInteger pageNumberTag = 10086;

@interface GQImageVideoViewer()
{
    GQImageVideoTableView *_tableView;//tableview
    UIPageControl *_pageControl;//页码显示control
    UILabel *_pageLabel;//页码显示label
    CGRect _superViewRect;//superview的rect
    CGRect _initialRect;//初始化rect
}

@property (nonatomic, assign) BOOL isVisible;//是否正在显示

@end

@implementation GQImageVideoViewer

__strong static GQImageVideoViewer *imageVideoViewerManager;
+ (GQImageVideoViewer *)sharedInstance
{
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken, ^{
        imageVideoViewerManager = [[super allocWithZone:nil] init];
    });
    return imageVideoViewerManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone*)zone
{
    return self;
}

//初始化，不可重复调用
- (instancetype)initWithFrame:(CGRect)frame
{
    NSAssert(!imageVideoViewerManager, @"init method can't call");
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self setClipsToBounds:YES];
        self.laucnDirection = GQLaunchDirectionBottom;
        self.usePageControl = YES;
    }
    return self;
}

@synthesize videoViewClassNameChain = _videoViewClassNameChain;
@synthesize imageViewClassNameChain = _imageViewClassNameChain;
@synthesize usePageControlChain     = _usePageControlChain;
@synthesize dataArrayChain          = _dataArrayChain;
@synthesize selectIndexChain        = _selectIndexChain;
@synthesize showViewChain           = _showViewChain;
@synthesize launchDirectionChain    = _launchDirectionChain;
@synthesize achieveSelectIndexChain = _achieveSelectIndexChain;

GQChainObjectDefine(videoViewClassNameChain, VideoViewClassName, NSString *, GQStringClassChain);
GQChainObjectDefine(imageViewClassNameChain, ImageViewClassName, NSString *, GQStringClassChain);
GQChainObjectDefine(usePageControlChain, UsePageControl, BOOL, GQUsePageControlChain);
GQChainObjectDefine(dataArrayChain, DataArray, NSArray *, GQDataArrayChain);
GQChainObjectDefine(selectIndexChain, SelectIndex, NSInteger, GQSelectIndexChain);
GQChainObjectDefine(launchDirectionChain, LaucnDirection, GQLaunchDirection, GQLaunchDirectionChain);
GQChainObjectDefine(achieveSelectIndexChain, AchieveSelectIndex, GQAchieveIndexBlock, GQAchieveIndexChain);

- (GQShowViewChain)showViewChain
{
    if (!_showViewChain) {
        GQWeakify(self);
        _showViewChain = ^(UIView *showView){
            GQStrongify(self);
            [self showInView:showView];
        };
    }
    return _showViewChain;
}

#pragma mark -- set method

- (void)setImageViewClassName:(NSString *)imageViewClassName {
    NSAssert(_dataArray == nil, @"_imageViewClassName must be set earlier than _dataArray");
    
    NSAssert(!_isVisible, @"GQImageVideoViewer can not be set _imageViewClassName in the display");
    
    if (_imageViewClassName) {
        _imageViewClassName = nil;
    }
    _imageViewClassName = [imageViewClassName copy];
}

- (void)setVideoViewClassName:(NSString *)videoViewClassName {
    NSAssert(_dataArray == nil, @"_imageViewClassName must be set earlier than _dataArray");
    
    NSAssert(!_isVisible, @"GQImageVideoViewer can not be set _imageViewClassName in the display");
    
    if (_videoViewClassName) {
        _videoViewClassName = nil;
    }
    _videoViewClassName = [videoViewClassName copy];
}

- (void)setUsePageControl:(BOOL)usePageControl
{
    _usePageControl = usePageControl;
    [self updateNumberView];
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = [[self handleImageUrlArray:dataArray] copy];
    if (!_isVisible) {
        return;
    }
    
    NSAssert([_dataArray count] > 0, @"imageArray count must be greater than zero");
    
    if (_selectIndex>[_dataArray count]-1&&[_dataArray count]>0){
        _selectIndex = [_dataArray count]-1;
        
        [self updatePageNumber];
        [self scrollToSettingIndex];
    }
    _tableView.dataArray = [_dataArray copy];
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    if (_selectIndex == selectIndex) {
        return;
    }
    _selectIndex = selectIndex;
    if (!_isVisible) {
        return;
    }
    
    NSAssert(selectIndex>=0, @"_selectIndex must be greater than zero");
    NSAssert([_dataArray count] > 0, @"imageArray count must be greater than zero");
    
    if (selectIndex>[_dataArray count]-1){
        _selectIndex = [_dataArray count]-1;
    }else if (selectIndex < 0){
        _selectIndex = 0;
    }
    
    [self updatePageNumber];
    [self scrollToSettingIndex];
}

- (void)showInView:(UIView *)showView
{
    if ([_dataArray count]==0) {
        return;
    }
    
    if (_isVisible) {
        [self dissMiss];
        return;
    }else{
        _isVisible = YES;
    }
    
    //设置superview的rect
    _superViewRect = showView.bounds;
    
    //初始化子view
    [self initSubViews];
    
    //更新初始化rect
    [self updateInitialRect];
    
    //设置初始值
    self.alpha = 0;
    self.frame = _initialRect;
    
    [showView addSubview:self];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.alpha = 1;
                         self.frame = _superViewRect;
                     }];
}

//view消失
- (void)dissMiss
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.alpha = 0;
                         self.frame = _initialRect;
                     } completion:^(BOOL finished) {
                         [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                         [self removeFromSuperview];
                         _tableView = nil;
                         _dataArray = nil;
                         _videoViewClassName = nil;
                         _imageViewClassName = nil;
                         _isVisible = NO;
                     }];
}

#pragma mark -- privateMethod
//屏幕旋转通知
- (void)statusBarOrientationChange:(NSNotification *)noti{
    if (_isVisible) {
        _superViewRect = self.superview.bounds;
        [self orientationChange];
    }
}

//屏幕旋转调整frame
- (void)orientationChange{
    self.frame = _superViewRect;
    _tableView.frame = _superViewRect;
    [self updateInitialRect];
}

//初始化子view
- (void)initSubViews
{
    [self updateNumberView];
    if (!_tableView) {
        _tableView = [[GQImageVideoTableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_superViewRect) ,CGRectGetHeight(_superViewRect)) collectionViewLayout:[UICollectionViewLayout new]];
        GQWeakify(self);
        _tableView.block = ^(NSInteger index){
            GQStrongify(self);
            self->_selectIndex = index;
            [self updatePageNumber];
        };
    }
    [self insertSubview:_tableView atIndex:0];
    
    //将所有的图片url赋给tableView显示
    _tableView.dataArray = [_dataArray copy];
    
    [self scrollToSettingIndex];
}

//更新初始化rect
- (void)updateInitialRect{
    switch (_laucnDirection) {
        case GQLaunchDirectionBottom:{
            _initialRect = CGRectMake(0, CGRectGetHeight(_superViewRect), CGRectGetWidth(_superViewRect), 0);
            break;
        }
        case GQLaunchDirectionTop:{
            _initialRect = CGRectMake(0, 0, CGRectGetWidth(_superViewRect), 0);
            break;
        }
        case GQLaunchDirectionLeft:{
            _initialRect = CGRectMake(0, 0, 0, CGRectGetHeight(_superViewRect));
            break;
        }
        case GQLaunchDirectionRight:{
            _initialRect = CGRectMake(CGRectGetWidth(_superViewRect), 0, 0, CGRectGetHeight(_superViewRect));
            break;
        }
        default:
            break;
    }
}

//更新页面显示view
- (void)updateNumberView
{
    [[self viewWithTag:pageNumberTag] removeFromSuperview];
    
    if (_usePageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_superViewRect)-10, 0, 10)];
        _pageControl.numberOfPages = _dataArray.count;
        _pageControl.tag = pageNumberTag;
        _pageControl.currentPage = _selectIndex;
        [self insertSubview:_pageControl atIndex:1];
    }else{
        _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_superViewRect)/2 - 30, CGRectGetHeight(_superViewRect) - 20, 60, 15)];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        _pageLabel.tag = pageNumberTag;
        _pageLabel.text = [NSString stringWithFormat:@"%zd/%zd",(_selectIndex+1),_dataArray.count];
        _pageLabel.textColor = [UIColor whiteColor];
        [self insertSubview:_pageLabel atIndex:1];
    }
    [self updatePageNumber];
}

//更新页码
- (void)updatePageNumber
{
    if (self.achieveSelectIndex) {
        self.achieveSelectIndex(_selectIndex);
    }
    if (_usePageControl) {
        _pageControl.currentPage = self.selectIndex;
    }else{
        _pageLabel.text = [NSString stringWithFormat:@"%zd/%zd",(_selectIndex+1),_dataArray.count];
    }
}

- (void)scrollToSettingIndex
{
    //滚动到指定的单元格
    if (_tableView) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_selectIndex inSection:0];
        [_tableView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

//图片处理
- (NSArray *)handleImageUrlArray:(NSArray *)imageURlArray{
    NSMutableArray *handleImages = [[NSMutableArray alloc] initWithCapacity:[imageURlArray count]];
    for (int i = 0 ; i < [imageURlArray count]; i++) {
        id imageObject = imageURlArray[i];
        //如果不是GQBaseImageVideoModel类和NSDictionary类，就默认为图片资源；
        if (![imageObject isKindOfClass:[GQBaseImageVideoModel class]]&&![imageObject isKindOfClass:[NSDictionary class]]) {
            imageObject = [@{GQURLString:imageObject,GQIsImageURL:@(YES),GQVideoViewClassName:_videoViewClassName?:@"GQBaseVideoView",GQImageViewClassName:_imageViewClassName?:@"GQBaseImageView"} copy];
        }else if ([imageObject isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:imageObject];
            [dictionary addEntriesFromDictionary:@{GQVideoViewClassName:_videoViewClassName?:@"GQBaseVideoView",GQImageViewClassName:_imageViewClassName?:@"GQBaseImageView"}];
            imageObject = dictionary;
        }
        //如果为NSDictionary类，则改装成GQBaseImageVideoModel类
        if ([imageObject isKindOfClass:[NSDictionary class]]) {
            imageObject = [[GQBaseImageVideoModel alloc] initWithDataDic:imageObject];
        }
        [handleImages addObject:imageObject];
    }
    return handleImages;
}

//清除通知，防止崩溃
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

@end
