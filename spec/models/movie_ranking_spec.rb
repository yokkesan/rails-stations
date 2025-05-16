# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MovieRanking, type: :model do
  let(:movie) { create(:movie) }
  let(:ranking) { create(:ranking) }

  it '有効な属性なら保存できる' do
    ranking = create(:ranking)
    movie_ranking = build(:movie_ranking, movie: movie, ranking: ranking, rank_date: Date.today, total_reservations: 5)
    expect(movie_ranking).to be_valid
  end

  it 'movie がなければ無効' do
    movie_ranking = build(:movie_ranking, movie: nil)
    expect(movie_ranking).not_to be_valid
  end

  it 'ranking がなければ無効' do
    movie_ranking = build(:movie_ranking, ranking: nil)
    expect(movie_ranking).not_to be_valid
  end

  it 'total_reservations が負の数だと無効' do
    movie_ranking = build(:movie_ranking, total_reservations: -1)
    expect(movie_ranking).not_to be_valid
  end

  it '同じ movie, ranking, rank_date の組み合わせは重複できない' do
    create(:movie_ranking, movie: movie, ranking: ranking, rank_date: Date.today)
    dup = build(:movie_ranking, movie: movie, ranking: ranking, rank_date: Date.today)
    expect(dup).not_to be_valid
  end
end
