//
//  ViewController.swift
//  GameOfLife
//
//  Created by Bipin Gohel on 19.05.18.
//  Copyright © 2018 Bipin Gohel. All rights reserved.
//

import UIKit

let cellSize:Int = 20

enum NodeState {
    case dead
    case alive
}

class Origin {
    var x:Int
    var y: Int

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

extension Origin : Equatable {
    static func == (lhs: Origin, rhs: Origin) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

class Node {
    var origin: Origin = Origin(x: 0, y: 0)
    var nextStage: NodeState = .dead
    var currentState: NodeState = .dead
    var cell:Cell?

    init(origin: Origin ) {
        self.origin.x = origin.x
        self.origin.y = origin.y
    }
}

// Two nodes are equal if both has same origin of point
extension Node : Equatable {
   static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.origin == rhs.origin
    }
}


class ViewController: UIViewController {

    @IBOutlet weak var runButton: UIButton!
    var aliveNodes = [Node]()
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self.view)

        if location.y > self.view.frame.size.height - 65 {
            return
        }

        let x:Int = Int(location.x/CGFloat(cellSize))
        let y:Int = Int(location.y/CGFloat(cellSize))

        let node = Node(origin: Origin(x: x, y: y))

        if !isAlive(node: node)  {
            // Tapped node isnot in View, add it to View
            let cell = Cell(frame: CGRect(x: x*cellSize, y: y*cellSize, width: cellSize, height: cellSize))
            node.currentState = .alive
            node.cell = cell
            aliveNodes.append(node)
            self.view.addSubview(cell)
        } else {
            // A node already exist at tapped point, remove it from View
            var aNode = aliveNodes.filter({$0 == node }).first
            aNode?.currentState = .dead
            if let aCell = aNode?.cell {
                aCell.removeFromSuperview()
            }
            aliveNodes = aliveNodes.filter({$0 != node })
        }
    }

    @IBAction func run(_ sender: Any) {
        if timer.isValid {
            timer.invalidate()
            runButton.setTitle("Run",for: .normal)

        } else {
            runButton.setTitle("Stop",for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.progressToNextGeneration), userInfo: nil, repeats: true)
        }
         //progressToNextGeneration()
    }

    @IBAction func clearBoard(_ sender: Any) {
        if timer.isValid {
            timer.invalidate()
        }
        runButton.setTitle("Run",for: .normal)
        for aNode in aliveNodes {
            if let cell = aNode.cell {
                cell.removeFromSuperview()
            }
        }
        aliveNodes.removeAll()
    }
    @objc func progressToNextGeneration() {

        guard !aliveNodes.isEmpty else {
            timer.invalidate()
            runButton.setTitle("Run",for: .normal)
            return
        }

        var nodesToCheck = nodesToCheckForNextStage()
        for i in 0..<nodesToCheck.count{
            updateNextState(of: &nodesToCheck[i])
        }
        // After updating next status of all nodes, proceed to update View,
        // As it changes the status of nodes, This must be done in sequence, not togather

        for aNode in nodesToCheck {
            changeNodeState(node: aNode)
        }
    }

    // Gathering list of all interesting nodes, nodes that might change, as per current arragement of Alive nodes in View
     func nodesToCheckForNextStage () -> [Node] {
        var nodesToCheck = [Node]()
        guard !aliveNodes.isEmpty else { return nodesToCheck }

        nodesToCheck.append(contentsOf: aliveNodes)
        for node in aliveNodes {
            let neighbours = allNeighbours(Of: node)
            for neighbour in neighbours {
                // checking neighbours of neighbour
                let nextNeighbours  = allNeighbours(Of: neighbour)
                for next in nextNeighbours {
                    //A node might be alreay in list as it has many neighbours, Remove the node if its already in list,
                    let nodes = nodesToCheck.filter({$0 == next })
                    if nodes.isEmpty {
                        nodesToCheck.append(next)
                    }
                }
            }
        }
        return nodesToCheck
    }

    // Update the nextStage of all nodes as per rules of Game
     func updateNextState(of nodeToUpdate: inout Node)  {
        let neighbours = allNeighbours(Of: nodeToUpdate)
        let alive = neighbours.filter({ $0.currentState == .alive })

        if isAlive(node: nodeToUpdate) {
            switch alive.count {
            case 2,3:
                nodeToUpdate.nextStage = .alive
            default:
                nodeToUpdate.nextStage = .dead
            }
        } else {
            if alive.count == 3 {
                nodeToUpdate.nextStage = .alive
            } else {
                nodeToUpdate.nextStage = .dead
            }
        }
    }

    // Updating final View as per nextState of all interesting nodes
    func changeNodeState (node: Node) {
        if node.nextStage == .alive {
            guard !isAlive(node: node) else { return }

            let cell = Cell(frame: CGRect(x: node.origin.x*cellSize, y: node.origin.y*cellSize, width: cellSize, height: cellSize))
            aliveNodes.append(node)
            node.cell = cell
            cell.alpha = 0.0
            self.view.addSubview(cell)
            UIView.animate(withDuration: 0.25, animations: {
                cell.alpha = 1.0
            })
        } else {
            aliveNodes = aliveNodes.filter({$0 != node })
            if let aCell = node.cell {
                aCell.removeFromSuperview()
            }
        }
    }

    // Find all neighbours of node, up down, left, right and diagonaly. So in total of 8
     func allNeighbours(Of node: Node) -> [Node] {

        let rightNodeOrigin = Origin(x: node.origin.x+1, y: node.origin.y)
        let rightDownNodeOrigin = Origin(x: node.origin.x+1, y: node.origin.y+1)
        let rightUpNodeOrigin = Origin(x: node.origin.x+1, y: node.origin.y-1)
        let leftNodeOrigin = Origin(x: node.origin.x-1, y: node.origin.y)
        let leftDwonNodeOrigin = Origin(x: node.origin.x-1, y: node.origin.y+1)
        let leftUpNodeOrigin = Origin(x: node.origin.x-1, y: node.origin.y-1)
        let upNodeOrigin = Origin(x: node.origin.x, y: node.origin.y-1)
        let downNodeOrigin = Origin(x: node.origin.x, y: node.origin.y+1)

        var neigbours = [ Node(origin: rightNodeOrigin),
                          Node(origin: rightDownNodeOrigin),
                          Node(origin: rightUpNodeOrigin),
                          Node(origin: leftNodeOrigin),
                          Node(origin: leftDwonNodeOrigin),
                          Node(origin: leftUpNodeOrigin),
                          Node(origin: upNodeOrigin),
                          Node(origin: downNodeOrigin)]

        // After creating dead nodes, by default, update nodes those are alive
        for i in 0..<neigbours.count {
            if isAlive(node: neigbours[i] as Node) {
                neigbours[i].currentState = .alive
            }
        }
        return neigbours
    }

    private func isAlive (node: Node) -> Bool {
        let found = aliveNodes.filter({$0 == node })
        return !found.isEmpty
    }
}

