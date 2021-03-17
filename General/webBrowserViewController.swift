//
//  webBrowserViewController.swift
//  kocinarteRepartidor
//
//  Created by Brandon Gonzalez on 27/02/21.
//

import UIKit
import WebKit

class webBrowserViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        let url = URL(string: "https://www.kocinaarte.com/administracion/login.php#nuevo_repartidor")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
 
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
