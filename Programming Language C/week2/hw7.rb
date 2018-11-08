# University of Washington, Programming Languages, Homework 7, hw7.rb 
# (See also ML code)

# a little language for 2D geometry objects

# each subclass of GeometryExpression, including subclasses of GeometryValue,
#  needs to respond to messages preprocess_prog and eval_prog
#
# each subclass of GeometryValue additionally needs:
#   * shift
#   * intersect, which uses the double-dispatch pattern
#   * intersectPoint, intersectLine, and intersectVerticalLine for 
#       for being called by intersect of appropriate clases and doing
#       the correct intersection calculuation
#   * (We would need intersectNoPoints and intersectLineSegment, but these
#      are provided by GeometryValue and should not be overridden.)
#   *  intersectWithSegmentAsLineResult, which is used by 
#      intersectLineSegment as described in the assignment
#
# you can define other helper methods, but will not find much need to

# Note: geometry objects should be immutable: assign to fields only during
#       object construction

# Note: For eval_prog, represent environments as arrays of 2-element arrays
# as described in the assignment

class GeometryExpression  
  # do *not* change this class definition
  Epsilon = 0.00001
end

class GeometryValue 
  # do *not* change methods in this class definition
  # you can add methods if you wish

  private
  # some helper methods that may be generally useful
  def real_close(r1,r2) 
    (r1 - r2).abs < GeometryExpression::Epsilon
  end
  def real_close_point(x1,y1,x2,y2) 
    real_close(x1,x2) && real_close(y1,y2)
  end
  # two_points_to_line could return a Line or a VerticalLine
  def two_points_to_line(x1,y1,x2,y2) 
    if real_close(x1,x2)
      VerticalLine.new x1
    else
      m = (y2 - y1).to_f / (x2 - x1)
      b = y1 - m * x1
      Line.new(m,b)
    end
  end

  def between(v, i, f)
    epilson = GeometryExpression::Epsilon
    ((i - epilson <= v && v <= f + epilson) || (f - epilson <= v && v <= i + epilson))
  end

  public
  # we put this in this class so all subclasses can inherit it:
  # the intersection of self with a NoPoints is a NoPoints object
  def intersectNoPoints np
    np # could also have NoPoints.new here instead
  end

  # we put this in this class so all subclasses can inhert it:
  # the intersection of self with a LineSegment is computed by
  # first intersecting with the line containing the segment and then
  # calling the result's intersectWithSegmentAsLineResult with the segment
  def intersectLineSegment seg
    line_result = intersect(two_points_to_line(seg.x1,seg.y1,seg.x2,seg.y2))
    line_result.intersectWithSegmentAsLineResult seg
  end
end

class NoPoints < GeometryValue
  # do *not* change this class definition: everything is done for you
  # (although this is the easiest class, it shows what methods every subclass
  # of geometry values needs)
  # However, you *may* move methods from here to a superclass if you wish to

  # Note: no initialize method only because there is nothing it needs to do
  def eval_prog env 
    self # all values evaluate to self
  end
  def preprocess_prog
    self # no pre-processing to do here
  end
  def shift(dx,dy)
    self # shifting no-points is no-points
  end
  def intersect other
    other.intersectNoPoints self # will be NoPoints but follow double-dispatch
  end
  def intersectPoint p
    self # intersection with point and no-points is no-points
  end
  def intersectLine line
    self # intersection with line and no-points is no-points
  end
  def intersectVerticalLine vline
    self # intersection with line and no-points is no-points
  end
  # if self is the intersection of (1) some shape s and (2) 
  # the line containing seg, then we return the intersection of the 
  # shape s and the seg.  seg is an instance of LineSegment
  def intersectWithSegmentAsLineResult seg
    self
  end
end


class Point < GeometryValue
  # *add* methods to this class -- do *not* change given code and do not
  # override any methods

  # Note: You may want a private helper method like the local
  # helper function inbetween in the ML code
  attr_reader :x, :y
  def initialize(x,y)
    @x = x
    @y = y
  end

  def eval_prog env
    self
  end

  def preprocess_prog
    self
  end

  def shift(dx, dy)
    Point.new(x+dx, y+dy)
  end

  def intersect other
    other.intersectPoint self
  end

  def intersectPoint p
    if real_close_point(x, y, p.x, p.y)
      self
    else
      NoPoints.new()
    end
  end

  def intersectLine l
    if real_close(y, l.m*x + l.b)
      self
    else
      NoPoints.new()
    end
  end

  def intersectVerticalLine vl
    if real_close(x, vl.x)
      self
    else
      NoPoints.new()
    end
  end

  def intersectWithSegmentAsLineResult s
    if between(x, s.x1, s.x2) && between(y, s.y1, s.y2)
      two_points_to_line(s.x1, s.y1, s.x2, s.y2).intersectPoint self
    else
      NoPoints.new()
    end
  end

end

class Line < GeometryValue
  # *add* methods to this class -- do *not* change given code and do not
  # override any methods
  attr_reader :m, :b 
  def initialize(m,b)
    @m = m
    @b = b
  end

  def eval_prog env
    self
  end

  def preprocess_prog
    self
  end

  def shift(dx, dy)
    Line.new(m, b+dy-m*dx)
  end

  def intersect other
    other.intersectLine self
  end

  def intersectPoint p
    if real_close(p.y, p.x*m + b)
      p
    else
      NoPoints.new()
    end
    # p.intersectLine self
  end

  def intersectLine l
    if real_close(m, l.m)
      if real_close(b, l.b)
        self
      else
        NoPoints.new()
      end
    else
      x = (l.b - b) / (m - l.m)
      y = m * x + b
      Point.new(x, y)
    end
  end

  def intersectVerticalLine vl
    Point.new(vl.x, m * vl.x + b)
  end

  def intersectWithSegmentAsLineResult s
    if real_close(s.y1 - s.y2, m*(s.x1 - s.x2))
      if real_close(s.y1, m*s.x1 + b)
         s
      else
         NoPoints.new()
      end
   else
      p = two_points_to_line(s.x1, s.y1, s.x2, s.y2).intersectLine self
      if between(p.x, s.x1, s.x2) && between(p.y, s.y1, s.y2)
           p
        else
         NoPoints.new()
      end      	   
   end
  end

end

