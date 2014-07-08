//
//  RIPEMD_Block_Tests.swift
//  RIPEMD
//
//  Created by Sjors Provoost on 08-07-14.
//  Copyright (c) 2014 Crypto Coin Swift. All rights reserved.
//

import Cocoa
import XCTest
import RIPEMDmac

class RIPEMD_Block_Tests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAddedConstants() {
        let k40:UInt32 = 0x6ED9EBA1
        XCTAssertEqual(RIPEMD.Block.K.Left[40], k40, "");
    }
    
    func testBitlevelFunctions() {
        let x: UInt32 =       0b0000_0000_0000_1111
        let y: UInt32 =       0b1111_1111_1111_0000
        let z: UInt32 =       0b0000_1111_1111_0000
        
        let xORxOR: UInt32 =  0b1111_0000_0000_1111
        
        let function = RIPEMD.Block().f(12)
        let result = function(x,y,z)
        
        XCTAssertEqual(result, xORxOR, "")
    }
    
    func testWordSelection() {
        let message: [UInt32] = [0,0,0,0,1,0,0,0,0,0,0,0,0,0,2,0]
        
        let r17l = message[RIPEMD.Block.r.Left[17]]
        let r63r = message[RIPEMD.Block.r.Right[63]]

        
        XCTAssertEqual(r63r, 2, "")

    }
    
    func testRotationAmount() {
        let s17r = RIPEMD.Block.s.Right[17]
        
        XCTAssertEqual(s17r, 13, "")
    }
    
    func testZero() {
        // One of the test vectors  is an empty string. Should result in the same hash as 1 iteration.
        
        /* Padding rules according to: https://github.com/agoebel/RIPEMD-160
        Start with 0x80 followed by zeros, followed by the 64-bit length of the string in BITS (bits = 8 times number of bytes) in little-endian form. */
        
        let message: [UInt32] = [0x00_00_00_80,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        
        var digester = RIPEMD.Block()
        digester.compress(message)
        
        let h0: UInt32 = digester.hash[0]
        let h1: UInt32 = digester.hash[1]
        let h2: UInt32 = digester.hash[2]
        let h3: UInt32 = digester.hash[3]
        let h4: UInt32 = digester.hash[4]
        
        // "" -> 9c1185a5 c5e9fc54 61280897 7ee8f548 b2258d31
        
        // In little endian byte order this becomes:
        //       a585119c 54fce9c5 97082861 48f5e87e 318d25b2
        
        
        let check0: Bool = h0 == 0xa585119c // 9c1185a5
        let check1: Bool = h1 == 0x54fce9c5 // c5e9fc54
        let check2: Bool = h2 == 0x97082861 // 61280897
        let check3: Bool = h3 == 0x48f5e87e // 7ee8f548
        let check4: Bool = h4 == 0x318d25b2 // b2258d31
        
        
        // Test will crash if you use more than two XTAssertTrue statements.
        // Either that or it had something to do with UInt32 values larger than 2^31
        
        XCTAssertTrue(check0 && check1 && check2 && check3 && check4, "")

    }
    
    func testA() {
        // "a" is another test vector. This allows to test thorny issues like padding rules,
        // conversion from ASCII to bytes and endianess.
        
        XCTAssertTrue(false, "Not implemented")
        
//        println("0: \( check0 ) " + NSString(format:"%2x", h0) + " ")
//        println("1: \( check1 ) " + NSString(format:"%2x", h1) + " ")
//        println("2: \( check2 ) " + NSString(format:"%2x", h2) + " ")
//        println("3: \( check3 ) " + NSString(format:"%2x", h3) + " ")
//        println("4: \( check4 ) " + NSString(format:"%2x", h4) + " ")
    }

}