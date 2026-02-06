//
//  LoginAndRegisterUITests.swift
//

import XCTest
import Foundation

extension XCUIElement {
    /// Scroll jusqu'à ce que l'élément soit cliquable
    func scrollToElement(in app: XCUIApplication) {
        var maxSwipes = 10 // éviter boucle infinie
        while !self.isHittable && maxSwipes > 0 {
            app.swipeUp()
            maxSwipes -= 1
        }
    }
    
    /// Attendre que l'élément soit hittable
    func waitForHittable(timeout: TimeInterval = 5) -> Bool {
        let predicate = NSPredicate(format: "isHittable == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        return XCTWaiter().wait(for: [expectation], timeout: timeout) == .completed
    }
}

final class LoginAndRegisterUITests: XCTestCase {

    /// Vérifie si l'utilisateur est connecté et le déconnecte si nécessaire
    @MainActor
    private func ensureUserLoggedOut(app: XCUIApplication) {
        let guestLoginButton = app.buttons["guest_login"]
        if guestLoginButton.exists {
            // Utilisateur déjà déconnecté
            return
        }

        // Vérifier si tab Profil existe
//        let profileTab = app.tabs["tab_profil"]
        let profileTab = app.tabBars.buttons["Profil"]
        if profileTab.waitForExistence(timeout: 3) {
            profileTab.tap()
        }

        // Scroll jusqu'au bouton "Se déconnecter"
        let logoutButton = app.buttons["logout_button"]
        var maxScrolls = 10
        while !logoutButton.exists && maxScrolls > 0 {
            app.swipeUp()
            maxScrolls -= 1
        }

        if logoutButton.exists {
            logoutButton.tap()
        }

        // Retour à l'onglet Films pour continuer le test
        let filmsTab = app.buttons["tab_films"]
        if filmsTab.exists {
            filmsTab.tap()
        }
    }

    @MainActor
    func testGuestLoginAndRegisterFlow() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--ui-testing-login-fail")
        app.launch()

        // Forcer orientation portrait
        XCUIDevice.shared.orientation = .portrait

        // --------------------------
        // 0️⃣ S'assurer que l'utilisateur est déconnecté si nécessaire
        // --------------------------
        ensureUserLoggedOut(app: app)

        // --------------------------
        // 1️⃣ Cliquer sur le bouton "Se connecter" dans GuestMovieListView
        // --------------------------
        let guestLoginButton = app.buttons["guest_login"]
        XCTAssertTrue(guestLoginButton.waitForHittable()) // Attend que le bouton soit cliquable
        guestLoginButton.tap()

        // --------------------------
        // 2️⃣ Vérifie LoginView
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
        // 3️⃣ Tentative de login échouée
        // --------------------------
        emailField.tap()
        emailField.typeText("default@test.com")
        app.keyboards.buttons["Return"].tap()

        passwordField.tap()
        passwordField.typeText("wrongpassword")
        app.keyboards.buttons["Return"].tap()

        loginButton.tap()

        // Vérifie qu'un message d'erreur s'affiche
        XCTAssertTrue(
            app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'incorrect'"))
                .firstMatch
                .waitForExistence(timeout: 3)
        )

        // --------------------------
        // 4️⃣ Navigation vers RegisterView
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
        // 5️⃣ Remplissage des champs et inscription
        // --------------------------
        usernameField.tap()
        usernameField.typeText("DefaultUser")
        app.keyboards.buttons["Return"].tap()

        let randomEmail = generateRandomEmail()
        registerEmailField.tap()
        registerEmailField.typeText(randomEmail)
        app.keyboards.buttons["Return"].tap()

        registerPasswordField.tap()
        registerPasswordField.typeText("P@ssword123")
        app.keyboards.buttons["Return"].tap() // Fermer clavier

        // Scroll si nécessaire et clic sur s'inscrire
        registerButton.scrollToElement(in: app)
        registerButton.tap()
    }

    /// Génère un email aléatoire pour les tests UI
    func generateRandomEmail() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyz0123456789"
        let randomString = String((0..<8).map { _ in letters.randomElement()! })
        return "test\(randomString)@example.com"
    }
}
