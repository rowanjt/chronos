require 'test_helper'
require 'chronos/constraints'
require 'securerandom'

class TestChronosConstraints < Minitest::Test
  def setup
    @file_ident ||= Chronos::Constraints.generate_constraints_id
    @file_ident_2 ||= Chronos::Constraints.generate_constraints_id
    @constraints = [
      {
        operation: 'occurs',
        repeats: 'yearly',
        month: 'december'
      },
      {
        operation: 'on',
        repeats: 'year',
        year_index: 2017
      },
      {
        operation: 'every',
        ordinal: 'last',
        weekday_name: 'wednesday'
      },
      {
        operation: 'occurs',
        repeats: 'before',
        date: '2017-07-05'
      }
    ]

    @constraints_2 = [
      {
        operation: 'occurs',
        repeats: 'after',
        date: '2017-08-15'
      },
      {
        operation: 'occurs',
        repeats: 'before',
        date: '2017-07-05'
      }
    ]
  end

  def teardown
    Chronos::Constraints.destroy(@file_ident)
    Chronos::Constraints.destroy(@file_ident_2)
  end

  should 'save constraints' do
    file = Chronos::Constraints.put(@file_ident, @constraints)

    assert file.closed?
    assert File.exist? file.path
  end

  should 'load nonexistent constraints' do
    constraints = Chronos::Constraints.get(@file_ident)
    expect = [{error: "No such file or directory @ rb_sysopen - test/data/#{@file_ident}.json"}]

    assert_equal expect, constraints
  end

  should 'load constraints' do
    Chronos::Constraints.put(@file_ident, @constraints)
    constraints = Chronos::Constraints.get(@file_ident)

    assert_equal @constraints, constraints
  end

  should 'load all constraints' do
    Chronos::Constraints.put(@file_ident, @constraints)
    Chronos::Constraints.put(@file_ident_2, @constraints_2)
    ids = [@file_ident, @file_ident_2]

    constraints = Chronos::Constraints.get_all(ids)

    assert_equal (@constraints | @constraints_2), constraints
  end

  should 'delete constraints' do
    file = Chronos::Constraints.put(@file_ident_2, @constraints)
    num = Chronos::Constraints.destroy(@file_ident_2)

    refute File.exist? file.path
    assert_equal 1, num
  end
end
