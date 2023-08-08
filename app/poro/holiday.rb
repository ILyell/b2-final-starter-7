class Holiday
    attr_reader :date, :name
    def initialize(data)
        # binding.pry;
        @date = data["date"]
        @name = data["name"]
    end
end