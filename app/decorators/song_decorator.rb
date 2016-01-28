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

  def name_with_artist
    "#{object.name} by #{artist_name}"
  end

  def song_url
    h.app_song_url(object)
  end

  def status_icon
    case object.status
      when 'processing'
        h.fa_icon 'cog', class: 'fa-spin text-warning', title: 'Processing'
      when 'failed'
        h.fa_icon 'close', class: 'text-danger', title: 'Failed'
      when 'working'
        h.fa_icon 'clock-o', class: 'text-warning', title: 'Working'
      when 'released'
        h.fa_icon 'check', class: 'text-success', title: 'Released'
      when 'processing_for_release'
        h.fa_icon 'cog', class: 'text-warning', title: 'Processing For Release'
      when 'archived'
        h.fa_icon 'archive', class: 'text-primary', title: 'Archived'
    end
  end

  def facebook_share_anchor
    url = "https://www.facebook.com/sharer/sharer.php?u=#{song_url}"
    h.link_to url, class: 'social-share-link', target: '_blank', data: { channel: 'facebook' } do
      h.image_tag 'profile/facebook.png'
    end
  end

  def twitter_share_anchor
    url = "https://twitter.com/share?url=#{song_url}"
    h.link_to url, class: 'social-share-link', target: '_blank', data: { channel: 'twitter' } do
      h.image_tag 'profile/twitter.png'
    end
  end

  def tumblr_share_anchor
    url = "https://www.tumblr.com/widgets/share/tool?canonicalUrl=#{song_url}&posttype=audio&tags=#{object.genre_list.to_s}&caption=#{name_with_artist}"
    h.link_to url, class: 'social-share-link', target: '_blank', data: { channel: 'tumblr' } do
      h.image_tag 'profile/tumblr.png'
    end
  end

  def google_plus_share_anchor
    url = "https://plus.google.com/share?url=#{song_url}"
    h.link_to url, class: 'social-share-link', target: '_blank', data: { channel: 'google-plus' } do
      h.image_tag 'profile/google-plus.png'
    end
  end

  def pinterest_share_anchor
    url = "http://pinterest.com/pin/create/button/?url=#{song_url}&media=&description="
    h.link_to url, class: 'social-share-link', target: '_blank', data: { channel: 'pinterest' } do
      h.image_tag 'profile/pinterest.png'
    end
  end

  def email_share_anchor
    url = "mailto:?subject=#{name_with_artist}&body=#{song_url}"
    h.link_to url, class: 'social-share-link', target: '_blank', data: { channel: 'email' } do
      h.image_tag 'profile/email.png'
    end
  end
end
