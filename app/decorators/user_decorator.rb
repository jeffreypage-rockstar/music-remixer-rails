class UserDecorator < Draper::Decorator
  delegate_all

  def facebook_link
    unless object.facebook_link.blank?
      h.link_to object.facebook_link, class: 'social-link' do
        h.fa_icon 'facebook'
      end
    end
  end

  def twitter_link
    unless object.twitter_link.blank?
      h.link_to object.twitter_link, class: 'social-link' do
        h.fa_icon 'twitter'
      end
    end
  end

  def soundcloud_link
    unless object.soundcloud_link.blank?
      h.link_to object.soundcloud_link, class: 'social-link' do
        h.fa_icon 'soundcloud'
      end
    end
  end

  def bio
    unless object.bio.blank?
      object.bio.html_safe
    end
  end
end
