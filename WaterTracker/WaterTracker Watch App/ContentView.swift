//
//  ContentView.swift
//  WaterTracker Watch App
//
//  Created by Sonia Perez on 12/9/23.
//
import SwiftUI
import UserNotifications

struct CuteProgressBar: View {
    var value: Double
    var maxValue: Double
    @Binding var waterIntake: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .frame(width: geometry.size.width, height: 50)
                    .foregroundColor(Color.gray.opacity(0.3))

                Capsule()
                    .frame(width: CGFloat(value / maxValue) * geometry.size.width, height: 60)
                    .foregroundColor(Color(UIColor(hex: "#997379")))
                    .gesture(DragGesture()
                        .onChanged { gesture in
                            self.updateWaterIntake(with: gesture.location.x, width: geometry.size.width)
                        }
                    )
                    .onTapGesture {
                        self.waterIntake += 8
                    }
                    .overlay(
                        Text("\(Int(waterIntake)) oz")
                            .foregroundColor(.white)
                            .font(.subheadline)
                            .padding(5)
                    )
            }
        }
    }

    private func updateWaterIntake(with locationX: CGFloat, width: CGFloat) {
        let clampedX = min(max(locationX, 0), width)
        self.waterIntake = Double(clampedX / width) * self.maxValue
    }
}

struct ContentView: View {
    @State private var waterIntake = 0.0

    var body: some View {
        VStack {
            Text("Stay Hydrated!")
                .font(.system(size: 20))
                .foregroundColor(Color(UIColor(hex: "#997379")))
                .padding()

            CuteProgressBar(value: waterIntake, maxValue: 100, waterIntake: $waterIntake)
                .foregroundColor(Color(UIColor(hex: "#ccac99")))

            Button(action: {
                // Tapping adds a fixed amount (e.g., 8 oz)
                self.waterIntake += 8
            }) {
                Text("Drink Water")
                    .font(.subheadline)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color(UIColor(hex: "#997379")))                    .cornerRadius(8)
                    .shadow(radius: 5)
            }
        }
        .background(Color(UIColor(red: 1.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)))

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
