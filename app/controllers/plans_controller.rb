# frozen_string_literal: true

class PlansController < ApplicationController
  before_action :set_plan

  def show
    @schedules = @plan.schedules
  end

  def update
    add_and_remove_plans if params[:add_schedule_id] || params[:remove_schedule_id]

    redirect_to request.referer || schedules_path
  end

  private

  def set_plan
    @plan = params[:id] ? Plan.find(params[:id]) : nil
  end

  def add_and_remove_plans
    ActiveRecord::Base.transaction do
      @plan.plan_schedules.create!(schedule: Schedule.find(params[:add_schedule_id])) if params[:add_schedule_id]

      if params[:remove_schedule_id]
        @plan.plan_schedules.find_by(schedule: Schedule.find(params[:remove_schedule_id])).destroy!
      end
    end
  end
end
