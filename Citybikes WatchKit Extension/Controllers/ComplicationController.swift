//
//  ComplicationController.swift
//  Citybikes WatchKit Extension
//
//  Created by Wojtek Siudzinski on 24/09/2019.
//  Copyright © 2019 Gaia Green Tech. All rights reserved.
//

import ClockKit
import WatchKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    weak var delegate: ExtensionDelegate! = WKExtension.shared().delegate as? ExtensionDelegate
    let bicycleTint = UIColor(red: 1.0, green: 215.0/255.0, blue: 0.0, alpha: 1.0)
    let parkingTint = UIColor(red: 32.0/255.0, green: 148.0/255.0, blue: 250.0/255.0, alpha: 1.0)
    let bicycleTextProvider = CLKSimpleTextProvider(text: "B")
    let parkingTextProvider = CLKSimpleTextProvider(text: "P")
    let bicycleValueProvider = CLKSimpleTextProvider(text: "--")
    let parkingValueProvider = CLKSimpleTextProvider(text: "--")
    var colors: [UIColor] = []

    private func setupProviders() {
        if colors.count != 0 {
            // We probably already set up all the providers
            return
        }
        colors = [
            bicycleTint,
            bicycleTint,
            parkingTint,
            parkingTint
        ]
        bicycleTextProvider.tintColor = bicycleTint
        parkingTextProvider.tintColor = parkingTint
    }

    /**
       Creates a template for the Modular Small complication
    
       - Parameter bicycles: Number of available bicycles
       - Parameter parkings: Number of parking spots available
    */
    private func getModularSmallTemplate(bicycles: Int,
                                         parkings: Int) -> CLKComplicationTemplateModularSmallColumnsText {
        if bicycles != 0 && parkings != 0 {
            bicycleValueProvider.text = "\(bicycles)"
            parkingValueProvider.text = "\(parkings)"
        }

        let template = CLKComplicationTemplateModularSmallColumnsText()
        template.row1Column1TextProvider = bicycleTextProvider
        template.row1Column2TextProvider = bicycleValueProvider
        template.row2Column1TextProvider = parkingTextProvider
        template.row2Column2TextProvider = parkingValueProvider
        return template
    }

    /**
       Creates a template for the Utilitarian Small complication
    
       - Parameter bicycles: Number of available bicycles
       - Parameter parkings: Number of parking spots available
    */
    private func getUtilitarianSmallTemplate(bicycles: Int,
                                             parkings: Int) -> CLKComplicationTemplateUtilitarianSmallFlat {
        if bicycles != 0 && parkings != 0 {
            bicycleValueProvider.text = "\(bicycles)"
            parkingValueProvider.text = "\(parkings)"
        }

        let template = CLKComplicationTemplateUtilitarianSmallFlat()
        template.textProvider = CLKTextProvider(
            format: "%@ %@ %@ %@",
            bicycleTextProvider,
            bicycleValueProvider,
            parkingTextProvider,
            parkingValueProvider
        )
        return template
    }

    /**
       Creates a template for the Circular Small complication
    
       - Parameter bicycles: Number of available bicycles
       - Parameter parkings: Number of parking spots available
    */
    private func getCircularSmallTemplate(bicycles: Int,
                                          parkings: Int) -> CLKComplicationTemplateCircularSmallStackText {
        if bicycles != 0 && parkings != 0 {
            bicycleValueProvider.text = "\(bicycles)"
            parkingValueProvider.text = "\(parkings)"
        }

        let template = CLKComplicationTemplateCircularSmallStackText()
        template.line1TextProvider = CLKTextProvider(format: "%@ %@", bicycleTextProvider, bicycleValueProvider)
        template.line2TextProvider = CLKTextProvider(format: "%@ %@", parkingTextProvider, parkingValueProvider)
        return template
    }

    /**
        Creates a template for the Graphic Corner complication
     
        - Parameter bicycles: Number of available bicycles
        - Parameter parkings: Number of parking spots available
     */
    private func getGraphicCornerTemplate(bicycles: Int,
                                          parkings: Int) -> CLKComplicationTemplateGraphicCornerGaugeText {
        let isUnknown = bicycles == 0 && parkings == 0
        var fraction = Float(bicycles) / Float(bicycles + parkings)
        var locations: [NSNumber] = []

        if isUnknown {
            // Empty state
            locations.append(NSNumber(0.0))
            fraction = 0.5
        } else {
            bicycleValueProvider.text = "\(bicycles)"
            parkingValueProvider.text = "\(parkings)"
            locations = [ NSNumber(0.0), NSNumber(value: fraction), NSNumber(value: fraction), NSNumber(1.0) ]
        }

        let template = CLKComplicationTemplateGraphicCornerGaugeText()
        template.outerTextProvider = CLKSimpleTextProvider(text: "")
        template.leadingTextProvider = bicycleValueProvider
        template.leadingTextProvider?.tintColor = bicycleTint
        template.trailingTextProvider = parkingValueProvider
        template.trailingTextProvider?.tintColor = parkingTint

        template.gaugeProvider = CLKSimpleGaugeProvider(
            style: .ring,
            gaugeColors: isUnknown ? [UIColor.gray] : colors,
            gaugeColorLocations: locations,
            fillFraction: fraction
        )
        return template
    }

    /**
       Creates a template for the Graphic Circular complication
    
       - Parameter bicycles: Number of available bicycles
       - Parameter parkings: Number of parking spots available
    */
    private func getGraphicCircularTemplate(bicycles: Int,
                                            parkings: Int) -> CLKComplicationTemplateGraphicCircularOpenGaugeRangeText {
        let isUnknown = bicycles == 0 && parkings == 0
        var fraction = Float(bicycles) / Float(bicycles + parkings)
        var locations: [NSNumber] = []

        if isUnknown {
            // Empty state
            locations.append(NSNumber(0.0))
            fraction = 0.0
        } else {
            bicycleValueProvider.text = "\(bicycles)"
            parkingValueProvider.text = "\(parkings)"
            locations = [ NSNumber(0.0), NSNumber(value: fraction), NSNumber(value: fraction), NSNumber(1.0) ]
        }

        let template = CLKComplicationTemplateGraphicCircularOpenGaugeRangeText()
        template.centerTextProvider = CLKSimpleTextProvider(text: "")
        template.leadingTextProvider = bicycleValueProvider
        template.leadingTextProvider.tintColor = bicycleTint
        template.trailingTextProvider = parkingValueProvider
        template.trailingTextProvider.tintColor = parkingTint
        template.gaugeProvider = CLKSimpleGaugeProvider(
            style: .ring,
            gaugeColors: isUnknown ? [UIColor.gray] : colors,
            gaugeColorLocations: locations,
            fillFraction: fraction
        )
        return template
    }

    // MARK: - Placeholder Templates

    func getLocalizableSampleTemplate(for complication: CLKComplication,
                                      withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        self.setupProviders()

        let bicycles = 23
        let parkings = 14

        var template: CLKComplicationTemplate?

        switch complication.family {
        case .modularSmall:
            template = self.getModularSmallTemplate(bicycles: bicycles, parkings: parkings)
        case .utilitarianSmall, .utilitarianSmallFlat:
            template = self.getUtilitarianSmallTemplate(bicycles: bicycles, parkings: parkings)
        case .circularSmall:
            template = self.getCircularSmallTemplate(bicycles: bicycles, parkings: parkings)
        case .graphicCorner:
            template = self.getGraphicCornerTemplate(bicycles: bicycles, parkings: parkings)
        case .graphicCircular:
            template = self.getGraphicCircularTemplate(bicycles: bicycles, parkings: parkings)
        default:
            break
        }
        handler(template)
    }

    // MARK: - Timeline Configuration

    func getSupportedTimeTravelDirections(for complication: CLKComplication,
                                          withHandler handler:@escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([])
    }

    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }

    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }

    func getPrivacyBehavior(for complication: CLKComplication,
                            withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population

    func getCurrentTimelineEntry(for complication: CLKComplication,
                                 withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        let (bicycles, parkings) = (self.delegate.model?.nearbyStats())!
        let date = Date()
        var template: CLKComplicationTemplate?
        var timelineEntry: CLKComplicationTimelineEntry?

        switch complication.family {
        case .modularSmall:
            template = self.getModularSmallTemplate(bicycles: bicycles, parkings: parkings)
        case .utilitarianSmall, .utilitarianSmallFlat:
            template = self.getUtilitarianSmallTemplate(bicycles: bicycles, parkings: parkings)
        case .circularSmall:
            template = self.getCircularSmallTemplate(bicycles: bicycles, parkings: parkings)
        case .graphicCorner:
            template = self.getGraphicCornerTemplate(bicycles: bicycles, parkings: parkings)
        case .graphicCircular:
            template = self.getGraphicCircularTemplate(bicycles: bicycles, parkings: parkings)
        default:
            break
        }
        if template != nil {
            timelineEntry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template!)
        }
        handler(timelineEntry)
    }

    func getTimelineEntries(for complication: CLKComplication,
                            before date: Date,
                            limit: Int,
                            withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }

    func getTimelineEntries(for complication: CLKComplication,
                            after date: Date,
                            limit: Int,
                            withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
}
