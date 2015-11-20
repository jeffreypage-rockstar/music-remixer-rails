class SongDecorator < Draper::Decorator
  delegate_all

  def name
    object.name
  end

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
    h.artist_song_url(object)
  end

  def facebook_share_anchor
    url = "https://www.facebook.com/sharer/sharer.php?u=#{song_url}"
    h.link_to url, class: 'social-share-link', target: '_blank' do
      h.image_tag 'profile/facebook.png'
    end
  end

  def twitter_share_anchor
    url = "http://tumblr.com/widgets/share/tool?canonicalUrl=#{song_url}"
    h.link_to url, class: 'social-share-link', target: '_blank' do
      h.image_tag 'profile/twitter.png'
    end
  end

  def tumblr_share_anchor
    url = "https://www.tumblr.com/widgets/share/tool?canonicalUrl=#{song_url}&posttype=audio&tags=#{object.genre_list.to_s}&caption=#{name_with_artist}"
    h.link_to url, class: 'social-share-link', target: '_blank' do
      h.image_tag 'profile/tumblr.png'
    end
  end

  def googleplus_share_anchor
    url = "https://plus.google.com/share?url=#{song_url}"
    h.link_to url, class: 'social-share-link', target: '_blank' do
      h.image_tag 'profile/googleplus.png'
    end
  end

  def pinterest_share_anchor
    url = "http://pinterest.com/pin/create/button/?url=#{song_url}&media=&description="
    h.link_to url, class: 'social-share-link', target: '_blank' do
      h.image_tag 'profile/pinterest.png'
    end
  end

  def email_share_anchor
    url = "mailto:subject=#{name_with_artist}&body=#{song_url}"
    h.link_to url, class: 'social-share-link', target: '_blank' do
      h.image_tag 'profile/email.png'
    end
  end
end
