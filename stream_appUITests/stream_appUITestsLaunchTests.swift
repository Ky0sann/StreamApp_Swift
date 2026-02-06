import XCTest

final class stream_appUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testAppLaunchAndInitialScreen() throws {
        let app = XCUIApplication()

        // Optionnel : flags UI Tests
        app.launchArguments.append("--ui-testing")
        app.launch()

        // CAS 1 : écran Login
        if app.staticTexts["MovieStream"].exists {
            XCTAssertTrue(app.textFields["Email"].exists)
            XCTAssertTrue(app.secureTextFields["Mot de passe"].exists)

            let loginAttachment = XCTAttachment(screenshot: app.screenshot())
            loginAttachment.name = "Launch - Login Screen"
            loginAttachment.lifetime = .keepAlways
            add(loginAttachment)

            return
        }

        // CAS 2 : utilisateur déjà connecté → MainTabView
        if app.tabBars.firstMatch.exists {
            XCTAssertTrue(app.tabBars.buttons["Films"].exists)
            XCTAssertTrue(app.tabBars.buttons["Cast"].exists)
            XCTAssertTrue(app.tabBars.buttons["Profil"].exists)

            let mainAttachment = XCTAttachment(screenshot: app.screenshot())
            mainAttachment.name = "Launch - MainTabView"
            mainAttachment.lifetime = .keepAlways
            add(mainAttachment)

            return
        }

        // Si aucun écran attendu n'est trouvé
        XCTFail("Aucun écran valide détecté au lancement")
    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
