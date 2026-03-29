---
name: sr-swift-engineer
description: Build production-grade macOS and iOS applications using AppKit, UIKit, and modern Swift. Emphasizes native frameworks over SwiftUI for maximum control and long-term stability.
---

> **Global Standards:** See [../STANDARDS.md](../STANDARDS.md) for icon library and other cross-platform standards.

# Native Apple Development

Build production-grade macOS and iOS applications using AppKit (macOS) and UIKit (iOS). This skill emphasizes native frameworks over SwiftUI for maximum control, performance, and long-term maintainability.

## Philosophy

**Why AppKit/UIKit over SwiftUI:**
- Complete control over rendering and layout timing
- Mature, stable APIs with decades of refinement
- Better debugging tools and stack traces
- Predictable memory management
- Superior accessibility support
- Full access to system capabilities
- Production apps run on SwiftUI-less systems (macOS 10.13+, iOS 11+)

SwiftUI is evolving rapidly with breaking changes each year. AppKit/UIKit provide stability.

## Stack Context

| Layer | macOS | iOS | Notes |
|-------|-------|-----|-------|
| UI Framework | AppKit | UIKit | Native frameworks only |
| Architecture | MVC / MVVM | MVC / MVVM | Coordinators for navigation |
| Concurrency | Swift Concurrency | Swift Concurrency | async/await, actors |
| Networking | URLSession | URLSession | No third-party HTTP clients |
| Data | Core Data / SwiftData | Core Data / SwiftData | SQLite for simple persistence |
| Build | Swift Package Manager | SPM + Xcode | Prefer SPM over CocoaPods |

## Project Structure

### macOS Application

```
MyApp/
├── MyApp.xcodeproj/
├── MyApp/
│   ├── App/
│   │   ├── AppDelegate.swift           # NSApplicationDelegate
│   │   ├── main.swift                  # Entry point (optional)
│   │   └── AppCoordinator.swift        # Root coordinator
│   ├── Features/
│   │   ├── MainWindow/
│   │   │   ├── MainWindowController.swift
│   │   │   ├── MainViewController.swift
│   │   │   ├── MainViewModel.swift
│   │   │   └── MainWindow.xib          # Optional, can be code-only
│   │   ├── Preferences/
│   │   │   ├── PreferencesWindowController.swift
│   │   │   └── Tabs/
│   │   │       ├── GeneralPrefsViewController.swift
│   │   │       └── AdvancedPrefsViewController.swift
│   │   └── StatusItem/
│   │       ├── StatusItemController.swift
│   │       └── StatusItemMenu.swift
│   ├── Core/
│   │   ├── Services/
│   │   │   ├── NetworkService.swift
│   │   │   └── PersistenceService.swift
│   │   ├── Models/
│   │   │   └── Domain models...
│   │   └── Extensions/
│   │       └── AppKit+Extensions.swift
│   ├── Resources/
│   │   ├── Assets.xcassets
│   │   ├── Main.storyboard            # Or code-only
│   │   └── Localizable.strings
│   └── Supporting Files/
│       ├── Info.plist
│       └── MyApp.entitlements
├── MyAppTests/
├── MyAppUITests/
└── Package.swift                       # If using SPM dependencies
```

### iOS Application

```
MyApp/
├── MyApp.xcodeproj/
├── MyApp/
│   ├── App/
│   │   ├── AppDelegate.swift
│   │   ├── SceneDelegate.swift         # iOS 13+ scene lifecycle
│   │   └── AppCoordinator.swift
│   ├── Features/
│   │   ├── Home/
│   │   │   ├── HomeViewController.swift
│   │   │   ├── HomeViewModel.swift
│   │   │   └── Views/
│   │   │       └── HomeCollectionViewCell.swift
│   │   └── Settings/
│   │       └── SettingsViewController.swift
│   ├── Core/
│   │   ├── Services/
│   │   ├── Models/
│   │   └── Extensions/
│   ├── Resources/
│   │   ├── Assets.xcassets
│   │   ├── LaunchScreen.storyboard
│   │   └── Localizable.strings
│   └── Supporting Files/
│       ├── Info.plist
│       └── MyApp.entitlements
└── Tests/
```

## AppKit Patterns

### AppDelegate

```swift
import AppKit

@main
final class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var mainWindowController: MainWindowController?
    private var statusItemController: StatusItemController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMainWindow()
        setupStatusItem()
        registerDefaults()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        // Cleanup
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        // Return false for menu bar apps
        return true
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    // MARK: - Setup
    
    private func setupMainWindow() {
        mainWindowController = MainWindowController()
        mainWindowController?.showWindow(nil)
    }
    
    private func setupStatusItem() {
        statusItemController = StatusItemController()
    }
    
    private func registerDefaults() {
        UserDefaults.standard.register(defaults: [
            "launchAtLogin": false,
            "showInDock": true
        ])
    }
}
```

### NSWindowController

```swift
import AppKit

final class MainWindowController: NSWindowController {
    
    convenience init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        
        self.init(window: window)
        
        configureWindow()
    }
    
    private func configureWindow() {
        guard let window = window else { return }
        
        window.title = "My App"
        window.minSize = NSSize(width: 400, height: 300)
        window.center()
        
        // Restoration
        window.isRestorable = true
        window.restorationClass = MainWindowController.self
        window.identifier = NSUserInterfaceItemIdentifier("MainWindow")
        
        // Content
        let viewController = MainViewController()
        window.contentViewController = viewController
        
        // Toolbar
        let toolbar = NSToolbar(identifier: "MainToolbar")
        toolbar.delegate = self
        toolbar.displayMode = .iconOnly
        window.toolbar = toolbar
        window.toolbarStyle = .unified
    }
}

// MARK: - NSToolbarDelegate

extension MainWindowController: NSToolbarDelegate {
    
    func toolbar(
        _ toolbar: NSToolbar,
        itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
        willBeInsertedIntoToolbar flag: Bool
    ) -> NSToolbarItem? {
        switch itemIdentifier {
        case .addItem:
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            item.label = "Add"
            item.image = NSImage(systemSymbolName: "plus", accessibilityDescription: "Add")
            item.action = #selector(addItemTapped)
            item.target = self
            return item
        default:
            return nil
        }
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [.flexibleSpace, .addItem]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [.addItem, .flexibleSpace, .space]
    }
    
    @objc private func addItemTapped() {
        // Handle action
    }
}

extension NSToolbarItem.Identifier {
    static let addItem = NSToolbarItem.Identifier("addItem")
}

// MARK: - State Restoration

extension MainWindowController: NSWindowRestoration {
    
    static func restoreWindow(
        withIdentifier identifier: NSUserInterfaceItemIdentifier,
        state: NSCoder,
        completionHandler: @escaping (NSWindow?, Error?) -> Void
    ) {
        let controller = MainWindowController()
        completionHandler(controller.window, nil)
    }
}
```

### NSViewController

```swift
import AppKit

final class MainViewController: NSViewController {
    
    private let viewModel: MainViewModel
    
    // MARK: - Views
    
    private lazy var tableView: NSTableView = {
        let table = NSTableView()
        table.style = .inset
        table.usesAlternatingRowBackgroundColors = true
        table.allowsMultipleSelection = false
        table.delegate = self
        table.dataSource = self
        
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("main"))
        column.title = "Items"
        table.addTableColumn(column)
        
        return table
    }()
    
    private lazy var scrollView: NSScrollView = {
        let scroll = NSScrollView()
        scroll.documentView = tableView
        scroll.hasVerticalScroller = true
        scroll.autohidesScrollers = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    // MARK: - Initialization
    
    init(viewModel: MainViewModel = MainViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not supported")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = NSView()
        view.wantsLayer = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindViewModel()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        Task {
            await viewModel.loadData()
        }
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        view.addSubview(scrollView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onDataChanged = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - NSTableViewDataSource

extension MainViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        viewModel.items.count
    }
}

// MARK: - NSTableViewDelegate

extension MainViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let identifier = NSUserInterfaceItemIdentifier("ItemCell")
        
        let cell = tableView.makeView(withIdentifier: identifier, owner: nil) as? NSTableCellView
            ?? NSTableCellView()
        
        cell.identifier = identifier
        cell.textField?.stringValue = viewModel.items[row].title
        
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let selectedRow = tableView.selectedRow
        guard selectedRow >= 0 else { return }
        viewModel.selectItem(at: selectedRow)
    }
}
```

### ViewModel Pattern

```swift
import Foundation

@MainActor
final class MainViewModel {
    
    // MARK: - Properties
    
    private(set) var items: [Item] = []
    private(set) var isLoading = false
    private(set) var error: Error?
    
    // MARK: - Callbacks
    
    var onDataChanged: (() -> Void)?
    var onError: ((Error) -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?
    
    // MARK: - Dependencies
    
    private let service: DataServiceProtocol
    
    // MARK: - Initialization
    
    init(service: DataServiceProtocol = DataService.shared) {
        self.service = service
    }
    
    // MARK: - Actions
    
    func loadData() async {
        isLoading = true
        onLoadingChanged?(true)
        
        do {
            items = try await service.fetchItems()
            onDataChanged?()
        } catch {
            self.error = error
            onError?(error)
        }
        
        isLoading = false
        onLoadingChanged?(false)
    }
    
    func selectItem(at index: Int) {
        guard index >= 0, index < items.count else { return }
        let item = items[index]
        // Handle selection
    }
    
    func addItem(_ item: Item) async {
        do {
            try await service.save(item)
            items.append(item)
            onDataChanged?()
        } catch {
            onError?(error)
        }
    }
    
    func deleteItem(at index: Int) async {
        guard index >= 0, index < items.count else { return }
        let item = items[index]
        
        do {
            try await service.delete(item)
            items.remove(at: index)
            onDataChanged?()
        } catch {
            onError?(error)
        }
    }
}
```

### Menu Bar / Status Item

```swift
import AppKit

final class StatusItemController {
    
    private var statusItem: NSStatusItem?
    private let menu = NSMenu()
    
    init() {
        setupStatusItem()
        setupMenu()
    }
    
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "star.fill", accessibilityDescription: "My App")
            button.action = #selector(statusItemClicked)
            button.target = self
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
    }
    
    private func setupMenu() {
        menu.addItem(withTitle: "Show Window", action: #selector(showWindow), keyEquivalent: "")
        menu.addItem(.separator())
        menu.addItem(withTitle: "Preferences...", action: #selector(showPreferences), keyEquivalent: ",")
        menu.addItem(.separator())
        menu.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        
        for item in menu.items {
            item.target = self
        }
    }
    
    @objc private func statusItemClicked(_ sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else { return }
        
        if event.type == .rightMouseUp {
            // Show menu on right-click
            statusItem?.menu = menu
            statusItem?.button?.performClick(nil)
            statusItem?.menu = nil
        } else {
            // Toggle popover or window on left-click
            showWindow()
        }
    }
    
    @objc private func showWindow() {
        NSApp.activate(ignoringOtherApps: true)
        // Show main window
    }
    
    @objc private func showPreferences() {
        // Show preferences
    }
    
    // MARK: - Badge / Title Updates
    
    func updateBadge(_ count: Int) {
        statusItem?.button?.title = count > 0 ? "\(count)" : ""
    }
    
    func setIcon(_ systemName: String) {
        statusItem?.button?.image = NSImage(
            systemSymbolName: systemName,
            accessibilityDescription: nil
        )
    }
}
```

### Preferences Window (Tabbed)

```swift
import AppKit

final class PreferencesWindowController: NSWindowController, NSWindowDelegate {
    
    static let shared = PreferencesWindowController()
    
    private init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 400),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        
        super.init(window: window)
        
        window.title = "Preferences"
        window.center()
        window.delegate = self
        
        setupTabs()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupTabs() {
        let tabViewController = NSTabViewController()
        tabViewController.tabStyle = .toolbar
        
        // General tab
        let generalVC = GeneralPrefsViewController()
        generalVC.title = "General"
        let generalItem = NSTabViewItem(viewController: generalVC)
        generalItem.image = NSImage(systemSymbolName: "gear", accessibilityDescription: nil)
        tabViewController.addTabViewItem(generalItem)
        
        // Advanced tab
        let advancedVC = AdvancedPrefsViewController()
        advancedVC.title = "Advanced"
        let advancedItem = NSTabViewItem(viewController: advancedVC)
        advancedItem.image = NSImage(systemSymbolName: "slider.horizontal.3", accessibilityDescription: nil)
        tabViewController.addTabViewItem(advancedItem)
        
        window?.contentViewController = tabViewController
    }
    
    func showWindow() {
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
```

## UIKit Patterns (iOS)

### SceneDelegate

```swift
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
        
        window.makeKeyAndVisible()
    }
}
```

### Coordinator Pattern

```swift
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get }
    
    func start()
}

final class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        window.rootViewController = navigationController
        showHome()
    }
    
    private func showHome() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        homeCoordinator.parentCoordinator = self
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
    
    func childDidFinish(_ child: Coordinator) {
        childCoordinators.removeAll { $0 === child }
    }
}
```

### UIViewController

```swift
import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: HomeViewModel
    weak var coordinator: HomeCoordinator?
    
    // MARK: - Views
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemBackground
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        return collection
    }()
    
    private lazy var dataSource = makeDataSource()
    
    // MARK: - Initialization
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupNavigation()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await viewModel.loadData()
        }
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigation() {
        title = "Home"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .add,
            primaryAction: UIAction { [weak self] _ in
                self?.coordinator?.showAddItem()
            }
        )
    }
    
    private func bindViewModel() {
        viewModel.onDataChanged = { [weak self] in
            self?.applySnapshot()
        }
    }
    
    // MARK: - Collection View
    
    private func createLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            self?.makeSwipeActions(for: indexPath)
        }
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Item> {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { cell, _, item in
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            content.secondaryText = item.subtitle
            cell.contentConfiguration = content
        }
        
        return UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func makeSwipeActions(for indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            Task {
                await self?.viewModel.deleteItem(at: indexPath.row)
                completion(true)
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let item = viewModel.items[indexPath.row]
        coordinator?.showDetail(for: item)
    }
}

// MARK: - Section

extension HomeViewController {
    enum Section {
        case main
    }
}
```

## Networking

### URLSession Service

```swift
import Foundation

protocol NetworkServiceProtocol: Sendable {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    func request(_ endpoint: Endpoint) async throws -> Data
}

actor NetworkService: NetworkServiceProtocol {
    
    static let shared = NetworkService()
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let data = try await request(endpoint)
        return try decoder.decode(T.self, from: data)
    }
    
    func request(_ endpoint: Endpoint) async throws -> Data {
        let request = try endpoint.urlRequest()
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode, data: data)
        }
        
        return data
    }
}

// MARK: - Endpoint

struct Endpoint {
    let path: String
    let method: HTTPMethod
    let queryItems: [URLQueryItem]?
    let body: Data?
    let headers: [String: String]?
    
    init(
        path: String,
        method: HTTPMethod = .get,
        queryItems: [URLQueryItem]? = nil,
        body: Data? = nil,
        headers: [String: String]? = nil
    ) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.body = body
        self.headers = headers
    }
    
    func urlRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.example.com"
        components.path = path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

// MARK: - Errors

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int, data: Data)
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let statusCode, _):
            return "HTTP error: \(statusCode)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        }
    }
}
```

## Sandboxing & Entitlements

### Common Entitlements

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- App Sandbox (required for Mac App Store) -->
    <key>com.apple.security.app-sandbox</key>
    <true/>
    
    <!-- Network access -->
    <key>com.apple.security.network.client</key>
    <true/>
    <key>com.apple.security.network.server</key>
    <true/>
    
    <!-- File access -->
    <key>com.apple.security.files.user-selected.read-write</key>
    <true/>
    <key>com.apple.security.files.downloads.read-write</key>
    <true/>
    
    <!-- Hardware -->
    <key>com.apple.security.device.camera</key>
    <true/>
    <key>com.apple.security.device.microphone</key>
    <true/>
    
    <!-- Hardened Runtime (required for notarization) -->
    <key>com.apple.security.hardened-runtime</key>
    <true/>
    
    <!-- Keychain access groups -->
    <key>keychain-access-groups</key>
    <array>
        <string>$(AppIdentifierPrefix)com.example.myapp</string>
    </array>
</dict>
</plist>
```

### Security-Scoped Bookmarks

```swift
import Foundation

actor BookmarkManager {
    
    private let bookmarksKey = "SecurityScopedBookmarks"
    
    func saveBookmark(for url: URL) throws {
        let bookmark = try url.bookmarkData(
            options: .withSecurityScope,
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        )
        
        var bookmarks = loadBookmarks()
        bookmarks[url.path] = bookmark
        
        UserDefaults.standard.set(bookmarks, forKey: bookmarksKey)
    }
    
    func resolveBookmark(for path: String) throws -> URL? {
        let bookmarks = loadBookmarks()
        guard let bookmarkData = bookmarks[path] else { return nil }
        
        var isStale = false
        let url = try URL(
            resolvingBookmarkData: bookmarkData,
            options: .withSecurityScope,
            relativeTo: nil,
            bookmarkDataIsStale: &isStale
        )
        
        if isStale {
            try saveBookmark(for: url)
        }
        
        return url
    }
    
    private func loadBookmarks() -> [String: Data] {
        UserDefaults.standard.dictionary(forKey: bookmarksKey) as? [String: Data] ?? [:]
    }
}

// Usage
func accessFile(at url: URL) throws {
    guard url.startAccessingSecurityScopedResource() else {
        throw FileError.accessDenied
    }
    
    defer {
        url.stopAccessingSecurityScopedResource()
    }
    
    // Read/write file
}
```

## Code Signing & Notarization

### Build & Notarize Script

```bash
#!/bin/bash
set -e

APP_NAME="MyApp"
BUNDLE_ID="com.example.myapp"
TEAM_ID="YOUR_TEAM_ID"
APPLE_ID="your@email.com"
APP_PASSWORD="xxxx-xxxx-xxxx-xxxx"  # App-specific password

# Build
xcodebuild -project "$APP_NAME.xcodeproj" \
    -scheme "$APP_NAME" \
    -configuration Release \
    -archivePath "build/$APP_NAME.xcarchive" \
    archive

# Export
xcodebuild -exportArchive \
    -archivePath "build/$APP_NAME.xcarchive" \
    -exportPath "build/export" \
    -exportOptionsPlist "ExportOptions.plist"

# Create DMG
hdiutil create -volname "$APP_NAME" \
    -srcfolder "build/export/$APP_NAME.app" \
    -ov -format UDZO \
    "build/$APP_NAME.dmg"

# Notarize
xcrun notarytool submit "build/$APP_NAME.dmg" \
    --apple-id "$APPLE_ID" \
    --password "$APP_PASSWORD" \
    --team-id "$TEAM_ID" \
    --wait

# Staple
xcrun stapler staple "build/$APP_NAME.dmg"

echo "✅ Build, notarize, and staple complete!"
```

### ExportOptions.plist

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>developer-id</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
    <key>signingStyle</key>
    <string>automatic</string>
</dict>
</plist>
```

## Testing

### Unit Tests

```swift
import XCTest
@testable import MyApp

final class MainViewModelTests: XCTestCase {
    
    private var sut: MainViewModel!
    private var mockService: MockDataService!
    
    @MainActor
    override func setUp() {
        super.setUp()
        mockService = MockDataService()
        sut = MainViewModel(service: mockService)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }
    
    @MainActor
    func testLoadData_Success() async {
        // Given
        let expectedItems = [Item(id: "1", title: "Test")]
        mockService.itemsToReturn = expectedItems
        
        var dataChangedCalled = false
        sut.onDataChanged = { dataChangedCalled = true }
        
        // When
        await sut.loadData()
        
        // Then
        XCTAssertEqual(sut.items, expectedItems)
        XCTAssertTrue(dataChangedCalled)
        XCTAssertFalse(sut.isLoading)
    }
    
    @MainActor
    func testLoadData_Failure() async {
        // Given
        mockService.errorToThrow = TestError.networkError
        
        var errorReceived: Error?
        sut.onError = { errorReceived = $0 }
        
        // When
        await sut.loadData()
        
        // Then
        XCTAssertTrue(sut.items.isEmpty)
        XCTAssertNotNil(errorReceived)
    }
}

// MARK: - Mocks

final class MockDataService: DataServiceProtocol {
    var itemsToReturn: [Item] = []
    var errorToThrow: Error?
    
    func fetchItems() async throws -> [Item] {
        if let error = errorToThrow {
            throw error
        }
        return itemsToReturn
    }
    
    func save(_ item: Item) async throws {}
    func delete(_ item: Item) async throws {}
}

enum TestError: Error {
    case networkError
}
```

## Pre-Flight Checklist

Before shipping:

- [ ] App runs on minimum deployment target
- [ ] Memory leaks checked with Instruments
- [ ] CPU usage reasonable (checked with Instruments)
- [ ] No retain cycles (verify with weak references)
- [ ] Accessibility audit passed (VoiceOver works)
- [ ] Dark/Light mode both work correctly
- [ ] Localization complete for target markets
- [ ] All entitlements minimal and justified
- [ ] Info.plist usage descriptions present
- [ ] Code signed with correct certificate
- [ ] Notarization succeeds (macOS)
- [ ] App Sandbox works correctly
- [ ] Crash reporter integrated
- [ ] Analytics respects user privacy

## Related Skills

- Use `/sr-software-architect` for system design
- Use `/sr-production-engineer` for CI/CD and release workflow
