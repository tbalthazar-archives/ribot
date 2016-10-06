module RiBot
  class Ri
    def self.execute(arg)
      %x(ri #{arg} --format=markdown)
    end
  end
end
