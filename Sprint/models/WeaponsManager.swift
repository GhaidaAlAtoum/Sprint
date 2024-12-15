//
//  WeaponsModel.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/15/24.
//

import Foundation
import SpriteKit

class WeaponButton: SKSpriteNode{}

class WeaponsManager {
    static let shared: WeaponsManager = WeaponsManager()
    var availableWeapons:[String : WeaponModel] = [:]
    var weaponSlots:[String:WeaponButton] = [:]
    var selectedWeapon:String = ""
    
    init() {
    }
    
    func resetWeapons(level: Int, scene: SKScene, boundingRect: CGRect) {
        switch level {
        case 0:
            resetToLevel0(sceneSize: scene.size, boundingRect: boundingRect)
            addWeaponSlotsToScene(scene: scene)
            break
        default:
            break
        }
    }
    
    private func addWeaponSlotsToScene(scene: SKScene) {
        for node in weaponSlots.values{
            scene.addChild(node)
        }
    }
    
    private func resetToLevel0(sceneSize: CGSize, boundingRect: CGRect) {
        availableWeapons = [:]
        weaponSlots = [:]
        let weapon_a_name = addWeapon(weaponName: "a", size: sceneSize, damage: 1, weaponsRect: boundingRect)
        let weapon_b_name = addWeapon(weaponName: "b", size: sceneSize, damage: 1, weaponsRect: boundingRect)
        let weapon_c_name = addWeapon(weaponName: "c", size: sceneSize, damage: 1, weaponsRect: boundingRect)
        let weapon_d_name = addWeapon(weaponName: "d", size: sceneSize, damage: 1, weaponsRect: boundingRect)
        selectedWeapon = weapon_a_name
    }
    
    func addWeapon(weaponName: String, size: CGSize, damage: Int, weaponsRect: CGRect) -> String {
        let buttonsSize: CGFloat = 80
        let buttonsHeight = size.height / 6 - buttonsSize / 1.5
        let name = "weapon_" + weaponName
        availableWeapons[name] = WeaponModel(name: name, damage: 1, size: size, position: .zero, projectileTexture: "attack_"+weaponName+"_projectile")
        let tempNode = WeaponButton(imageNamed: "attack_" + weaponName + "_opt")
        tempNode.anchorPoint = .zero
        tempNode.scale(to: CGSize(width: buttonsSize, height: buttonsSize))
        tempNode.position = CGPoint(x: weaponsRect.minX + (CGFloat(weaponSlots.count) * buttonsSize * 1.1), y: buttonsHeight)
        tempNode.zPosition = 1
        tempNode.name = name
        
        weaponSlots[weaponName] = tempNode
        return name
    }
    
    func updateSelectedWeapon(node: WeaponButton)  {
        selectedWeapon = node.name!
    }
    
    func getSelectedWeapon() -> WeaponModel  {
        return availableWeapons[selectedWeapon]!
    }
    
    func getSelectedWeaponName() -> String  {
        return selectedWeapon
    }
    
    
}
