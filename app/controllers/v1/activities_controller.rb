module V1
  class ActivitiesController < ApiController
    before_action :authenticate_request, only: [:search]

    def search
      @act_i_participate = Participant.where(user: current_user).select('activity_id').map do |act|
        act[:activity_id]
      end

      @challenges_im_invited = InvitedUser.where(user: current_user).select('activity_id').map do |act|
        act[:activity_id]
      end

      @full_activities = Activity.joins(:participants)
                        .group('participants.activity_id, activities.max_users')
                        .having('count(*) >= activities.max_users')
                        .select('participants.activity_id as id').map do |act|
                          act[:id]
                        end

      acts = Activity.where('challenge = false')
      acts_counters = acts.to_a.map do |act|
        [act[:id], 0]
      end

      tags = current_user[:interests]
      for tag in tags do
        for i in 0..acts.length-1 do
          if acts[i][:interests].include? tag
            acts_counters[i][1] = acts_counters[i][1] + 1
          end
        end
      end

      @acts_no_challenges_id = acts_counters.sort_by { |a| -a[1] }.map do |tuple|
        tuple[0]
      end

      @expired = Activity.where('ends <= ?', Time.current).map do |act|
        act[:activity_id]
      end

      @feed = Activity.find(@challenges_im_invited + @acts_no_challenges_id - @act_i_participate - @full_activities - @expired)

      render json: @feed, each_serializer: ActivitySerializer
    end


    def my_activities
      @act_i_participate = Participant.where(user: current_user).select('activity_id').map do |act|
        act[:activity_id]
      end

      @expired = Activity.where('ends <= ?', Time.current)
      @my_activities = Activity.order(challenge: :desc).find(@act_i_participate - @expired)

      render json: @my_activities
    end

    def join
      Participant.create(user: current_user, activity: Activity.find(params[:id]))
      InvitedUser.where(user: current_user, activity: Activity.find(params[:id])).destroy_all
      render json: Activity.find(params[:id])
    end

    def create
      owner_id = params[:owner_id]
      activity = Activity.create(
        title: params[:title],
        interests: params[:interests],
        description: params[:description],
        location: params[:location],
        completed: params[:completed],
        max_users: params[:max_users],
        min_users: params[:min_users],
        ends: params[:ends],
        picture_url: params[:picture_url],
        owner_id: params[:owner_id],
        challenge: params[:challenge],
        discount: params[:discount]
      )

      if owner_id != nil
        Participant.create(user_id: owner_id, activity_id: activity[:id])
      end

      invited_users_ids = params[:invited_users]
      if invited_users_ids != nil
        for user_id in invited_users_ids
          InvitedUser.create(user_id: user_id, activity_id: activity[:id])
        end
      end

      render json: activity, status: :ok
    end

    def leave
      activity = Activity.find(params[:id])
      Participant.where(user: current_user, activity: activity).destroy_all

      if activity[:challenge]
        participants = Participant.where(activity: activity).to_a

        if participants.length <= 1
          activity.destroy_all
        end
      end
      render status: :ok, nothing: true
    end

    def show
      render json: Activity.find(params[:id]), serializer: CompleteActivitySerializer
    end

    def add_comment
      comment = Comment.create(content: params[:content], activity: Activity.find(params[:id]), user: current_user)
      render json: comment, each_serializer: CommentSerializer
    end
  end
end
