class ConvertSchedulesTrack < ActiveRecord::Migration[7.1]
  def up
    add_column :schedules, :track_id, :uuid

    Schedule.all.each do |schedule|
      track = Track.find_or_create_by!(event: schedule.event, name: schedule.track_name)
      schedule.track = track
      schedule.save!
    end
    
    Event.all.each do |event|
      event.tracks.sort_by { _1.name.reverse }.each_with_index do |track, i|
        track.position = i + 1
        track.save!
      end
    end

    remove_column :schedules, :track_name
    change_column :schedules, :track_id, :uuid, null: false
    add_foreign_key :schedules, :tracks
  end

  def down
    add_column :schedules, :track_name, :string
    
    Schedule.all.each do |schedule|
      schedule.track_name = schedule.track.name
      schedule.save!
    end

    change_column :schedules, :track_name, :string, null: false
    remove_column :schedules, :track_id
  end
end
