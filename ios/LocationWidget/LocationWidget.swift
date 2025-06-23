//
//  LocationWidget.swift
//  LocationWidget
//
//  Created by 🐽 Mr9esx on 2025/6/21.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), locationText: "获取位置中...", accuracy: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), locationText: "位置记录", accuracy: nil)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        
        // 获取当前位置
        LocationManager.shared.getCurrentLocation { location, address, error in
            let locationText: String
            let accuracy: Double?
            
            if let location = location {
                if let address = address, !address.isEmpty {
                    locationText = address
                } else {
                    locationText = String(format: "%.4f, %.4f", location.coordinate.latitude, location.coordinate.longitude)
                }
                accuracy = location.horizontalAccuracy
            } else if let error = error {
                locationText = "定位失败: \(error.localizedDescription)"
                accuracy = nil
            } else {
                locationText = "获取位置中..."
                accuracy = nil
            }
            
            // 创建当前时间的条目
            let entry = SimpleEntry(date: currentDate, locationText: locationText, accuracy: accuracy)
            entries.append(entry)
            
            // 创建下一次更新的时间线（15分钟后）
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
            let timeline = Timeline(entries: entries, policy: .after(nextUpdate))
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let locationText: String
    let accuracy: Double?
}

struct LocationWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 12))
                
                Text("位置记录")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            Text(entry.locationText)
                .font(.system(size: 10))
                .foregroundColor(.secondary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            HStack {
                if let accuracy = entry.accuracy {
                    Text("精度: \(Int(accuracy))m")
                        .font(.system(size: 8))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text(entry.date, style: .time)
                    .font(.system(size: 8))
                    .foregroundColor(.gray)
            }
        }
        .padding(8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(.systemBackground))
    }
}

struct LocationWidget: Widget {
    let kind: String = "LocationWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LocationWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("位置记录")
        .description("显示您的当前位置信息")
        .supportedFamilies([.systemSmall])
    }
}

@main
struct LocationWidgetBundle: WidgetBundle {
    var body: some Widget {
        LocationWidget()
    }
}

// iOS 14兼容的预览
struct LocationWidget_Previews: PreviewProvider {
    static var previews: some View {
        LocationWidgetEntryView(entry: SimpleEntry(date: Date(), locationText: "北京市朝阳区", accuracy: 10.0))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

