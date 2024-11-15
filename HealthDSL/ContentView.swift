//
//  ContentView.swift
//  HealthDSL
//
//  Created by Andrés Camilo Núñez Garzón on 13/11/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showOnlyAppleSamples = false

    var healthDataSamples: [HealthDataSample] {
        return showOnlyAppleSamples ?
            HealthDataSample.previewSamples(includeNonAppleSamples: true) :
            HealthDataSample.previewSamples()
    }

    var body: some View {
        VStack {
            title()
            Toggle(isOn: $showOnlyAppleSamples) {
                Text("Show only Apple samples")
            }
            Group {
                List(healthDataSamples) { sample in
                    HStack {
                        Text(sample.type.name)
                        Spacer()
                        Text("\(sample.value.value, specifier: "%.2f")")
                        Text("\(sample.type.unit.symbol)")
                    }
                }
                .listStyle(.plain)
                .padding(.horizontal, .zero)
            }
            .padding(.top)
        }
        .padding()

        Spacer()
    }

    @ViewBuilder
    func title() -> some View {
        HStack {
            Text("Health Data Samples")
            Image(systemName: "heart")
                .foregroundStyle(.red)
                .fontWeight(.bold)
            Spacer()
        }
        .font(.title)

        Divider()
    }
}

#Preview {
    ContentView()
}
