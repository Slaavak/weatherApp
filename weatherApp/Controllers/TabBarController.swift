//
//  TabBarControllerViewController.swift
//  weatherApp
//
//  Created by Slava Korolevich on 9/17/20.
//  Copyright © 2020 Slava Korolevich. All rights reserved.
//

import UIKit

class TabBarController: UIViewController {
    
    enum Controllers {
        case current
        case forecast
    }
    
    // MARK: - Properties
    
    var currentButton = UIButton()
    var forecastButton = UIButton()
    private var selectWeatherTypeOverlayView: UIView?
    private var currentViewController: UINavigationController!
    private var forecastViewController: UINavigationController!
    private(set) var selectedViewController: UINavigationController?
    private(set) var selectedController: Controllers = .current
    private var tabView: UIView!
    private var selectWeatherTypeBackgroundView: UIImageView?
    var currentButtonTaped = false
    var forecastButtonTaped = false
    
    var delegate: WeatherLoadManagerDelegate?
    
    //MARK:- life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WeatherLoadManager.instance.startWorking()
        
        setup()
        configureUI()
        switchTo(tab: .current)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout(size: view.bounds.size)
    }
    
    //MARK:- configure UI
    
    private func configureUI() {
        configureTabView()
        configureTabButtons()
    }
    
    
    private func configureTabView() {
        tabView = UIView(frame: .zero)
        tabView.backgroundColor = UIColor(white: 0.8, alpha: 0.3)
        view.addSubview(tabView)
    }
    
    private func configureTabButtons() {
        currentButton = createTabButton()
        currentButton.setTitle("current", for: .normal)
        currentButton.setTitleColor(.black, for: .normal)
        currentButton.setTitleColor(.blue, for: .selected)
        
        currentButton.isSelected = true
        currentButtonTaped = true
        currentButton.tintColor = .clear
        
        forecastButton = createTabButton()
        forecastButton.setTitleColor(.black, for: .normal)
        forecastButton.setTitleColor(.blue, for: .selected)
        
        forecastButton.setTitle("forecast", for: .normal)
        forecastButton.tintColor = .clear
        
    }
    
    @objc func tabButtonTapped(_ button: UIButton) {
        if let tab = tabForTabButton(button) {
            UIView.performWithoutAnimation {
                self.switchTo(tab: tab)
            }
        }
    }
    
    private func createTabButton() -> UIButton {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
        tabView.addSubview(btn)
        return btn
    }
    
    private func layout(size: CGSize) {
        let weatherButtonWidth: CGFloat = min(140, (size.width - 96) / 2)
        let weatherButtonHeight: CGFloat = 32
        let tabHeight: CGFloat = 50
        let additionalBottomSpacing = view.safeAreaInsets.bottom
        let tabViewHeight = tabHeight + additionalBottomSpacing
        let tabViewOriginY = size.height - tabViewHeight
        tabView.frame = CGRect(x: 0, y: tabViewOriginY, width: size.width, height: tabViewHeight)
        
        currentButton.frame = CGRect(x: 15, y: 10, width: weatherButtonWidth, height: weatherButtonHeight)
        forecastButton.frame = CGRect(x: view.frame.size.width - weatherButtonWidth - 15, y: 10, width: weatherButtonWidth, height: weatherButtonHeight)
        
        let viewHeight = size.height - tabViewHeight
        
        selectedViewController?.view.frame = CGRect(x: 0, y: 0, width: size.width, height: viewHeight)
        
    }
    
    //MARK: - setup
    
    private func setup() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let currentNavigationViewController = storyboard.instantiateViewController(withIdentifier: "NavigationViewController") as? UINavigationController {
            currentViewController = currentNavigationViewController
            (currentNavigationViewController.viewControllers.first as? ViewController)?.weatherType = .current
        }
        if let forecastNavigationViewController = storyboard.instantiateViewController(withIdentifier: "NavigationViewController") as? UINavigationController {
            forecastViewController = forecastNavigationViewController
            (forecastNavigationViewController.viewControllers.first as? ViewController)?.weatherType = .forecast
        }
    }
    
    private func tabForTabButton(_ button: UIButton) -> Controllers? {
        switch button {
        case currentButton: return .current
        case forecastButton: return .forecast
        default: return nil
        }
    }
    
    //MARK:- switchTo
    
    func switchTo(tab selectedTab: Controllers) {
        let viewControllerToSwitch: UINavigationController
        switch selectedTab {
        case .current: viewControllerToSwitch = currentViewController
        case .forecast: viewControllerToSwitch = forecastViewController
        }
        if selectedViewController != viewControllerToSwitch {
            selectedViewController?.willMove(toParent: nil)
            selectedViewController?.view.removeFromSuperview()
            selectedViewController?.removeFromParent()
            selectedViewController?.didMove(toParent: nil)
        }
        viewControllerToSwitch.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - tabView.bounds.height)
        viewControllerToSwitch.willMove(toParent: self)
        self.addChild(viewControllerToSwitch)
        self.view.insertSubview(viewControllerToSwitch.view, at: 0)
        
        viewControllerToSwitch.didMove(toParent: self)
        selectedViewController = viewControllerToSwitch
        
        if selectedTab == .current {
            currentButton.isSelected = true
            forecastButton.isSelected = false
        } else {
            forecastButton.isSelected = true
            currentButton.isSelected = false
        }
    }
}
