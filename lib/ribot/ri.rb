module RiBot
  # Internal: This class is responsible for running the ri command.
  class Ri
    # Internal: Execute a ri command.
    #
    # arg - The String containing the arguments passed to the ri command.
    #
    # Examples
    #
    #   ri.execute("Array#sort")
    #
    # Returns the output (stdout) of the ri command.
    def execute(arg)
      %x(ri #{arg} --format=markdown 2>/dev/null)
    end
  end
end
