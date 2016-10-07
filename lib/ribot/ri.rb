module RiBot
  class Ri
    def execute(arg)
      %x(ri #{arg} --format=markdown 2>/dev/null)
    end
  end
end
