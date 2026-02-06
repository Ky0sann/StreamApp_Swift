//
//  LoginAndRegisterUITests.swift
//

import XCTest

final class LoginAndRegisterUITests: XCTestCase {

    @MainActor
    func testLoginAndRegisterFlow() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--ui-testing-login-fail")
        app.launch()

        // --------------------------
        // 1️⃣ Vérifie LoginView
        // --------------------------
        XCTAssertTrue(app.staticTexts["MovieStream"].exists)

        let emailField = app.textFields["login_email"]
        let passwordField = app.secureTextFields["login_password"]
        let loginButton = app.buttons["login_button"]
        let goToRegisterButton = app.buttons["go_to_register"]

        XCTAssertTrue(emailField.exists)
        XCTAssertTrue(passwordField.exists)
        XCTAssertTrue(loginButton.exists)
        XCTAssertTrue(goToRegisterButton.exists)

        // --------------------------
        // 2️⃣ Tentative de login échouée
        // --------------------------
        emailField.tap()
        emailField.typeText("default@test.com")

        passwordField.tap()
        passwordField.typeText("wrongpassword")

        loginButton.tap()

        // Vérifie qu'un message d'erreur s'affiche
        XCTAssertTrue(
            app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'incorrect'"))
                .firstMatch
                .waitForExistence(timeout: 3)
        )

        // --------------------------
        // 3️⃣ Navigation vers RegisterView
        // --------------------------
        goToRegisterButton.tap()

        XCTAssertTrue(app.staticTexts["Inscription"].exists)

        let usernameField = app.textFields["register_username"]
        let registerEmailField = app.textFields["register_email"]
        let registerPasswordField = app.secureTextFields["register_password"]
        let registerButton = app.buttons["register_button"]

        XCTAssertTrue(usernameField.exists)
        XCTAssertTrue(registerEmailField.exists)
        XCTAssertTrue(registerPasswordField.exists)
        XCTAssertTrue(registerButton.exists)

        // --------------------------
        // 4️⃣ Remplissage des champs par défaut et inscription
        // --------------------------
        usernameField.tap()
        usernameField.typeText("DefaultUser")

        registerEmailField.tap()
        registerEmailField.typeText("default@test.com")

        registerPasswordField.tap()
        registerPasswordField.typeText("P@ssword123")

        // Clique sur le bouton S'inscrire
        registerButton.tap()

        // Ici, tu peux ajouter une vérification si l'inscription réussit, par exemple :
        // XCTAssertTrue(app.staticTexts["Bienvenue, DefaultUser"].exists)
    }
}
