// Christopher Van Malsen
// Created: July 10, 2017

// Challenge - Eularian Path
// Description : Given a set of points in a graph, discover if it is possible to draw a Eularian path through all the points

import UIKit

class Graph {
    
    var edges : [Int : Set<Int>]
    
    init() {
        edges = [:]
    }
    
    func hasVertice(verticeNum : Int) -> Bool {
        
        for edgeKey in edges.keys {
            if edgeKey == verticeNum {
                return true
            }
        }
        
        return false
    }
    
    func addVertice(verticeNum : Int) {
        
        if !hasVertice(verticeNum: verticeNum) {
            edges[verticeNum] = []
        }
    }
    
    func addEdge(verticeOne v1: Int, verticeTwo v2: Int) {
        
        if hasVertice(verticeNum: v1) && hasVertice(verticeNum: v2) {
            edges[v1]?.insert(v2)
            edges[v2]?.insert(v1)
        }
    }
    
    func getVerticesCount() -> Int {
        return edges.keys.count
    }
    
    func getEdgesCount() -> Int {
        
        var uniqueEdges = [(Int, Int)]()
        
        for vertice in edges.keys {
            
            for edge in edges[vertice]! {
                
                var uniqueEdgeFound = true
                for uniqueEdge in uniqueEdges {
                    if (uniqueEdge.0 == edge && uniqueEdge.1 == vertice) ||
                        (uniqueEdge.1 == edge && uniqueEdge.1 == vertice)
                    {
                        uniqueEdgeFound = false
                    }
                }
                if uniqueEdgeFound {
                    uniqueEdges.append((vertice, edge))
                }
            }
        }
        
        return uniqueEdges.count
    }
    
    func getGraphPrintout() -> String {
        
        var graphPrinout = String()
        
        for vertice in edges.keys {
            
            graphPrinout += String(vertice) + " : "
            if let edgesDescription = edges[vertice]?.description as String! {
                graphPrinout += edgesDescription
            }
            
            graphPrinout += "\n"
        }
        
        return graphPrinout
    }
    
    func isEulerianPath() -> Bool {
        
        guard edges.count > 0 else {
            return false
        }
        
        var isEulerianPath = false
        
        for vertice in edges.keys {
            
            var previousVertices = Set<Int>()
            previousVertices.insert(vertice)
            
            if checkForEulerianPath(nextVertice: vertice, previousVertices: previousVertices, previousEdges: []) {
                isEulerianPath = true
                break
            }
        }
        
        return isEulerianPath
    }
    
    func checkForEulerianPath(nextVertice: Int, previousVertices: Set<Int>, previousEdges: [(v1 : Int, v2 : Int)]) -> Bool {
        
        var foundEulerianPath = false
        
        if let adjacentVerticesList = edges[nextVertice] as Set<Int>! {
            
            for adjacentVertice in adjacentVerticesList {
                
                let edge = (nextVertice, adjacentVertice)
                
                var isUniqueEdge = true
                
                for previousEdge in previousEdges {
                    if (edge.0 == previousEdge.0 && edge.1 == previousEdge.1) || (edge.1 == previousEdge.0 && edge.0 == previousEdge.1) {
                        
                        isUniqueEdge = false
                    }
                }
                
                if isUniqueEdge {
                    
                    // recursive call
                    var previouslyVisitedVertices = previousVertices
                    previouslyVisitedVertices.insert(adjacentVertice)
                    
                    var previouslyVisitedEdges = previousEdges
                    previouslyVisitedEdges.append(edge)
                    
                    // check for complete eulerian path
                    if previouslyVisitedVertices.count == edges.keys.count {
                        foundEulerianPath = true
                        break
                    }
                    else {
                        
                        foundEulerianPath = checkForEulerianPath(nextVertice: adjacentVertice, previousVertices: previouslyVisitedVertices, previousEdges: previouslyVisitedEdges)
                    }
                }
            }
        }
        
        return foundEulerianPath
    }
}

let graphOne = Graph()
graphOne.addVertice(verticeNum: 1)
graphOne.addVertice(verticeNum: 2)
graphOne.addVertice(verticeNum: 3)
graphOne.addVertice(verticeNum: 4)
graphOne.addEdge(verticeOne: 1, verticeTwo: 2)
graphOne.addEdge(verticeOne: 2, verticeTwo: 3)
graphOne.addEdge(verticeOne: 3, verticeTwo: 1)
graphOne.addEdge(verticeOne: 1, verticeTwo: 4)

print(graphOne.isEulerianPath() ? "Has a Eularian path." : "Does not have a eularian path.")

print(graphOne.getGraphPrintout())

