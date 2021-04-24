import SpriteKit
import Foundation
import AVFoundation

// Essa é a cena interativa que é exibida
class DragScene: SKScene, SKPhysicsContactDelegate {
    // Cria uma lista de fotos. Ela começa vazia
    var pictures = [SKSpriteNode]()
    var dragging: SKSpriteNode! // Variável para guardar a foto que está sendo arrastada
    let totalPens = 3
    var totalResets = 0
    var totalMessages = 0
    var audioIsPlaying = false
    // Animations
    let fadeIn = SKAction.fadeAlpha(to: 1, duration: 1)
    let fadeOut = SKAction.fadeAlpha(to: 0, duration: 1)
    let fadeInOut = SKAction.sequence([SKAction.fadeAlpha(to: 1, duration: 1), SKAction.fadeAlpha(to: 0, duration: 4.5)])
    // Interactions 
    let interactions: [String] = [
        "I knew you were going to do this",
        "That's not a problem",
        "and you are very insistent",
        "and would try again",
        "and again",
        "and again",
        "and again",
        "and again",
        "HEY!",
        "sometimes things are fine",
        "the way they are",
        "you don't need to fix everything",
        "not everything fits",
        "and it's not your fault",
        "let's try again!"
    ]
    
    // Essa parte do código é executada logo que a cena começa
    override func didMove(to view: SKView) {
        // Deixa animação suave
        fadeInOut.timingMode = .easeInEaseOut
        // Vamos começar criando a imagem de background
        let background = SKSpriteNode(imageNamed: "Desk")
        // Centralizar a imagem (metade da largura e altura da tela)
        background.position = CGPoint(x: 375, y: 600)
        // Agora vamos colocar o background na cena
        self.addChild(background)
        addObjects()
    }
    
    func addObjects() {
        for picture in pictures {
            picture.removeFromParent()
        }
        pictures = []
        // Agora vamos adicionar todas as fotos que importamos para o projeto
        for i in 0 ... totalPens - 1 {
            // Nome da imagem a partir do índice
            let name = "pen-4" 
            let picture = SKSpriteNode(imageNamed: name) // Usamos o nemo gerado para carregar a foto no código#fileLiteral(resourceName: "pen-1.png")
            // Colocamos a foto na nossa lista de fotos para podermos acessá-la depois
            pictures.append(picture)
            // Altera a escala para deixar a foto menor
            picture.setScale(0.8)
            // Posição aleatória
            picture.position = CGPoint(x: CGFloat.random(in: 20...725), y: CGFloat.random(in: 50...1100))
            // Posição Z para a imagem ficar por cima de todas as outras
            picture.zPosition = 1
            // Adicionamos a foto à cena
            self.addChild(picture)
        }
    } 
    
    func showLabel(_ label: SKLabelNode) {
        // Transforma em animação que repete para sempre.
        let repeating = SKAction.repeat(fadeInOut, count: 1)
        // Roda a animação.
        label.run(repeating)
        self.addChild(label)
    }
    
    func createLabel(
        fontNamed: String = "Futura",
        text: String = "",
        fontSize: CGFloat = 40,
        fontColor: SKColor = SKColor.black,
        show: Bool = true
    ) -> SKLabelNode {
        let label = SKLabelNode(fontNamed: fontNamed)
        label.text = text
        label.fontSize = CGFloat(fontSize)
        label.fontColor = fontColor
        label.position = CGPoint(x: frame.midX, y: 1000)
        
        if (show) {
            showLabel(label)
        }
        return label
    }
    
    // Função que recebe a coordenada do ponto clicado na tela
    func touchDown(atPoint pos : CGPoint) {
        // No momento do clique na tela verificamos se esse click ocorreu sobre uma das imagens
        for picture in pictures.reversed() { // Reversed para começarmos pelas últimas, que são as que estão no topo da pilha
            if picture.contains(pos) { // Verifica se a imagem contêm a coordenada do click
                dragging = picture // Define que a foto arrastada é a que contêm o ponto clicado
                // Coloca a imagem no topo
                picture.zPosition = 1
                return // Interrompe a busca quando encontra a imagem
            }
        }
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
        messItUp()
    }
    
    func messItUp() {
        let coordsY = extractExis("y")
        let coordsX = extractExis("x")
        let countY = checkIfHasAlignment(coordsY)
        let countX = checkIfHasAlignment(coordsX)
        if countY > 0 || countX > 0 {
            totalResets += 1
            showMessage()
            addObjects()
        }
    }
    
    func showMessage() {
        if totalResets == 1 {
            playSound()
            createLabel(text: interactions[totalMessages])
            totalMessages += 1
        } else if totalMessages >= interactions.count {
            reset()
        } else if totalResets % 3 == 0 {
            createLabel(text: interactions[totalMessages])
            totalMessages += 1
        }
    }
    
    func reset() {
        totalResets = 0
        totalMessages = 0
    }
    
    func extractExis(_ exis: String) -> [Int] {
        var coordY: [Int] = []
        for pic in pictures {
            coordY.append(Int(exis == "x" ? pic.position.x : pic.position.y))
        }
        return coordY
    }
    
    func checkIfHasAlignment(_ coords: [Int]) -> Int {
        var count = 0
        let limit = 25
        for i in 0...coords.count - 1 {
            let coord1 = coords[i]
            let coord1Max = coord1 + limit
            let coord1Min = coord1 - limit
            
            for j in 0...coords.count - 1 {
                if i == j {
                    continue
                }
                let coord2 = coords[j]
                if coord1Max >= coord2 && coord1Min <= coord2 {
                    count += 1
                }
            }
        }
        
        return count
    }
    
    func playSound() {
        if (audioIsPlaying) {
            return
        }
//          let sound = SKAction.playSoundFileNamed("Away.mp3", waitForCompletion: false)
        let sound = SKAudioNode(fileNamed: "Away.mp3")
        sound.autoplayLooped = true
        self.addChild(sound)
        audioIsPlaying = true
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
