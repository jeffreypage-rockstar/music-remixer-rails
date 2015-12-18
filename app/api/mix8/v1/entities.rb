module Mix8
  module V1
    module Entities
      class User < Grape::Entity
        expose :name
        expose :username
        expose :email
        expose :profile_image do |instance|
          instance.profile_image_url(:thumb)
        end
        expose :remember_token, if: lambda { |instance, options| options[:expose_token] == true }
      end

      class Artist < Grape::Entity
        expose :id
        expose :name
        expose :username
      end

      class Part < Grape::Entity
        expose :id
        expose :name
        expose :duration do |instance|
          (instance.duration/1000.0).to_s
        end
        expose :column
      end

      class ClipType < Grape::Entity
        expose :id
        expose :name
        expose :row
      end

      class Clip < Grape::Entity
        expose :id
        expose :row
        expose :column
        expose :part_id
        expose :state
        expose :state2
        expose :state3
        expose :file do |instance|
          instance.file_url
        end
      end

      class Song < Grape::Entity
        expose :id
        expose :name
        expose :duration do |instance|
          (instance.duration/1000.0).to_s
        end
        expose :bpm
        expose :preview_url
        expose :image do |instance|
          instance.image_url(:thumb)
        end
        expose :user, using: User, as: :artist
        expose :parts, using: Part, if: lambda { |instance, options| options[:type] == :full }
        expose :clips, using: Clip, if: lambda { |instance, options| options[:type] == :full }
        expose :clip_types, using: ClipType, if: lambda { |instance, options| options[:type] == :full }
      end

      class Remix < Grape::Entity
        expose :id
        expose :name
        expose :config
        expose :audio do |instance|
          instance.audio_url
        end
        expose :status
      end

      class Trackable < Grape::Entity
        expose :id
        expose :name
      end

      class Activity < Grape::Entity
        expose :owner, using: User, as: :actor
        expose :key, as: :verb
        expose :trackable, using: Trackable, as: :object
        expose :created_at, as: :published
      end
    end
  end
end