//
//  ViewController.swift
//  Demo
//
//  Created by shim on 2015-08-08.
//  Copyright (c) 2015 Bupkis. All rights reserved.
//

import UIKit

class ViewController: SBAccordionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let subItem = ["SubItem1","SubItem2","SubItem3","SubItem4"]
        self.headers = [SBAccordionHeader(header: "Header1",subItems: subItem),SBAccordionHeader(header: "Header2",subItems: subItem),SBAccordionHeader(header: "Header3",subItems: subItem)]
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

