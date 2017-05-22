//
//  MeetleUITests.swift
//  MeetleUITests
//
//  Created by AppsFoundation
//  Copyright © 2015 AppsFoundation. All rights reserved.
//

import XCTest

class MeetleUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testLoginScreen() {
        
        let app = XCUIApplication()
        let enterYourEMailTextField = app.textFields["Enter Your E-mail"]
        enterYourEMailTextField.tap()
        enterYourEMailTextField.typeText("qwe")
        
        let enterYourPasswordSecureTextField = app.secureTextFields["Enter Your Password"]
        enterYourPasswordSecureTextField.tap()
        enterYourPasswordSecureTextField.typeText("qwe")
        
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.otherElements.containing(.button, identifier:"FORGOT PASSWORD?").element.tap()
        
        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.buttons["FORGOT PASSWORD?"].tap()
        elementsQuery.buttons["SIGN UP"].tap()
        app.buttons["Sign In with Facebook"].tap()
        app.buttons["Sign In with Twitter"].tap()
        app.buttons["Sign In"].tap()
        
    }
    
    func testMainScreen() {
        
        let app = XCUIApplication()
        app.buttons["Sign In"].tap()
        
        let jessyImage = app.images["jessy"]
        jessyImage.swipeLeft()
        app.buttons["like button"].tap()
        app.buttons["next button"].tap()
        app.navigationBars["Jessy, 22"].buttons["message"].tap()
        app.buttons["Info"].tap()
        jessyImage.swipeLeft()
        
        let manImage = app.images["man"]
        manImage.swipeLeft()
        
        let veronikaImage = app.images["Veronika"]
        veronikaImage.swipeLeft()
        jessyImage.swipeLeft()
        manImage.swipeLeft()
        veronikaImage.swipeLeft()
        
        let backButton = app.navigationBars["Profile"].children(matching: .button).matching(identifier: "Back").element(boundBy: 0)
        backButton.tap()
        app.buttons["shared friend2"].tap()
        backButton.tap()
        
    }
    
    func testChatScreen() {
        let app = XCUIApplication()
        app.buttons["Sign In"].tap()
        app.navigationBars["Jessy, 22"].buttons["menu icon"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["My Chat"].tap()
        
        let veronikaNavigationBar = app.navigationBars["Veronika"]
        veronikaNavigationBar.buttons["message"].tap()
        app.buttons["microphone"].tap()
        app.buttons["camera"].tap()
        app.alerts["Camera Not Available"].collectionViews.buttons["OK"].tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 2).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        let textField = element.children(matching: .other).element(boundBy: 1).children(matching: .textField).element
        textField.tap()
        textField.typeText("qwe\n")
        textField.typeText("rtyui\n")

    }
    
    func testLocationScreen() {
        let app = XCUIApplication()
        app.buttons["Sign In"].tap()
        app.navigationBars["Jessy, 22"].buttons["menu icon"].tap()
        app.tables.staticTexts["Location"].tap()
        
        let meetleLocationviewNavigationBar = app.navigationBars["Meetle.LocationView"]
        meetleLocationviewNavigationBar.images["no_one_around_header_like"].tap()
        meetleLocationviewNavigationBar.buttons["message"].tap()
        app.buttons["Invite a Friend"].tap()
        app.navigationBars["Hello"].buttons["Cancel"].tap()
        app.buttons["Search again"].tap()
        app.navigationBars["Veronika, 21"].buttons["message"].tap()
        app.buttons["Send her a message"].tap()
        app.buttons["Keep searching"].tap()
    }
    
    func testSettingsScreen() {
        let app = XCUIApplication()
        app.buttons["Sign In"].tap()
        app.navigationBars["Jessy, 22"].buttons["menu icon"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Settings"].tap()
        app.buttons["Female"].tap()
        app.buttons["Woman"].tap()
        app.sliders["20%"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 2).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 4).press(forDuration: 1.1);
        app.buttons["Miles"].tap()
        
        let menuIconButton = app.navigationBars["Settings"].buttons["menu icon"]
        menuIconButton.tap()
        tablesQuery.staticTexts["Invite a Friend"].tap()
    }
    
}
