//
//  BookListCell.swift
//  Nuvilab
//
//  Created by 심영민 on 12/3/24.
//

import SwiftUI

struct BookListCell: View {
    let item: BookInformationModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text(item.genre)
                .foregroundStyle(.blue)
                .font(.caption)
            
            Text(item.bookName)
                .font(.title2)
            
            HStack {
                Text(item.authorName)
                
                Divider()
                    .frame(width: 1, height: 16)
                    .background(.gray)
                
                Text(item.publisher)
                
                Divider()
                    .frame(width: 1, height: 16)
                    .background(.gray)
                
                Text(item.publicationYear)
                    .foregroundStyle(.gray)
            }
            
            HStack {
                Text("대여가능여부: ")
                Text(item.isLoaned ? "Y" : "N")
            }
            .font(.caption)
            
            HStack(alignment: .top) {
                Text(item.descriptions)
                    .lineLimit(3)
                    .font(.caption)
            }
        }
    }
}
