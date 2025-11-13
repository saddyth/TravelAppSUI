//
//  PageControl.swift
//  TravelAppSwiftUI
//
//  Created by pulino4ka ✌🏻 on 10.10.2025.
//

import Foundation
import SwiftUI

struct PageControl: UIViewRepresentable {
    var numberOfPages: Int
    var currentPage: Int
    var onPageChange: (Int) -> ()
    
    func makeUIView(context: Context) -> UIPageControl{
        let view = UIPageControl()
        view.currentPage = currentPage
        view.numberOfPages = numberOfPages
        view.currentPageIndicatorTintColor = .main
        view.pageIndicatorTintColor = .pageIndicator
        view.addTarget(context.coordinator, action: #selector(Coordinator.onPageUpdate(control:)), for: .valueChanged)
        return view
    }
   
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        DispatchQueue.main.async {
            uiView.numberOfPages = numberOfPages
            uiView.currentPage = currentPage
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(onPageChange: onPageChange)
    }
    
    class Coordinator: NSObject {
        var onPageChange: (Int) -> ()
        init(onPageChange: @escaping (Int) -> Void) {
            self.onPageChange = onPageChange
        }
        
        @objc
        func onPageUpdate(control: UIPageControl){
            onPageChange(control.currentPage)
        }
    }
    
}

