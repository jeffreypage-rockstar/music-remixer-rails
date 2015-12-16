require 'grape-swagger'

module Mix8
  class Base < Grape::API
    mount Mix8::V1::Base

    add_swagger_documentation(
        api_version: 'v1',
        base_path: '/api',
        hide_format: true
    )
  end
end