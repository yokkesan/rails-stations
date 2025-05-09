# frozen_string_literal: true

puts "🎬 Seeding database..."

# --- Sheet マスターデータの投入 ---
if Sheet.exists?
  puts 'ℹ️ Sheetデータはすでに存在しています。'
else
  ('a'..'c').each_with_index do |row, row_index|
    (1..5).each do |column|
      Sheet.create!(row: row, column: column)
    end
  end
  puts "✅ Sheetデータを作成しました。"
end

# --- Theater データ ---
theater = Theater.find_or_create_by!(name: 'シネマ新宿')
puts "✅ 劇場: #{theater.name}"

# --- Screen データ ---
screen = Screen.find_or_create_by!(name: 'スクリーン1', theater: theater)
puts "✅ スクリーン: #{screen.name}"

# --- Movie データ ---
movie = Movie.find_or_create_by!(
  name: 'ゴジラ2025',
  year: 2025,
  description: '破壊と再生の物語。',
  image_url: 'https://example.com/godzilla2025.jpg',
  is_showing: true
)
puts "✅ 映画: #{movie.name}"

# --- Schedule データ ---
schedule = Schedule.find_or_create_by!(
  movie: movie,
  screen: screen,
  start_time: Time.zone.parse('2025-05-09 19:00'),
  end_time: Time.zone.parse('2025-05-09 21:00')
)
puts "✅ スケジュール: #{schedule.start_time.strftime('%F %R')} 上映開始"