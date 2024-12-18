/*
 Copyright 2018 New Vector Ltd

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <XCTest/XCTest.h>

#import "MXFilter.h"
#import "MXRoomEventFilter.h"
#import "MXRoomFilter.h"

@interface MXFilterTests : XCTestCase

@end

@implementation MXFilterTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testFilterInitWithDictionary
{
    MXFilter *filter = [[MXFilter alloc] initWithDictionary:
                                          @{
                                            @"limit": @(30),
                                            @"types": @[@"m.room.message"],
                                            @"not_types": @[@"m.room.not.message"],
                                            @"senders": @[@"@hello:example.com"],
                                            @"not_senders": @[@"@spam:example.com"],

                                            // Not yet specified filter field in matrix spec
                                            @"new_field": @"welcome"
                                            }];

    XCTAssertEqual(filter.limit, 30);
    XCTAssertEqualObjects(filter.types[0], @"m.room.message");
    XCTAssertEqualObjects(filter.notTypes[0], @"m.room.not.message");
    XCTAssertEqualObjects(filter.senders[0], @"@hello:example.com");
    XCTAssertEqualObjects(filter.notSenders[0], @"@spam:example.com");
    XCTAssertEqualObjects(filter.dictionary[@"new_field"], @"welcome");
}

- (void)testFilterInit
{
    MXFilter *filter = [[MXFilter alloc] init];
    filter.limit = 30;
    filter.types = @[@"m.room.message"];
    filter.notTypes = @[@"m.room.not.message"];
    filter.senders = @[@"@hello:example.com"];
    filter.notSenders = @[@"@spam:example.com"];

    NSDictionary *dictionary = @{
                                 @"limit": @(30),
                                 @"types": @[@"m.room.message"],
                                 @"not_types": @[@"m.room.not.message"],
                                 @"senders": @[@"@hello:example.com"],
                                 @"not_senders": @[@"@spam:example.com"]
                                 };

    XCTAssertTrue([filter.dictionary isEqualToDictionary:dictionary], @"%@/%@", filter.dictionary, dictionary);
}


- (void)testRoomEventFilterInitWithDictionary
{
    MXRoomEventFilter *filter = [[MXRoomEventFilter alloc] initWithDictionary:
                                          @{
                                            @"limit": @(30),
                                            @"types": @[@"m.room.message"],
                                            @"not_types": @[@"m.room.not.message"],
                                            @"rooms": @[@"!726s6s6q:example.com"],
                                            @"not_rooms": @[@"!not726s6s6q:example.com"],
                                            @"senders": @[@"@hello:example.com"],
                                            @"not_senders": @[@"@spam:example.com"],
                                            @"contains_url": @(YES),

                                            // Not yet specified filter field in matrix spec
                                             @"new_field": @"welcome"
                                            }];

    XCTAssertEqual(filter.limit, 30);
    XCTAssertEqualObjects(filter.types[0], @"m.room.message");
    XCTAssertEqualObjects(filter.notTypes[0], @"m.room.not.message");
    XCTAssertEqualObjects(filter.rooms[0], @"!726s6s6q:example.com");
    XCTAssertEqualObjects(filter.notRooms[0], @"!not726s6s6q:example.com");
    XCTAssertEqualObjects(filter.senders[0], @"@hello:example.com");
    XCTAssertEqualObjects(filter.notSenders[0], @"@spam:example.com");
    XCTAssertTrue(filter.containsURL);
    XCTAssertEqualObjects(filter.dictionary[@"new_field"], @"welcome");
}

- (void)testRoomEventFilterInit
{
    MXRoomEventFilter *filter = [[MXRoomEventFilter alloc] init];
    filter.limit = 30;
    filter.types = @[@"m.room.message"];
    filter.notTypes = @[@"m.room.not.message"];
    filter.rooms = @[@"!726s6s6q:example.com"];
    filter.notRooms = @[@"!not726s6s6q:example.com"];
    filter.senders = @[@"@hello:example.com"];
    filter.notSenders = @[@"@spam:example.com"];
    filter.containsURL = YES;

    NSDictionary *dictionary = @{
                                 @"limit": @(30),
                                 @"types": @[@"m.room.message"],
                                 @"not_types": @[@"m.room.not.message"],
                                 @"rooms": @[@"!726s6s6q:example.com"],
                                 @"not_rooms": @[@"!not726s6s6q:example.com"],
                                 @"senders": @[@"@hello:example.com"],
                                 @"not_senders": @[@"@spam:example.com"],
                                 @"contains_url": @(YES)
                                 };

    XCTAssertTrue([filter.dictionary isEqualToDictionary:dictionary], @"%@/%@", filter.dictionary, dictionary);
}


- (void)testRoomFilterInitWithDictionary
{
    NSMutableArray<NSDictionary*> *roomEventFiltersDict = [NSMutableArray array];
    for (NSUInteger i = 0; i < 4; i++)
    {
        [roomEventFiltersDict addObject:@{
                                          @"limit": @(i),
                                          @"types": @[@"m.room.message"],
                                          @"not_types": @[@"m.room.not.message"],
                                          @"rooms": @[@"!726s6s6q:example.com"],
                                          @"not_rooms": @[@"!not726s6s6q:example.com"],
                                          @"senders": @[@"@hello:example.com"],
                                          @"not_senders": @[@"@spam:example.com"],
                                          @"contains_url": @(YES)
                                          }];
    }

    MXRoomFilter *filter = [[MXRoomFilter alloc] initWithDictionary:
                                 @{
                                   @"rooms": @[@"!726s6s6q:example.com"],
                                   @"not_rooms": @[@"!not726s6s6q:example.com"],
                                   @"ephemeral": roomEventFiltersDict[0],
                                   @"include_leave": @(YES),
                                   @"state": roomEventFiltersDict[1],
                                   @"timeline": roomEventFiltersDict[2],
                                   @"account_data": roomEventFiltersDict[3],

                                   // Not yet specified filter field in matrix spec
                                   @"new_field": @"welcome"
                                   }];

    XCTAssertEqualObjects(filter.rooms[0], @"!726s6s6q:example.com");
    XCTAssertEqualObjects(filter.notRooms[0], @"!not726s6s6q:example.com");
    XCTAssertTrue([filter.ephemeral.dictionary isEqualToDictionary:roomEventFiltersDict[0]]);
    XCTAssertTrue(filter.includeLeave);
    XCTAssertTrue([filter.state.dictionary isEqualToDictionary:roomEventFiltersDict[1]]);
    XCTAssertTrue([filter.timeline.dictionary isEqualToDictionary:roomEventFiltersDict[2]]);
    XCTAssertTrue([filter.accountData.dictionary isEqualToDictionary:roomEventFiltersDict[3]]);
    XCTAssertEqualObjects(filter.dictionary[@"new_field"], @"welcome");
}

- (void)testEventFilterInit
{
    NSMutableArray<MXRoomEventFilter*> *roomEventFilters = [NSMutableArray array];
    for (NSUInteger i = 0; i < 4; i++)
    {
        [roomEventFilters addObject:[[MXRoomEventFilter alloc] initWithDictionary:@{
                                                                                    @"limit": @(i),
                                                                                    @"types": @[@"m.room.message"],
                                                                                    @"not_types": @[@"m.room.not.message"],
                                                                                    @"rooms": @[@"!726s6s6q:example.com"],
                                                                                    @"not_rooms": @[@"!not726s6s6q:example.com"],
                                                                                    @"senders": @[@"@hello:example.com"],
                                                                                    @"not_senders": @[@"@spam:example.com"],
                                                                                    @"contains_url": @(YES)
                                                                                    }]];
    }

    MXRoomFilter *filter = [[MXRoomFilter alloc] init];
    filter.rooms = @[@"!726s6s6q:example.com"];
    filter.notRooms = @[@"!not726s6s6q:example.com"];
    filter.ephemeral = roomEventFilters[0];
    filter.includeLeave = YES;
    filter.state = roomEventFilters[1];
    filter.timeline = roomEventFilters[2];
    filter.accountData = roomEventFilters[3];

    NSDictionary *dictionary = @{
                                 @"rooms": @[@"!726s6s6q:example.com"],
                                 @"not_rooms": @[@"!not726s6s6q:example.com"],
                                 @"ephemeral": roomEventFilters[0].dictionary,
                                 @"include_leave": @(YES),
                                 @"state": roomEventFilters[1].dictionary,
                                 @"timeline": roomEventFilters[2].dictionary,
                                 @"account_data": roomEventFilters[3].dictionary
                                 };

    XCTAssertTrue([filter.dictionary isEqualToDictionary:dictionary], @"%@/%@", filter.dictionary, dictionary);
}

@end
