require 'gcalapi'
require 'date'
require 'icalendar'
require 'simple-rss'
require 'vpim/icalendar'

class IcsToGcal
    def initialize(google_id,google_pw,calendar_name,ics)
        @google_id = google_id
        @google_pw = google_pw
        @calendar_name = calendar_name
        @ics = ics
    end
    
    def import_gics
        delete_events
        copy_events_from_ics_to_google_calendar
    end

private
    def delete_events
        google_calendar.events(conditions).each do |e|
            e.destroy!
        end
    end

    def google_calendar
        @google_calendar ||= GoogleCalendar::Calendar::new(service, calendar_link)
    end

    def service
        @service ||= begin
            GoogleCalendar::Service.proxy_addr = "proxy.ndensan.co.jp"
            GoogleCalendar::Service.new(@google_id,@google_pw)
        end
    end

    def calendar_link
        get_calendar_link_from calendars
    end

    def calendars
        SimpleRSS.parse(service.calendars.body).entries
    end

    def get_calendar_link_from(calendars)
        link = nil
        calendars.each do |calendar|
            if calendar[:title].toutf8 == @calendar_name
                link = calendar[:link]
                break
            end
        end
        link
    end

    def copy_events_from_ics_to_google_calendar
        ical = Icalendar::parse(@ics,true)
        ical.events.each do |event|
            create_event event
        end
    end
    
    def create_event(event)
         dtstart = Time.parse(event.dtstart.to_s.sub(/\+.*/, ''))
         dtend = Time.parse(event.dtend.to_s.sub(/\+.*/, ''))
         if event.recurrence_rules?
             diff = dtend - dtstart
             Vpim::Rrule.new(dtstart, event.recurrence_rules.first.orig_value).each() do |time|
                 set_event_to_calendar(event,time,time + diff)
             end
         else
             set_event_to_calendar(event, dtstart, dtend)
         end
    end

    def set_event_to_calendar(event, dtstart, dtend)
        attributes = create_event_attributes event, dtstart, dtend
        ge = google_calendar.create_event
        ge = update_attributes ge, attributes
        ge.save! unless Date.strptime(event.dtstart.to_s,"%Y-%m-%d") < conditions['start-min']
    end

    def create_event_attributes(event, dtstart, dtend)
        {
            :title  => event.summary,
            :st     => dtstart,
            :en     => dtend,
            :desc   => event.description,
            :where  => event.location,
            :allday => (dtstart.hour == 0 and dtstart.min == 0 and dtend.hour == 0 and dtend.min == 0)
        }
    end

    def update_attributes(event, attributes)
        attributes.each do |key, value|
            event.__send__("#{key.to_s}=", value)
        end
        event
    end

    def conditions
        {
            'start-min' => Date.today - 7,
            'start-max' => Date.today + 31,
            'max-results' => 100
        }
    end
end
