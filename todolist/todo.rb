# This class represents a todo item and its associated
# data: name and description. There's also a "done"
# flag to show whether this todo item is done.

class Todo
  DONE_MARKER = 'X'
  UNDONE_MARKER = ' '

  attr_accessor :title, :description, :done

  def initialize(title, description='')
    @title = title
    @description = description
    @done = false
  end

  def done!
    self.done = true
  end

  def done?
    done
  end

  def undone!
    self.done = false
  end

  def to_s
    "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
  end
end

class TodoList
  attr_accessor :title
  attr_reader :todos

  def initialize(title)
    @title = title
    @todos = []
  end

  def add(item)
    raise TypeError, "Can only add Todo objects" if item.class != Todo
    @todos << item
  end

  def size
    todos.size
  end
  
  def first
    todos[0]
  end
  
  def last
    todos[-1]
  end
  
  def item_at(index)
    raise IndexError if index > todos.size
    todos[index]
  end
  
  def mark_done_at(index)
    raise IndexError if index > todos.size
    todos[index].done!
  end
  
  def mark_undone_at(index)
    raise IndexError if index > todos.size
    todos[index].undone!
  end
  
  def shift
    todos.shift
  end
  
  def pop
    todos.pop
  end
  
  def remove_at(index)
    raise IndexError if index > todos.size
    todos.delete_at(index)
  end
  
  def to_s
    text = "---- #{title} ----\n"
    text << @todos.map(&:to_s).join("\n")
    text
  end
end

todo1 = Todo.new("Buy milk")
todo2 = Todo.new("Clean room")
todo3 = Todo.new("Go to gym")

list = TodoList.new("Today's Todos")
list.add(todo1)
list.add(todo2)
list.add(todo3)

puts list

list.pop

puts list

list.mark_done_at(1)

puts list