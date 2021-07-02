# frozen_string_literal: true

module Faker
  class Article < Base
    include Mongoid::Document

    field :publish_date, type: ::Date
    field :publish_time, type: ::Time
    field :publish_datetime, type: ::DateTime

    validates_date :publish_date, allow_nil: true
    validates_time :publish_time, allow_nil: true
    validates_datetime :publish_datetime, allow_nil: true
  end
end
