import SwiftUI

// MARK: - Menu State & Screens
enum MenuState {
	case collapsed, expanded
}

struct AppScreen: Identifiable, Equatable {
	let id = UUID()
	let title: String
	let icon: String
	
	static let home = AppScreen(title: "Home", icon: "house.fill")
	static let profile = AppScreen(title: "Profile", icon: "person.fill")
	static let settings = AppScreen(title: "Settings", icon: "gearshape.fill")
	
	static let allScreens: [AppScreen] = [.home, .profile, .settings]
}

// MARK: - Main View
struct Animated3DDrawer: View {
	@State private var menuState: MenuState = .collapsed
	@State private var selectedScreen: AppScreen = .home
	@Namespace private var animation
	
	var body: some View {
		ZStack {
			// Menu background
			Color(.systemGray6)
				.ignoresSafeArea()
			
			// 3D Drawer Menu
			menuView
				.offset(x: menuState == .expanded ? 0 : -250)
			
			// Main Content with 3D rotation
			mainContent
				.scaleEffect(menuState == .expanded ? 0.9 : 1)
				.rotation3DEffect(
					.degrees(menuState == .expanded ? 15 : 0),
					axis: (x: 0, y: 1, z: 0),
					perspective: 0.7
				)
				.offset(x: menuState == .expanded ? 250 : 0)
				.disabled(menuState == .expanded)
				.animation(.spring(response: 0.5, dampingFraction: 0.8), value: menuState)
		}
	}
	
	// MARK: - Menu View
	var menuView: some View {
		VStack(alignment: .leading, spacing: 40) {
			ForEach(AppScreen.allScreens) { screen in
				HStack {
					Image(systemName: screen.icon)
						.font(.title2)
						.foregroundColor(selectedScreen == screen ? .blue : .gray)
					Text(screen.title)
						.font(.title2)
						.fontWeight(selectedScreen == screen ? .bold : .regular)
						.foregroundColor(selectedScreen == screen ? .blue : .gray)
				}
				.onTapGesture {
					selectedScreen = screen
					withAnimation { menuState = .collapsed }
				}
			}
			Spacer()
		}
		.padding(.top, 100)
		.padding(.horizontal, 20)
		.frame(maxWidth: 250, alignment: .leading)
		.background(Color.white)
		.edgesIgnoringSafeArea(.all)
		.shadow(radius: 5)
	}
	
	// MARK: - Main Content View
	var mainContent: some View {
		VStack(spacing: 20) {
			HStack {
				Button {
					withAnimation { menuState = menuState == .collapsed ? .expanded : .collapsed }
				} label: {
					Image(systemName: "line.horizontal.3")
						.font(.title)
						.foregroundColor(.black)
				}
				Spacer()
				Text(selectedScreen.title)
					.font(.title2)
					.fontWeight(.bold)
				Spacer()
				Image(systemName: "bell.fill")
					.font(.title2)
					.foregroundColor(.black)
			}
			.padding()
			
			Spacer()
			
			switch selectedScreen {
			case .home:
				Color.blue
					.cornerRadius(20)
					.padding()
			case .profile:
				Color.green
					.cornerRadius(20)
					.padding()
			case .settings:
				Color.orange
					.cornerRadius(20)
					.padding()
			default:
				Spacer()
			}
			
			Spacer()
		}
		.background(Color.white)
		.cornerRadius(menuState == .expanded ? 20 : 0)
		.edgesIgnoringSafeArea(menuState == .expanded ? .all : .bottom)
		.animation(.spring(), value: menuState)
	}
}
