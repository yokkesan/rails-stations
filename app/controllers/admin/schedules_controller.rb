module Admin
    class SchedulesController < ApplicationController
      before_action :set_schedule, only: [:show, :edit, :update, :destroy] 
  
      # スケジュール一覧
      def index
        @movies = Movie.includes(:schedules).where.not(schedules: { id: nil })
      end
  
      # スケジュール詳細（編集ページ）
      def show
      end
  
      # スケジュール作成ページ（映画ごと）
      def new
        @movie = Movie.find(params[:movie_id])
        @schedule = @movie.schedules.build
      end
  
      # スケジュール登録処理
      def create
        @movie = Movie.find(params[:movie_id])
        @schedule = @movie.schedules.build(schedule_params)
  
        if @schedule.save
          flash[:notice] = "スケジュールが登録されました"
          redirect_to edit_admin_movie_path(@movie)
        else
          flash.now[:alert] = "登録に失敗しました"
          render :new, status: :unprocessable_entity
        end
      end
  
      def show
        @schedule = Schedule.find(params[:id])
        @movie = @schedule.movie
      end
  
      # スケジュール更新
      def update
        if @schedule.update(schedule_params)
          flash[:notice] = "スケジュールが更新されました"
          redirect_to admin_schedules_path
        else
          flash.now[:alert] = "更新に失敗しました"
          render :edit, status: :unprocessable_entity
        end
      end
  
      # スケジュール削除
      def destroy
        @schedule.destroy
        flash[:notice] = "スケジュールが削除されました"
        redirect_to admin_schedules_path, status: :see_other
      end
  
      private
  
      def set_schedule
        @schedule = Schedule.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "スケジュールが見つかりませんでした"
        redirect_to admin_schedules_path, status: :see_other
      end
  
      def schedule_params
        params.require(:schedule).permit(:start_time, :end_time)
      end
    end
  end