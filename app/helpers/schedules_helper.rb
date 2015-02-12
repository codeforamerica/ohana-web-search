module SchedulesHelper
  # @param schedules [Array] List of hashes with weekday hours information.
  # @return [HTML] Snippet of opening hours per weekday.
  def regular_hours_for(schedules)
    schedules.group_by { |sch| [sch.opens_at, sch.closes_at] }.map do |k, v|
      regular_schedule_content_for(v[0].weekday, v[-1].weekday, k[0], k[1])
    end.join(' ').html_safe
  end

  # @param schedules [Array] List of hashes with weekday hours information.
  # @return [HTML] Snippet of opening hours per weekday and date.
  def holiday_hours_for(schedules)
    schedules.map { |schedule| holiday_schedule_content_for(schedule) }.
      join(' ').html_safe
  end

  private

  # REGULAR SCHEDULE HELPERS
  # Private helper methods used for regular schedules.

  # Used by the `regular_hours_for` helper.
  # @param start_day [Integer] An integer representing a weekday.
  # @param end_day [Integer] An integer representing a weekday.
  # @param open_time [Time] An opening hours timestamp.
  # @param close_time [Time] A closing hours timestamp.
  # @return [HTML] Snippet of opening hours for a single weekday
  #   or range of weekdays.
  def regular_schedule_content_for(start_day, end_day, open_time, close_time)
    content_tag :section do
      "#{weekday_range_for(start_day, end_day)}: "\
      "#{time_range_for(open_time, close_time)}".html_safe
    end
  end

  # @param day [Integer] An integer representing the weekday. 1 = Monday, etc.
  # @return [HTML] Weekday name wrapped in a span element.
  def weekday_range_for(start_day, end_day)
    content_tag :span, class: 'weekdays' do
      return weekday_content_for(start_day) if start_day == end_day
      "#{weekday_content_for(start_day)} - "\
      "#{weekday_content_for(end_day)}".html_safe
    end
  end

  # @param day [Integer] An integer representing the weekday. 1 = Monday, etc.
  # @return [HTML] Weekday name wrapped in a span element.
  def weekday_content_for(day)
    content_tag :span, class: 'weekday' do
      I18n.t('date.day_names')[day - 1]
    end
  end

  # HOLIDAY SCHEDULE HELPERS
  # Private helper methods used for holiday schedules.

  # Used by the `holiday_opening_hours_for` helper.
  # @param schedule [Sawyer::Resource] Resource containing closed, start_date, end_date
  #   open_time, and close_time keys.
  # @return [HTML] Snippet of opening hours for a single weekday
  #   or range of weekdays.
  def holiday_schedule_content_for(schedule)
    content_tag :section do
      "#{date_range_for(schedule.start_date, schedule.end_date)}: "\
      "#{holiday_hours(
        schedule.closed, schedule.opens_at, schedule.closes_at)}".html_safe
    end
  end

  # @param closed [Boolean] Whether location/service is open on start_date.
  # @param start_date [Date] A datestamp.
  # @param end_date [Date] A datestamp.
  # @param open_time [Time] An opening hours timestamp.
  # @param close_time [Time] A closing hours timestamp.
  # @return [HTML] Snippet of opening hours for a single weekday
  #   or range of weekdays.
  def holiday_hours(closed, open_time, close_time)
    content_tag :span, class: 'opening-hours' do
      if closed == true
        holiday_hours_when_closed
      else
        time_range_for(open_time, close_time)
      end
    end
  end

  # @return [HTML] Snippet for hours of a single weekday, when it is closed.
  def holiday_hours_when_closed
    content_tag :span, class: 'closed' do
      I18n.t('date.closed')
    end
  end

  # @param day [Integer] An integer representing the weekday. 1 = Monday, etc.
  # @return [HTML] Weekday name wrapped in a span element.
  def date_range_for(start_date, end_date)
    return date_content_for(start_date) if start_date == end_date
    "#{date_content_for(start_date)} - "\
    "#{date_content_for(end_date)}"
  end

  # @param day [Date] A datestamp.
  # @return [HTML] Date wrapped in a time element.
  def date_content_for(date)
    content_tag :time, class: 'date' do
      l date, format: :holiday_schedules_date
    end
  end

  # SHARED SCHEDULE HELPERS
  # Private helper methods used for both holiday and regular schedules.

  # @param open_time [Time] An opening hours timestamp.
  # @param close_time [Time] A closing hours timestamp.
  # @return [HTML] Snippet for a day's opening hours.
  def time_range_for(open_time, close_time)
    content_tag :span, class: 'opening-hours' do
      "#{hour_content_for(open_time, 'opens-at')} - "\
      "#{hour_content_for(close_time, 'closes-at')}".html_safe
    end
  end

  # @param time [Time] A timestamp.
  # @param class_name [String] The DOM class to apply to the time element.
  # @return [HTML] An hour time wrapped in a time element.
  def hour_content_for(time, class_name)
    content_tag :time, class: class_name do
      l time, format: :schedules_hours
    end
  end
end
