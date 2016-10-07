module RiBot
  class Ri
    def execute(arg)
      %x(ri #{arg} --format=markdown)
    end
  end
end
