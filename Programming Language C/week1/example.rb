class MyRational

  def initialize(num,den=1)
    if den == 0
      raise "MyRational received an inappropriate argument"
    elsif den < 0
      @num = - num
      @den = - den
    else
      @num = num
      @den = den
    end
    reduce() # i.e., self.reduce() but private
  end

  def to_string
    ans = @num.to_s
    if @den != 1 # everything true except false _and_ nil objects
      ans += "/"
      ans += @den.to_s 
    end
    ans
  end

  def to_string2
    dens = ""
    dens = "/" + @den.to_s if @den != 1 # e1 if e2
    @num.to_s + dens
  end

  def to_string3
    "#{@num}#{if @den==1 then "" else "/" + @den.to_s end}"
  end

  def add! r # mutate self in-place
    a = r.num # only works because of protected methods below
    b = r.den # only works because of protected methods below
    c = @num
    d = @den
    @num = (a * d) + (b * c)
    @den = b * d
    reduce
    self # convenient for stringing calls
  end

  # a functional addition, so we can write r1.+ r2 to make a new rational
  # and built-in syntactic sugar will work: can write r1 + r2
  def + r
    ans = MyRational.new(@num,@den)
    ans.add! r
    ans
  end
    
protected  
  # there is very common sugar for this (attr_reader)
  # the better way:
  # attr_reader :num, :den
  # protected :num, :den
  # we do not want these methods public, but we cannot make them private
  # because of the add! method above
  def num
    @num
  end
  def den
    @den
  end

private
  def gcd(x,y) # greatest common divisor
    if x == y
      x
    elsif x < y
      gcd(x,y-x)
    else
      gcd(y,x)
    end
  end

  def reduce
    if @num == 0
      @den = 1
    else
      d = gcd(@num.abs, @den)
      @num = @num / d
      @den = @den / d
    end
  end
end

def use_rationals
  r1 = MyRational.new(3,4)
  r2 = r1 + r1 + MyRational.new(-5,2)
  puts r2.to_string
  (r2.add! r1).add! (MyRational.new(1,-4))
  puts r2.to_string
  puts r2.to_string2
  puts r2.to_string3
end

use_rationals()
