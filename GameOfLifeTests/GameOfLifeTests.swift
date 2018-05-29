//
//  GameOfLifeTests.swift
//  GameOfLifeTests
//
//  Created by Bipin Gohel on 19.05.18.
//  Copyright © 2018 Bipin Gohel. All rights reserved.
//

import XCTest
@testable import GameOfLife

class GameOfLifeTests: XCTestCase {

    var VC: ViewController = ViewController()

    override func setUp() {
        VC.aliveNodes = []
        super.setUp()
    }
    
    override func tearDown() {
        VC.aliveNodes = []
        VC.permanentDeadNodes = []
        super.tearDown()
    }
    
    func testNeighbourOfANode() {

        let node = Node(origin: Origin(x: 80, y: 80))
        let nodoes = VC.allNeighbours(Of: node)
        XCTAssert(nodoes.count == 8, "Every nodes must have exactly 8 neighbours")

    }

    func testListOfNodesToBeChecked() {
        let node1 = Node(origin: Origin(x: 80, y: 80))
        VC.aliveNodes = [node1]
        let nodoes = VC.nodesToCheckForNextStage()
        XCTAssert(nodoes.count == 25, "for alive node, it should check for all neighbours of neighbour of alive node")

    }

    //Blinker Test, for more info, http://conwaylife.com/w/index.php?title=Blinker

    func testBlinker() {

        var node1 = Node(origin: Origin(x: 80, y: 80))
        var node2 = Node(origin: Origin(x: 100, y: 80))
        var node3 = Node(origin: Origin(x: 120, y: 80))

        node1.currentState = .alive
        node2.currentState = .alive
        node3.currentState = .alive

        let resultNode1 = Node(origin: Origin(x: 100, y: 60))
        let resultNode2 = Node(origin: Origin(x: 100, y: 80))
        let resultNode3 = Node(origin: Origin(x: 100, y: 100))

        let outputNodes = [resultNode1,resultNode2,resultNode3]

        VC.aliveNodes = [node1,node2,node3]

        VC.progressToNextGeneration()

        XCTAssert(VC.aliveNodes.count == outputNodes.count, "Blinker test - must have three nodes as output ")

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
