# frozen_string_literal: true

class SheetsController < ApplicationController
  def index
    @sheets = Sheet.all.group_by(&:row)
  end
end
