# frozen_string_literal: true

require 'application_system_test_case'

class SchedulesTest < ApplicationSystemTestCase
  test 'schedule has all days buttons' do
    visit event_schedules_path(event_name: events(:kaigi).name)
    assert_button('2024-03-18')
    assert_button('2024-03-19')
  end

  test 'schedule date button can switch table' do
    visit event_schedules_path(event_name: events(:kaigi).name)

    assert_selector('h3', text: 'keynote1')
    refute_selector('h3', text: 'keynote2')

    click_button('2024-03-19')

    refute_selector('h3', text: 'keynote1')
    assert_selector('h3', text: 'keynote2')
  end

  test 'schedule cards count expected' do
    visit event_schedules_path(event_name: events(:kaigi).name)

    table_rows = all('tr')

    assert_equal 1, table_rows[1].all('turbo-frame').count
    assert_equal 3, table_rows[2].all('turbo-frame').count
    assert_equal 2, table_rows[3].all('turbo-frame').count
    assert_equal 1, table_rows[4].all('turbo-frame').count

    click_button('2024-03-19')

    table_rows = all('tr')

    assert_equal 3, table_rows[1].all('turbo-frame').count
    assert_equal 2, table_rows[2].all('turbo-frame').count
    assert_equal 2, table_rows[3].all('turbo-frame').count
    assert_equal 1, table_rows[4].all('turbo-frame').count
  end

  test 'anker works' do
    visit "#{event_schedules_path(event_name: events(:kaigi).name)}#2024-03-19"
    find_button(class: 'tab-btn-active').has_text?('2024-03-19')
  end

  test 'dialog shown up' do
    visit event_schedules_path(event_name: events(:kaigi).name)

    refute_selector('dialog')

    all(class: ['show-detail-button'])[0].click

    assert_selector('dialog')
  end

  test 'when add a schedule to plan first time, shown up dialog' do
    visit event_schedules_path(event_name: events(:kaigi).name)

    all(class: ['add-plan-button'])[0].click

    assert_selector(class: ['confirm-terms-of-service-button'])
  end

  test 'when one schedule added to plan, disable same row schedule button' do
    visit event_schedules_path(event_name: events(:kaigi).name)

    all(class: ['add-plan-button'])[1].click
    find(class: ['confirm-terms-of-service-button']).click

    # wait for turbo frame
    if has_selector?('dialog', visible: true, wait: 0.25.seconds)
      has_no_selector?('dialog', visible: true, wait: 1.seconds)
    end

    table_rows = all('tr')
    assert table_rows[2].all(class: ['add-plan-button']).all?(&:disabled?)
  end

  test 'when one schedule added to plan, that schedule button to be remove button' do
    visit event_schedules_path(event_name: events(:kaigi).name)

    all(class: ['add-plan-button'])[1].click
    find(class: ['confirm-terms-of-service-button']).click

    # wait for turbo frame
    if has_selector?('dialog', visible: true, wait: 0.25.seconds)
      has_no_selector?('dialog', visible: true, wait: 1.seconds)
    end

    table_rows = all('tr')
    assert table_rows[2].find_button(class: ['remove-plan-button'])
  end
end
