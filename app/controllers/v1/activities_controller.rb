module V1
  class ActivitiesController < ApiController
    before_action :authenticate_request, only: [:search]

    def search
      @act_i_participate = Participant.where(user: current_user).select("activity_id").map do |act|
        act[:activity_id]
      end

      @challenges_im_not_invited = InvitedUser.where.not(user: current_user).select("activity_id").map do |act|
        act[:activity_id]
      end

      @full_activities = Activity.joins(:participants)
                        .group('participants.activity_id, activities.max_users')
                        .having('count(*) >= activities.max_users')
                        .select('participants.activity_id as id').map do |act|
                          act[:id]
                        end

      @all_act = Activity.all.select("id").map do |act|
        act[:id]
      end

      @feed = Activity.order(challenge: :desc).find(@all_act - @act_i_participate - @challenges_im_not_invited - @full_activities)

      render json: @feed, each_serializer: ActivitySerializer
    end


    def my_activities
      @act_i_participate = Participant.where(user: current_user).select("activity_id").map do |act|
        act[:activity_id]
      end

      @my_activities = Activity.order(challenge: :desc).find(@act_i_participate)

      render json: @my_activities
    end

    def join
      Participant.create(user: current_user, activity: Activity.find(params[:id]))
      InvitedUser.where(user: current_user, activity: Activity.find(params[:id])).destroy_all
      render json: Activity.find(params[:id])
    end
  end
end
