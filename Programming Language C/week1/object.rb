# Object

class B 
  # uses initialize method, which is called when creating a new instance of the class
  # initialize can take arguments too (here providing defaults)
  def initialize(f=0)
    @foo = f
  end

  def m2 x
    @foo += x
  end

  def foo
    @foo
  end

end

class C
  # we now add in a class-variable, class-constant, and class-method
  # class constants - capitalized & should not be mutated
  # accessing from outsite class as C::Dans_Age
  Dans_Age = 38

  # class methods (static method) - use as C.reset_bar
  def self.reset_bar
    # class variable - associated to the class (not the instance of the class, like state)
    @@bar = 0
  end

  def initialize(f=0)
    @foo = f
  end

  def m2 x
    @foo += x
    @@bar += 1
  end

  def foo
    @foo
  end
  
  def bar
    @@bar
  end
end

# Method visibility
  # private - only available to object itself
    # private methods can only be called by their assigned name (not self.name)
  # protected - available only to code in the class or subclasses
  # public - available to all code (default)

  # Once a visibility keyword is used, all the following methods will have
  # the same visibility method, until a new keyword is set.

