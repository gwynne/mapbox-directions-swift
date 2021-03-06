import XCTest
@testable import MapboxDirections
import Turf

class GeoJSONTests: XCTestCase {
    func testInitialization() {
        XCTAssertThrowsError(try LineString(encodedPolyline: ">==========>", precision: 1e6))
        
        var lineString: LineString? = nil
        XCTAssertNoThrow(lineString = try LineString(encodedPolyline: "afvnFdrebO@o@", precision: 1e5))
        XCTAssertNotNil(lineString)
        XCTAssertEqual(lineString?.coordinates.count, 2)
        XCTAssertEqual(lineString?.coordinates.first?.latitude ?? 0.0, 39.27665, accuracy: 1e-5)
        XCTAssertEqual(lineString?.coordinates.first?.longitude ?? 0.0, -84.411389, accuracy: 1e-5)
        XCTAssertEqual(lineString?.coordinates.last?.latitude ?? 0.0, 39.276635, accuracy: 1e-5)
        XCTAssertEqual(lineString?.coordinates.last?.longitude ?? 0.0, -84.411148, accuracy: 1e-5)
    }
    
    func testZeroLengthWorkaround() {
        var lineString: LineString? = nil
        
        // Correctly encoded zero-length LineString
        // https://github.com/mapbox/mapbox-navigation-ios/issues/2611
        XCTAssertNoThrow(lineString = try LineString(encodedPolyline: "s{byuAnigzhF??", precision: 1e6))
        XCTAssertNotNil(lineString)
        XCTAssertEqual(lineString?.coordinates.count, 2)
        XCTAssertEqual(lineString?.coordinates.first, lineString?.coordinates.last)
        XCTAssertEqual(lineString?.polylineEncodedString(precision: 1e6), "s{byuAnigzhF??")
        
        // Incorrectly encoded zero-length LineString
        XCTAssertNoThrow(lineString = try LineString(encodedPolyline: "s{byuArigzhF", precision: 1e6))
        XCTAssertNotNil(lineString)
        XCTAssertEqual(lineString?.coordinates.count, 2)
        XCTAssertEqual(lineString?.coordinates.first, lineString?.coordinates.last)
        XCTAssertEqual(lineString?.polylineEncodedString(precision: 1e6), "s{byuArigzhF??")
    }
}
