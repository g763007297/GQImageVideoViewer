//
//  GQImageVideoTableView.m
//  GQImageVideoViewerDemo
//
//  Created by 高旗 on 16/9/12.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQImageVideoTableView.h"
#import "GQImageVideoScrollView.h"

#import "GQImageVideoViewerConst.h"

@interface GQImageVideoTableView()
{
    NSIndexPath *currentIndexPath;
}

@end

@implementation GQImageVideoTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.pagingEnabled = YES;
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"GQImageVideoScrollViewIdentify";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //将cell.contentView顺时针旋转90度
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
        cell.backgroundColor = [UIColor clearColor];
        
        GQImageVideoScrollView *photoSV = [[GQImageVideoScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        photoSV.tag = 100;
        [cell.contentView addSubview:photoSV];
    }
    GQImageVideoScrollView *photoSV = (GQImageVideoScrollView *)[cell.contentView viewWithTag:100];
    
    photoSV.data = self.dataArray[indexPath.row];
    
    photoSV.row = indexPath.row;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    GQImageVideoScrollView *photoSV = (GQImageVideoScrollView *)[cell.contentView viewWithTag:100];
    
    [photoSV setZoomScale:1.0 animated:YES];
    
    [photoSV stopDisplay];
}

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    [super scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
    
    //如果不存在currentIndexPath
    if (!currentIndexPath)
    {
        currentIndexPath = indexPath;
    }else if (currentIndexPath != indexPath)//如果currentIndexPath不等于indexPath则停止currentIndexPath的播放
    {
        UITableViewCell *cell = [self cellForRowAtIndexPath:currentIndexPath];
        GQImageVideoScrollView *photoSV = (GQImageVideoScrollView *)[cell.contentView viewWithTag:100];
        [photoSV stopDisplay];
        currentIndexPath = indexPath;
    }
    //播放当前indexPath
    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    GQImageVideoScrollView *photoSV = (GQImageVideoScrollView *)[cell.contentView viewWithTag:100];
    [photoSV beginDisplay];
}

@end

