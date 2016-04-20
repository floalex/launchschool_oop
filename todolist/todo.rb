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
  
  def done?
    todos.all? { |todo| todo.done? }
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
  
  def each 
    todos.each do |todo|
      yield(todo)
    end
    self
  end
  
  def select
    list = TodoList.new(title)
    each do |todo|
      list.add(todo) if yield(todo)
    end
    list
  end
  
  def find_by_title(title)
    select { |todo| todo.title == title }.first
  end
  
  def all_done
    select { |todo| todo.done? }
  end
  
  def all_not_done
    select { |todo| !todo.done? }
  end
  
  def mark_done(title)
    find_by_title(title) && find_by_title(title).done!
  end
  
  def mark_all_done
    each do |todo|
      todo.done!
    end
  end
  
  def mark_all_undone
    each do |todo|
      todo.undone!
    end
  end
end

