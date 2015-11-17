class SongDecorator < Draper::Decorator
  delegate_all

  def duration
    unless object.duration.blank?
      mins = (object.duration / 60).to_i
      secs = (object.duration % 60).to_i
      [mins.to_s.rjust(2, '0'), secs.to_s.rjust(2, '0')].reject(&:blank?).join ':'
    end
  end

  def artist_name
    object.user.name
  end
end
