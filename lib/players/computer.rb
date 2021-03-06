module Players
  class Computer < Player
    WIN_COMBINATIONS = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
                        [1, 4, 7], [2, 5, 8], [3, 6, 9],
                        [1, 5, 9], [3, 5, 7]]

    def move(board)
      @board = board
      if o_cells.empty? && empty_cells.include?(5)
        return "5"
      end
      # Only include empty cells on the array feeding in to the freq table
      valid_selection = weighted_selection.flatten.select do |ws|
        empty_cells.include?(ws)
      end
      freq_table = valid_selection.flatten.inject(Hash.new(0)) do |k, v|
        k[v] += 1
        k
      end
      choice = valid_selection.flatten.max_by { |v| freq_table[v] }
      choice.to_s
    end

    def empty_cells
      result = []
      @board.cells.each_with_index { |c, i| result << i + 1 if c == " " }
      result
    end

    def x_cells
      result = []
      @board.cells.each_with_index { |c, i| result << i + 1 if c == "X" }
      result
    end

    def o_cells
      result = []
      @board.cells.each_with_index { |c, i| result << i + 1 if c == "O" }
      result
    end

    def opponent_weightings
      result = Array.new(8, 0)
      WIN_COMBINATIONS.each_with_index do |win, win_no|
        remaining = win - (x_cells + o_cells)
        if remaining.length > 0
          win.each { |w| result[win_no] -= 3 if x_cells.include?(w) }
        end
      end
      result
    end

    def weighted_selection
      lowest = 0
      selection = []
      opponent_weightings.each_with_index do |weight, i|
        if weight < lowest
          selection = [i]
          lowest = weight
        elsif weight == lowest
          selection << i
        end
      end
      selection.map { |win| WIN_COMBINATIONS[win] }
    end

  end
end
