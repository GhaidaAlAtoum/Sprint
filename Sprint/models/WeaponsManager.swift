//
//  WeaponsModel.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/15/24.
//

import Foundation
import SpriteKit

class WeaponButton: SKSpriteNode, VibrateProtocol{}

class WeaponsManager {
    static let shared: WeaponsManager = WeaponsManager()
    var availableWeapons:[String : WeaponModel] = [:]
    var weaponSlots:[String:WeaponButton] = [:]
    var selectedWeapon:String = ""
    
    init() {
    }
    
    func resetWeapons(level: Int, scene: SKScene, boundingRect: CGRect) {
        resetToLevel(level: level, sceneSize: scene.size, boundingRect: boundingRect)
        addWeaponSlotsToScene(scene: scene)
    }
    
    private func addWeaponSlotsToScene(scene: SKScene) {
        for node in weaponSlots.values{
            scene.addChild(node)
        }
    }
    
    private func resetToLevel(level: Int, sceneSize: CGSize, boundingRect: CGRect) {
        availableWeapons = [:]
        weaponSlots = [:]
        let weapon_a_name = addWeapon(level: level, weaponName: "a", size: sceneSize, damage: 1, weaponsRect: boundingRect)
        let weapon_b_name = addWeapon(level: level, weaponName: "b", size: sceneSize, damage: 1, weaponsRect: boundingRect)
        let weapon_c_name = addWeapon(level: level, weaponName: "c", size: sceneSize, damage: 1, weaponsRect: boundingRect)
        let weapon_d_name = addWeapon(level: level, weaponName: "d", size: sceneSize, damage: 1, weaponsRect: boundingRect)
        selectedWeapon = weapon_a_name
    }
    
    
    
    static func getWeaponSelectedForAttack(weaponName: String, level: Int) -> String {
        return "selected_weapon_\(weaponName)_level\(level)"
    }
    
    static func getWeaponForOpt(weaponName: String, level: Int) -> String {
        return "attack_\(weaponName)_level\(level)_opt"
    }
    
    func addWeapon(level: Int, weaponName: String, size: CGSize, damage: Int, weaponsRect: CGRect) -> String {
        let buttonsSize: CGFloat = 80
        let buttonsHeight = size.height / 6 - buttonsSize / 1.5
        availableWeapons[weaponName] = WeaponModel(name: weaponName, damage: 1, size: size, position: .zero, projectileTexture: "attack_"+weaponName+"_projectile")
        let tempNode = WeaponButton(imageNamed: WeaponsManager.getWeaponForOpt(weaponName: weaponName, level: level))
        tempNode.anchorPoint = .zero
        tempNode.scale(to: CGSize(width: buttonsSize, height: buttonsSize))
        tempNode.position = CGPoint(x: weaponsRect.minX + (CGFloat(weaponSlots.count) * buttonsSize * 1.1), y: buttonsHeight)
        tempNode.zPosition = 1
        tempNode.name = weaponName
        
        weaponSlots[weaponName] = tempNode
        return weaponName
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
