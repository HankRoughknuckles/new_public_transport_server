# typed: true
sig { params(line: T::Array[String]).void }
def create_line(line = [])
  line.each_with_index do |station_name, index|
    station = Station.find_or_create_by(name: station_name)
    if index > 0
      previous_station = Station.find_or_create_by(name: line[index - 1])
      station.add_neighbor(previous_station)
    end
  end
end
