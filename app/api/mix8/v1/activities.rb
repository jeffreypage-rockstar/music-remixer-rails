module Mix8
  module V1
    class Activities < Grape::API
      include Mix8::V1::Defaults
      include Grape::Kaminari

      resource :activities, desc: 'Activities' do
        desc 'Get list of activities', {headers: {'Authorization' => {description: 'Access Token', required: true}}}
        params do
          optional :since, type: DateTime, desc: 'since the specific datetime'
          requires :filter, type: Symbol, values: [:all, :friends, :songs], default: :all, desc: 'filter'
        end
        paginate per_page: 20, max_per_page: 30, offset: 0
        get do
          authenticate!
          activities_query = PublicActivity::Activity
                                 .select('min(id) as id, trackable_id, trackable_type, owner_id, owner_type, `key`, parameters, recipient_id, recipient_type, min(created_at) as created_at')
                                 .group('trackable_id, trackable_type, owner_id, owner_type, `key`, parameters, recipient_id, recipient_type')
                                 .order('min(created_at) DESC')
          # activities_query = PublicActivity::Activity.order('created_at DESC')

          activities_query = case params[:filter]
                               when :friends
                                 activities_query.where(owner_id: current_user.followees(User).map(&:id))
                               when :songs
                                 activities_query.where(key: %w(song.create song.share song.like remix.create remix.share remix.like))
                               else
                                 activities_query
                             end
          activities_query = activities_query.where('created_at >= ?', params[:since]) if params[:since]
          activities = paginate(activities_query)
          present activities, with: Mix8::V1::Entities::Activity
        end
      end
    end
  end
end