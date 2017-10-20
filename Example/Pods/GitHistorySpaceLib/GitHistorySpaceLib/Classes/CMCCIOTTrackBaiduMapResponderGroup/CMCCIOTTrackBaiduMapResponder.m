//
//  CMCCIOTTrackBaiduMapResponder.m
//  driverGuard
//
//  Created by BigKrist on 16/4/11.
//  Copyright © 2016年 CMCCIOT. All rights reserved.
//

#import "CMCCIOTTrackBaiduMapResponder.h"
#import "CMCCIOTBaiduPolyline.h"
#import "CMCCIOTDeviceStateAnnotation.h"
#import "CMCCIOTMapMovingAnnotation.h"
#import "CMCCIOTTrackPaopaoView.h"
#import "CMCCIOTAppKit.h"
@interface CMCCIOTTrackBaiduMapResponder ()
{
    BMKAnnotationView *movingAnnotationView;
    CMCCIOTMapMovingAnnotation *movingAnnotation;
    CMCCIOTTrackPaopaoView *paopaoView;
    
    NSArray *innerTrackArray;
    
    
    UIImage *tempTestImg;
}
- (void)cmcciotAddSubTrackArray:(NSArray*)targetSubTracks forSegNum:(NSInteger)targetSegNum;
- (void)cmcciotAddBeginAndEndPointWith:(NSArray*)targetTracks;
- (void)cmcciotSetMapTrackCoorWith:(NSArray*)targetTracks;
- (NSArray*)cmcciotGetInnerTrackArray;
@end

@implementation CMCCIOTTrackBaiduMapResponder

- (NSArray*)cmcciotGetInnerTrackArray
{
    return innerTrackArray;
}

- (void)cmcciotClearAnnotaionAndOverlay
{
    if(self.weakMapView == nil)
        return;
    if([self.weakMapView annotations] != nil)
    {
        NSArray *annotaions = [NSArray arrayWithArray:self.weakMapView.annotations];
        [self.weakMapView removeAnnotations:annotaions];
        movingAnnotation = nil;
    }
    
    if([self.weakMapView overlays] != nil)
    {
        NSArray *overlays = [NSArray arrayWithArray:self.weakMapView.overlays];
        [self.weakMapView removeOverlays:overlays];
    }
    
}

- (void)cmcciotAddTracks:(NSArray *)trackPoints
{
    [self cmcciotClearAnnotaionAndOverlay];
    innerTrackArray = trackPoints;
    CMCCIOTLOG(@"trackPoints count is %ld",(long)trackPoints.count);
    
    if(trackPoints == nil || trackPoints.count == 0)
        return;
    
    for(NSInteger arrayIndex = 0; arrayIndex < trackPoints.count ; arrayIndex++)
    {
        NSArray *subArray = [trackPoints objectAtIndex:arrayIndex];
        CMCCIOTLOG(@"sub array count is %ld",(long)subArray.count);
        [self cmcciotAddSubTrackArray:subArray forSegNum:arrayIndex];
    }
    
    [self cmcciotAddBeginAndEndPointWith:trackPoints];
    [self cmcciotSetMapTrackCoorWith:trackPoints];
}

- (void)cmcciotAddSubTrackArray:(NSArray *)targetSubTracks forSegNum:(NSInteger)targetSegNum
{
    //构建轨迹
    NSInteger newPointsCount = targetSubTracks.count;
    if(newPointsCount < 2) return;
    CLLocationCoordinate2D *coorsArray = (CLLocationCoordinate2D*)malloc(sizeof(CLLocationCoordinate2D)*newPointsCount);
//    NSInteger segMoValue = targetSegNum % 3;
//    NSNumber *segMoValueNum = [NSNumber numberWithInteger:segMoValue];
    NSMutableArray *textureArry = [[NSMutableArray alloc] init];
    for(NSInteger index = 0; index < newPointsCount; index++)
    {
        
        NSDictionary *subDicInfo  = [targetSubTracks objectAtIndex:index];
        double latitudeValue = [[subDicInfo objectForKey:@"lat"] doubleValue];
        double longitudeValue = [[subDicInfo objectForKey:@"lng"] doubleValue];
        CLLocationCoordinate2D coorToAdd;
        coorToAdd.latitude = latitudeValue;
        coorToAdd.longitude = longitudeValue;
        coorsArray[index] = coorToAdd;
        
        if(index > 0)
            [textureArry addObject:@0];
    }
    
    if(textureArry.count < 1) {
        free(coorsArray);
        return;
    }
    
    CMCCIOTBaiduPolyline *polyLine = [[CMCCIOTBaiduPolyline alloc] init];
    polyLine.segNum = targetSegNum;
    [polyLine setPolylineWithCoordinates:coorsArray count:newPointsCount textureIndex:textureArry];
    
    [self.weakMapView addOverlay:polyLine];
    free(coorsArray);
}


- (void)cmcciotAddBeginAndEndPointWith:(NSArray*)targetTracks
{
    NSDictionary *beginPointDic = [[targetTracks firstObject] firstObject];
    NSDictionary *endPointDic = [[targetTracks lastObject] lastObject];
    
    CMCCIOTDeviceStateAnnotation *beginAnnotation = [[CMCCIOTDeviceStateAnnotation alloc] init];
    beginAnnotation.contextInfo = beginPointDic;
    CLLocationCoordinate2D beginCoor;
    beginCoor.latitude = [[beginPointDic objectForKey:@"lat"] doubleValue];
    beginCoor.longitude = [[beginPointDic objectForKey:@"lng"] doubleValue];
    beginAnnotation.coordinate = beginCoor;
    beginAnnotation.annotationState = CMCCIOTDeviceTrackState_BeginPoint;
    
    CMCCIOTDeviceStateAnnotation *endPointAnnotation = [[CMCCIOTDeviceStateAnnotation alloc] init];
    endPointAnnotation.contextInfo = endPointDic;
    CLLocationCoordinate2D endCoor;
    endCoor.latitude = [[endPointDic objectForKey:@"lat"] doubleValue];
    endCoor.longitude = [[endPointDic objectForKey:@"lng"] doubleValue];
    endPointAnnotation.coordinate = endCoor;
    endPointAnnotation.annotationState = CMCCIOTDeviceTrackState_EndPoint;
    
    [self.weakMapView addAnnotation:beginAnnotation];
    [self.weakMapView addAnnotation:endPointAnnotation];
}

- (void)cmcciotSetMapTrackCoorWith:(NSArray*)targetTracks
{
    double maxLongitude = -180;
    double minLongitude = 180;
    double maxLatitude = -90;
    double minLatitude = 90;
    
    for(NSArray *subArray in targetTracks)
    {
        for(NSDictionary *subDicInfo in subArray)
        {
            double opLongitude = [[subDicInfo objectForKey:@"lng"] doubleValue];
            double opLatitude = [[subDicInfo objectForKey:@"lat"] doubleValue];

            if(opLongitude > maxLongitude)
                maxLongitude = opLongitude;

            if(opLongitude < minLongitude)
                minLongitude = opLongitude;

            if(opLatitude > maxLatitude)
                maxLatitude = opLatitude;
            
            if(opLatitude < minLatitude)
                minLatitude = opLatitude;
        }
    }
    
    double centerLatitude = (maxLatitude + minLatitude)/2.0;
    double centerLontitude = (maxLongitude + minLongitude)/2.0;
    CLLocationCoordinate2D center2D;
    center2D.longitude = centerLontitude;
    center2D.latitude = centerLatitude;
    
    BMKCoordinateRegion centerRegion;
    centerRegion.center = center2D;
    BMKCoordinateSpan span;
    span.latitudeDelta = (maxLatitude - minLatitude) + 0.05;
    span.longitudeDelta = (maxLongitude - minLongitude) + 0.05;
    centerRegion.span = span;
    
    [self.weakMapView setRegion:centerRegion animated:YES];
}


- (void)cmcciotSetTheMovingPointDic:(NSDictionary *)targetPointDicInfo
{
    if(movingAnnotation == nil)
    {
        movingAnnotation = [[CMCCIOTMapMovingAnnotation alloc] init];
        CLLocationCoordinate2D center2D;
        center2D.latitude = [[targetPointDicInfo objectForKey:@"lat"] doubleValue];
        center2D.longitude = [[targetPointDicInfo objectForKey:@"lng"] doubleValue];
        movingAnnotation.coordinate = center2D;
        movingAnnotation.contextInfo = targetPointDicInfo;
        
        [self.weakMapView addAnnotation:movingAnnotation];
        [self.weakMapView setCenterCoordinate:center2D animated:YES];
    }
    else
    {
        CLLocationCoordinate2D center2D;
        center2D.latitude = [[targetPointDicInfo objectForKey:@"lat"] doubleValue];
        center2D.longitude = [[targetPointDicInfo objectForKey:@"lng"] doubleValue];
        movingAnnotation.coordinate = center2D;
        movingAnnotation.contextInfo = targetPointDicInfo;
        [self.weakMapView setCenterCoordinate:center2D animated:YES];
        if(paopaoView != nil)
            [paopaoView displayWithContextInfo:targetPointDicInfo];
    }
    
    [self.weakMapView selectAnnotation:movingAnnotation animated:NO];
}


#pragma mark - 
#pragma mark - MapViewDelegate
- (BMKAnnotationView*)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if([annotation isKindOfClass:[CMCCIOTDeviceStateAnnotation class]])
    {
        CMCCIOTDeviceStateAnnotation *opAnnotaion = (CMCCIOTDeviceStateAnnotation*)annotation;
        
        BMKAnnotationView *retAnnotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"CMCCIOTDeviceStatusAnnotationId"];
        if(retAnnotationView == nil)
        {
            retAnnotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CMCCIOTDeviceStatusAnnotationId"];
        }
        
        
        if(opAnnotaion.annotationState == CMCCIOTDeviceTrackState_BeginPoint)
        {
            retAnnotationView.image = [UIImage imageNamed:@"trackBeginPoint"];
            retAnnotationView.centerOffset = CGPointMake(0, -(31/2.0));
        }
        else if(opAnnotaion.annotationState == CMCCIOTDeviceTrackState_EndPoint)
        {
            retAnnotationView.image = [UIImage imageNamed:@"trackEndPoint"];
            retAnnotationView.centerOffset = CGPointMake(0, -(31/2.0));
        }
        
        retAnnotationView.annotation = annotation;
        return retAnnotationView;
    }
    else if([annotation isKindOfClass:[CMCCIOTMapMovingAnnotation class]])
    {
        CMCCIOTMapMovingAnnotation *mapMovingAnnotation = (CMCCIOTMapMovingAnnotation*)annotation;
        BMKAnnotationView *retAnnotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"CMCCIOTMapMovingAnnotationViewId"];
        if(retAnnotationView == nil)
            retAnnotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CMCCIOTMapMovingAnnotationViewId"];
        
        retAnnotationView.image = [UIImage imageNamed:@"blueCircelSmall"];
        retAnnotationView.annotation = mapMovingAnnotation;
        if(paopaoView == nil)
        {
            paopaoView = [[CMCCIOTTrackPaopaoView alloc] initWithFrame:CGRectMake(0, 0, 108, 42.5)];
            [paopaoView displayWithContextInfo:mapMovingAnnotation.contextInfo];
        }
        retAnnotationView.paopaoView = paopaoView;
        retAnnotationView.canShowCallout = YES;
        retAnnotationView.calloutOffset = CGPointMake(-54, -42.5);
        return retAnnotationView;
    }
    return nil;
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if([overlay isKindOfClass:[CMCCIOTBaiduPolyline class]])
    {
        
        CMCCIOTBaiduPolyline *opOverlay = (CMCCIOTBaiduPolyline*)overlay;
        BMKPolylineView *retLineView = [[BMKPolylineView alloc] initWithOverlay:opOverlay];
        NSString *tempImageName = nil;
        NSInteger segNum = opOverlay.segNum;
        if(segNum % 3 == 0)
        {
            tempImageName = @"icon_road_blue_arrow";
        }
        else if(segNum % 3 == 1)
        {
            tempImageName = @"icon_road_green_arrow";
        }
        else if(segNum % 3 == 2)
        {
            tempImageName = @"icon_road_purple_arrow";
        }
        
        if(tempImageName == nil)
        {
            tempImageName = @"icon_road_blue_arrow";
        }
        retLineView.lineWidth = 5;
        retLineView.isFocus = YES;
        retLineView.tileTexture = YES;
        UIImage *tempImg = [UIImage imageNamed:tempImageName];
        if(tempImg != nil)
            [retLineView loadStrokeTextureImages:@[tempImg]];
        
        return retLineView;
    }
    return nil;
}

@end
