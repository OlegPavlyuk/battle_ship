class Field
	attr_reader :size

	#Creating a field with default size 10x10
	def initialize(size = 10)
		@size = size
		@field = Array.new(size) do |x|
			Array.new(size) { |y| Cell.new(self, x, y) }
		end
	end

	#Get cell by its coordinates,unless coordinates out of border
	def get_cell(x, y)
		return nil unless (0..size - 1).cover?(x)
    return nil unless (0..size - 1).cover?(y)
    @field[x][y]
	end

	#Getting an array of chunks with unoccupied cells
	def free_space
		#selecting horizontal available space
		horizontal_space = @field.flat_map { |line| line.chunk(&:free?).select(&:first).map(&:last) }
		#selecting vertical available space
		vertical_space = @field.transpose.flat_map { |line| line.chunk(&:free?).select(&:first).map(&:last) }
		horizontal_space + vertical_space
	end

	#Ramdomly adding a ship(marking "#") and reserve a buffer zone around the ship(buffer zone marking "0")
	def add_ship(size)
		space = free_space.select { |space| space.count >= size }.sample
		puts "Sorry,not enough free space, try again " unless space
		offset = rand(0..space.count - size)
		ship = space.slice(offset, size)
		ship.each do |cell|
			cell.ship = "#"
			cell.border_cells.each { |border_cell| border_cell.ship ||= 0 }
		end
	end

	#Print field to the console
  def to_s
  	@field.map do |line|
      line.map(&:to_s).join(" ")
    end.join("\n")
  end

end


#Class cell for each cell on the Field
class Cell
	attr_reader :x, :y
  attr_accessor :ship

  #Init a cell with field it belongs to and x,y coordinates of cell
	def initialize(field, x, y)
		@field = field
		@x = x
		@y = y
		@ship = nil
	end

	#Check if cell is empty,without ships and buffer zone
	def free?
		ship.nil?
	end

	#Getting coordinates of all border cells
	def border_cells
		border_cells = [-1, 0, 1].repeated_permutation(2).to_a
		border_cells.delete([0, 0])
		border_cells.map do |bx, by|
			@field.get_cell(x + bx, y + by)
		end.compact
	end

	#Check if cell is a "sea":)
	def blank?
		ship.nil? || ship == 0
	end

	#Print sea as "-" and ships as "#"
	def to_s
		blank? ? "-" : ship.to_s
	end

end


def start
	#create instance of Field
	field = Field.new
	#create array of ships
	fleet = [ 4,3,3,2,2,2,1,1,1,1 ]
	#add each ship to the field
  fleet.map do |ship|
		field.add_ship(ship)
	end
	#print field
	puts field
end

start






