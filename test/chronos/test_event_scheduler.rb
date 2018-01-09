require 'test_helper'
require 'chronos/event_scheduler'
require 'active_support/core_ext/numeric/time'

class TestChronosEventScheduler < Minitest::Test
  def setup
    @scheduler = Chronos::EventScheduler.new('availability', false)
  end

  context 'unavailability' do
    context 'recurring' do
      should 'be unavailable every year on Christmas day' do
        xmas_2k = Time.new(2000,12,25,10,30,00)
        constraints = [
          {
            operation: 'occurs',
            repeats: 'yearly',
            month: 'december',
            day_index: 25
          }
        ]

        @scheduler.add_constraints(constraints)
        @scheduler.schedule_event

        refute @scheduler.check(xmas_2k)
        assert @scheduler.check(xmas_2k + 1.day)
        assert @scheduler.check(xmas_2k - 1.day)
      end

      should 'be unavailable every last wednesday in december' do
        last_wed_dec = Time.new(2016,12,28,10,00,00)
        last_wed_dec2 = Time.new(2017,12,27,10,00,00)
        last_wed_nov = Time.new(2017,11,26,10,30,00)
        constraints = [
          {
            operation: 'occurs',
            repeats: 'yearly',
            month: 'december'
          },
          {
            operation: 'every',
            ordinal: 'last',
            weekday_name: 'wednesday'
          }
        ]

        @scheduler.add_constraints(constraints)
        @scheduler.schedule_event

        refute @scheduler.check(last_wed_dec)
        refute @scheduler.check(last_wed_dec2)
        assert @scheduler.check(last_wed_nov)
      end
    end

    context 'occurring' do
      should 'be unavailable on 2017 birthday' do
        birthday = Time.new(2017,03,24,10,30,00)
        birthday_next = Time.new(2018,03,24,10,30,00)
        constraints = [
          {
            operation: 'occurs',
            repeats: 'yearly',
            month: 'march',
            day_index: 24
          },
          {
            operation: 'on',
            repeats: 'year',
            year_index: 2017
          }
        ]

        @scheduler.add_constraints(constraints)
        @scheduler.schedule_event

        refute @scheduler.check(birthday)
        assert @scheduler.check(birthday + 1.day)
        assert @scheduler.check(birthday_next)
      end

      should 'be unavailable on 2017/07/04' do
        date = Date.new(2017,07,04)
        constraints = [
          {
            operation: 'occurs',
            repeats: 'after',
            date: Date.new(2017,07,03).to_s
          },
          {
            operation: 'occurs',
            repeats: 'before',
            date: Date.new(2017,07,05).to_s
          }
        ]

        @scheduler.add_constraints(constraints)
        @scheduler.schedule_event

        refute @scheduler.check(date)
        assert @scheduler.check(date + 1.day)
        assert @scheduler.check(date - 1.day)
      end
    end
  end

  context 'technical specs' do
    context '#add_constraints' do
      should 'not modify constraints (side effect)' do
        constraints = [
          {
            operation: 'occurs',
            repeats: 'yearly',
            month: 'december',
            day_index: 25
          }
        ]
        expected_constraints =  Marshal.load(Marshal.dump(constraints))
        actual_constraints = @scheduler.add_constraints(constraints)

        assert_equal expected_constraints, actual_constraints
      end

      should 'not add constraints with errors' do
        constraints = [{error: 'error message'}]

        @scheduler.add_constraints(constraints)

        assert_nil @scheduler.constraints
      end
    end

    context '#schedule_event' do
      should 'return nil without constraints' do
        assert_nil @scheduler.schedule_event
      end
    end
  end
end
