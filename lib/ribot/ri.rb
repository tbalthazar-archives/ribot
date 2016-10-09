module RiBot
  # Internal: This class is responsible for running the ri command.
  class Ri
    # Internal: Build a ri command in order to execute it later.
    #
    # arg - The String containing the arguments passed to the ri command.
    #
    # Examples
    #
    #   ri.build_command("Array#sort")
    #
    # Returns the ri command String to be executed.
    def build_command(arg)
      "ri #{arg} --format=markdown 2>/dev/null"
    end

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
      %x(#{build_command(arg)})
    end
  end
end
