# frozen_string_literal: true

require 'spec_helper'

describe ValidatesTimeliness, Mongoid do
  after do
    Mongoid.purge!
  end

  class Article
    include Mongoid::Document
    field :publish_date, type: Date
    field :publish_time, type: Time
    field :publish_datetime, type: DateTime
    validates_date :publish_date, allow_nil: true
    validates_time :publish_time, allow_nil: true
    validates_datetime :publish_datetime, allow_nil: true
  end

  context 'with validation methods' do
    let(:record) { Article.new }

    it 'is defined on the class' do
      expect(Article).to respond_to(:validates_date)
      expect(Article).to respond_to(:validates_time)
      expect(Article).to respond_to(:validates_datetime)
    end

    it 'is defined on the instance' do
      expect(record).to respond_to(:validates_date)
      expect(record).to respond_to(:validates_time)
      expect(record).to respond_to(:validates_datetime)
    end

    it 'validates a valid value string' do
      record.publish_date = '2012-01-01'

      record.valid?
      expect(record.errors[:publish_date]).to be_empty
    end

    it 'validates a nil value' do
      record.publish_date = nil

      record.valid?
      expect(record.errors[:publish_date]).to be_empty
    end
  end

  it 'determines type for attribute' do
    expect(Article.timeliness_attribute_type(:publish_date)).to eq :date
    expect(Article.timeliness_attribute_type(:publish_time)).to eq :time
    expect(Article.timeliness_attribute_type(:publish_datetime)).to eq :datetime
  end

  context 'with attribute write method' do
    let(:record) { Article.new }

    it 'caches attribute raw value' do
      record.publish_datetime = date_string = '2010-01-01'

      expect(record._timeliness_raw_value_for('publish_datetime')).to eq date_string
    end

    context 'with plugin parser' do
      let(:record) { ArticleWithParser.new }

      class ArticleWithParser
        include Mongoid::Document
        field :publish_date, type: Date
        field :publish_time, type: Time
        field :publish_datetime, type: DateTime

        ValidatesTimeliness.use_plugin_parser = true
        validates_date :publish_date, allow_nil: true
        validates_time :publish_time, allow_nil: true
        validates_datetime :publish_datetime, allow_nil: true
        ValidatesTimeliness.use_plugin_parser = false
      end

      context 'with date columns' do
        it 'parses a string value' do
          expect(Timeliness::Parser).to receive(:parse)

          record.publish_date = '2010-01-01'
        end

        it 'parses a invalid string value as nil' do
          expect(Timeliness::Parser).to receive(:parse)

          record.publish_date = 'not valid'
        end

        it 'stores a Date value after parsing string' do
          record.publish_date = '2010-01-01'

          expect(record.publish_date).to be_kind_of(Date)
          expect(record.publish_date).to eq Date.new(2010, 1, 1)
        end
      end

      context 'with time columns' do
        it 'parses a string value' do
          expect(Timeliness::Parser).to receive(:parse)

          record.publish_time = '12:30'
        end

        it 'parses a invalid string value as nil' do
          expect(Timeliness::Parser).to receive(:parse)

          record.publish_time = 'not valid'
        end

        it 'stores a Time value after parsing string' do
          record.publish_time = '12:30'

          expect(record.publish_time).to be_kind_of(Time)
          expect(record.publish_time).to eq Time.utc(2000, 1, 1, 12, 30)
        end
      end

      context 'with datetime columns' do
        with_config(:default_timezone, 'Australia/Melbourne')

        it 'parses a string value' do
          expect(Timeliness::Parser).to receive(:parse)

          record.publish_datetime = '2010-01-01 12:00'
        end

        it 'parses a invalid string value as nil' do
          expect(Timeliness::Parser).to receive(:parse)

          record.publish_datetime = 'not valid'
        end

        it 'parses string into DateTime value' do
          record.publish_datetime = '2010-01-01 12:00'

          expect(record.publish_datetime).to be_kind_of(DateTime)
        end

        it 'parses string as current timezone' do
          record.publish_datetime = '2010-06-01 12:00'

          expect(record.publish_datetime.utc_offset).to eq Time.zone.utc_offset
        end
      end
    end
  end

  context 'with cached values' do
    it 'is cleared on reload' do
      record = Article.create!
      record.publish_date = '2010-01-01'
      record.reload
      expect(record._timeliness_raw_value_for('publish_date')).to be_nil
    end
  end

  context 'with before_type_cast method' do
    let(:record) { Article.new }

    it 'is defined on class if ORM supports it' do
      expect(record).to respond_to(:publish_datetime_before_type_cast)
    end

    it 'returns original value' do
      record.publish_datetime = date_string = '2010-01-01'

      expect(record.publish_datetime_before_type_cast).to eq date_string
    end

    it 'returns attribute if no attribute assignment has been made' do
      time = Time.zone.local(2010, 0o1, 0o1)
      Article.create(publish_datetime: time)
      record = Article.last
      expect(record.publish_datetime_before_type_cast).to eq time.to_datetime
    end

    context 'with plugin parser' do
      with_config(:use_plugin_parser, true)

      it 'returns original value' do
        record.publish_datetime = date_string = '2010-01-31'
        expect(record.publish_datetime_before_type_cast).to eq date_string
      end
    end
  end

  context 'with aliased fields' do
    class ArticleWithAliasedFields
      include Mongoid::Document
      field :pd, as: :publish_date, type: Date
      field :pt, as: :publish_time, type: Time
      field :pdt, as: :publish_datetime, type: DateTime
      validates_date :publish_date, allow_nil: true
      validates_time :publish_time, allow_nil: true
      validates_datetime :publish_datetime, allow_nil: true
    end

    it 'determines type for attribute' do
      expect(ArticleWithAliasedFields.timeliness_attribute_type(:publish_date)).to eq :date
      expect(ArticleWithAliasedFields.timeliness_attribute_type(:publish_time)).to eq :time
      expect(ArticleWithAliasedFields.timeliness_attribute_type(:publish_datetime)).to eq :datetime
    end
  end
end
