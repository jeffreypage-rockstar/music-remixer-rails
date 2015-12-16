require 'grape-swagger'

module Mix8
  module V1
    class Base < Grape::API
      mount Mix8::V1::App
      mount Mix8::V1::Users
      mount Mix8::V1::Songs
      mount Mix8::V1::Activities
    end
  end
end