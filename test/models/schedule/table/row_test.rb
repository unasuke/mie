# frozen_string_literal: true

require 'test_helper'

class Schedule
  class Table
    class RowTest < ActiveSupport::TestCase
      def setup
        schedules = Schedule.where(event: events(:kaigi))
        @tables = Schedule::Tables.new(schedules)
      end

      test 'each rows mapping correct track infomations with fixture' do
        day1 = @tables['2024-03-18']

        assert_equal day1.rows[0].start_end, '10:00 - 10:30'
        assert_equal day1.rows[0].tracks['TrackA'], schedules(:kaigi_day1_time1_track1)

        assert_equal day1.rows[1].start_end, '10:40 - 11:00'
        assert_equal day1.rows[1].tracks['TrackA'], schedules(:kaigi_day1_time2_track1)
        assert_equal day1.rows[1].tracks['TrackB'], schedules(:kaigi_day1_time2_track2)
        assert_equal day1.rows[1].tracks['TrackC'], schedules(:kaigi_day1_time2_track3)

        assert_equal day1.rows[2].start_end, '11:10 - 11:30'
        assert_equal day1.rows[2].tracks['TrackA'], schedules(:kaigi_day1_time3_track1)
        assert_equal day1.rows[2].tracks['TrackB'], schedules(:kaigi_day1_time3_track2)

        assert_equal day1.rows[3].start_end, '11:45 - 12:30'
        assert_equal day1.rows[3].tracks['TrackA'], schedules(:kaigi_day1_time4_track1)

        day2 = @tables['2024-03-19']

        assert_equal day2.rows[0].start_end, '09:00 - 09:30'
        assert_equal day2.rows[0].tracks['TrackA'], schedules(:kaigi_day2_time1_track1)
        assert_equal day2.rows[0].tracks['TrackB'], schedules(:kaigi_day2_time1_track2)
        assert_equal day2.rows[0].tracks['TrackC'], schedules(:kaigi_day2_time1_track3)

        assert_equal day2.rows[1].start_end, '10:00 - 10:30'
        assert_equal day2.rows[1].tracks['TrackA'], schedules(:kaigi_day2_time2_track1)
        assert_equal day2.rows[1].tracks['TrackB'], schedules(:kaigi_day2_time2_track2)

        assert_equal day2.rows[2].start_end, '10:40 - 11:10'
        assert_equal day2.rows[2].tracks['TrackA'], schedules(:kaigi_day2_time3_track1)
        assert_equal day2.rows[2].tracks['TrackB'], schedules(:kaigi_day2_time3_track2)

        assert_equal day2.rows[3].start_end, '13:00 - 14:00'
        assert_equal day2.rows[3].tracks['TrackA'], schedules(:kaigi_day2_time4_track1)
      end
    end
  end
end
