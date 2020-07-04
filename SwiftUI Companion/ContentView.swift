//
//  ContentView.swift
//  SwiftUI Companion
//
//  Created by Jerry Hanks on 02/07/2020.
//  Copyright © 2020 Jerry Okafor. All rights reserved.
//

//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        Text("Hello, World!")
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}


import SwiftUI

struct ContentView: View {
    @State var isDrawerOpen: Bool = false

    var body: some View {
        return ZStack{
            NavigationView{
                GeometryReader{geo in
                    TextCompanion()
                    .navigationBarItems(leading: Button(action: {
                        //update drawer status on the main thread
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.isDrawerOpen.toggle()
                        }
                    }){Image(R.image.sideMenu.name)}.padding(5))
                    
                    
                }
            }
            
            //add navigation drawer
            NavigationDrawer(isOpen: self.$isDrawerOpen)
                .edgesIgnoringSafeArea([.top,.bottom])
                .transition(.move(edge: .leading))
                .animation(.interpolatingSpring(stiffness: 50, damping: 1))
                .onTapGesture {
                    if self.isDrawerOpen{self.isDrawerOpen.toggle()}
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct BottomMenu : View {
    var body: some View{
        VStack{
            Divider()
            HStack(alignment: .center, spacing: 10) {
                HStack(alignment: .center, spacing: 10) {
                    Image(R.image.settings.name)
                    Text("Settings")
                }.frame(alignment:.leading)
                Spacer(minLength: 8)
                Divider()
                Spacer(minLength: 8)
                HStack(alignment: .center, spacing: 10) {
                    Image(R.image.logOut.name)
                    Text("Log Out")
                }.frame(alignment:.leading)
            }.frame(height: 50)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        }
    }

}

struct DrawerHeader : View {
    var body: some View{
        VStack(alignment: .leading){
            Image(R.image.logo.name)
                .resizable()
                .frame(width: 75, height: 75, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                .clipShape(Circle())
        }
    }
}

struct Menu : Hashable {
    let title:String!
    let icon:UIImage!
}

struct DrawerContent : View{
    @Environment(\.colorScheme) var colorScheme

    private let backgroundLight = LinearGradient(gradient: Gradient(colors: [Color(.white), Color(.white)]), startPoint: .top, endPoint: .bottom)
    private let backgroundDark = LinearGradient(gradient: Gradient(colors: [Color(UIColor(hex: "#3b3d43")), Color(UIColor(hex: "#3c4561"))]), startPoint: .top, endPoint: .bottom)


    let menus = [Menu(title: "Quizs", icon:R.image.quizes()),
                 Menu(title: "My Chats", icon:R.image.myChats()),
                 Menu(title: "Leaderboard", icon:R.image.leaderBoard()),
                 Menu(title: "Notiifcations", icon:R.image.leaderBoard()),
                 Menu(title: "Earn Coin", icon:R.image.earnCoin())]
    
    init() {
        UITableView.appearance().separatorStyle = .none
        UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().backgroundColor = .clear
    }

    var body: some View{
        GeometryReader{geo in
            VStack(alignment: .leading, spacing:8){
                Spacer(minLength: 0).frame(height: 30)
                DrawerHeader()
                Spacer(minLength: 0).frame(height: 10)
                
                List{
                    Section(header: Text("View").font(.system(size: 20))) {
                       ForEach(self.menus, id: \.self) { menu in
                            HStack(alignment: .center, spacing: 20) {
                                Image(uiImage: menu.icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .padding(EdgeInsets(top: 4, leading: 20, bottom: 4, trailing: 0))

                                Text(menu.title)
                                    .font(.system(size: 18))
                                    .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                            }.frame(minWidth: 0, maxWidth: geo.size.width,alignment: .leading)
                        }
                        
                    }
                    
                    Section(header: Text("Layout").font(.system(size: 20))) {
                       ForEach(self.menus, id: \.self) { menu in
                            HStack(alignment: .center, spacing: 20) {
                                Image(uiImage: menu.icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .padding(EdgeInsets(top: 4, leading: 20, bottom: 4, trailing: 0))

                                Text(menu.title)
                                    .font(.system(size: 18))
                                    .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                            }.frame(minWidth: 0, maxWidth: geo.size.width,alignment: .leading)
                        }
                        
                    }
                    
                    
                    }.listStyle(GroupedListStyle())
                    
                    .listRowBackground(Color.clear)

//                Spacer()
//                BottomMenu()

            }
            .frame(width: geo.size.width, height: geo.size.height,alignment: .top)
            .background(self.colorScheme == .dark ? self.backgroundDark : self.backgroundLight)

        }
    }
}


struct NavigationDrawer : View {
    private let width   = UIScreen.main.bounds.width - 100

    @Binding var isOpen : Bool

    var body: some View{
        HStack{
            DrawerContent()
                .frame(width:self.width)
                .offset(x: self.isOpen ? 0: -self.width)
                .animation(Animation.spring(response: 0.5, dampingFraction: 1.0, blendDuration: 0.4))
            Spacer()
        }

    }
}
