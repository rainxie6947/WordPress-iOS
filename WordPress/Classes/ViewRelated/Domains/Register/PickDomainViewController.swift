import UIKit
import WordPressAuthenticator

class PickDomainViewController: UIViewController, HidableBottomViewOwner {

    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    private var domain: String?

    private var domainsTableViewController: RegisterDomainSuggestionsTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showButtonView(show: false, withAnimation: false)
    }

    @IBOutlet private var buttonViewContainer: UIView! {
        didSet {
            buttonViewController.move(to: self, into: buttonViewContainer)
        }
    }

    private lazy var buttonViewController: NUXButtonViewController = {
        let buttonViewController = NUXButtonViewController.instance()
        buttonViewController.delegate = self
        buttonViewController.setButtonTitles(
            primary: NSLocalizedString("Choose domain",
                                       comment: "Register domain - Title for the Choose domain button of Suggested domains screen")
        )
        return buttonViewController
    }()

    static func instance() -> PickDomainViewController {
        let storyboard = UIStoryboard(name: "Domains", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "PickDomainViewController") as! PickDomainViewController
        return controller
    }

    private func configure() {
        title = NSLocalizedString("Register domain",
                                  comment: "Register domain - Title for the Suggested domains screen")
        addCancelBarButtonItem()
        WPStyleGuide.configureColors(for: view, andTableView: nil)
    }

    private func addCancelBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("Cancel",
                                     comment: "Register domain - Navigation bar cancel button for Suggested domains screen"),
            style: .plain,
            target: self,
            action: #selector(cancelBarButtonTapped)
        )
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let vc = segue.destination as? RegisterDomainSuggestionsTableViewController {
            vc.delegate = self
            vc.siteName = nil
            domainsTableViewController = vc
        }
    }

    // MARK: - Actions

    @objc private func cancelBarButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - DomainSuggestionsTableViewControllerDelegate

extension RegisterDomainSuggestionsViewController: DomainSuggestionsTableViewControllerDelegate {
    func domainSelected(_ domain: String) {
        self.domain = domain
        showButtonView(show: true, withAnimation: true)
    }

    func newSearchStarted() {
        showButtonView(show: false, withAnimation: true)
    }
}

// MARK: - NUXButtonViewControllerDelegate

extension PickDomainViewController: NUXButtonViewControllerDelegate {
    func primaryButtonPressed() {
        let controller = RegisterDomainDetailsViewController()
        controller.domain = domain
        self.navigationController?.pushViewController(controller, animated: true)
    }
}