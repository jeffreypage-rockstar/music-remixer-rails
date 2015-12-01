module Mix8
  module V1
    class Activities < Grape::API
      include Mix8::V1::Defaults
      include Grape::Kaminari

      resource :activities, desc: 'Activities' do
        desc 'Get list of activities'
        paginate per_page: 20, max_per_page: 30, offset: 5
        get do
          authenticate!
          activities = paginate(PublicActivity::Activity.order('created_at DESC'))
          present activities, with: Mix8::V1::Entities::Activity
        end
      end
    end
  end
end