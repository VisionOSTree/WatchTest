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
    @State var stop: Bool = false
    @State var count: Int = 0


    func callFunc() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.getHeartRate()
                print("got heart rate: \(count)")
                count = count + 1
                if !stop {
                    callFunc()
                }
            }
        }
    
    var body: some View {
        VStack {
            Text("Your heart rate is: \(heartRate)")
            Button(action: startStop, label: {
                Text("stopped: \(stop)")
            })
        }
    }
        
        private func startStop(){
            if stop { //Continue loop
                stop = false
                callFunc()
            } else { //Stop loop
                stop = true
            }
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
