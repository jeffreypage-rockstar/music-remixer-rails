class UserDecorator < Draper::Decorator
  delegate_all

  def facebook_link
    unless object.facebook.blank?
      h.link_to "https://facebook.com/#{object.facebook}", class: 'social-link' do
        h.fa_icon 'facebook'
      end
    end
  end

  def instagram_link
    unless object.instagram.blank?
      h.link_to "https://instagram.com/#{object.instagram}", class: 'social-link' do
        h.fa_icon 'instagram'
      end
    end
  end

  def twitter_link
    unless object.twitter.blank?
      h.link_to "https://twitter.com/#{object.twitter}", class: 'social-link' do
        h.fa_icon 'twitter'
      end
    end
  end

  def soundcloud_link
    unless object.soundcloud.blank?
      h.link_to "https://soundcloud.com/#{object.soundcloud}", class: 'social-link' do
        h.fa_icon 'soundcloud'
      end
    end
  end

  def bio
    unless object.bio.blank?
      object.bio.html_safe
    end
  end

  def mixes
    mix_blobs = []

    object.released_songs.each do |song|
      mix_blob = {id: song.id, mixes: []}
      mix_blob[:mixes] << {
          :url => song.mixaudio_mix2.url,
          :style => 'Mix2'
      }
      mix_blob[:mixes] << {
          :url => song.mixaudio_mix3.url,
          :style => 'Mix3'
      }
      mix_blobs << mix_blob
    end
    puts mix_blobs
    mix_blobs
  end
end
