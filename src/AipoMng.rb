require 'rubygems'
require 'httpclient'
require 'json'
require 'net/http'
require 'kconv'

class AipoMng

 Net::HTTP.version_1_2

    def initialize(aipoid , aipopw)
        @aipoid = aipoid
        @aipopw = aipopw
    end

    def aipo_getIcs
            response = Net::HTTP.start('zrportal.ndensan.co.jp') {|http|
                    req = Net::HTTP::Get.new('/aipo/ical/calendar.ics')
                    req.basic_auth @aipoid, @aipopw
                    http.request(req)
            }.body
    end

    def ics_filewrite
        file = open("calendar.ics", "wb") 
        file.write(aipo_getIcs)
        file.close()
    end

end
