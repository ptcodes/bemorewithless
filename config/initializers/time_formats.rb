Time::DATE_FORMATS[:date] = lambda { |date| date.strftime("%d %B, %H:%M") }
Time::DATE_FORMATS[:year] = lambda { |date| date.strftime("%b %d %Y") }
