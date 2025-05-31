//
//  Home.swift
//  WalletCardAnimation
//
//  Created by Rajesh Triadi Noftarizal on 27/05/25.
//

import SwiftUI

struct Home: View {
    var size: CGSize
    var safeArea: EdgeInsets
    
    /// View Properties
    @State private var showDetailView: Bool = false
    @State private var selectedCard: Card?
    @Namespace private var animation
    
    var body: some View {
        /// ScrollView with Card UI
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                Text("My Wallet")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .trailing) {
                        Button {
                            
                        } label: {
                            Image(.pic)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                        }

                    }
                    .blur(radius: showDetailView ? 5 : 0)
                    .opacity(showDetailView ? 0 : 1)
                
                /// Cards View
                
                let mainOffset = CGFloat(cards.firstIndex(where: { $0.id == selectedCard?.id }) ?? 0) * -size.width
                
                LazyVStack(spacing: 10) {
                    ForEach(cards) { card in
                        /// Convert this scrollview to horizontal without changing any of its properties and by just using the offset modifier
                        let cardOffset = CGFloat(cards.firstIndex(where: { $0.id == card.id }) ?? 0) * size.width
                        
                        CardView(card)
                        /// Making it to occupy the full screen width
                            .frame(width: showDetailView ? size.width : nil)
                        /// Move all the cards to the top with visualEffect modifier
                            .visualEffect { [showDetailView] content, proxy in
                                content
                                    .offset(x: showDetailView ? cardOffset : 0, y: showDetailView ? -proxy.frame(in: .scrollView).minY : 0)
                            }
                    }
                }
                .padding(.top, 25)
                .offset(x: showDetailView ? mainOffset : 0)
            }
            .safeAreaPadding(15)
            .safeAreaPadding(.top, safeArea.top)
        }
        .scrollDisabled(showDetailView)
        .scrollIndicators(.hidden)
        .overlay {
            if let selectedCard, showDetailView {
                DetailView(selectedCard: selectedCard)
                    .padding(.top, expandedCardHeight)
                    .transition(.move(edge: .bottom))
            }
        }
    }
    
    /// Card View
    @ViewBuilder
    func CardView(_ card: Card) -> some View {
        /// Adapting CardView when it's getting expanded
        ZStack {
            Rectangle()
                .fill(card.color.gradient)
            
            /// Card Details View
            VStack(alignment: .leading, spacing: 15) {
                if !showDetailView {
                    VisaImageView(card.visaGeometryID, height: 20)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(card.number)
                        .font(.caption)
                        .foregroundStyle(.white.secondary)
                    
                    Text("$3878.98")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                }
                /// Making it center when the card is expanded
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: showDetailView ? .center : .leading)
                .overlay {
                    ZStack {
                        /// Moving the Visa view here with the help of MatchGeometry Effect
                        if showDetailView {
                            VisaImageView(card.visaGeometryID, height: 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            /// Move close to the date
                                .offset(y: 45)
                        }
                        
                        /// Create a close button and which will be only visible to the selected card
                        if let selectedCard, selectedCard.id == card.id, showDetailView {
                            Button {
                                withAnimation(.smooth(duration: 0.5, extraBounce: 0)) {
                                    self.selectedCard = nil
                                    showDetailView = false
                                }
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.title3.bold())
                                    .foregroundStyle(.white)
                                    .contentShape(.rect)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .transition(.asymmetric(insertion: .opacity, removal: .identity))

                        }
                    }
                }
                .padding(.top, showDetailView ? safeArea.top - 10 : 0)
                
                HStack {
                    Text("Expires: \(card.expires)")
                        .font(.caption)
                    
                    Spacer()
                    
                    Text("iJustine")
                        .font(.callout)
                }
                .foregroundStyle(.white)
            }
            .padding(showDetailView ? 15 : 25)
                
        }
        /// Modify the card height for the detail view
        .frame(height: showDetailView ? expandedCardHeight : nil)
        .frame(height: 200, alignment: .top)
        .clipShape(.rect(cornerRadius: showDetailView ? 0 : 25))
        .onTapGesture {
            /// Closing will be done by the back button
            guard !showDetailView else { return }
            withAnimation(.smooth(duration: 0.5, extraBounce: 0)) {
                selectedCard = card
                showDetailView = true
            }
        }
    }
    
    @ViewBuilder
    func VisaImageView(_ id: String, height: CGFloat) -> some View {
        Image(.visa)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .matchedGeometryEffect(id: id, in: animation)
            .frame(height: height)
    }
    
    var expandedCardHeight: CGFloat {
        safeArea.top + 130
    }
    
}

struct DetailView: View {
    var selectedCard: Card
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 12) {
                ForEach(1...20, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.black.gradient)
                        .frame(height: 45)
                }
            }
            .padding(15)
        }
    }
}

#Preview {
    ContentView()
}
