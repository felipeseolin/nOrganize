

import Foundation
import SpriteKit

public class DragViewController : UIViewController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let view = SKView()
        
        // Aqui é criada uma cena com as dimensões 750 x 1200 e exibida na tela. Para ver o funcionamento dessa cena veja o arquivo DragScene.swift
        var scene = DragScene(size: CGSize(width: 750, height: 1200))
        scene.scaleMode = .aspectFit
        view.presentScene(scene)
        
        self.view = view
        
    }
}
