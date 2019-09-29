//
//  ComplicationController.swift
//  Citybikes WatchKit Extension
//
//  Created by Wojtek Siudzinski on 24/09/2019.
//  Copyright © 2019 Gaia Green Tech. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        let colors = [
            UIColor(red: 1.0, green: 215.0/255.0, blue: 0.0, alpha: 1.0),
            UIColor(red: 1.0, green: 215.0/255.0, blue: 0.0, alpha: 1.0),
            UIColor(red: 32.0/255.0, green: 148.0/255.0, blue: 250.0/255.0, alpha: 1.0),
            UIColor(red: 32.0/255.0, green: 148.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        ]
        let locations = [
            NSNumber(0.0),
            NSNumber(0.65),
            NSNumber(0.75),
            NSNumber(1.0)
        ]
        
        if complication.family == .modularSmall {
            let template = CLKComplicationTemplateModularSmallColumnsText()
            template.row1Column1TextProvider = CLKSimpleTextProvider(text: "B:")
            template.row1Column2TextProvider = CLKSimpleTextProvider(text: "23")
            template.row2Column1TextProvider = CLKSimpleTextProvider(text: "P:")
            template.row2Column2TextProvider = CLKSimpleTextProvider(text: "14")
            handler(template)
        } else if (complication.family == .utilitarianSmall) || (complication.family == .utilitarianSmallFlat) {
            let template = CLKComplicationTemplateUtilitarianSmallFlat()
            template.textProvider = CLKSimpleTextProvider(text: "B: 23 P: 14")
            handler(template)
        } else if complication.family == .circularSmall {
            let template = CLKComplicationTemplateCircularSmallStackText()
            template.line1TextProvider = CLKSimpleTextProvider(text: "B: 23")
            template.line2TextProvider = CLKSimpleTextProvider(text: "P: 14")
            handler(template)
        } else if complication.family == .graphicCorner {
            let template = CLKComplicationTemplateGraphicCornerGaugeText()
            template.outerTextProvider = CLKSimpleTextProvider(text: "")
            template.leadingTextProvider = CLKSimpleTextProvider(text: "23")
            template.trailingTextProvider = CLKSimpleTextProvider(text: "14")
            
            template.gaugeProvider = CLKSimpleGaugeProvider(style: .ring, gaugeColors: colors, gaugeColorLocations: locations, fillFraction: 0.7)
            handler(template)
        } else if complication.family == .graphicCircular {
            let template = CLKComplicationTemplateGraphicCircularOpenGaugeRangeText()
            template.centerTextProvider = CLKSimpleTextProvider(text: "")
            template.leadingTextProvider = CLKSimpleTextProvider(text: "23")
            template.trailingTextProvider = CLKSimpleTextProvider(text: "14")
            template.gaugeProvider = CLKSimpleGaugeProvider(style: .ring, gaugeColors: colors, gaugeColorLocations: locations, fillFraction: 0.7)
            handler(template)
        } else {
            handler(nil)
        }
    }
    
}
