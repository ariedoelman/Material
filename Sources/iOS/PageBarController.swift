/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	*	Redistributions of source code must retain the above copyright notice, this
 *		list of conditions and the following disclaimer.
 *
 *	*	Redistributions in binary form must reproduce the above copyright notice,
 *		this list of conditions and the following disclaimer in the documentation
 *		and/or other materials provided with the distribution.
 *
 *	*	Neither the name of CosmicMind nor the names of its
 *		contributors may be used to endorse or promote products derived from
 *		this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit

extension UIViewController {
    /**
     A convenience property that provides access to the PageBarController.
     This is the recommended method of accessing the PageBarController
     through child UIViewControllers.
     */
    public var pageBarController: PageBarController? {
        var viewController: UIViewController? = self
        while nil != viewController {
            if viewController is PageBarController {
                return viewController as? PageBarController
            }
            viewController = viewController?.parent
        }
        return nil
    }
}

@objc(PageBarControllerDelegate)
public protocol PageBarControllerDelegate: MaterialDelegate {

}

@objc(PageBarController)
open class PageBarController: RootController {
    /// Reference to the PageBar.
    open internal(set) var pageBar: PageBar!
    
    /// Delegation handler.
    public weak var delegate: PageBarControllerDelegate?
    
    /**
     To execute in the order of the layout chain, override this
     method. LayoutSubviews should be called immediately, unless you
     have a certain need.
     */
    open override func layoutSubviews() {
        super.layoutSubviews()
        guard let v = pageBar else {
            return
        }
        
        let h = Device.height
        let w = Device.width
        let p = v.intrinsicContentSize.height + v.grid.layoutEdgeInsets.top + v.grid.layoutEdgeInsets.bottom
        let y = h - p
        
        v.y = y
        v.width = w + v.grid.layoutEdgeInsets.left + v.grid.layoutEdgeInsets.right
        v.height = p
        
        rootViewController.view.frame.origin.y = 0
        rootViewController.view.frame.size.height = y
    }
    
    /**
     Prepares the view instance when intialized. When subclassing,
     it is recommended to override the prepareView method
     to initialize property values and other setup operations.
     The super.prepareView method should always be called immediately
     when subclassing.
     */
    open override func prepareView() {
        super.prepareView()
        preparePageBar()
    }
    
    /// Prepares the pageBar.
    private func preparePageBar() {
        if nil == pageBar {
            pageBar = PageBar()
            pageBar.zPosition = 1000
            view.addSubview(pageBar)
        }
    }
}
