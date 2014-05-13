//
//  HelloTests.m
//  HelloTests
//
//  Created by Talha Ansari on 1/29/14.
//  Copyright (c) 2014 Talha Ansari. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HelloTests : XCTestCase

@end

@implementation HelloTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
