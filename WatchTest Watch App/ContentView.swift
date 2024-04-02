//
//  ContentView.swift
//  WatchTest Watch App
//
//  Created by Daniel Braithwaite on 2/4/2024.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @State private var heartRate: Double = 0
    var body: some View {
        VStack {
            Text("Your heart rate is: \(heartRate)")
            Button(action: self.getHeartRate, label: {
                Text("Get heart rate")
            })
        }
        .padding()
    }
    
    private func getHeartRate(){
        let healthStore = HKHealthStore()
        
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        
        let date = Date();
        
        let predicate = HKQuery.predicateForSamples(withStart: date.addingTimeInterval(-60), end: date, options: .strictEndDate)
        
        let query = HKStatisticsQuery(quantityType: heartRateType, quantitySamplePredicate: predicate, options: .discreteAverage) { _, result, _ in
            guard let result = result, let quantity = result.averageQuantity() else {
                return
            }
            self.heartRate = quantity.doubleValue(for: HKUnit(from: "count/min"))
            }
        healthStore.execute(query)
    }
}

#Preview {
    ContentView()
}
