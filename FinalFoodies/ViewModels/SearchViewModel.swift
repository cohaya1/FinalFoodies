//
//  SearchViewModel.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 5/12/23.
//

import Foundation


protocol SearchViewModelProtocol: ObservableObject {
    func search(_ query: String)
}
