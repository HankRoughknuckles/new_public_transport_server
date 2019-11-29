# Join model that associates tram lines with segments - helps us know what
# segment goes in which tram line and what order they go in
class SegmentTramLine < ApplicationRecord
  belongs_to :segment
  belongs_to :tram_line
end
