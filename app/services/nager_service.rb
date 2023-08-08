class NagerService

    def next_holidays
        response = connection.get("/api/v3/NextPublicHolidays/US")
        parsed = JSON.parse(response.body)
        holidays = []
        parsed[0..2].each do |holiday|
            holidays << Holiday.new(holiday)
        end
        holidays
    end

    def connection
        Faraday.new(url: "https://date.nager.at/swagger/index.html")
    end
end