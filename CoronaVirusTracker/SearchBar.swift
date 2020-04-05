//
//  SearchBar.swift
//  CoronaVirusTracker
//
//  Created by EMRE on 23.03.2020.
//  Copyright © 2020 EMRE. All rights reserved.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {
    typealias UIViewType = UISearchBar
    
    @Binding
    var query: String
    var placeholder: String
    
    class Coordinator : NSObject, UISearchBarDelegate {
        
        @Binding var text : String
        
        init(text : Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
            searchBar.showsCancelButton = true
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            text = ""
            searchBar.resignFirstResponder()
            searchBar.showsCancelButton = false
            searchBar.endEditing(true)
        }
    }
    
    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $query)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> SearchBar.UIViewType {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        return searchBar
    }
    
    
    
    func updateUIView(_ uiView: SearchBar.UIViewType, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = query
    }
}
