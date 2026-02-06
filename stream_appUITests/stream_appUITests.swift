import XCTest

final class stream_appUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {}

    // MARK: Login
    @MainActor
    func testLoginViewIsDisplayedOnLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Vérifie le titre
        XCTAssertTrue(app.staticTexts["MovieStream"].exists)

        // Vérifie les champs
        XCTAssertTrue(app.textFields["login_email"].exists)
        XCTAssertTrue(app.secureTextFields["login_password"].exists)

        // Vérifie le bouton de connexion
        XCTAssertTrue(app.buttons["login_button"].exists)

        // Vérifie le lien d'inscription
        XCTAssertTrue(app.buttons["go_to_register"].exists)
    }


    // MARK: Navigation Login → Register après échec
    @MainActor
    func testLoginFailureThenNavigateToRegister() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--ui-testing-login-fail")
        app.launch()

        // --- Tentative de login ---
        let emailField = app.textFields["login_email"]
        let passwordField = app.secureTextFields["login_password"]
        let loginButton = app.buttons["login_button"]

        XCTAssertTrue(emailField.exists)
        XCTAssertTrue(passwordField.exists)

        emailField.tap()
        emailField.typeText("default@test.com")

        passwordField.tap()
        passwordField.typeText("wrongpassword")

        loginButton.tap()

        // Vérifie qu'une erreur s'affiche
        XCTAssertTrue(
            app.staticTexts.containing(
                NSPredicate(format: "label CONTAINS 'incorrect'")
            ).firstMatch.waitForExistence(timeout: 3)
        )

        // --- Navigation vers Register ---
        let registerButton = app.buttons["go_to_register"]
        XCTAssertTrue(registerButton.exists)
        registerButton.tap()

        XCTAssertTrue(app.staticTexts["Inscription"].exists)
    }


    // MARK: Login Inputs
    @MainActor
    func testLoginFormTyping() throws {
        let app = XCUIApplication()
        app.launch()

        let emailField = app.textFields["login_email"]
        let passwordField = app.secureTextFields["login_password"]

        emailField.tap()
        emailField.typeText("test@email.com")

        passwordField.tap()
        passwordField.typeText("P@ssword123")

        XCTAssertEqual(emailField.value as? String, "test@email.com")
    }

    
    // MARK: RegisterView (dans le même scénario utilisateur)
    @MainActor
    func testRegisterViewFieldsExistAfterLoginFailure() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--ui-testing-login-fail")
        app.launch()

        // Aller à Register
        app.buttons["go_to_register"].tap()

        XCTAssertTrue(app.staticTexts["Inscription"].exists)

        XCTAssertTrue(app.textFields["register_username"].exists)
        XCTAssertTrue(app.textFields["register_email"].exists)
        XCTAssertTrue(app.secureTextFields["register_password"].exists)
        XCTAssertTrue(app.buttons["register_button"].exists)
    }

    
    // MARK: MainTabView
    
    @MainActor
    func testMainTabViewTabsExist() throws {
        let app = XCUIApplication()
        app.launch()

        // Supposé utilisateur déjà connecté (flag UI test recommandé)
        XCTAssertTrue(app.tabBars.buttons["Films"].exists)
        XCTAssertTrue(app.tabBars.buttons["Cast"].exists)
        XCTAssertTrue(app.tabBars.buttons["Profil"].exists)
    }

    
    // MARK: MovieListView
    
    @MainActor
    func testMovieListViewDisplaysList() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Films"].tap()

        // La liste existe
        XCTAssertTrue(app.tables.firstMatch.exists)
    }

    @MainActor
    func testMovieSearchFieldExists() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Films"].tap()
        XCTAssertTrue(app.searchFields.firstMatch.exists)
    }
    
    // MARK: MovieDetailView
    @MainActor
    func testNavigateToMovieDetail() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Films"].tap()

        let firstMovie = app.tables.cells.firstMatch
        XCTAssertTrue(firstMovie.waitForExistence(timeout: 5))
        firstMovie.tap()

        // Titre présent dans la navbar
        XCTAssertTrue(app.navigationBars.firstMatch.exists)
    }

    
    // MARK: Bande-Annonce
    
    @MainActor
    func testTrailerButtonIfExists() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Films"].tap()
        app.tables.cells.firstMatch.tap()

        let trailerButton = app.buttons["Voir la bande annonce"]
        if trailerButton.exists {
            trailerButton.tap()
            XCTAssertTrue(app.otherElements.firstMatch.exists) // sheet
        }
    }


    
    // MARK: PeopleListView
    
    @MainActor
    func testPeopleListViewLoads() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Cast"].tap()
        XCTAssertTrue(app.tables.firstMatch.exists)
    }

    @MainActor
    func testPeopleSearchExists() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Cast"].tap()
        XCTAssertTrue(app.searchFields.firstMatch.exists)
    }
    
    // MARK: PersonDetailView
    
    @MainActor
    func testNavigateToPersonDetail() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Cast"].tap()
        let firstPerson = app.tables.cells.firstMatch

        XCTAssertTrue(firstPerson.waitForExistence(timeout: 5))
        firstPerson.tap()

        XCTAssertTrue(app.navigationBars.firstMatch.exists)
    }

    
    // MARK: ProfileView
    @MainActor
    func testProfileViewDisplaysSections() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Profil"].tap()

        XCTAssertTrue(app.staticTexts["Infos utilisateur"].exists)
        XCTAssertTrue(app.staticTexts["Favoris"].exists)
        XCTAssertTrue(app.staticTexts["Apparence"].exists)
    }

    @MainActor
    func testLogoutButtonExists() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Profil"].tap()
        XCTAssertTrue(app.buttons["Se déconnecter"].exists)
    }

    
    
   

    
    // MARK: Test composants
    
    @MainActor
    func testFavoriteButtonToggle() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Films"].tap()
        app.tables.cells.firstMatch.tap()

        let favoriteButton = app.buttons.matching(identifier: "favorite_button").firstMatch
        if favoriteButton.exists {
            favoriteButton.tap()
        }
    }
        
}
