//
//  LBRViewController.m
//  RealtimeLocation
//
//  Created by Luca Bernardi on 13/10/13.
//  Copyright (c) 2013 Luca Bernardi. All rights reserved.
//

#import "LBRViewController.h"

#import <MapKit/MapKit.h>

#import "LBRLocationBroker.h"
#import "LBRLocationSourceCanned.h"
#import "LBRLocationSourceSensor.h"


@interface LBRViewController () <MKMapViewDelegate>
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (nonatomic, strong) LBRLocationBroker *locationBroker;
@property (nonatomic, strong) LBRLocationSourceCanned *source;
@property (nonatomic, strong) NSMutableDictionary *sessionMapping;
@end


@implementation LBRViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate          = self;
    
    self.actionButton.layer.cornerRadius = 25.0f;
    self.actionButton.layer.borderWidth  = 2.0;
    self.actionButton.layer.borderColor  = [UIColor whiteColor].CGColor;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setupLocationBroker];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self teardownLocationBroker];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.2;
    mapRegion.span.longitudeDelta = 0.2;
    
    [mapView setRegion:mapRegion animated: YES];
}

#pragma mark - Action

- (IBAction)startButtonTapped:(id)sender
{
    [self.locationBroker start];
}

- (IBAction)stopButtonTapped:(id)sender
{
    [self.locationBroker stop];
}

#pragma mark - Private

- (void)setupLocationBroker
{
    LBRLocationSource *locationSource = nil;
#if TARGET_IPHONE_SIMULATOR
    CLLocation *monzaLocation = [[CLLocation alloc] initWithLatitude:45.5845001 longitude:9.2744485];
    locationSource = [[LBRLocationSourceCanned alloc] initWithInitialLocation:monzaLocation];
#else
    CLLocation *conferenceLocation = [[CLLocation alloc] initWithLatitude:45.5021432 longitude:9.2282217];
    locationSource = [[LBRLocationSourceCanned alloc] initWithInitialLocation:conferenceLocation];
#endif
    
    self.locationBroker = [[LBRLocationBroker alloc] initWithLocationSource:locationSource
                                                                updateBlock:^(NSString *sessionID, CLLocation *location) {
                                                                    [self handleLocationUpdate:sessionID location:location];
                                                                }];
    
    __weak typeof(self) weakSelf = self;
    self.locationBroker.statusChangeBlock = ^(BOOL isRunning) {
        if (isRunning) {
            weakSelf.actionButton.backgroundColor = [UIColor colorWithRed:231.0/255 green:76.0/255 blue:60.0/255 alpha:1.0];
            weakSelf.actionButton.titleLabel.text = NSLocalizedString(@"Stop", nil);
            [weakSelf.actionButton removeTarget:weakSelf
                                         action:@selector(startButtonTapped:)
                               forControlEvents:UIControlEventTouchUpInside];
            [weakSelf.actionButton addTarget:weakSelf
                                      action:@selector(stopButtonTapped:)
                            forControlEvents:UIControlEventTouchUpInside];
            
        } else {
            weakSelf.actionButton.backgroundColor = [UIColor colorWithRed:40.0/255 green:188.0/255 blue:123.0/255 alpha:1.0];
            weakSelf.actionButton.titleLabel.text = NSLocalizedString(@"Start", nil);
            [weakSelf.actionButton removeTarget:weakSelf
                                         action:@selector(stopButtonTapped:)
                               forControlEvents:UIControlEventTouchUpInside];
            [weakSelf.actionButton addTarget:weakSelf
                                      action:@selector(startButtonTapped:)
                            forControlEvents:UIControlEventTouchUpInside];
        }
    };
}

- (void)teardownLocationBroker
{
    [self.locationBroker stop];
    self.locationBroker.statusChangeBlock = nil;
    self.locationBroker = nil;
}

- (void)handleLocationUpdate:(NSString *)sessionID location:(CLLocation *)location
{
    MKPointAnnotation *annotation = self.sessionMapping[sessionID];
    if (annotation == nil) {
        annotation = [[MKPointAnnotation alloc] init];
        [self.mapView addAnnotation:annotation];
        self.sessionMapping[sessionID] = annotation;
    }
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         annotation.coordinate = location.coordinate;
                     }];
}


@end
