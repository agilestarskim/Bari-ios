//
//  Map.swift
//  Bari
//
//  Created by 김민성 on 2022/12/30.
//
import CoreLocation
import Contacts
import Foundation

extension CLPlacemark {
    /// street name, eg. Infinite Loop
    var streetName: String? { thoroughfare }
    /// // eg. 1
    var streetNumber: String? { subThoroughfare }
    /// city, eg. Cupertino
    var city: String? { locality }
    /// neighborhood, common name, eg. Mission District
    var neighborhood: String? { subLocality }
    /// state, eg. CA
    var state: String? { administrativeArea }
    /// county, eg. Santa Clara
    var county: String? { subAdministrativeArea }
    /// zip code, eg. 95014
    var zipCode: String? { postalCode }
    /// postal address formatted
    @available(iOS 11.0, *)
    var fullName: String {
        guard let postalAddress = postalAddress else { return ""}
        let fullName = CNPostalAddressFormatter().string(from: postalAddress)
        if let lastSpaceRange = fullName.range(of: " ", options: .backwards) {
            let newString = fullName.prefix(upTo: lastSpaceRange.lowerBound)
            return String(newString.replacingOccurrences(of: "\n", with: " "))
        }else {
            return ""
        }
    }
}

extension CLLocation {
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}
