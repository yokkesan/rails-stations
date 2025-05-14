# frozen_string_literal: true

# app/controllers/admin/theaters_controller.rb
module Admin
  class TheatersController < ApplicationController
    def index
      @theaters = Theater.all
    end

    def new
      @theater = Theater.new
    end

    def create
      @theater = Theater.new(theater_params)
      if @theater.save
        redirect_to admin_theaters_path, notice: '劇場を作成しました'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @theater = Theater.find(params[:id])
    end

    def update
      @theater = Theater.find(params[:id])
      if @theater.update(theater_params)
        redirect_to admin_theaters_path, notice: '劇場を更新しました'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @theater = Theater.find(params[:id])
      @theater.destroy
      redirect_to admin_theaters_path, notice: '劇場を削除しました'
    end

    private

    def theater_params
      params.require(:theater).permit(:name)
    end
  end
end
