import DateHelper

import Foundation

struct DateFormat {
    static var half_month_date_time_ampm_format = Date.DateFormatType.custom("MM-dd-yyyy hh:mm")
    static var month_date_time_ampm_format = Date.DateFormatType.custom("MM-dd-yyyy hh:mm a")
    static var time_ampm = Date.DateFormatType.custom("HH:mm a")
    static var ampm = Date.DateFormatType.custom("a")
}
