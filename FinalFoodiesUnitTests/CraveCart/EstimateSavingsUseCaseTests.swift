//
//  EstimateSavingsUseCaseTests.swift
//  FinalFoodiesUnitTests / CraveCart
//
//  Savings math, including the clamp-at-zero rule (never show negative).
//

@testable import FinalFoodies
import XCTest

final class EstimateSavingsUseCaseTests: XCTestCase {

    private let sut = EstimateSavingsUseCase()

    func testSavingsIsDeliveryMinusHomemade() {
        let savings = sut.execute(deliveryEstimate: 24, homemadeCost: 6)
        XCTAssertEqual(savings, 18)
    }

    func testSavingsClampedAtZeroWhenHomemadeIsMoreExpensive() {
        let savings = sut.execute(deliveryEstimate: 5, homemadeCost: 9)
        XCTAssertEqual(savings, 0)
    }

    func testZeroSavingsWhenEqual() {
        let savings = sut.execute(deliveryEstimate: 10, homemadeCost: 10)
        XCTAssertEqual(savings, 0)
    }
}
