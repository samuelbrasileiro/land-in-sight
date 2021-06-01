import UIKit


class StopPoint{
    
    var challenge: String = ""
    var consequence: String = ""
    
    var position: CGPoint
    
    init(position: CGPoint){
        self.position = position
    }
    
    //(5, 10)     (12, 13)
    func getLinePositions(final: CGPoint) -> [CGPoint]{
        var x = final.x - position.x
        var y = final.y - position.y
        
        var movements: [CGPoint] = []
        
        while abs(x) > 0{
            movements.append(CGPoint(x: (x >= 0 ? 1 : -1), y: 0))
            x += (x >= 0 ? -1 : 1)
        }
        while abs(y) > 0{
            movements.append(CGPoint(x: 0, y: (y >= 0 ? 1 : -1)))
            y += (y >= 0 ? -1 : 1)
        }
        //[(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(0,1),(0,1),(0,1)]
        movements.shuffle()
        
        var start = position
        
        var positions: [CGPoint] = []
        
        for movement in movements{
            start.x += movement.x
            start.y += movement.y
            
            positions.append(start)
        
        }
        
        return positions
    }
}

let points = [StopPoint(position: CGPoint(x: 10, y: 10)),StopPoint(position: CGPoint(x: 15, y: 13)), StopPoint(position: CGPoint(x: 12, y: 5)), StopPoint(position: CGPoint(x: 15, y: 5))]

var linesPositions: [(CGPoint, Bool)] = []
linesPositions.append((points[0].position, true))
for i in 0..<points.count-1{
    
    linesPositions.append(contentsOf: points[i].getLinePositions(final: points[i+1].position).dropLast().map{($0, false)})
    linesPositions.append((points[i+1].position, true))
}
print(linesPositions)

