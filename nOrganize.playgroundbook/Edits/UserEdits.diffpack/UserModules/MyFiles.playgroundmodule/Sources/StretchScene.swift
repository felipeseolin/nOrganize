import SpriteKit
import Foundation
import AVFoundation

// Essa é a cena interativa que é exibida
class StretchScene: SKScene, SKPhysicsContactDelegate {
    // Cria uma lista de fotos. Ela começa vazia
    var pictures = [SKSpriteNode]()
    var dragging: SKSpriteNode! // Variável para guardar a foto que está sendo arrastada
    // Essa parte do código é executada logo que a cena começa
    override func didMove(to view: SKView) {
        // Vamos começar criando a imagem de background
        let background = SKSpriteNode(imageNamed: "Desk")
        // Centralizar a imagem (metade da largura e altura da tela)
        background.position = CGPoint(x: 375, y: 600)
        // Agora vamos colocar o background na cena
        self.addChild(background)
        
        let sourcePositions: [float2] = [
            float2(0, 1),   float2(0.5, 1),   float2(1, 1),
            float2(0, 0.5), float2(0.5, 0.5), float2(1, 0.5),
            float2(0, 0),   float2(0.5, 0),   float2(1, 0)
        ]
        let destinationPositions: [float2] = [
            float2(-0.25, 1.5), float2(0.5, 1.75), float2(1.25, 1.5),
            float2(0.25, 0.5),   float2(0.5, 0.5),   float2(0.75, 0.5),
            float2(-0.25, -0.5),  float2(0.5, -0.75),  float2(1.25, -0.5)
        ]
        let warpGeometryGrid = SKWarpGeometryGrid(columns: 2,
                                                  rows: 2,
                                                  sourcePositions: sourcePositions,
                                                  destinationPositions: destinationPositions)
        
        let sprite = SKSpriteNode(imageNamed: "mindBlown")
        let warpGeometryGridNoWarp = SKWarpGeometryGrid(columns: 2, rows: 2)
        
        print("numberOfColumns: \(warpGeometryGridNoWarp.numberOfColumns)")
        print("numberOfRows: \(warpGeometryGridNoWarp.numberOfRows)")
        print("vertexCount: \(warpGeometryGridNoWarp.vertexCount)")
        print("source 0: \(warpGeometryGridNoWarp.sourcePosition(at: 0))")
        print("dest 0: \(warpGeometryGridNoWarp.destPosition(at: 0))")
        print("source 6: \(warpGeometryGridNoWarp.sourcePosition(at: 6))")
        print("dest 6: \(warpGeometryGridNoWarp.destPosition(at: 6))")
        
        sprite.warpGeometry = warpGeometryGridNoWarp
        sprite.setScale(1)
        sprite.position = CGPoint(x: frame.midX, y: frame.midY)
        sprite.zPosition = 1
        
//          let warpAction = SKAction.warp(to: warpGeometryGrid,duration: 10)
        let warpAction = SKAction.animate(withWarps:[warpGeometryGridNoWarp, 
                                                     warpGeometryGrid,
                                                     warpGeometryGridNoWarp],                                  
                                          times: [0.25, 0.5, 0.75])
        self.addChild(sprite)
        sprite.run(warpAction!)
    }
    
    // Função que recebe a coordenada do ponto clicado na tela
    func touchDown(atPoint pos : CGPoint) {
        print("pos: \(pos)")
    }
    
    // Função que recebe a coordenada no toque ao movimentar o dedo ou cursor do mouse sobre a tela 
    func touchMoved(toPoint pos : CGPoint) {
        // Nesse momento verificamos se alguma imagem está sendo arrastada
        if dragging != nil {
            // Então alteramos a posição da imagem para coincidir com a posição do toque
            dragging.position = pos
        }
    }
    
    // Função que recebe a coordenada do dedo ou cursor do mouse no momento em que o dedo sai da tela ou o botão do mouse é solto 
    func touchUp(atPoint pos : CGPoint) {
        // Nesse momento verificamos se alguma imagem está sendo arrastada
        if dragging != nil {            
            // Removemos a imagem da variável dragging
            dragging = nil
        }
    }
    
    // Essa parte cuida de monitorar os toques ou cliques na tela. Cada vez que isso acontece essa função chama a nossa outra função touchDown passando a posição exata do toque na tela. Normalmente não precisamos mexer aqui.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    // Muito parecido com o código acima. A diferença é que essa função monitora o movimento do doque na tela 
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    // Aqui é monitorada a saída do dedo dda tela ou o término do click do mouse
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
}
